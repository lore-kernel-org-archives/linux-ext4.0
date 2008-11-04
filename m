From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC][PATCH 7/9]ext4: Add the EXT4_IOC_FIEMAP_INO ioctl
Date: Tue, 04 Nov 2008 14:42:50 -0700
Message-ID: <20081104214250.GX3184@webber.adilger.int>
References: <49019EF6.4000706@rs.jp.nec.com>
 <20081026084048.GF3184@webber.adilger.int> <49059633.8080600@rs.jp.nec.com>
 <20081027195524.GN3184@webber.adilger.int> <490AD3E4.1010908@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	Mingming Cao <cmm@us.ibm.com>, hch@infradead.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:35870 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302AbYKDVnR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Nov 2008 16:43:17 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mA4LhDw7016494
	for <linux-ext4@vger.kernel.org>; Tue, 4 Nov 2008 13:43:13 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K9T00601W6GXM00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 04 Nov 2008 13:43:13 -0800 (PST)
In-reply-to: <490AD3E4.1010908@rs.jp.nec.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Oct 31, 2008  18:46 +0900, Akira Fujita wrote:
>> Why does a regular user need to do the ioctl on a file that it may not
>> have read permission to access?  I can see this is useful for root
>> doing a defrag of the whole filesystem instead of opening and closing
>> all of the files, but for regular users we need to validate via the
>> full path to ensure they can even access the file before defragmenting it.
>
> The FIEMAP_INO ioctl just passes a inode number belongs to
> the target block group from user space to kernel space
> and then the owner check is done in the kernel space.
>
> If the regular user (defrag -f excecutant) is owner of a file,
> defrag handles this file as the candidate of victim file which would
> be moved to the other block group to make free space.
>
> So I think the full path check is unneeded because the owner check
> is done in the kernel space (I'm not sure it's good enough).
> If it's not good in the security point of view,
> I will make defrag -f mode be done only by root user.

If the defrag operation is limited to the owner of the file (or root
via CAP_DAC_OVERRIDE) then this is probably OK also.  The data never
gets to userspace so there is relatively little risk to this operation.

>>>> This was mentioned last time these patches were posted, but there was
>>>> no reply from you.  Christoph suggested a more generic VFS open-by-inum,
>>>> which isn't impossible to do but would cause a lot of controversy I
>>>> think, while the EXT4_IOC_WRAPPER is at least contained within ext4,
>>>> but is more generically useful than EXT4_IOC_FIEMAP_INO.
>
> How do the other ext4 developers think about
> implementing EXT4_IOC_WRAPPER?
> Will it be used only for defrag so far?

I expect the initial users of this ioctl will be FIEMAP and DEFRAG, but
it might also be useful for other ioctls in the future.

I haven't really asked other ext4 developers about it yet, and nobody
else has commented the last time I posted the patch.

I don't have an objection to Christoph's open-by-FH API, if there is
acceptance of this from other kernel developers (Al Viro in particular),
but that exposes a lot more security issues than just the ioctl wrapper.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

