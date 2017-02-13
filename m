From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: don't BUG when truncating encrypted inodes on the
 orphan list
Date: Mon, 13 Feb 2017 10:19:27 -0500
Message-ID: <20170213151927.vi4pzuggm5t6kqe5@thunk.org>
References: <20170211031942.11783-1-tytso@mit.edu>
 <20170212220900.GA566@zzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34348 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752906AbdBMPTa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 13 Feb 2017 10:19:30 -0500
Content-Disposition: inline
In-Reply-To: <20170212220900.GA566@zzz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 12, 2017 at 02:09:00PM -0800, Eric Biggers wrote:
> On Fri, Feb 10, 2017 at 10:19:42PM -0500, Theodore Ts'o wrote:
> > Fix a BUG when the kernel tries to mount a file system constructed as
> > follows:
> > 
> > echo foo > foo.txt
> > mke2fs -Fq -t ext4 -O encrypt foo.img 100
> > debugfs -w foo.img << EOF
> > write foo.txt a
> > set_inode_field a i_flags 0x80800
> > set_super_value s_last_orphan 12
> > quit
> > EOF
> 
> I also had to pass '-b 4096' to mke2fs; otherwise mounting the filesystem failed
> with "Unsupported blocksize for fs encryption".

Sorry, oops.  My original test case didn't have the -O encrypt, and it
works equally well without the -O encrypt.

> e2fsck does clean up the orphan list, which lets the kernel mount the filesystem
> without crashing.  e2fsck also completes the truncates and is apparently
> supposed to zero out the unused portion of the last block, but it doesn't due to
> a bug.  See release_inode_block() in e2fsck/super.c:
> 
>         /*
>          * If part of the last block needs truncating, we do
>          * it here.
>          */
>         if ((blockcnt == pb->truncate_block) && pb->truncate_offset) {
>                 pb->errcode = io_channel_read_blk64(fs->io, blk, 1,
>                                                 pb->buf);
>                 if (pb->errcode)
>                         goto return_abort;
>                 memset(pb->buf + pb->truncate_offset, 0,
>                        fs->blocksize - pb->truncate_offset);
>                 pb->errcode = io_channel_write_blk64(fs->io, blk, 1,
>                                                  pb->buf);
>                 if (pb->errcode)
>                         goto return_abort;
>         }
> 
> 'blockcnt' is a logical block number, but 'truncate_block' is the number of
> blocks in the file, i.e. 1 plus the last logical block number.  So this gets
> executed on the block following the one intended, which is useless because that
> block then gets freed.

Ah, nice catch, thanks!

> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index bc282f9d0969..831d025e59ad 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -3944,6 +3944,10 @@ static int ext4_block_truncate_page(handle_t *handle,
> >  	unsigned blocksize;
> >  	struct inode *inode = mapping->host;
> >  
> > +	/* If we are processing an encrypted inode during orphan list handling */
> > +	if (!fscrypt_has_encryption_key(inode))
> > +		return 0;
> > +
> >  	blocksize = inode->i_sb->s_blocksize;
> >  	length = blocksize - (offset & (blocksize - 1));
> 
> Shouldn't it be:
> 
> 	if (ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode) &&
> 	    !fscrypt_has_encryption_key(inode))
> 		return 0;
> 
> ... since only encrypted regular files should be skipped?

We certainly don't want to add the ext4_encrypted_inode() test, since
this can fail even if -O encrypt is not enabled.  As for checking for
regular files, we could potentially fall into this code path for
non-regular files too (symlinks with length greater than 60 bytes come
to mind), and if we don't have the encryption key, there's no *point*
to try to zero beyond i_size --- and if we do, we're going to fail
with a BUG.

> Otherwise, I think this will be okay for now and better than the current
> situation, though the underlying problem of handling an interrupted truncate
> still needs to be solved.  Journalling the last block together with the i_size
> change sounds like it may be the right solution, though perhaps difficult to
> implement.

It *is* going to be hard, because the currently only way to _stop_
data journalling for a particular inode safely is to lock the journal
against any updates, flush all previously journalled blocks to their
final location on disk, empty the journal, and then unlock the journal
--- and doing that after any truncate of a file which is not deleted
is a performance non-starter.

I've been looking into this problem for the lazy journalling[1]
patches (in the unstable portion of the patch queue) with respect to
clearing the JOURNAL_DATA flag (via chattr) and...

	/*
	 * Clearing the JOURNAL_DATA flag is *hard* with lazy
	 * journalling.  We can't use jbd2_journal_flush(); instead,
	 * we must, for all blocks in the file which have been logged
	 * to the journal, save them to their final location on disk
	 * and insert revoke records for them, and then do a journal
	 * commit --- and while this whole procedure is being carried
	 * out, any attempts to write to the file must be locked out.
	 * Punt for now.
	 */
	if ((oldflags & EXT4_JOURNAL_DATA_FL) && !jflag &&
	    test_opt(inode->i_sb, JOURNAL_LAZY)) {
		err = -EOPNOTSUPP;
		goto flags_out;
	}

[1] https://www.usenix.org/conference/fast17/technical-sessions/presentation/aghayev
    (Final camera ready copy not up yet; pre-prints available on request)

This is somewhat easier for the truncate case, since there is only one
block that needs to be written out and revoked after the truncate
takes place, but it is still a going to be somewhat painful, since it
will require a forced flush for every truncate(2) system call to an
encrypted file.

Another way of doing it which might be simpler would be to allocate an
inode flag which if set, indicates that there may be data after i_size
which must be zero'ed, and the kernel can take care of that when it
actually has the key and the file is opened for reading or writing.
(We would need to make sure read-only mounts are handled properly,
since we can't modify the on-disk block or the inode in that case; so
there would be a second code path that would have to be tested
separately.)

    	   	  	     	    - Ted
