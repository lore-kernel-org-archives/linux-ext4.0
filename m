From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC] on-line resize with flex_bg and exclude_bitmap
Date: Tue, 12 Apr 2011 14:27:06 +0300
Message-ID: <BANLkTimfddp_6LkfCMfAe_SA2wa3t3jrMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46988 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab1DLL1G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Apr 2011 07:27:06 -0400
Received: by qyk7 with SMTP id 7so1904388qyk.19
        for <linux-ext4@vger.kernel.org>; Tue, 12 Apr 2011 04:27:06 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

I realized another issue regarding exclude bitmap compatibility.
the exiting EXT4_IOC_GROUP_ADD ioctl doesn't pass a field for the location
of exclude_bitmap block, so we need to either allocate exclude_bitmap in kernel
or define a new ioctl, which passes the exclude_bitmap to kernel.

If we are going to go with the latter solution, we may want to add
support for flex_bg
layout for the new ioctl, so following is my proposal for
EXT4_IOC_FLEX_GROUP_ADD:

1. As far as online resize and mkfs are concerned, we always allocate all
group descriptors of a flex bg at the same time.

2. If there is not enough space for all flex_bg metadata in the last group,
the last group will be dropped.

3. The new flex group input will assume all bitmaps of the same type are
consecutive, so only the address of the first bitmap is needed as input.

struct ext4_new_flex_group_input {
        __u32 group;            /* Group number for this data */
        __u64 block_bitmap;     /* Absolute block number of first
block bitmap */
        __u64 exclude_bitmap;     /* Absolute block number of first
exclude bitmap */
        __u64 inode_bitmap;     /* Absolute block number of first
inode bitmap */
        __u64 inode_table;      /* Absolute block number of first
inode table start */
        __u32 blocks_count;     /* Total number of blocks in this flex group */
        __u16 reserved_blocks;  /* Number of reserved blocks in this
flex group */
        __u16 flex_size;            /* Number of groups in the flex group */
};

4. ext4_group_extend() should be the same except we need to allow extending
within the last flex bg, but not necessarily the last block group.


To look at this from a different angle, if you imagine that the flex
group is just
a big group, whose bitmaps and group descriptor are flex_size times bigger and
where ext4_new_flex_group_input encodes the info of the big descriptor,
then this design is identical to the current implementation of online resize.

What I will do, if you agree to this design, is use the new ioctl,
with flex_size = 1
to pass the exclude_bitmap in online resize and enforce flex_size == 1
in kernel.
Then later we can teach resize2fs and the kernel to extend flex groups properly
using the new ioctl.

What do you think?
Can you think of another way I can support exclude_bitmap and online resize,
without the need for a new ioctl?

Amir.
