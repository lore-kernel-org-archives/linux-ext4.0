From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2image: double free when restoring image
Date: Mon, 2 Dec 2013 13:26:06 -0500
Message-ID: <20131202182606.GA11204@thunk.org>
References: <529664F6.3040103@ddn.com>
 <2536F444-3B5C-4A73-94A1-9464F89B29CD@intel.com>
 <529CC2E7.90806@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Dilger, Andreas" <andreas.dilger@intel.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Kit Westneat <kwestneat@ddn.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35692 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724Ab3LBS0O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Dec 2013 13:26:14 -0500
Content-Disposition: inline
In-Reply-To: <529CC2E7.90806@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 02, 2013 at 12:27:03PM -0500, Kit Westneat wrote:
> diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
> index 113b80e..6861cfe 100644
> --- a/lib/ext2fs/openfs.c
> +++ b/lib/ext2fs/openfs.c
> @@ -441,6 +441,7 @@ errcode_t ext2fs_rewrite_to_io(ext2_filsys fs,
> io_channel new_io)
>  {
>  	if ((fs->flags & EXT2_FLAG_IMAGE_FILE) == 0)
>  		return EXT2_ET_NOT_IMAGE_FILE;
> +	new_io->block_size = fs->io->block_size;

One other thought; we should really use io_channel_set_blksize(),
which is the supported interface to set the blocksize.  This makes
sure that if there is any cached blocks, they are flushed, and there
might also some other io_channels, either now in the future (i.e., to
talk to Windows, etc.) where some kind of ioctl or other io control
functoin might be needed to set the block size.

I'll send out a corrected patch.

Thanks again, for looking into this!

					- Ted
