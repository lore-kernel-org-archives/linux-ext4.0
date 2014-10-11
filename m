From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix reservation overflow in ext4_da_write_begin
Date: Sat, 11 Oct 2014 19:52:00 -0400
Message-ID: <20141011235200.GD6262@thunk.org>
References: <542C7331.4070200@redhat.com>
 <542D6F2A.70006@redhat.com>
 <979DAB3D-0F2D-4CF2-BDF2-EF101713829B@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48040 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbaJKXwG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Oct 2014 19:52:06 -0400
Content-Disposition: inline
In-Reply-To: <979DAB3D-0F2D-4CF2-BDF2-EF101713829B@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 02, 2014 at 03:00:23PM -0600, Andreas Dilger wrote:
> On Oct 2, 2014, at 9:28 AM, Eric Sandeen <sandeen@redhat.com> wrote:
> > Delalloc write journal reservations only reserve 1 credit,
> > to update the inode if necessary.  However, it may happen
> > once in a filesystem's lifetime that a file will cross
> > the 2G threshold, and require the LARGE_FILE feature to
> > be set in the superblock as well, if it was not set already.
> > 
> > This overruns the transaction reservation, and can be
> > demonstrated simply on any ext4 filesystem without the LARGE_FILE
> > feature already set:
> > 
> > dd if=/dev/zero of=testfile bs=1 seek=2147483646 count=1 \
> > 	conv=notrunc of=testfile
> > sync
> > dd if=/dev/zero of=testfile bs=1 seek=2147483647 count=1 \
> > 	conv=notrunc of=testfile
> > 
> > leads to:
> > 
> > EXT4-fs: ext4_do_update_inode:4296: aborting transaction: error 28 in __ext4_handle_dirty_super
> > EXT4-fs error (device loop0) in ext4_do_update_inode:4301: error 28
> > EXT4-fs error (device loop0) in ext4_reserve_inode_write:4757: Readonly filesystem
> > EXT4-fs error (device loop0) in ext4_dirty_inode:4876: error 28
> > EXT4-fs error (device loop0) in ext4_da_write_end:2685: error 28
> > 
> > Adjust the number of credits based on whether the flag is
> > already set, and whether the current write may extend past the
> > LARGE_FILE limit.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Applied, thanks.  I added the likely() qualifer per Andreas'
suggestion.

						- Ted
