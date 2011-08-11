From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Make reads/writes atomic with i_rwlock semaphore
Date: Thu, 11 Aug 2011 15:01:59 -0600
Message-ID: <C174786E-E1A9-4593-9A04-7F7F36EFB4AC@dilger.ca>
References: <1303154492-25446-1-git-send-email-lczerner@redhat.com> <alpine.LFD.2.00.1108111710040.29009@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4 List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, esandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:62547 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab1HKVCA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Aug 2011 17:02:00 -0400
In-Reply-To: <alpine.LFD.2.00.1108111710040.29009@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-08-11, at 9:10 AM, Lukas Czerner wrote:
> On Mon, 18 Apr 2011, Lukas Czerner wrote:
>> Currently concurrent reads/writes are atomic only wrt individual pages,
>> however are not on the system call. This may cause read() to return data
>> mixed from several different writes, which I do not think it is good
>> approach. We might argue that application doing this is broken, but
>> actually this is something we can easily do on filesystem level without
>> significant performance issues, so we can be consistent. Also POSIX
>> mentions this as well and XFS filesystem already has this feature.
>> 
>> This commit adds new rw_semaphore into ext4_inode structure. We take
>> read lock every time we read data from a file (via ext4_file_read() or
>> ext4_file_splice_read()) and also when we write data in direct io mode,
>> since in this mode application should know exactly what it is doing.
>> Then we take write lock when we write into a file (via ext4_file_write()
>> and ext4_file_splice_write()), except the direct io when we take read
>> lock and unaligned direct io which is already serialized in different
>> manner. Also we are locking ext4_truncate() as well so we are consistent
>> and preserve atomicity.
>> 
>> This should not have any significant performance impact since we still
>> allow concurrent reads from the same inode and concurrent writes are
>> serialized already by i_mutex. The only type of load which will feel the
>> performance hit is the case of writing into an inode while reading from
>> it and vice versa. In this case, if reads/writes are exclusive it might
>> not need locking, however tracking this would be expensive.
> 
> Anyone any thoughts on this one ?

Rather than adding more global locking to the IO path, it would be much
preferable IMHO to start looking at extent locks for file IO.  At that
point, a reader could get a read lock for the range of its syscall and
get an atomic read, and other writers could write atomically to different
parts of the file without contention (to the greatest degree possible).

I wouldn't be surprised if there is already some code in the kernel that
implements this.

>> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
>> ---
>> fs/ext4/ext4.h  |    5 ++++
>> fs/ext4/file.c  |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++----
>> fs/ext4/inode.c |    7 ++++++
>> fs/ext4/super.c |    1 +
>> 4 files changed, 66 insertions(+), 5 deletions(-)
>> 
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 4daaf2b..037857c 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -858,6 +858,11 @@ struct ext4_inode_info {
>> 	 */
>> 	tid_t i_sync_tid;
>> 	tid_t i_datasync_tid;
>> +
>> +	/*
>> +	 * Semaphore forcing read/write atomicity
>> +	 */
>> +	struct rw_semaphore i_rwlock;
>> };
>> 
>> /*
>> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
>> index 7b80d54..6c7ed94 100644
>> --- a/fs/ext4/file.c
>> +++ b/fs/ext4/file.c
>> @@ -94,7 +94,7 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
>> 		unsigned long nr_segs, loff_t pos)
>> {
>> 	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
>> -	int unaligned_aio = 0;
>> +	int unaligned_aio = 0, direct_io = 0;
>> 	int ret;
>> 
>> 	/*
>> @@ -117,6 +117,7 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
>> 	} else if (unlikely((iocb->ki_filp->f_flags & O_DIRECT) &&
>> 		   !is_sync_kiocb(iocb))) {
>> 		unaligned_aio = ext4_unaligned_aio(inode, iov, nr_segs, pos);
>> +		direct_io = 1;
>> 	}
>> 
>> 	/* Unaligned direct AIO must be serialized; see comment above */
>> @@ -131,12 +132,19 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
>> 				 inode->i_ino, current->comm);
>> 		mutex_lock(ext4_aio_mutex(inode));
>> 		ext4_aiodio_wait(inode);
>> -	}
>> +	} else if (unlikely(direct_io))
>> +		down_read(&EXT4_I(inode)->i_rwlock);
>> +	else
>> +		down_write(&EXT4_I(inode)->i_rwlock);
>> 
>> 	ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
>> 
>> 	if (unaligned_aio)
>> 		mutex_unlock(ext4_aio_mutex(inode));
>> +	else if (unlikely(direct_io))
>> +		up_read(&EXT4_I(inode)->i_rwlock);
>> +	else
>> +		up_write(&EXT4_I(inode)->i_rwlock);
>> 
>> 	return ret;
>> }
>> @@ -252,11 +260,51 @@ loff_t ext4_llseek(struct file *file, loff_t offset, int origin)
>> 	return offset;
>> }
>> 
>> +static ssize_t
>> +ext4_file_read(struct kiocb *iocb, const struct iovec *iov,
>> +	       unsigned long nr_segs, loff_t pos)
>> +{
>> +	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
>> +	ssize_t size;
>> +
>> +	down_read(&EXT4_I(inode)->i_rwlock);
>> +	size = generic_file_aio_read(iocb, iov, nr_segs, pos);
>> +	up_read(&EXT4_I(inode)->i_rwlock);
>> +	return size;
>> +}
>> +
>> +ssize_t ext4_file_splice_read(struct file *in, loff_t *ppos,
>> +			      struct pipe_inode_info *pipe, size_t len,
>> +			      unsigned int flags)
>> +{
>> +	struct inode *inode = in->f_mapping->host;
>> +	ssize_t size;
>> +
>> +	down_read(&EXT4_I(inode)->i_rwlock);
>> +	size = generic_file_splice_read(in, ppos, pipe, len, flags);
>> +	up_read(&EXT4_I(inode)->i_rwlock);
>> +	return size;
>> +}
>> +
>> +ssize_t ext4_file_splice_write(struct pipe_inode_info *pipe,
>> +			       struct file *out, loff_t *ppos, size_t len,
>> +			       unsigned int flags)
>> +{
>> +	struct inode *inode = out->f_mapping->host;
>> +	ssize_t size;
>> +
>> +	down_write(&EXT4_I(inode)->i_rwlock);
>> +	size = generic_file_splice_write(pipe, out, ppos, len, flags);
>> +	up_write(&EXT4_I(inode)->i_rwlock);
>> +	return size;
>> +}
>> +
>> +
>> const struct file_operations ext4_file_operations = {
>> 	.llseek		= ext4_llseek,
>> 	.read		= do_sync_read,
>> 	.write		= do_sync_write,
>> -	.aio_read	= generic_file_aio_read,
>> +	.aio_read	= ext4_file_read,
>> 	.aio_write	= ext4_file_write,
>> 	.unlocked_ioctl = ext4_ioctl,
>> #ifdef CONFIG_COMPAT
>> @@ -266,8 +314,8 @@ const struct file_operations ext4_file_operations = {
>> 	.open		= ext4_file_open,
>> 	.release	= ext4_release_file,
>> 	.fsync		= ext4_sync_file,
>> -	.splice_read	= generic_file_splice_read,
>> -	.splice_write	= generic_file_splice_write,
>> +	.splice_read	= ext4_file_splice_read,
>> +	.splice_write	= ext4_file_splice_write,
>> 	.fallocate	= ext4_fallocate,
>> };
>> 
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index f2fa5e8..769ab0f 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -4482,6 +4482,12 @@ void ext4_truncate(struct inode *inode)
>> 		goto out_stop;
>> 
>> 	/*
>> +	 * We should block reads/writes to that inode so we are sure we are
>> +	 * consistent and reads/writes remain atomic.
>> +	 */
>> +	down_write(&EXT4_I(inode)->i_rwlock);
>> +
>> +	/*
>> 	 * From here we block out all ext4_get_block() callers who want to
>> 	 * modify the block allocation tree.
>> 	 */
>> @@ -4566,6 +4572,7 @@ do_indirects:
>> 
>> out_unlock:
>> 	up_write(&ei->i_data_sem);
>> +	up_write(&EXT4_I(inode)->i_rwlock);
>> 	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
>> 	ext4_mark_inode_dirty(handle, inode);
>> 
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 8553dfb..2dbe86a 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -895,6 +895,7 @@ static void init_once(void *foo)
>> 	init_rwsem(&ei->xattr_sem);
>> #endif
>> 	init_rwsem(&ei->i_data_sem);
>> +	init_rwsem(&ei->i_rwlock);
>> 	inode_init_once(&ei->vfs_inode);
>> }
>> 
>> 
> 
> -- 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





