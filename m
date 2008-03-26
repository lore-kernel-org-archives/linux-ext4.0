From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: mballoc errors
Date: Wed, 26 Mar 2008 16:31:31 -0700
Message-ID: <1206574291.3637.23.camel@localhost.localdomain>
References: <47EAC302.5040109@redhat.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37710 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954AbYCZXbf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Mar 2008 19:31:35 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m2QNVWQM021410
	for <linux-ext4@vger.kernel.org>; Wed, 26 Mar 2008 19:31:32 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2QNVWNK201874
	for <linux-ext4@vger.kernel.org>; Wed, 26 Mar 2008 19:31:32 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2QNVW9u009148
	for <linux-ext4@vger.kernel.org>; Wed, 26 Mar 2008 19:31:32 -0400
In-Reply-To: <47EAC302.5040109@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2008-03-26 at 16:41 -0500, Eric Sandeen wrote:
> This report just came in on the fedora list...
> 
> EXT4-fs error (device dm-0): ext4_mb_generate_buddy: EXT4-fs: group 717:
> 23410 blocks in bitmap, 23411 in gd
> 
> EXT4-fs error (device dm-0): ext4_mb_generate_buddy: EXT4-fs: group 721:
> 19309 blocks in bitmap, 19333 in gd
> 
> has anyone else seen this problem in testing?  I guess it means
> freespace accounting got out of sync...?
> 
No, I haven't seen this before. The related code is
ext4_mb_generate_buddy(..)
{
....
        if (free != grp->bb_free) {
                ext4_error(sb, __func__,
                        "EXT4-fs: group %lu: %u blocks in bitmap, %u in gd\n",
                        group, free, grp->bb_free);
                /*
                 * If we intent to continue, we consider group descritor
                 * corrupt and update bb_free using bitmap value
                 */
                grp->bb_free = free;
        }
}


I guess the free blocks counter in in-memory group descriptor is not
sync with the on-disk bitmap. Looks like mballoc introduced in-core
block group descriptor(struct ext4_group_info) and keep track of free
blocks counter in the in-core block group
descriptor(ext4_group_info.bb_free), while the non-mballoc allocation
accounting is done via the on-disk block group descriptor, which is
likely, the metadata block(s) (e.g index extent block, xattr block) are
all allocated in the old way (ext4_new_blocks_old()). 

I guess this out-of-sync happens already without notice, only when the
buddy info for this block group is re-generated after being pushed out
of memory under pressure this check is being hit.

> Thanks,
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

