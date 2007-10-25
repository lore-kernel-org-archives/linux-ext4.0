From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] Clustering indirect blocks in Ext2
Date: Thu, 25 Oct 2007 17:38:20 -0600
Message-ID: <20071025233820.GL3042@webber.adilger.int>
References: <d9885f0f0710250320u2af6dd3eq730f460c4ba538fd@mail.gmail.com> <d9885f0f0710250321l5f7b05e0q8990e8e3419c8f4@mail.gmail.com> <20071025202035.GE3042@webber.adilger.int> <d9885f0f0710251556k98fc1e5le2d99167fa880457@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Abhishek Rai <abhishekrai@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:55543 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300AbXJYXiX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Oct 2007 19:38:23 -0400
Content-Disposition: inline
In-Reply-To: <d9885f0f0710251556k98fc1e5le2d99167fa880457@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 25, 2007  15:56 -0700, Abhishek Rai wrote:
> While this patch does add some complexity to ext2, it has the benefit
> of backward and forward compatibility which will probably make it
> attractive for more people than any change that changes on-disk
> format.

To be honest, I think the number of people using ext2 on their systems
is relatively small compared to ext3 because of the e2fsck hit on each
boot.  IMHO, that means the engineering effort spent on improving
e2fsck for ext2 is less worthwhile than if the same effort was spent
on testing ext4 and the improvements made there.

My understanding is that the primary reason Google is using ext2 instead
of ext3 is because of the performance impact of journaling.  With the
performance (and also scalability) improvements in ext4, doesn't it make
sense to put test/development time and effort toward ext4?

> Thanks for pointing these out. extents and delalloc+mballoc are of
> course useful but are not a simple transition though I'm definitely
> considering trying them out.

Note that delalloc and mballoc don't strictly require extents, as
they are in-memory optimizations only.

> Regarding the uninit_groups patch, I think it can be implemented in a
> backward compatible way as follows. Instead of modifying the group
> desc to store the number of unused inodes (bg_itable_inodes), we can
> alternatively define an implicit boundary in every group's inode
> bitmap by having a special free "marker" inode with a certain
> signature. Whenever we need to allocate inodes in a group beyond this
> boundary, we shift the boundary by using a later inode as the free
> marker inode. The idea is that new ext2 will try to allocate inodes
> from before the marker and fsck will not seek past the marker.

The problem with this is that ext2 is not journalled and it is possible
that updates are not ordered on disk.  The danger is that the update
of the marker block is lost, but inodes are allocated after it. 

> - Over time markers drift towards higher inode numbers but never
> travel backwards, so a pathological workload can kill all markers
> bringing us back to old behavior, but this is very unlikely.

This is currently true of the uninit_groups feature also, because it
is a lot easier to avoid the problem of safely shrinking the high
watermark.  On the next e2fsck it will shrink the high watermark for
each group again.


Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
