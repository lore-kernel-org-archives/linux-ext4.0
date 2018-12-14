Return-Path: <SRS0=b4XO=OX=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35300 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbeLNDk4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 13 Dec 2018 22:40:56 -0500
Date: Thu, 13 Dec 2018 22:40:52 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org, Miao Xie <miaoxie@huawei.com>,
        yangerkun <yangerkun@huawei.com>
Subject: Re: Question about commit "ext4: always initialize the crc32c
 checksum driver"
Message-ID: <20181214034052.GC20880@thunk.org>
References: <d686d167-9ad2-bfd6-3464-fb35c10ae63d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d686d167-9ad2-bfd6-3464-fb35c10ae63d@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 13, 2018 at 03:56:04PM +0800, zhangyi (F) wrote:
> I am checking a CVE patch a45403b515 "ext4: always initialize the crc32c checksum driver"[1]
> in CVE-2018-1094[2] recently, and have a question about the commit log in this patch.
> 
> The patch commit log said:
> 
> > The extended attribute code now uses the crc32c checksum for hashing
> > purposes, so we should just always always initialize it.  We also want
> > to prevent NULL pointer dereferences if one of the metadata checksum
> > features is enabled after the file sytsem is originally mounted.
> 
> This first fix is clear. But I don't understand the second fix. IIUC, the kernel does not call
> ext4_set_feature_metadata_csum() to enable metadata checksum, and this feature can only be enabled
> by mkfs,turn2fs or change the image directly. So this feature bit will never change once the
> file system is mounted, the second case could never happen ?

This was triggered by a maliciously created file system where the
journal contained a superblock which had the metadata checksum feature
enabled (although the superblock which was visible to the kernel when
it was initially mounted did not have the metadata checksum field
set).

So the file system would get mounted, with metadata_csum not enabled,
so the crc32c checksum was not initialized.  Then the journal replay
would overwrite the superblock with a version that had the
metadata_csum feature set.  And then the next time the kernel tried to
fetch an inode, it would try to check the inode's metadata checksum,
and dereference a NULL pointer.... and boom.

This was found by a researcher that was investigating file system
fuzzing techniques.  So if you have a system with automount enabled,
this is one more way that someone with access to the USB port could
plug in a maliciously crafted file system, and cause the system to
crash, or at least oops.  I don't think *this* particular one could be
exploited to cause a remote execution attack, just a DOS, but it's why
it was assigned a CVE.

> BTW, does this patch need on the old kernel before dec214d00e "ext4: xattr inode deduplication" ?

It's needed on any old kernel which supports the metadata checksum
feature.

Cheers,

					- Ted
