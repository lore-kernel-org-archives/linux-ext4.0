From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: can we simplify the quota matrix in ext4?
Date: Tue, 21 Jun 2011 13:24:57 -0600
Message-ID: <E794C3E7-985B-4A6F-B763-C7BBB14061FE@dilger.ca>
References: <4E00E6DE.9060208@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:64627 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757428Ab1FUTZA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jun 2011 15:25:00 -0400
In-Reply-To: <4E00E6DE.9060208@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-21, at 12:45 PM, Eric Sandeen wrote:
> I was looking at 
> 
> 62d2b5f2dcd3707b070efb16bbfdf6947c38c194 ext4: Always journal quota file modifications
> 
> and was thinking - if we always journal, why do we still have all the mount options etc for journaled quota?
> 
> I guess without -o usrjquota=foo we don't journal right from mount time, and there are a few other paths that get skipped, but those seem like details...
> 
> It seems that ideally - and perhaps this is hindsight - ext4 should have defaulted to journaled, QFMT_VFS_V1 quotas only... is there any reason not to?

This would be the ideal situation for Lustre as well.  The remaining issue,
AFAIK, is that e2fsck needs to do quota accounting internally so that there
is never a need to run a quotacheck on the filesystem.

Since e2fsck is already traversing all of the inodes, this is no extra effort
to keep a handful of bytes (inode count, blocks count) for each user.  I
believe there was someone at Google working on this?  Haven't seen any output
so far, however.

> I'm still not very well versed in vfs quota, but does it seem possible to
> move in this direction?  It seems odd that we should still be supporting
> unjournaled, vfsold-format quotas in ext4 these days.  What's the point?

I totally agree.

> If it seems possible to move in this direction within the exiting quota
> framework I'd be interested in trying to get it done.
> 
> Thanks,
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





