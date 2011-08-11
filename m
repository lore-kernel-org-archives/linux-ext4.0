From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] e2fsprogs: Use punch hole as "discard" on regular files
Date: Thu, 11 Aug 2011 15:23:49 -0600
Message-ID: <17B42AB6-41A0-4D74-9F5D-5E177F310A0A@dilger.ca>
References: <1313074129-31223-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:9205 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab1HKVXu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Aug 2011 17:23:50 -0400
In-Reply-To: <1313074129-31223-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-08-11, at 8:48 AM, Lukas Czerner wrote:
> If e2fsprogs tools (mke2fs, e2fsck) is run on regular file instead of
> on block device, we can use punch hole instead of regular discard
> command which would not work on regular file anyway. This gives us
> several advantages. First of all when e2fsck is run with '-E discard'
> parameter it will punch out all ununsed space from the image, hence
> trimming down the file system image. And secondly, when creating an
> file system on regular file (with '-E discard' which is default), we
> can use punch hole to clear the file content, hence we can skip inode
> table initialization, because reads from sparse area returns zeros. This
> will result in faster file system creation (without the need to specify
> lazy_itable_init) and smaller images.
> 
> This commit also fixes some tests that would wail due to mke2fs showing
> discard progress, hence the output would differ.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
> lib/ext2fs/ext2_io.h            |    1 +
> lib/ext2fs/unix_io.c            |   46 ++++++++++++++++++++++++++++++++++----
> misc/mke2fs.c                   |   10 ++++++-
> tests/f_resize_inode/expect     |    1 +
> tests/m_dasd_bs/expect.1        |    1 +
> tests/m_extent_journal/expect.1 |    1 +
> tests/m_large_file/expect.1     |    1 +
> tests/m_meta_bg/expect.1        |    1 +
> tests/m_no_opt/expect.1         |    1 +
> tests/m_raid_opt/expect.1       |    1 +
> tests/m_std/expect.1            |    1 +
> tests/m_uninit/expect.1         |    1 +
> 12 files changed, 59 insertions(+), 7 deletions(-)
> 
> diff --git a/lib/ext2fs/ext2_io.h b/lib/ext2fs/ext2_io.h
> index e71ada9..bcc2f87 100644
> --- a/lib/ext2fs/ext2_io.h
> +++ b/lib/ext2fs/ext2_io.h
> @@ -30,6 +30,7 @@ typedef struct struct_io_stats *io_stats;
> 
> #define CHANNEL_FLAGS_WRITETHROUGH	0x01
> #define CHANNEL_FLAGS_DISCARD_ZEROES	0x02
> +#define CHANNEL_FLAGS_BLOCK_DEVICE	0x04
> 
> #define io_channel_discard_zeroes_data(i) (i->flags & CHANNEL_FLAGS_DISCARD_ZEROES)
> 
> diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
> index c1d0561..eb5df55 100644
> --- a/lib/ext2fs/unix_io.c
> +++ b/lib/ext2fs/unix_io.c
> @@ -441,7 +441,11 @@ static errcode_t unix_open(const char *name, int flags, io_channel *channel)
> 	struct unix_private_data *data = NULL;
> 	errcode_t	retval;
> 	int		open_flags, zeroes = 0;
> +#ifdef HAVE_OPEN64
> +	struct stat64	st;
> +#else
> 	struct stat	st;
> +#endif
> #ifdef __linux__
> 	struct 		utsname ut;
> #endif
> @@ -482,11 +486,26 @@ static errcode_t unix_open(const char *name, int flags, io_channel *channel)
> #endif
> 	data->flags = flags;
> 
> +	st.st_mode = 0;
> #ifdef HAVE_OPEN64
> 	data->dev = open64(io->name, open_flags);
> +	stat64(io->name, &st);
> #else
> 	data->dev = open(io->name, open_flags);
> +	stat(io->name, &st);
> #endif

IMHO it would be nicer to have wrappers for open() and stat() instead
of #ifdef spread around the code.

> +	/*
> +	 * If the device is really a block device, then set the
> +	 * appropriate flag, otherwise we can set DISCARD_ZEROES flag
> +	 * because we are going to use punch hole instead of discard
> +	 * and if it succeed, subsequent read from sparse area returns
> +	 * zero.
> +	 */
> +	if (S_ISBLK(st.st_mode))
> +		io->flags |= CHANNEL_FLAGS_BLOCK_DEVICE;
> +	else
> +		io->flags |= CHANNEL_FLAGS_DISCARD_ZEROES;
> +
> 	if (data->dev < 0) {
> 		retval = errno;
> 		goto cleanup;
> @@ -552,7 +571,11 @@ static errcode_t unix_open(const char *name, int flags, io_channel *channel)
> 	     (ut.release[2] == '4') && (ut.release[3] == '.') &&
> 	     (ut.release[4] == '1') && (ut.release[5] >= '0') &&
> 	     (ut.release[5] < '8')) &&
> -	    (fstat(data->dev, &st) == 0) &&
> +#ifdef HAVE_OPEN64
> +	    (stat64(io->name, &st) == 0) &&
> +#else
> +	    (stat(io->name, &st) == 0) &&
> +#endif
> 	    (S_ISBLK(st.st_mode))) {
> 		struct rlimit	rlim;
> 
> @@ -857,7 +880,9 @@ static errcode_t unix_set_option(io_channel channel, const char *option,
> }
> 
> #if defined(__linux__) && !defined(BLKDISCARD)
> -#define BLKDISCARD	_IO(0x12,119)
> +#define BLKDISCARD		_IO(0x12,119)
> +#define FALLOC_FL_KEEP_SIZE	0x01
> +#define FALLOC_FL_PUNCH_HOLE	0x02

Should these get their own #ifndef FALLOC_FL_KEEP_SIZE and also
#ifndef FALLOC_FL_PUNCH_HOLE?  Otherwise the compiler may complain
if they are defined multiple times.  FALLOC_FL_PUNCH_HOLE was added
a lot later than the others.

> @@ -872,10 +897,21 @@ static errcode_t unix_discard(io_channel channel, unsigned long long block,
> 	data = (struct unix_private_data *) channel->private_data;
> 	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
> 
> -	range[0] = (__uint64_t)(block) * channel->block_size;
> -	range[1] = (__uint64_t)(count) * channel->block_size;
> +	if (channel->flags & CHANNEL_FLAGS_BLOCK_DEVICE) {
> +		range[0] = (__uint64_t)(block) * channel->block_size;
> +		range[1] = (__uint64_t)(count) * channel->block_size;
> 
> -	ret = ioctl(data->dev, BLKDISCARD, &range);
> +		ret = ioctl(data->dev, BLKDISCARD, &range);
> +	} else {
> +		/*
> +		 * If we are not on block device, try to use punch hole
> +		 * to reclaim free space.
> +		 */
> +		ret = fallocate(data->dev,
> +				FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
> +				(off_t)(block) * channel->block_size,
> +				(off_t)(count) * channel->block_size);
> +		}
> 	if (ret < 0)
> 		return errno;


This will fail on kernels/userspace that don't have fallocate() or
FALLOC_FL_PUNCH_HOLE (which is very new).  Maybe it is better to wrap
this whole thing in "#ifdef FALLOC_FL_PUNCH_HOLE" so that it is only
compiled on systems that have such support, and convert EOPNOTSUPP into
EXT2_ET_UNIMPLEMENTED.

> diff --git a/tests/f_resize_inode/expect b/tests/f_resize_inode/expect
> index a396927..cfc699c 100644
> --- a/tests/f_resize_inode/expect
> +++ b/tests/f_resize_inode/expect
> @@ -1,4 +1,5 @@
> mke2fs -F -O resize_inode -o Linux -b 1024 -g 1024 test.img 16384
> +Discarding device blocks:  1024/16384           done                            

What happens on devices/kernels that don't support discard?  In newer
e2fsprogs this message isn't printed at all if the device doesn't
support discard.  It seems better to have the run_e2fsck script
strip out these lines so that the tests pass regardless of whether
discard is working or not.

> Filesystem label=
> OS type: Linux
> Block size=1024 (log=0)
> diff --git a/tests/m_dasd_bs/expect.1 b/tests/m_dasd_bs/expect.1
> index 31db54b..310fc95 100644
> --- a/tests/m_dasd_bs/expect.1
> +++ b/tests/m_dasd_bs/expect.1
> @@ -1,3 +1,4 @@
> +Discarding device blocks:  2048/32768           done                            
> Filesystem label=
> OS type: Linux
> Block size=2048 (log=1)
> diff --git a/tests/m_extent_journal/expect.1 b/tests/m_extent_journal/expect.1
> index 88ea2d9..fb07588 100644
> --- a/tests/m_extent_journal/expect.1
> +++ b/tests/m_extent_journal/expect.1
> @@ -1,3 +1,4 @@
> +Discarding device blocks:  1024/65536           done                            
> Filesystem label=
> OS type: Linux
> Block size=1024 (log=0)
> diff --git a/tests/m_large_file/expect.1 b/tests/m_large_file/expect.1
> index 2b40c84..3ebd03c 100644
> --- a/tests/m_large_file/expect.1
> +++ b/tests/m_large_file/expect.1
> @@ -1,3 +1,4 @@
> +Discarding device blocks:  4096/16384           done                            
> Filesystem label=
> OS type: Linux
> Block size=4096 (log=2)
> diff --git a/tests/m_meta_bg/expect.1 b/tests/m_meta_bg/expect.1
> index f1c9cef..f947da9 100644
> --- a/tests/m_meta_bg/expect.1
> +++ b/tests/m_meta_bg/expect.1
> @@ -1,3 +1,4 @@
> +Discarding device blocks:   1024/131072             done                            
> Filesystem label=
> OS type: Linux
> Block size=1024 (log=0)
> diff --git a/tests/m_no_opt/expect.1 b/tests/m_no_opt/expect.1
> index 7f3e5aa..81764d3 100644
> --- a/tests/m_no_opt/expect.1
> +++ b/tests/m_no_opt/expect.1
> @@ -1,3 +1,4 @@
> +Discarding device blocks:  1024/65536           done                            
> Filesystem label=
> OS type: Linux
> Block size=1024 (log=0)
> diff --git a/tests/m_raid_opt/expect.1 b/tests/m_raid_opt/expect.1
> index 0c6acc1..c8667e8 100644
> --- a/tests/m_raid_opt/expect.1
> +++ b/tests/m_raid_opt/expect.1
> @@ -1,3 +1,4 @@
> +Discarding device blocks:   1024/131072             done                            
> Filesystem label=
> OS type: Linux
> Block size=1024 (log=0)
> diff --git a/tests/m_std/expect.1 b/tests/m_std/expect.1
> index d0bf27c..a2b6c3f 100644
> --- a/tests/m_std/expect.1
> +++ b/tests/m_std/expect.1
> @@ -1,3 +1,4 @@
> +Discarding device blocks:  1024/65536           done                            
> Filesystem label=
> OS type: Linux
> Block size=1024 (log=0)
> diff --git a/tests/m_uninit/expect.1 b/tests/m_uninit/expect.1
> index 173c072..72c652c 100644
> --- a/tests/m_uninit/expect.1
> +++ b/tests/m_uninit/expect.1
> @@ -1,3 +1,4 @@
> +Discarding device blocks:   1024/131072             done                            
> Filesystem label=
> OS type: Linux
> Block size=1024 (log=0)
> -- 
> 1.7.4.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





