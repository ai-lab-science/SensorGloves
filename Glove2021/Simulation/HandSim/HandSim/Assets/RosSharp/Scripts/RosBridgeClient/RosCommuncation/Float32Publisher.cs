using UnityEngine;

namespace RosSharp.RosBridgeClient

{
    public class Float32Publisher : UnityPublisher<MessageTypes.Std.Float32>
    {
        public float messData = 0.0f;
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
            message.data = messData;
            Publish(message);
        }

        private void OnTriggerEnter(Collider other)
        {
            other.gameObject.GetComponent<Renderer>().material.SetColor("_Color", Color.red);
            if (other.gameObject.name == "ball_sphere")
            {
                messData = 0.5f;
            }
        }

        private void OnTriggerExit(Collider other)
        {
            other.gameObject.GetComponent<Renderer>().material.SetColor("_Color", Color.green);
            if (other.gameObject.name == "ball_sphere")
            {
                messData = 0.0f;
            }
        }
    }
}
