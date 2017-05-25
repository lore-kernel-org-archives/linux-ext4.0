From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] libext2fs: correctly subtract xattr blocks on bigalloc
 filesystems
Date: Wed, 24 May 2017 20:10:38 -0700
Message-ID: <20170525031038.GA630@zzz>
References: <20170521062303.32296-1-ebiggers3@gmail.com>
 <91D3FA03-A23E-45C4-AA3D-575C52D59408@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:32927 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937754AbdEYDKm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 24 May 2017 23:10:42 -0400
Received: by mail-pf0-f194.google.com with SMTP id f27so36167643pfe.0
        for <linux-ext4@vger.kernel.org>; Wed, 24 May 2017 20:10:42 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <91D3FA03-A23E-45C4-AA3D-575C52D59408@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,

On Tue, May 23, 2017 at 10:19:35AM -0600, Andreas Dilger wrote:
> On May 21, 2017, at 12:23 AM, Eric Biggers <ebiggers3@gmail.com> wrote:
> > 
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > ext2fs_inode_data_blocks2() calculates an inode's data block count by
> > subtracting the external xattr block, if any, from the total blocks.
> > But on bigalloc filesystems, the xattr "block" is actually a whole
> > cluster, so ext2fs_inode_data_blocks2() would return a too-large value.
> > 
> > It seems this could have caused several different problems, but the one
> > I encountered was that xfstest generic/399 failed in the "bigalloc"
> > config because e2fsck incorrectly considered a symlink on the filesystem
> > to be corrupted at the end of the test.  This happened because e2fsck
> > incorrectly calculated a nonzero data block count for a "fast" symlink
> > with an external xattr block and therefore treated it as a "slow"
> > symlink, which failed validation.
> 
> I thought we changed this to detect "fast" inodes by i_size < 60 rather
> than using the blocks count, because the blocks count was (and apparently
> continues to be) unreliable for determining fast vs. slow symlinks.
> 
> However, ext4_inode_is_fast_symlink() still checks blocks count.  In
> "[PATCH] ext4: fix reading new encrypted symlinks on no-journal filesystems"
> we discussed whether this was safe, and it appears to be OK from my
> analysis.
> 
> We just continue to hit problems when extrapolating various blocks counts
> to detect fast symlinks rather than just using the same mechanism we use
> at creation time, which is "len > EXT4_N_BLOCKS * 4".
> 
> Cheers, Andreas
> 

Yes, I still think we probably should do that.  This bug needed to be fixed
anyway though, since ext2fs_inode_data_blocks2() is used for a bit more than
just distinguishing between fast and slow symlinks.

Eric
