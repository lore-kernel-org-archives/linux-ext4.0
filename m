From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH] ext4: Make reads/writes atomic with i_rwlock semaphore
Date: Fri, 12 Aug 2011 16:33:58 +0800
Message-ID: <CAGBYx2ZBZz7GDCPyuNgudMfMZY7bwGeyJ_4TNbcvATZC61Sohg@mail.gmail.com>
References: <1303154492-25446-1-git-send-email-lczerner@redhat.com>
	<alpine.LFD.2.00.1108111710040.29009@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, esandeen@redhat.com,
	adilger@s0106002191d9348c.cg.shawcable.net
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:47806 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab1HLId6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Aug 2011 04:33:58 -0400
Received: by pzk37 with SMTP id 37so777093pzk.1
        for <linux-ext4@vger.kernel.org>; Fri, 12 Aug 2011 01:33:58 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1108111710040.29009@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 11, 2011 at 11:10 PM, Lukas Czerner <lczerner@redhat.com> w=
rote:
> On Mon, 18 Apr 2011, Lukas Czerner wrote:
>
>> Currently concurrent reads/writes are atomic only wrt individual pag=
es,
>> however are not on the system call. This may cause read() to return =
data
>> mixed from several different writes, which I do not think it is good
>> approach. We might argue that application doing this is broken, but
>> actually this is something we can easily do on filesystem level with=
out
>> significant performance issues, so we can be consistent. Also POSIX
>> mentions this as well and XFS filesystem already has this feature.
>>
>> This commit adds new rw_semaphore into ext4_inode structure. We take
>> read lock every time we read data from a file (via ext4_file_read() =
or
>> ext4_file_splice_read()) and also when we write data in direct io mo=
de,
>> since in this mode application should know exactly what it is doing.
>> Then we take write lock when we write into a file (via ext4_file_wri=
te()
>> and ext4_file_splice_write()), except the direct io when we take rea=
d
>> lock and unaligned direct io which is already serialized in differen=
t
>> manner. Also we are locking ext4_truncate() as well so we are consis=
tent
>> and preserve atomicity.
>>
>> This should not have any significant performance impact since we sti=
ll
>> allow concurrent reads from the same inode and concurrent writes are
>> serialized already by i_mutex. The only type of load which will feel=
 the
>> performance hit is the case of writing into an inode while reading f=
rom
>> it and vice versa. In this case, if reads/writes are exclusive it mi=
ght
>> not need locking, however tracking this would be expensive.
>
> Anyone any thoughts on this one ?

Should this job be done in vfs?

Applications are not based on specific filesystems, so if an
application wants this feature, it should have done the work in
userspace to achieve this.

I don't think only several fileysytems(e.g. xfs and ext4) can help
applciations a lot with this feature.

If the feature goes into vfs, then applications can use it without
consideration.

Yongqiang.
>
> Thanks!
> -Lukas
>
>>
>> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
>> ---
>> =A0fs/ext4/ext4.h =A0| =A0 =A05 ++++
>> =A0fs/ext4/file.c =A0| =A0 58 ++++++++++++++++++++++++++++++++++++++=
++++++++++++----
>> =A0fs/ext4/inode.c | =A0 =A07 ++++++
>> =A0fs/ext4/super.c | =A0 =A01 +
>> =A04 files changed, 66 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 4daaf2b..037857c 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -858,6 +858,11 @@ struct ext4_inode_info {
>> =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 tid_t i_sync_tid;
>> =A0 =A0 =A0 tid_t i_datasync_tid;
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* Semaphore forcing read/write atomicity
>> + =A0 =A0 =A0*/
>> + =A0 =A0 struct rw_semaphore i_rwlock;
>> =A0};
>>
>> =A0/*
>> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
>> index 7b80d54..6c7ed94 100644
>> --- a/fs/ext4/file.c
>> +++ b/fs/ext4/file.c
>> @@ -94,7 +94,7 @@ ext4_file_write(struct kiocb *iocb, const struct i=
ovec *iov,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long nr_segs, loff_t pos)
>> =A0{
>> =A0 =A0 =A0 struct inode *inode =3D iocb->ki_filp->f_path.dentry->d_=
inode;
>> - =A0 =A0 int unaligned_aio =3D 0;
>> + =A0 =A0 int unaligned_aio =3D 0, direct_io =3D 0;
>> =A0 =A0 =A0 int ret;
>>
>> =A0 =A0 =A0 /*
>> @@ -117,6 +117,7 @@ ext4_file_write(struct kiocb *iocb, const struct=
 iovec *iov,
>> =A0 =A0 =A0 } else if (unlikely((iocb->ki_filp->f_flags & O_DIRECT) =
&&
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0!is_sync_kiocb(iocb))) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 unaligned_aio =3D ext4_unaligned_aio(ino=
de, iov, nr_segs, pos);
>> + =A0 =A0 =A0 =A0 =A0 =A0 direct_io =3D 1;
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 /* Unaligned direct AIO must be serialized; see comment =
above */
>> @@ -131,12 +132,19 @@ ext4_file_write(struct kiocb *iocb, const stru=
ct iovec *iov,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode=
->i_ino, current->comm);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_lock(ext4_aio_mutex(inode));
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_aiodio_wait(inode);
>> - =A0 =A0 }
>> + =A0 =A0 } else if (unlikely(direct_io))
>> + =A0 =A0 =A0 =A0 =A0 =A0 down_read(&EXT4_I(inode)->i_rwlock);
>> + =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 down_write(&EXT4_I(inode)->i_rwlock);
>>
>> =A0 =A0 =A0 ret =3D generic_file_aio_write(iocb, iov, nr_segs, pos);
>>
>> =A0 =A0 =A0 if (unaligned_aio)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(ext4_aio_mutex(inode));
>> + =A0 =A0 else if (unlikely(direct_io))
>> + =A0 =A0 =A0 =A0 =A0 =A0 up_read(&EXT4_I(inode)->i_rwlock);
>> + =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 up_write(&EXT4_I(inode)->i_rwlock);
>>
>> =A0 =A0 =A0 return ret;
>> =A0}
>> @@ -252,11 +260,51 @@ loff_t ext4_llseek(struct file *file, loff_t o=
ffset, int origin)
>> =A0 =A0 =A0 return offset;
>> =A0}
>>
>> +static ssize_t
>> +ext4_file_read(struct kiocb *iocb, const struct iovec *iov,
>> + =A0 =A0 =A0 =A0 =A0 =A0unsigned long nr_segs, loff_t pos)
>> +{
>> + =A0 =A0 struct inode *inode =3D iocb->ki_filp->f_path.dentry->d_in=
ode;
>> + =A0 =A0 ssize_t size;
>> +
>> + =A0 =A0 down_read(&EXT4_I(inode)->i_rwlock);
>> + =A0 =A0 size =3D generic_file_aio_read(iocb, iov, nr_segs, pos);
>> + =A0 =A0 up_read(&EXT4_I(inode)->i_rwlock);
>> + =A0 =A0 return size;
>> +}
>> +
>> +ssize_t ext4_file_splice_read(struct file *in, loff_t *ppos,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct pipe_in=
ode_info *pipe, size_t len,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int f=
lags)
>> +{
>> + =A0 =A0 struct inode *inode =3D in->f_mapping->host;
>> + =A0 =A0 ssize_t size;
>> +
>> + =A0 =A0 down_read(&EXT4_I(inode)->i_rwlock);
>> + =A0 =A0 size =3D generic_file_splice_read(in, ppos, pipe, len, fla=
gs);
>> + =A0 =A0 up_read(&EXT4_I(inode)->i_rwlock);
>> + =A0 =A0 return size;
>> +}
>> +
>> +ssize_t ext4_file_splice_write(struct pipe_inode_info *pipe,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct file=
 *out, loff_t *ppos, size_t len,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned in=
t flags)
>> +{
>> + =A0 =A0 struct inode *inode =3D out->f_mapping->host;
>> + =A0 =A0 ssize_t size;
>> +
>> + =A0 =A0 down_write(&EXT4_I(inode)->i_rwlock);
>> + =A0 =A0 size =3D generic_file_splice_write(pipe, out, ppos, len, f=
lags);
>> + =A0 =A0 up_write(&EXT4_I(inode)->i_rwlock);
>> + =A0 =A0 return size;
>> +}
>> +
>> +
>> =A0const struct file_operations ext4_file_operations =3D {
>> =A0 =A0 =A0 .llseek =A0 =A0 =A0 =A0 =3D ext4_llseek,
>> =A0 =A0 =A0 .read =A0 =A0 =A0 =A0 =A0 =3D do_sync_read,
>> =A0 =A0 =A0 .write =A0 =A0 =A0 =A0 =A0=3D do_sync_write,
>> - =A0 =A0 .aio_read =A0 =A0 =A0 =3D generic_file_aio_read,
>> + =A0 =A0 .aio_read =A0 =A0 =A0 =3D ext4_file_read,
>> =A0 =A0 =A0 .aio_write =A0 =A0 =A0=3D ext4_file_write,
>> =A0 =A0 =A0 .unlocked_ioctl =3D ext4_ioctl,
>> =A0#ifdef CONFIG_COMPAT
>> @@ -266,8 +314,8 @@ const struct file_operations ext4_file_operation=
s =3D {
>> =A0 =A0 =A0 .open =A0 =A0 =A0 =A0 =A0 =3D ext4_file_open,
>> =A0 =A0 =A0 .release =A0 =A0 =A0 =A0=3D ext4_release_file,
>> =A0 =A0 =A0 .fsync =A0 =A0 =A0 =A0 =A0=3D ext4_sync_file,
>> - =A0 =A0 .splice_read =A0 =A0=3D generic_file_splice_read,
>> - =A0 =A0 .splice_write =A0 =3D generic_file_splice_write,
>> + =A0 =A0 .splice_read =A0 =A0=3D ext4_file_splice_read,
>> + =A0 =A0 .splice_write =A0 =3D ext4_file_splice_write,
>> =A0 =A0 =A0 .fallocate =A0 =A0 =A0=3D ext4_fallocate,
>> =A0};
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index f2fa5e8..769ab0f 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -4482,6 +4482,12 @@ void ext4_truncate(struct inode *inode)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_stop;
>>
>> =A0 =A0 =A0 /*
>> + =A0 =A0 =A0* We should block reads/writes to that inode so we are =
sure we are
>> + =A0 =A0 =A0* consistent and reads/writes remain atomic.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 down_write(&EXT4_I(inode)->i_rwlock);
>> +
>> + =A0 =A0 /*
>> =A0 =A0 =A0 =A0* From here we block out all ext4_get_block() callers=
 who want to
>> =A0 =A0 =A0 =A0* modify the block allocation tree.
>> =A0 =A0 =A0 =A0*/
>> @@ -4566,6 +4572,7 @@ do_indirects:
>>
>> =A0out_unlock:
>> =A0 =A0 =A0 up_write(&ei->i_data_sem);
>> + =A0 =A0 up_write(&EXT4_I(inode)->i_rwlock);
>> =A0 =A0 =A0 inode->i_mtime =3D inode->i_ctime =3D ext4_current_time(=
inode);
>> =A0 =A0 =A0 ext4_mark_inode_dirty(handle, inode);
>>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 8553dfb..2dbe86a 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -895,6 +895,7 @@ static void init_once(void *foo)
>> =A0 =A0 =A0 init_rwsem(&ei->xattr_sem);
>> =A0#endif
>> =A0 =A0 =A0 init_rwsem(&ei->i_data_sem);
>> + =A0 =A0 init_rwsem(&ei->i_rwlock);
>> =A0 =A0 =A0 inode_init_once(&ei->vfs_inode);
>> =A0}
>>
>>
>
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
