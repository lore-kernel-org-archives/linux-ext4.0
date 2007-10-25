From: Chris Mason <chris.mason@oracle.com>
Subject: Re: compilebench numbers for ext4
Date: Thu, 25 Oct 2007 19:45:44 -0400
Message-ID: <20071025194544.25c6dd7f@think.oraclecorp.com>
References: <20071022193104.0beafeca@think.oraclecorp.com>
	<20071025103449.2e358220@gara>
	<20071025144355.583a8f88@think.oraclecorp.com>
	<20071025174025.1c042424@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:13826 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbXJYXrW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Oct 2007 19:47:22 -0400
In-Reply-To: <20071025174025.1c042424@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 25 Oct 2007 17:40:25 -0500
"Jose R. Santos" <jrs@us.ibm.com> wrote:

> > > 
> > > I really want to use seekwatcher to test some of the stuff that
> > > I'm doing for flex_bg feature but it barfs on me in my test
> > > machine.
> > > 
> > > running :sleep 10:
> > > done running sleep 10
> > > Device: /dev/sdh
> > >   Total:                     0 events (dropped 0),     1368 KiB
> > > data blktrace done
> > > Traceback (most recent call last):
> > >   File "/usr/bin/seekwatcher", line 534, in ?
> > >     add_range(hist, step, start, size)
> > >   File "/usr/bin/seekwatcher", line 522, in add_range
> > >     val = hist[slot]
> > > IndexError: list index out of range
> > 
> > I don't think you have any events in the trace.  Try this instead:
> > 
> > echo 3 > /proc/sys/vm/drop_caches
> > seekwatcher -t find-trace -d /dev/xxxx -p 'find /usr/local -type f'
> 
> Nope, get the same error.  There does seem to be data recorded in the
> trace files and iostat does show activity on the disk.

Hmmm, could you please send me your trace files.  There will be one for
each cpu, starting with find-trace-blktrace

> > I wanted to benchmark flexbg too, but couldn't quite figure out the
> > correct patch combination ;)
> 
> Ill attach e2progfs and Kernel patches but do realize that these are
> experimental patches that Im using to test what layout would work
> best.  Don't take them too seriously as it is largely incomplete.

Thanks, I'll try this out.

> 
> Currently trying to come up with workloads to test this and other
> changes with.  Im am warming up to yours :)

At least for the write phases of compilebench, it should benefit from
data and metadata separation.  It made a very big difference in btrfs,
(from 20MB/s up to 32MB/s on create).  However it did make the read
phases slower.

-chris
