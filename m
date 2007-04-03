From: Andreas Dilger <adilger-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] Correction to check_filetype()
Date: Tue, 3 Apr 2007 11:37:16 -0600
Message-ID: <20070403173716.GW5967@schatzie.adilger.int>
References: <1172049359.4727.15.camel@garfield>
	<20070331004417.GJ3198@thunk.org>
	<20070331081624.GF5967@schatzie.adilger.int>
	<20070331123509.GA25539@thunk.org>
	<20070331143926.GG25539@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Lustre-discuss <Lustre-discuss-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org>
To: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <lustre-discuss-bounces-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20070331143926.GG25539-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
List-Unsubscribe: <https://mail.clusterfs.com/mailman/listinfo/lustre-discuss>,
	<mailto:lustre-discuss-request-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://mail.clusterfs.com/pipermail/lustre-discuss>
List-Post: <mailto:lustre-discuss-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org>
List-Help: <mailto:lustre-discuss-request-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org?subject=help>
List-Subscribe: <https://mail.clusterfs.com/mailman/listinfo/lustre-discuss>,
	<mailto:lustre-discuss-request-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org?subject=subscribe>
Sender: lustre-discuss-bounces-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org
Errors-To: lustre-discuss-bounces-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Mar 31, 2007  10:39 -0400, Theodore Tso wrote:
> I'm going to let this one soak for a bit to make sure we don't pick up
> any fase positives or negatives in the hueristics.
> 
> @@ -133,11 +133,10 @@ int e2fsck_pass1_check_device_inode(ext2
> +	 * If the index flag is set, then this is a bogus
> +	 * device/fifo/socket
>  	 */
> -	if ((ext2fs_inode_data_blocks(fs, inode) != 0) ||
> -	    (inode->i_flags & EXT2_INDEX_FL))
> +	if (inode->i_flags & EXT2_INDEX_FL)
>  		return 0;

There were ancient versions of the kernel that left EXT2_INDEX_FL set
on all files, instead of just directories...  I'm not sure if those
were in actual released kernels, or just in patches.

> +static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
> +				char *buf)
> +{
> +	if (ext2fs_read_dir_block(ctx->fs, inode->i_block[0], buf))
> +		return;

Do we call check_blocks() on this inode shortly thereafter?  If we do then
the overhead of reading the first block is offset by not reading it again
later.  Otherwise, this could slow things down.

> +	dirent = (struct ext2_dir_entry *) buf;
> +	if (((dirent->name_len & 0xFF) != 1) ||
> +	    (dirent->name[0] != '.') ||
> +	    (dirent->inode != pctx->ino) ||
> +	    (dirent->rec_len < 12) ||
> +	    (dirent->rec_len % 4) ||
> +	    (dirent->rec_len >= ctx->fs->blocksize - 12))
> +		return;
> +
> +	dirent = (struct ext2_dir_entry *) (buf + dirent->rec_len);
> +	if (((dirent->name_len & 0xFF) != 2) ||
> +	    (dirent->name[0] != '.') ||
> +	    (dirent->name[1] != '.') ||
> +	    (dirent->rec_len < 12) ||
> +	    (dirent->rec_len % 4))
> +		return;
> +
> +	if (fix_problem(ctx, PR_1_TREAT_AS_DIRECTORY, pctx)) {
> +		inode->i_mode = (inode->i_mode & 07777) | LINUX_S_IFDIR;
> +		e2fsck_write_inode_full(ctx, pctx->ino, inode, 
> +					EXT2_INODE_SIZE(ctx->fs->super), 
> +					"check_is_really_dir");
>  	}

The one worry I have here (though I don't think it is necessarily IN
the code you propose) is that someone could create a regular file which
looks like a directory and somehow get it linked into the filesystem
tree, giving them escalated access (e.g. device files owned by them,
suid executables, links to otherwise unreadable files, etc).

It would seem that this is only a danger if the mode on the file is
corrupted, which shouldn't really be doable by a regular user, but
it is definitely something to consider.

I take it that this code fixes the test image I previously posted?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
