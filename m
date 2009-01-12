From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [ltt-dev] Fw: [PATCH] ext4: Add markers for better
	debuggability
Date: Sun, 11 Jan 2009 20:34:16 -0500
Message-ID: <20090112013415.GA23423@Krystal>
References: <20090109170408.75C1.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090109144901.GA7262@Krystal> <20090109185840.GD23869@mit.edu> <20090110161906.GB20526@Krystal> <20090110184240.GA31579@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: Theodore Tso <tytso@mit.edu>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	ltt-dev@lists.casi.polymtl.ca,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.ke
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:35681 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359AbZALBeT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Jan 2009 20:34:19 -0500
Content-Disposition: inline
In-Reply-To: <20090110184240.GA31579@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Theodore Tso (tytso@mit.edu) wrote:
> On Sat, Jan 10, 2009 at 11:19:06AM -0500, Mathieu Desnoyers wrote:
> > 
> > I just ported LTTng to 2.6.28 yesterday and started doing the port of
> > ext4/jbd2 to tracepoints. As you can see in my 0.74 announcement, the
> > tracepoint work for both jbd2 and ext4 is done. I also did the lttng
> > probe module for jbd2. Now I just have to create the probe module for
> > ext4. I also want to create debugfs files to control per-probe module
> > filtering, e.g. :
> > 
> > /mnt/debugfs/ltt/filter/jbd2/dev
> > /mnt/debugfs/ltt/filter/ext4/dev
> > 
> > Where writing to it would add device names to the filter list. I would
> > like a scheme where we can easily add/remove devices, list all
> > devices... I think ftrace already has something similar for
> > instrumentation activation.
> > 
> > The main question I am facing is : What interface semantic do we want
> > for such filter control file ?
> 
> Hmm, we'll let's see.  The most common filtering restriction will be
> by device, but I'll occasionally want to filter based on a single
> inode; the next most common thing I could forsee wanting to do is to
> filter on a based of inode numbers or on one or more block groups.
> (This would be when trying to figure out what is going on with a
> particular filesystem benchmark.)
> 
> Past a certain point, I recognize that I'll probably have to write a
> custom probe module --- although I have to admit that's one of the
> things that has spoiled me about SystemTap; it automates the job of
> creating the custom probe modules, and allows me to create
> turing-equivalent filtering and data collection.
> 
> So the question is where do we draw the line between the most common
> filters that is worth putting into a probe module that goes into
> mainline, versus what should be done via custome probe modules,
> probably via modifying the probe module as an example.
> 
> If it's not too much trouble, being able to filter on a single device
> (or report the data from all trace points) and filtering on a single
> inode (or reporting all inodes) seems to make the most mount of sense.
> Does tht seem reasonable to you?
> 

Yes, very reasonable. It's now implemented in LTTng 0.77. Usage looks
like :

echo "*" > /mnt/debugfs/ltt/filter/ext4/dev
 (or just echo "" > /mnt/debugfs/ltt/filter/ext4/dev)
 (enables all devices, this is the default)
cat /mnt/debugfs/ltt/filter/ext4/dev
 (shows current filter)

echo sda1 > /mnt/debugfs/ltt/filter/ext4/dev
 (ext4 probes will only record information for device sda1)
echo 15 > /mnt/debugfs/ltt/filter/ext4/inode
 (in addition to device filtering, only inode 15 will be traced)

I think it makes sense to let people edit
ltt/probes/ext4-trace.c to implement their own more complex filtering
suiting their need. It can be compiled as a kernel module.

Here is the ext4 filtering feature diff :
http://ltt.polymtl.ca/cgi-bin/gitweb.cgi?p=linux-2.6-lttng.git;a=blob;f=ltt/probes/ext4-trace.c;h=4824a82fe9c2056d8dea83c57473ecf6c7f1c25d;hb=ad03cc9ead62d85d7641dcd19ea883f07bb7900a

> The other question is how much data gets reported back; normally with
> Systemtap I would report back to userspace only the bits that I needed
> to debug whatever issue I was looking at.  However, with the LTTNG
> approach, can we send back all of the bits of data tht was in the
> markers?

Yes, LTTng consists of a "probe layer" which converts the data taken
from tracepoints into markers. For ext4 :
http://ltt.polymtl.ca/cgi-bin/gitweb.cgi?p=linux-2.6-lttng.git;a=blob;f=ltt/probes/ext4-trace.c;h=167357d87e730e33c3ca1fb335358ddc469473ad;hb=1861c6b862df1e6aad2d658984fbff137b15496e

By default, LTTng sends all the data, including the payload, identified
by the markers. Note that the marker format string is only recorded once
per trace in the metadata channel in a table, which makes everything
very compact and efficient.

> It won't be needed for all problems, and I know that sending
> too much data back will cause us to potentilly overflow the kernel
> buffering, since there is a limited bandwidth of stuff we can send
> back through the kernel<->user interface.  I'll have to admit to being
> that well informed about LTTNG; what are the practical bandwidth
> limitations that I should expect to see when it's in use?
> 

LTTng has been heavily optimized to provide good performances. It uses
lightweight locking (RCU and per-cpu local atomic operations) and
splices the data directly from the memory buffers to disk without
intermediate copy.

A small test to give you an idea of the amount of data generated :

Copying 125MB worth of data (the drivers/ subdirectory) from an ext3 to
an ext4 partition, both on the same disk (raid1) + issuing sync, while
tracing with the trace output on the same disk (on the ext3 partition).

Copy duration : 12.99s
sync duration :  3.59s

Trace generated : 39M

ext4-related data:
516K  /tmp/trace/ext4_0
516K  /tmp/trace/ext4_1
516K  /tmp/trace/ext4_2
3.1M  /tmp/trace/ext4_3
516K  /tmp/trace/ext4_4
516K  /tmp/trace/ext4_5
516K  /tmp/trace/ext4_6
516K  /tmp/trace/ext4_7

Therefore, most of the trace size is padding due to unused buffer space.
I should say that this amount of ext4 data output (187.0kB/s) is really
not a problem neither for LTTng nor the disk.

A small speed test to figure out the tracer impact :
echo 3 > /proc/sys/vm/drop_caches; time (cp -ax drivers /mnt/testext4/; sync)

Without tracing (1):
real  0m18.182s to 0m19.026s

While tracing the overall kernel (including ext4) to disk :
real  0m19.309s to 0m19.986s (~4.8% execution time overhead over (1))

If you cannot afford to dirturb disk activity, you can use the flight
recorder mode, which only keep the data in memory buffers and overwrites
the oldest data until you stop tracing. At that point, you can grab the
buffers and dump them to disk to analyse the last events. It's very
useful if you know what particular condition you are looking for and if
you are only interested in the latest prior to the condition.

Flight recorder trace example :

lttctl -C -w /tmp/trace3 -o channel.all.overwrite=1 trace3
...
lttctl -D -w /tmp/trace3 trace3

While tracing the overall kernel (including ext4) to memory buffers :
real  0m18.748s to 0m19.388s (~2.2% execution time overhead over (1))

Note that the current ext4 probe implementation uses the format-string
serializer (printk-like code which iterates on the format string). For
very high throughput events, we can trivially change to
ltt-type-serializer.[ch] and diminish the execution time impact a lot.
It's just a bit more probe code to write. See kernel-trace.c to see
examples using such mechanism. The only reason why I use this dynamic
serializer is because I am lazy. ;)

> Thanks, regards,
> 
> 						- Ted
> 
> P.S.  At the kernel summit, there was some talk about a very
> simplified interface that would allow us to extract text dumps from
> tracepoints without having to download a huge userspace utility like
> SystemTap --- or LTTng.  Has that been written yet, or is the only way
> for me to use Tracepoints right now is to figure out how to use the
> whole LTTng infrstructure?
> 

Yes, we're working on having a binary-to-ascii converter in the kernel.
People at Fujitsu are helping on this, and I'm waiting for news in this
regard. That's the main element I'm waiting for before I start
submitting LTTng for mainline inclusion.

The current LTTng work flow does not require "huge" userspace utilities.
lttctl (from the ltt-control package) is just a helper over the
/mnt/debugfs/ltt/ interface; this can be done using simple "echo"
commands too. It's therefore optional.

lttd is the daemon which splices the data to disk. It is required.

lttv is built as a single executable with multiple libraries. The
package itself depends on GTK/GDK, but the textDump module really only
needs the glib library.

However, I agree that also providing a text output directly from a
debugfs file would be useful for low-overhead tracing. Note, however,
that this would increase the tracer footprint.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
