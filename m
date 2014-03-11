From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: fstrim has no effect on a just-mounted filesystem
Date: Tue, 11 Mar 2014 23:07:15 +0000
Message-ID: <20140311230715.GA19648@redhat.com>
References: <20140311213932.GA19176@redhat.com>
 <531F8456.2020404@redhat.com>
 <20140311220013.GV1346@redhat.com>
 <531F8953.1030702@redhat.com>
 <20140311225932.GW1346@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055AbaCKXHR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Mar 2014 19:07:17 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2BN7GMq011036
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2014 19:07:16 -0400
Content-Disposition: inline
In-Reply-To: <20140311225932.GW1346@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 11, 2014 at 10:59:32PM +0000, Richard W.M. Jones wrote:
> On Tue, Mar 11, 2014 at 05:08:19PM -0500, Eric Sandeen wrote:
> > blktrace is probably the place to start.  Do you see discard
> > requests?  then ext4 is doing its job.  If not, we can trace
> > ext4 to see why it's not issuing them, assuming there really
> > is work to do.
> 
> At the moment I can't get this to work.  The script I'm using is:
> 
> ----------------------------------------------------------------------
> set -e
> set -x
> trace-cmd record -e all -o /tmp/trace &
> pid=$!
> fstrim /sysroot
> kill $pid; sleep 2
> trace-cmd report -i /tmp/trace
> ----------------------------------------------------------------------

I got it to work by using:

----------------------------------------------------------------------
set -e
set -x
trace-cmd record -e all fstrim /sysroot
trace-cmd report
----------------------------------------------------------------------

The output is absolutely huge and I didn't capture it.

However just the act of doing the tracing *caused* the trim to happen
properly in the underlying disk.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-top is 'top' for virtual machines.  Tiny program with many
powerful monitoring features, net stats, disk stats, logging, etc.
http://people.redhat.com/~rjones/virt-top
