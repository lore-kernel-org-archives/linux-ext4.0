From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] Clustering indirect blocks in Ext2
Date: Thu, 25 Oct 2007 14:20:35 -0600
Message-ID: <20071025202035.GE3042@webber.adilger.int>
References: <d9885f0f0710250320u2af6dd3eq730f460c4ba538fd@mail.gmail.com> <d9885f0f0710250321l5f7b05e0q8990e8e3419c8f4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Abhishek Rai <abhishekrai@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:37820 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbXJYUUh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Oct 2007 16:20:37 -0400
Content-Disposition: inline
In-Reply-To: <d9885f0f0710250321l5f7b05e0q8990e8e3419c8f4@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 25, 2007  03:21 -0700, Abhishek Rai wrote:
> This patch modifies the block allocation strategy in ext2 in order to
> improve fsck performance.
> 
> Most of Ext2 metadata is clustered on disk. For example, Ext2
> partitions the block space into block groups and stores the metadata
> for each block group (inode table, block bitmap, inode bitmap) at the
> beginning of the block group. Clustering related metadata together not
> only helps ext2 I/O performance by keeping data and related metadata
> close together, but also helps fsck since it is able to find all the
> metadata in one place. However, indirect blocks are an exception.
> Indirect blocks are allocated on-demand and are spread out along with
> the data. This layout enables good I/O performance due to the close
> proximity between an indirect block and its data blocks but it makes
> things difficult for fsck which must now rotate almost the entire disk
> in order to read all indirect blocks.

I understand this does not change the on-disk format, but it does
introduce complexity into the ext2 code base, which we have been
trying to avoid for several reasons (risk of introducing bugs in
ext2, keeping it less complex for easier understanding of code).

There is a fair amount of existing work for reducing e2fsck time both
for crash recovery and full scanning of the filesystem.

Of course with ext3 journaling this removes most of the need for e2fsck
at boot time, but it does impact performance to some extent.  In ext4
there are several other features that also reduce e2fsck time, likely
more than what you will be getting with your patch.

- uninit_groups: keep a high watermark of inodes in use in each group, to
  avoid scanning the unused inodes during a full scan.  This has been
  shown to reduce full e2fsck times by 90%.
- extents: reduces the file metadata by at least an order of magnitude
  over indirect blocks.  For unfragmented files an extent-mapped inode
  can map up to 512MB without even using an indirect (index) block.  No
  indirect block reads/seeks is always better than optimized reads/seeks.
- delalloc+mballoc: this improves ext4 performance to be equal or better
  than ext2 performance for large IO by doing better block allocation to
  ensure large extents are allocated and avoiding seeks during IO and
  keeping the extents compact for fewer/no index blocks.

We also have Lustre patches against ext3 for most of these features
against "older" vendor kernels (SLES10 2.6.16, RHEL5 2.6.18) if that is
of interest to you (only delalloc isn't included in the existing Lustre
patch set, but I believe Alex had delalloc patches for 2.6.18 kernels
in the past).

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
