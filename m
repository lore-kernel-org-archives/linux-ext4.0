From: Dave Chinner <david@fromorbit.com>
Subject: Re: A huge latency in ext4 and xfs because of stable page write
Date: Tue, 11 Dec 2012 22:17:07 +1100
Message-ID: <20121211111707.GU15784@dastard>
References: <20121211084520.GA13277@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, hch@infradead.org,
	darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28318 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752608Ab2LKLRL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Dec 2012 06:17:11 -0500
Content-Disposition: inline
In-Reply-To: <20121211084520.GA13277@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 11, 2012 at 04:45:21PM +0800, Zheng Liu wrote:
> Hi all,
> 
> At Tao Bao we meet a problem in our product system which causes a huge latency
> because of stable page write.  This problem is easy to reproduce in a testing
> environment, and I can reproduce it in my desktop with a SATA disk.  Here is the
> fio config file that is used to reproduce this problem.
> 
> config file
> -----------
> [global]
> iodepth=1
> directory=/mnt/sda3
> direct=0
> group_reporting
> thread
> fallocate=0
> runtime=120
> 
> [log-append]
> ioengine=sync
> rw=write
> bs=1k

Sub-page sized IO. That's guaranteed to have noticable IO latency
anomalies, regardless of stable data pages. If you are just
doing appending writes, then you can easily buffer them till you
have a page of data to write and avoid the problem altogether.

> Hence, I wonder whether or not we could revert stable page write temporarily.
> After it is improved, we could add it back again.

The plan is to turn it off for filesystems/devices that don't
require it. That list of devices will grow in future, so you
probably should plan to handle latencies in the application
properly...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
