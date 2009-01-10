From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: LTTng for ext4 tracing HOWTO
Date: Sat, 10 Jan 2009 13:19:59 -0500
Message-ID: <20090110181959.GA23307@Krystal>
References: <20090109170408.75C1.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090109144901.GA7262@Krystal> <20090109185840.GD23869@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	ltt-dev@lists.casi.polymtl.ca,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:52201 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753157AbZAJSUD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Jan 2009 13:20:03 -0500
Content-Disposition: inline
In-Reply-To: <20090109185840.GD23869@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Theodore Tso (tytso@mit.edu) wrote:
> On Fri, Jan 09, 2009 at 09:49:01AM -0500, Mathieu Desnoyers wrote:
> > 
> > Given this is meant to be in the mainline kernel, using tracepoints
> > rather than markers would be more appropriate. Please see
> > Documentation/tracepoints.txt and samples/tracepoints/ for details.
> 
> I saw that, but I'm still not sure how I would actually *use*
> tracepoints.  I can use markers today with Systemtap, and I need an
> easy way to be able to selectively do things like "trap and print all
> of the logged data when the ext4_request_inode tracepoint/marker is
> tripped where dev=='dm-8'".
> 
> Unfortunately, Systemtap seems doomed given its current course and
> direction, so I'm not opposed to moving to another solution --- I just
> need a HOWTO that demonstrates how I can do this painlessly and
> easily; preferably without having me have to manually hack up a kernel
> module each time I want to implement the tracing
> 
> Is there an easy way to do that using ltt today?  Can you point me at
> a sample of how this could be done?
> 
> 						- Ted
> 

Hi Ted,

I just finished adding the ext4 tracing feature to LTTng. It's in LTTng
0.75 as I write this. The only requirement currently not fulfilled is
the "filtering by dev == 'dm-8'", which I plan to implement later. We
currently have the whole stream of ext4 operations recorded to trace
buffers (all on) when tracing is enabled.

The starting point for the LTTng project is http://ltt.polymtl.ca

You will need LTTng 0.75 and the matching ltt-control and lttv packages
to get this running. Matching versions are listed here :
http://ltt.polymtl.ca/svn/trunk/lttv/doc/developer/lttng-lttv-compatibility.html

To save you time, here are the direct links to the sources :
LTTng :
http://ltt.polymtl.ca/lttng/patch-2.6.28-lttng-0.75.tar.bz2
or
git://git.kernel.org/pub/scm/linux/kernel/git/compudj/linux-2.6-lttng.git

ltt-control :
http://ltt.polymtl.ca/lttng/ltt-control-0.63-03012009.tar.gz

lttv :
http://ltt.polymtl.ca/packages/lttv-0.12.5-09012009.tar.gz

Follow the QUICKSTART GUIDE to perform the installation :
http://ltt.polymtl.ca/svn/trunk/lttv/QUICKSTART

Once you are setted up, reboot your LTTng-enabled kernel, and try the
following (as root) :

ltt-armall
  (you should see all the markers within lttng probes being enabled on
  the screen. This should include lines beginning with
  "Connecting ext4 ....". If not, make sure you have the lttng ext4
  probe module loaded.)
lttctl -C -w /tmp/trace trace

  (perform some ext4 operations)

lttctl -D trace

lttv -m textDump -e channel.name=ext4 -t /tmp/trace
  This will show events from the ext4 channel only, e.g. :

ext4.da_write_begin: 197.030265213 (/tmp/trace/ext4_3), 4190, 4190, \
    /bin/cp, , 4021, 0x0, SYSCALL \
    { dev = "loop0", ino = 15, pos = 5320704, len = 4096, flags = 0 }
ext4.da_write_end: 197.030268714 (/tmp/trace/ext4_3), 4190, 4190, \
    /bin/cp, , 4021, 0x0, SYSCALL \
    { dev = "loop0", ino = 15, pos = 5320704, len = 4096, copied = 4096 }
ext4.da_write_begin: 197.030279441 (/tmp/trace/ext4_3), 4190, 4190, \
    /bin/cp, , 4021, 0x0, SYSCALL \
    { dev = "loop0", ino = 15, pos = 5324800, len = 4096, flags = 0 }
....

You can also try the GUI interface if you like, with :
lttv-gui -t /tmp/trace

You will find it useful if you need to dig in the ext4 trace information
along with the instrumentation collected from the rest of the kernel.

This is a very basic HOWTO. Don't hesitate to ask if you need help to
tune the amount of events logged (e.g. by disabling some markers, which
can be done by doing a custom ltt-armall script).

Also, lttv filtering currently does not support filtering by event
fields. A quick hack to do it is :

lttv -m textDump -e channel.name=ext4 -t /tmp/trace |grep "dev = \"loop0\","

Enjoy :)

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
