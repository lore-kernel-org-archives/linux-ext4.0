From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [ltt-dev] Fw: [PATCH] ext4: Add markers for better
	debuggability
Date: Sat, 10 Jan 2009 11:19:06 -0500
Message-ID: <20090110161906.GB20526@Krystal>
References: <20090109170408.75C1.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090109144901.GA7262@Krystal> <20090109185840.GD23869@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	ltt-dev@lists.casi.polymtl.ca,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	Steven Rostedt <rostedt@goodmis.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:54173 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751976AbZAJQTI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Jan 2009 11:19:08 -0500
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

Hi Ted,

I just ported LTTng to 2.6.28 yesterday and started doing the port of
ext4/jbd2 to tracepoints. As you can see in my 0.74 announcement, the
tracepoint work for both jbd2 and ext4 is done. I also did the lttng
probe module for jbd2. Now I just have to create the probe module for
ext4. I also want to create debugfs files to control per-probe module
filtering, e.g. :

/mnt/debugfs/ltt/filter/jbd2/dev
/mnt/debugfs/ltt/filter/ext4/dev

Where writing to it would add device names to the filter list. I would
like a scheme where we can easily add/remove devices, list all
devices... I think ftrace already has something similar for
instrumentation activation.

The main question I am facing is : What interface semantic do we want
for such filter control file ?

Comments/ideas are welcome.

Mathieu

> 						- Ted
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
