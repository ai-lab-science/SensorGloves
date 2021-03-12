using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace RosSharp.RosBridgeClient

{
    public class Float32Subscriber : UnitySubscriber<MessageTypes.Std.Float32>
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
            newTransform.localEulerAngles = new Vector3(-messageData * Mathf.Rad2Deg, 0, 0)+offset;

        }

        protected override void ReceiveMessage(MessageTypes.Std.Float32 message)
        {
            messageData = message.data;
        }
    }
}
