using UnityEngine;

namespace RosSharp.RosBridgeClient

{
    public class Float32Publisher : UnityPublisher<MessageTypes.Std.Float32>
    {
        public float messageData = 0.0f;
        private MessageTypes.Std.Float32 message;

        protected override void Start()
        {
            base.Start();
            InitializeMessage();
        }

        private void InitializeMessage()
        {
            message = new MessageTypes.Std.Float32();
            message.data = 0.0f;
        }

        private void FixedUpdate()
        {
            message.data = messageData;
            Publish(message);
        }
    }
}
