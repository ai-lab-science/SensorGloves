using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace RosSharp.RosBridgeClient

{
    public class ThumbJointSub : UnitySubscriber<MessageTypes.Std.Float32>
    {
        public float messageData;
        public Transform newTransform;
        private Vector3 offset;

        protected override void Start()
        {
            base.Start();
            offset = newTransform.localEulerAngles;
        }

        private void Update()
        {
            //newTransform.localEulerAngles = new Vector3((float)7.632, (float)23.806, messageData * Mathf.Rad2Deg);
            newTransform.localEulerAngles = new Vector3(0, 0, messageData * Mathf.Rad2Deg)+offset;

        }

        protected override void ReceiveMessage(MessageTypes.Std.Float32 message)
        {
            messageData = message.data;
        }
    }
}
