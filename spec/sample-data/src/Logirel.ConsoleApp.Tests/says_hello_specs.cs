using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using SharpTestsEx;

namespace Logirel.ConsoleApp.Tests
{
	public class says_hello_specs
	{
		[Test]
		public void contains_hello()
		{
			Program.CONSTANT_MESSAGE.Should().Contain("Hello");
		}
	}
}
