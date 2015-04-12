From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 20/22] ext4 crypto: Add symlink encryption
Date: Sun, 12 Apr 2015 01:29:53 -0400
Message-ID: <20150412052953.GK6540@thunk.org>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu>
 <1428012659-12709-21-git-send-email-tytso@mit.edu>
 <3E172AFE-2288-4115-9D3A-E4A047311D27@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jaegeuk@kernel.org, mhalcrow@google.com,
	Uday Savagaonkar <savagaon@google.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34816 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbbDLF35 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Apr 2015 01:29:57 -0400
Content-Disposition: inline
In-Reply-To: <3E172AFE-2288-4115-9D3A-E4A047311D27@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 08, 2015 at 11:58:02AM -0600, Andreas Dilger wrote:
> On Apr 2, 2015, at 4:10 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> > +/**
> > + * For encrypted symlinks, the ciphertext length is stored at the beginning
> > + * of the string in little-endian format.
> > + */
> > +struct ext4_encrypted_symlink_data {
> > +	__le32 len;
> > +	char encrypted_path[1];
> > +} __attribute__((__packed__));
> 
> We can't have a symlink size larger than a block (or possibly PATH_MAX),
> can we?  That would allow using __le16 for the symlink length, and
> checkpatch.pl will complain about __attribute__((__packed__)) and
> request the use of __packed instead.

Yes, although it's a bit pointless since right now we don't support
fast encrypted symlinks.  What we should probably do is to switch to
using CTS, and then add fast encrypted symlinks, and then use __le16
here.

When did checkpatch start complaining about
__attribute__((__packed__))?  It's not complaining for me.

> > +static inline u32 encrypted_symlink_data_len(u32 l)
> > +{
> > +	return ((l + EXT4_CRYPTO_BLOCK_SIZE - 1) / EXT4_CRYPTO_BLOCK_SIZE)
> > +		* EXT4_CRYPTO_BLOCK_SIZE
> > +		+ sizeof(struct ext4_encrypted_symlink_data) - 1;
> 
> Coding style has operators at the end of the line instead of the start.

Thanks, fixed.

> > +		else {
> > +			sd = kmalloc(l2 + 1, GFP_NOFS);
    			   ...
> 
> Can "sd" moved inside this scope?  It doesn't appear to be used outside.

Good point, thanks.

> > diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
> > index ff37119..d788891 100644
> > --- a/fs/ext4/symlink.c
> > +++ b/fs/ext4/symlink.c
> > @@ -22,9 +22,106 @@
> > #include <linux/namei.h>
> > #include "ext4.h"
> > #include "xattr.h"
> > +#include "ext4_crypto.h"
> > 
> > +#ifdef CONFIG_EXT4_FS_ENCRYPTION
> > static void *ext4_follow_link(struct dentry *dentry, struct nameidata *nd)
> > {
> > +	struct page *cpage = NULL;
> > +	char *caddr, *paddr;
> > +	struct ext4_str cstr, pstr;
> > +	struct inode *inode = dentry->d_inode;
> > +	struct ext4_fname_crypto_ctx *ctx = NULL;
> > +	struct ext4_encrypted_symlink_data *sd;
> > +	loff_t size = min(inode->i_size, (loff_t) PAGE_SIZE-1);
> 
> No space after typecast.  Should this use min_t() instead?

I'll change it to use min_t, thanks.

> > +		if ((cstr.len + sizeof(struct ext4_encrypted_symlink_data) - 1)
> > +			> inode->i_sb->s_blocksize) {
> 
> Operator at the end of the previous line.
> Continued line should align after '(' from previous line.

Thanks, will fix.

> > +		plen = (cstr.len < EXT4_FNAME_CRYPTO_DIGEST_SIZE*2)
> > +			? EXT4_FNAME_CRYPTO_DIGEST_SIZE*2
> > +			: cstr.len;
> 
> Operators at the end of the previous line.

Thanks, will fix.

						- Ted
