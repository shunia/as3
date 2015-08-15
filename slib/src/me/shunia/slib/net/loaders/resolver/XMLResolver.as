package me.shunia.slib.net.loaders.resolver
{
	public class XMLResolver implements IManuallyResolver
	{
		public function XMLResolver()
		{
		}
		
		public function resolve(target:*):*
		{
			return XML(target);
		}
	}
}