From: "Abhishek Rai" <abhishekrai@google.com>
Subject: Re: [PATCH] Clustering indirect blocks in Ext2
Date: Thu, 25 Oct 2007 15:56:11 -0700
Message-ID: <d9885f0f0710251556k98fc1e5le2d99167fa880457@mail.gmail.com>
References: <d9885f0f0710250320u2af6dd3eq730f460c4ba538fd@mail.gmail.com>
	 <d9885f0f0710250321l5f7b05e0q8990e8e3419c8f4@mail.gmail.com>
	 <20071025202035.GE3042@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Andreas Dilger" <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:31941 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbXJYW4P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Oct 2007 18:56:15 -0400
Received: from zps19.corp.google.com (zps19.corp.google.com [172.25.146.19])
	by smtp-out.google.com with ESMTP id l9PMuCBC014540
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 15:56:12 -0700
Received: from rv-out-0910.google.com (rvbk15.prod.google.com [10.140.87.15])
	by zps19.corp.google.com with ESMTP id l9PMuBIv024512
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 15:56:12 -0700
Received: by rv-out-0910.google.com with SMTP id k15so588525rvb
        for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 15:56:11 -0700 (PDT)
In-Reply-To: <20071025202035.GE3042@webber.adilger.int>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/25/07, Andreas Dilger <adilger@sun.com> wrote:
>
> I understand this does not change the on-disk format, but it does
> introduce complexity into the ext2 code base, which we have been
> trying to avoid for several reasons (risk of introducing bugs in
> ext2, keeping it less complex for easier understanding of code).

While this patch does add some complexity to ext2, it has the benefit
of backward and forward compatibility which will probably make it
attractive for more people than any change that changes on-disk
format.

> There is a fair amount of existing work for reducing e2fsck time both
> for crash recovery and full scanning of the filesystem.
>
> Of course with ext3 journaling this removes most of the need for e2fsck
> at boot time, but it does impact performance to some extent.  In ext4
> there are several other features that also reduce e2fsck time, likely
> more than what you will be getting with your patch.
>
> - uninit_groups: keep a high watermark of inodes in use in each group, to
>   avoid scanning the unused inodes during a full scan.  This has been
>   shown to reduce full e2fsck times by 90%.
> - extents: reduces the file metadata by at least an order of magnitude
>   over indirect blocks.  For unfragmented files an extent-mapped inode
>   can map up to 512MB without even using an indirect (index) block.  No
>   indirect block reads/seeks is always better than optimized reads/seeks.
> - delalloc+mballoc: this improves ext4 performance to be equal or better
>   than ext2 performance for large IO by doing better block allocation to
>   ensure large extents are allocated and avoiding seeks during IO and
>   keeping the extents compact for fewer/no index blocks.

Thanks for pointing these out. extents and delalloc+mballoc are of
course useful but are not a simple transition though I'm definitely
considering trying them out. Conceptually, my proposed patch has some
overlap with these patches. It keeps indirect blocks together allowing
them to be read in one go instead of seeking to and fro upon each
access. So although it doesn't reduce the metadata footprint on disk
(like extents) do, it achieves some of the same benefits (fewer
seeks), but of course there is a limit to these benefits (maximum one
metacluster per block group in my change though this can be changed)
and extents can do much better + they help keep memory and disk
footprint low helping both IO and fsck, etc. Still, I'd consider
metaclusters as poor man's extents :-)

Regarding the uninit_groups patch, I think it can be implemented in a
backward compatible way as follows. Instead of modifying the group
desc to store the number of unused inodes (bg_itable_inodes), we can
alternatively define an implicit boundary in every group's inode
bitmap by having a special free "marker" inode with a certain
signature. Whenever we need to allocate inodes in a group beyond this
boundary, we shift the boundary by using a later inode as the free
marker inode. The idea is that new ext2 will try to allocate inodes
from before the marker and fsck will not seek past the marker.

This will work with old ext2 because ext2 searches for free inodes
from the beginning of the group inode table bitmap, so if it ends up
allocating the marker inode, the absence of any markers will indicate
to new ext2 / fsck to fall back to old semantics.

There are a few assumptions here:
- we can come up with a reliable signature for the marker, that should
be easy as we can use most fields in inode for this except for the
link_count and given that ext2_new_inode() modifies many of the fields
of an inode adequately identifying a marker from a non-marker inode.
- Over time markers drift towards higher inode numbers but never
travel backwards, so a pathological workload can kill all markers
bringing us back to old behavior, but this is very unlikely.

How does this sound to you ?

Thanks,
Abhishek

> We also have Lustre patches against ext3 for most of these features
> against "older" vendor kernels (SLES10 2.6.16, RHEL5 2.6.18) if that is
> of interest to you (only delalloc isn't included in the existing Lustre
> patch set, but I believe Alex had delalloc patches for 2.6.18 kernels
> in the past).
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Software Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>
>
