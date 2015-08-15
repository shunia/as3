package me.shunia.smedia.core.video
{
	public class SVideoStatus
	{
		
		"NetConnection.Call.BadVersion"
		"NetConnection.Call.Prohibited"
		"NetConnection.Connect.AppShutdown"
		"NetConnection.Connect.IdleTimeout"
		"NetConnection.Connect.InvalidApp"
		"NetConnection.Connect.NetworkChange"
		"NetConnection.Connect.Rejected"
		"NetGroup.Connect.Failed"
		"NetGroup.Connect.Rejected"
		"NetGroup.Connect.Success"
		"NetGroup.LocalCoverage.Notify"
		"NetGroup.MulticastStream.PublishNotify"
		"NetGroup.MulticastStream.UnpublishNotify"
		"NetGroup.Neighbor.Connect"
		"NetGroup.Neighbor.Disconnect"
		"NetGroup.Posting.Notify"
		"NetGroup.Replication.Fetch.Failed"
		"NetGroup.Replication.Fetch.Result"
		"NetGroup.Replication.Fetch.SendNotify"
		"NetGroup.Replication.Request"
		"NetGroup.SendTo.Notify"
		"NetStream.DRM.UpdateNeeded"
		"NetStream.MulticastStream.Reset"
		"NetStream.Play.FileStructureInvalid"
		"NetStream.Play.InsufficientBW"
		"NetStream.Play.NoSupportedTrackFound"
		"NetStream.Play.PublishNotify"
		"NetStream.Play.Reset"
		"NetStream.Play.Transition"
		"NetStream.Play.UnpublishNotify"
		"NetStream.Play.Complete"
		"NetStream.Publish.BadName"
		"NetStream.Publish.Idle"
		"NetStream.Record.AlreadyExists"
		"NetStream.Record.Failed"
		"NetStream.Record.NoAccess"
		"NetStream.Record.Start"
		"NetStream.Record.Stop"
		"NetStream.Seek.Failed"
		"NetStream.Seek.InvalidTime"
		"NetStream.Step.Notify"
		"NetStream.Unpublish.Success"
		"SharedObject.BadPersistence"
		"SharedObject.Flush.Failed"
		"SharedObject.Flush.Success"
		"SharedObject.UriMismatch"
		
		public static const NC_CALL_FAIL:String = "NetConnection.Call.Failed";
		public static const NC_CONNECT_CLOSE:String = "NetConnection.Connect.Closed";
		public static const NC_CONNECT_FAIL:String = "NetConnection.Connect.Failed";
		public static const NC_CONNECT_SUCC:String = "NetConnection.Connect.Success";
		public static const NS_EMPTY:String = "NetStream.Buffer.Empty";
		public static const NS_FLUSH:String = "NetStream.Buffer.Flush";
		public static const NS_FULL:String = "NetStream.Buffer.Full";
		public static const NS_CLOSE:String = "NetStream.Connect.Closed";
		public static const NS_CONNECT_FAIL:String = "NetStream.Connect.Failed";
		public static const NS_REJECT:String = "NetStream.Connect.Rejected";
		public static const NS_SUCC:String = "NetStream.Connect.Success";
		public static const NS_FAIL:String = "NetStream.Failed";
		public static const NS_PAUSE:String = "NetStream.Pause.Notify";
		public static const NS_PLAY_FAIL:String = "NetStream.Play.Failed";
		public static const NS_START:String = "NetStream.Play.Start";
		public static const NS_STOP:String = "NetStream.Play.Stop";
		public static const NS_COMPLETE:String = "NetStream.Play.Complete";
		public static const NS_NOT_FOUND:String = "NetStream.Play.StreamNotFound";
		public static const NS_PUB_START:String = "NetStream.Publish.Start";
		public static const NS_SEEK:String = "NetStream.Seek.Notify";
		public static const NS_RESUME:String = "NetStream.Unpause.Notify";
		public static const NS_DIMENSION_CHANGE:String = "NetStream.Video.DimensionChange";
		
		public static const NS_META:String = "onMetadata";
		public static const NS_BW_DONE:String = "onBWDone";
		public static const NS_CUE:String = "onCuePoint";
		
	}
}