using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace RosSharp.RosBridgeClient

{
    public class PoseSubscriber : UnitySubscriber<MessageTypes.Sensor.Imu>
    {
        //public Vector3 orientation = new Vector3(0.0f, 0.0f, 0.0f);
        public Quaternion orientation;
        private Quaternion offset;
        public Transform newTransform;
        public Vector3 currentAcc;
        public float sens = 0.2f;
        public uint secs;
        public uint nsecs;

        protected override void Start()
        {
            base.Start();
            offset = newTransform.localRotation;
            currentAcc = Vector3.zero;
        }

        private void Update()
        {
            newTransform.rotation = orientation*offset;

            if (currentAcc.x >= 0)
            {
                currentAcc.x = Mathf.Floor(currentAcc.x * (1 / sens)) * sens;
            }
            else
            {
                currentAcc.x = Mathf.Ceil(currentAcc.x * (1 / sens)) * sens;
            }
            if (currentAcc.y >= 0)
            {
                currentAcc.y = Mathf.Floor(currentAcc.y * (1 / sens)) * sens;
            }
            else
            {
                currentAcc.y = Mathf.Ceil(currentAcc.y * (1 / sens)) * sens;
            }
            if (currentAcc.z >= 0)
            {
                currentAcc.z = Mathf.Floor(currentAcc.z * (1 / sens)) * sens;
            }
            else
            {
                currentAcc.z = Mathf.Ceil(currentAcc.z * (1 / sens)) * sens;
            }
            
            //newTransform.Translate(currentAcc);
        }

        protected override void ReceiveMessage(MessageTypes.Sensor.Imu message)
        {
            orientation.x = (float)message.orientation.x;
            orientation.y = -(float)message.orientation.z;
            orientation.z = (float)message.orientation.y;
            orientation.w = (float)message.orientation.w;

            currentAcc.x = -(float)message.linear_acceleration.x;
            currentAcc.y = (float)message.linear_acceleration.y;
            currentAcc.z = (float)message.linear_acceleration.z;

            secs = message.header.stamp.secs;
            nsecs = message.header.stamp.nsecs;
        }
    }
}