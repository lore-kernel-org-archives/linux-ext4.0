From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] dynamic inodes
Date: Thu, 25 Sep 2008 16:37:31 -0600
Message-ID: <20080925223731.GM10950@webber.adilger.int>
References: <48DA28B0.2020207@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Alex Tomas <bzzz@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:52111 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbYIYWhx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Sep 2008 18:37:53 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m8PMbrhi016721
	for <linux-ext4@vger.kernel.org>; Thu, 25 Sep 2008 15:37:53 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K7R00901W609H00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 25 Sep 2008 15:37:53 -0700 (PDT)
Received: from webber.adilger.int ([68.147.167.155])
 by fe-sfbay-10.sun.com (Sun Java System Messaging Server 6.2-8.04 (built Feb
 28 2007)) with ESMTPSA id <0K7R00IWCW73LGB0@fe-sfbay-10.sun.com> for
 linux-ext4@vger.kernel.org; Thu, 25 Sep 2008 15:37:52 -0700 (PDT)
In-reply-to: <48DA28B0.2020207@sun.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 24, 2008  15:46 +0400, Alex Tomas wrote:
> another idea how to achieve more (dynamic) inodes:

Actually, Jos=E9 propsed a _very_ simple idea that would allow dynamic
inodes with relatively low code complexity or risk due to dynamic
placement of inode tables.

The basic idea is to extend the FLEX_BG feature so that (essentially)
"blockless groups" can be added to the filesystem when the inodes are
all gone.  The core idea of FLEX_BG is that the "group metadata" (inode
and block bitmaps, inode table) can be placed anywhere in the filesyste=
m.
This implies that a "block group" is strictly just a contiguous range o=
f
blocks, and somewhere in the filesystem is the metadata that describes =
its
usage.

If one adds a new group (ostensibly "at the end of the filesystem") tha=
t
has a flag which indicates there are no blocks available in the group,
then what we get is the inode bitmap and inode table, with a 1-block
"excess baggage" of the block bitmap and a new group descriptor.  The
"baggage" is small considering any overhead needed to locate and descri=
be
fully dynamic inode tables.

A big plus is that there are very few changes needed to the kernel or
e2fsck (the "dynamic inode table" is just a group which has no space
for data).  Some quick checks on 10 filesystems (some local, some
server) shows that there is enough contiguous space in the filesystems
to allocate a full inode table (between 1-4MB for most filesystems), an=
d
mballoc can help with this.  This makes sense because the cases where
there is a shortage of inodes also means there is an excess of space,
and if the inodes were under-provisioned it also (usually) means the
itable is on the smaller side.

Another important benefit is that the 32-bit inode space is used fully
before there is any need to grow to 64-bit inodes.  This avoids the
compatibility issues with userspace to the maximum possible extent,
without any complex remapping of inode numbers.

We could hedge our bets for finding large enough contiguous itable spac=
e
and allow the itable to be smaller than normal, and mark the end inodes
as in-use.  e2fsck will in fact consider any blocks under the rest of
the inode table as "shared blocks" and do duplicate block processing to
remap the data blocks.  We could also leverage online defrag to remap
the blocks before allocating the itable if there isn't enough space.

Another major benefit of this approach is that the "dynamic" inode tabl=
e
is actually relatively static in location, and we don't need a tree to
find it.  We would continue to use the "normal" group inodes first, and
only add dynamic groups if there are no free inodes.  It would also be
possible to remove the last dynamic group if all its inodes are freed.

The itable location would be replicated to all of the group descriptor
backups for safety, though we would need to find a way for "META_BG"
to store a backup of the GDT in blocks that don't exist, in the case
where increasing the GDT size in-place isn't possible.

The drawbacks of the approach is relatively coarse-grained itable
allocation, which would fail if the filesystem is highly fragmented,
but we don't _have_ to succeed either.  The coarse-grained approach is
also a benefit because we don't need complex data structures to find th=
e
itable, it reduces seeking during e2fsck, and we can keep some hysteres=
is
in adding/removing dynamic groups to reduce overhead (updates of many
GDT backups).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
