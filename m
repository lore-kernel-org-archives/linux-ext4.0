From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: data=journal busted
Date: Fri, 16 Feb 2007 15:42:46 -0800
Message-ID: <20070216154246.7b9a643c.akpm@linux-foundation.org>
References: <20070215204445.411d2760.akpm@linux-foundation.org>
	<20070216233108.GY10715@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41488 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946298AbXBPXnS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Feb 2007 18:43:18 -0500
In-Reply-To: <20070216233108.GY10715@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 16 Feb 2007 16:31:09 -0700
Andreas Dilger <adilger@clusterfs.com> wrote:

> > I suspect we should resurrect and formalise my old
> > make-the-disk-stop-accepting-writes-when-a-timer-goes-off thing.  It was
> > very useful for stress-testing recovery.
> 
> We have a patch that we use for Lustre testing which allows you to set a
> block device readonly (silently discarding all writes), without the
> filesystem immediately keeling over dead like set_disk_ro.  The readonly
> state persists until the the last reference on the block device is dropped,
> so there are no races w.r.t. VFS cleanup of inodes and flushing buffers
> after the filesystem is unmounted.

Not sure I understand all that.

For this application, we *want* to expose VFS races, errors in handling
EIO, errors in handling lost writes, etc.  It's another form of for-developers
fault injection, not a thing-for-production.

The reason I prefer doing it from the timer interrupt is to toss more
randomness in there, avoid the possibility of getting synchronised
with application or kernel activity in some fashion.

I don't know if there's much value in that, but it provides peace-of-mind.


I'm now seeing reports that ordered-data is corrupting data and metadata,
as is data=writeback.  I'm hoping that the blame lies with the
allededly-battery-backed RAID controller, but it could be ext3.  Has anyone
actually done any decent recovery testing in the past half decade?
