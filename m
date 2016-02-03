From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: vfs/xfs: directio updates to ease COW handling V2
Date: Wed, 03 Feb 2016 16:53:04 -0500
Message-ID: <x49twlpxxz3.fsf@segfault.boston.devel.redhat.com>
References: <1454524816-11392-1-git-send-email-hch@lst.de>
	<x49zivhy3zt.fsf@segfault.boston.devel.redhat.com>
	<20160203200159.GK20038@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	xfs@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756255AbcBCVxG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Feb 2016 16:53:06 -0500
In-Reply-To: <20160203200159.GK20038@birch.djwong.org> (Darrick J. Wong's
	message of "Wed, 3 Feb 2016 12:01:59 -0800")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Darrick J. Wong" <darrick.wong@oracle.com> writes:

> On Wed, Feb 03, 2016 at 02:43:02PM -0500, Jeff Moyer wrote:
>> Hi, Christoph,
>> 
>> Can you explain a bit what you mean by easing COW handling?  Whenever I
>> see COW referenced near DIO, my mind always turns to g_u_p vs. fork.
>
> Just to clarify, I'm talking about copy on write for disk blocks, not for
> memory pages.
>
> Basically, XFS implements (disk block) copy on write for (perfectly block
> aligned) directio writes by allocating a set of replacement blocks, mapping the
> dio writes to the new blocks, and playing a punch/remap trick to map the new
> blocks into the file at the appropriate offset.
>
> If the write fails then we don't want do the remap, so the dio_complete handler
> has to know whether or not the IO succeeded, hence the new parameter.
> Furthermore, if the write succeeds but the remap fails, we also want to be able
> to report that to userspace, hence the change of return value from void to int.
>
> (If the dio write isn't block aligned, we fall back to the page cache.)
>
> Hope that helps,

Eric said the magic word: reflink.  I think I've got it now.

Thanks!
Jeff
