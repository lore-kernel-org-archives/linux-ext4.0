From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] ext4: don't BUG when truncating encrypted inodes on the
 orphan list
Date: Sun, 12 Feb 2017 14:09:00 -0800
Message-ID: <20170212220900.GA566@zzz>
References: <20170211031942.11783-1-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34337 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751509AbdBLWJD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 12 Feb 2017 17:09:03 -0500
Received: by mail-pf0-f195.google.com with SMTP id o64so5077686pfb.1
        for <linux-ext4@vger.kernel.org>; Sun, 12 Feb 2017 14:09:03 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20170211031942.11783-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 10, 2017 at 10:19:42PM -0500, Theodore Ts'o wrote:
> Fix a BUG when the kernel tries to mount a file system constructed as
> follows:
> 
> echo foo > foo.txt
> mke2fs -Fq -t ext4 -O encrypt foo.img 100
> debugfs -w foo.img << EOF
> write foo.txt a
> set_inode_field a i_flags 0x80800
> set_super_value s_last_orphan 12
> quit
> EOF

I also had to pass '-b 4096' to mke2fs; otherwise mounting the filesystem failed
with "Unsupported blocksize for fs encryption".

(I also added 'zap_block -f a 0 -p 42' so that I could see if/when the unused
portion of the block gets zeroed.)

> The problem is that when the kernel tries to truncate an inode in
> ext4_truncate(), it tries to clear any on-disk data beyond i_size.
> Without the encryption key, it can't do that, and so it triggers a
> BUG.
> 
> E2fsck does *not* provide this service, and in practice most file
> systems have their orphan list processed by e2fsck, so to avoid
> crashing, this patch skips this step if we don't have access to the
> encryption key (which is the case when processing the orphan list; in
> all other cases, we will have the encryption key, or the kernel
> wouldn't have allowed the file to be opened).
> 
> An open question is whether the fact that e2fsck isn't clearing the
> bytes beyond i_size causing problems --- and if we've lived with it
> not doing it for so long, can we drop this from the kernel replay of
> the orphan list in all cases (not just when we don't have the key for
> encrypted inodes).

e2fsck does clean up the orphan list, which lets the kernel mount the filesystem
without crashing.  e2fsck also completes the truncates and is apparently
supposed to zero out the unused portion of the last block, but it doesn't due to
a bug.  See release_inode_block() in e2fsck/super.c:

        /*
         * If part of the last block needs truncating, we do
         * it here.
         */
        if ((blockcnt == pb->truncate_block) && pb->truncate_offset) {
                pb->errcode = io_channel_read_blk64(fs->io, blk, 1,
                                                pb->buf);
                if (pb->errcode)
                        goto return_abort;
                memset(pb->buf + pb->truncate_offset, 0,
                       fs->blocksize - pb->truncate_offset);
                pb->errcode = io_channel_write_blk64(fs->io, blk, 1,
                                                 pb->buf);
                if (pb->errcode)
                        goto return_abort;
        }

'blockcnt' is a logical block number, but 'truncate_block' is the number of
blocks in the file, i.e. 1 plus the last logical block number.  So this gets
executed on the block following the one intended, which is useless because that
block then gets freed.

So I think that should be fixed too, but zeroing still wouldn't be appropriate
for encrypted regular files, so it would need to be skipped on such files.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index bc282f9d0969..831d025e59ad 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3944,6 +3944,10 @@ static int ext4_block_truncate_page(handle_t *handle,
>  	unsigned blocksize;
>  	struct inode *inode = mapping->host;
>  
> +	/* If we are processing an encrypted inode during orphan list handling */
> +	if (!fscrypt_has_encryption_key(inode))
> +		return 0;
> +
>  	blocksize = inode->i_sb->s_blocksize;
>  	length = blocksize - (offset & (blocksize - 1));

Shouldn't it be:

	if (ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode) &&
	    !fscrypt_has_encryption_key(inode))
		return 0;

... since only encrypted regular files should be skipped?

Otherwise, I think this will be okay for now and better than the current
situation, though the underlying problem of handling an interrupted truncate
still needs to be solved.  Journalling the last block together with the i_size
change sounds like it may be the right solution, though perhaps difficult to
implement.

- Eric
