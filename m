From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] ext4: fix reading new encrypted symlinks on no-journal
 filesystems
Date: Fri, 18 Nov 2016 10:47:04 -0800
Message-ID: <20161118184704.GA73496@google.com>
References: <1479318627-143193-1-git-send-email-ebiggers@google.com>
 <2FD4E662-B708-4C34-B1FC-8D42083322A2@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:33511 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751965AbcKRSrH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Nov 2016 13:47:07 -0500
Received: by mail-pg0-f53.google.com with SMTP id 3so105686532pgd.0
        for <linux-ext4@vger.kernel.org>; Fri, 18 Nov 2016 10:47:07 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <2FD4E662-B708-4C34-B1FC-8D42083322A2@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 17, 2016 at 07:20:24PM -0700, Andreas Dilger wrote:
> On Nov 16, 2016, at 10:50 AM, Eric Biggers <ebiggers@google.com> wrote:
> > 
> > On a filesystem with no journal, a symlink longer than about 32
> > characters (exact length depending on padding for encryption) could not
> > be followed or read immediately after being created in an encrypted
> > directory.  This happened because when the symlink data went through the
> > delayed allocation path instead of the journaling path, the symlink was
> > incorrectly detected as a "fast" symlink rather than a "slow" symlink
> > until its data was written out.
> 
> IMHO, this again exposes an issue that we've seen with "fast" vs. "slow"
> symlink detection several times in the past whenever there is a data block
> allocated for a fast symlink (e.g. when xattrs were allowed on symlinks).
> 
> int ext4_inode_is_fast_symlink(struct inode *inode)
> {
>         int ea_blocks = EXT4_I(inode)->i_file_acl ?
>                 EXT4_CLUSTER_SIZE(inode->i_sb) >> 9 : 0;
> 
>         if (ext4_has_inline_data(inode))
>                 return 0;
> 
>         return (S_ISLNK(inode->i_mode) && inode->i_blocks - ea_blocks == 0);
> }
> 
> Instead of depending on the i_blocks count to detect slow symlinks, we
> should just check the i_size < EXT4_N_BLOCKS * 4 (or <=, need to verify).
> I believe this has always been true for fast symlinks, so it should be
> OK to make this change.  That will isolate us from future changes that
> may add block allocations to symlinks.
> 

Yes, this would be a much nicer way to detect fast symlinks.

The only thing I'd be concerned about is the possibility of pre-existing "slow"
symlinks that actually have targets short enough to be "fast" symlinks, perhaps
in filesystems created by old drivers or by external tools.  If such links
happened to work before, then a change to check i_size would break them.

This may not be an issue in practice.  I checked some old ext4 versions, ext2
from Linux 0.99.7, e2fsprogs, Android's ext4_utils, and FreeBSD's ext2 driver.
They all create "fast" symlinks if the length of the symlink target length
excluding the terminating null (i_size) is < 60.

Eric
