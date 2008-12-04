From: Eric Sandeen <sandeen@redhat.com>
Subject: RFC, 32-bit compat handlers for EXT4_IOC_GROUP_ADD
Date: Thu, 04 Dec 2008 16:37:57 -0600
Message-ID: <49385BC5.2070703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60937 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549AbYLDWiB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Dec 2008 17:38:01 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mB4Mbxup028887
	for <linux-ext4@vger.kernel.org>; Thu, 4 Dec 2008 17:37:59 -0500
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB4Mbwcb001897
	for <linux-ext4@vger.kernel.org>; Thu, 4 Dec 2008 17:37:59 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id mB4MbvqU008804
	for <linux-ext4@vger.kernel.org>; Thu, 4 Dec 2008 17:37:58 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Unfortunately the argument to EXT4_IOC_GROUP_ADD contains padding on
64-bit arches, not present on 32-bit arches:

struct ext4_new_group_input {
	__u32            group;                /*     0     4 */

	/* XXX 4 bytes hole, try to pack */

	__u64            block_bitmap;         /*     8     8 */
	__u64            inode_bitmap;         /*    16     8 */
	__u64            inode_table;          /*    24     8 */
	__u32            blocks_count;         /*    32     4 */
	__u16            reserved_blocks;      /*    36     2 */
	__u16            unused;               /*    38     2 */

	/* size: 40, cachelines: 1 */
	/* sum members: 36, holes: 1, sum holes: 4 */
	/* last cacheline: 40 bytes */
};

due to the new 64-bit types, which want to align on 64-bit boundaries.
So, when called from an ia32 executable on a 64-bit kernel, the size of
the arg is "wrong" and the ioctl fails:

ioctl32(resize2fs:3595): Unknown cmd fd(99) cmd(80186608){t:'f';sz:24}
arg(ff8ce8a0) on /mnt/tmp

The simple/straightforward fix is to add a compat handler, which I've
written:

 ext4.h  |   12 ++++++++++++
 ioctl.c |   25 ++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletion(-)

this bloats the kernel just a bit; we have to add a compat arg structure
which is packed, then copy in the elements, and dispatch it to the
native ioctl handler.

It's too bad this wasn't caught sooner, but I wonder if maybe it's still
not too late; can we change the structure in the kernel and have newer
e2fsprogs try both the old & new?  The new interface would add 32 bits
of padding to the structure; this would leave it unchanged on 64-bit
boxes so everything would continue to work.  Newer e2fsprogs would try
both, so still work on older kernels.  32-bit compat would have a simple
handler, *but* this *would* break resize of ext4 on native 32-bit
machines with older e2fsprogs (the kernel would have a padded struct;
older userspace would not, and the ioctl would fail).

How far out of "dev" are we?  I'm leaning towards saying "oh well, would
have been nicer the other way" but going ahead and just putting the
compat handler into the kernel.

Thoughts?

-Eric
