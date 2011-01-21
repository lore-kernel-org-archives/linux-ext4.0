From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: speed up group trim
Date: Fri, 21 Jan 2011 10:53:33 -0700
Message-ID: <CD6D9488-48B7-4964-97DF-76B985FC8FAF@dilger.ca>
References: <1295577131-3778-1-git-send-email-tm@tao.ma> <alpine.LFD.2.00.1101211148180.3275@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:47279 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab1AURxf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Jan 2011 12:53:35 -0500
In-Reply-To: <alpine.LFD.2.00.1101211148180.3275@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Actually, I had another idea which might speed up trim operations significantly.  If the kernel keeps a bit in ext4_group_info->bb_state that indicates whether this group has any freed blocks since it last had a trim operation sent to it, then the kernel can completely avoid doing anything for that group.  This isn't just avoiding the need to scan the bitmap for free ranges, but more importantly it avoids sending the TRIM/UNMAP operation to the disk for free ranges that were previously trimmed in the backing storage.

Something like:

#define EXT4_GROUP_INFO_NEED_TRIM_BIT	1

/* Note that bit clear means a trim is needed, so that a newly mounted
* filesystem assumes that holes the group need to be trimmed. */
#define EXT4_MB_GRP_NEED_TRIM(grp)	\
	(!test_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &((grp)->bb_state)))


When calling the TRIM ioctl it can check EXT4_MB_GRP_NEED_TRIM(grp) and skip that group if it hasn't changed since last time.  Otherwise, it should call EXT4_MB_GRP_DONE_TRIM(grp) before doing the actual trim, so it is not racy with another process freeing blocks in that group.

In release_blocks_on_commit() it should call EXT4_MB_GRP_MUST_TRIM() to mark that the group needs to be trimmed again, since blocks were freed in the group.

This can potentially avoid a huge number of TRIMs to the disk, if this is run periodically (e.g. every day) and the filesystem is not remounted all the time, and does not undergo huge allocate/free/allocate cycles during daily use.

It would even be possible to store this bit on-disk ext4_group_desc->bg_flags to avoid the initial "assume every group needs to be trimmed" operation, if that ends up to be a significant factor.  However, that can be done later once some numbers are measured on how significant the initial-mount overhead is.  It is also not free, since it will cause disk IO to set/clear this bit.

Cheers, Andreas





