From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] ext4 crypto: migrate into vfs's crypto engine
Date: Fri, 6 May 2016 21:31:02 -0500
Message-ID: <20160507023102.GB906@zzz>
References: <1461629736-16523-1-git-send-email-jaegeuk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu, linux-ext4@vger.kernel.org
To: Jaegeuk Kim <jaegeuk@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1461629736-16523-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Jaegeuk,

On Mon, Apr 25, 2016 at 05:15:36PM -0700, Jaegeuk Kim wrote:
> This patch removes the most parts of internal crypto codes.
> And then, it modifies and adds some ext4-specific crypt codes to use the generic
> facility.

Except for the key name prefix issue that Ted pointed out, this overall seems
good, although I didn't read into every detail and haven't yet tested the code.
A few comments:

There are compiler errors and warnings in the function 'dx_show_leaf()', which
is not compiled by default.

In ext4_lookup():
>               /*
>                * DCACHE_ENCRYPTED_WITH_KEY is set if the dentry is
>                * created while the directory was encrypted and we
>                * don't have access to the key.
>                */
>               if (fscrypt_has_encryption_key(dir))
>                       fscrypt_set_encrypted_dentry(dentry);

Shouldn't this say "and we have access to the key"?  Or is the code wrong?

In ext4_empty_dir():
>       bool err = false;

Since this is a bool it should not be called "err".  Maybe call it "empty"
instead.

In ext4_finish_bio():
>               if (!page->mapping) {
>                       /* The bounce data pages are unmapped. */
>                       data_page = page;
>                       fscrypt_pullback_bio_page(&page, false);
>               }
...
>#ifdef CONFIG_EXT4_FS_ENCRYPTION
>                       if (data_page)
>                               fscrypt_restore_control_page(data_page);
>#endif

Does this always do the same thing as the previous code?  Does !page->mapping
always imply that the page was involved in encrypted I/O?

In ext4_encrypted_get_link():
>       if ((cstr.len + 
>            sizeof(struct fscrypt_symlink_data) - 1) >
>           max_size) {

Make this one line?

In ext4_file_mmap()
>               int err = fscrypt_get_encryption_info(inode);
>               if (err)
>                       return 0;

Should the error code be propagated to the caller?

In ext4_ioctl():
>       case EXT4_IOC_GET_ENCRYPTION_POLICY: {
>#ifdef CONFIG_EXT4_FS_ENCRYPTION
>               struct fscrypt_policy policy;
>               int err = 0;
>
>               if (!ext4_encrypted_inode(inode))
>                       return -ENOENT;

This is existing code and I do not know if it can be changed, but I feel that
ENOENT is a not good error code here.  If the ext4_encrypted_inode() check were
to be removed, the implementation would match f2fs and the error code would be
ENODATA instead.

- Eric
