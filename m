From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH 4/4] ext4: Wait for proper transaction commit on fsync
Date: Tue, 20 Oct 2009 07:36:55 -0700
Message-ID: <6601abe90910200736i78fa50b0jb4db9fed8800c805@mail.gmail.com>
References: <1256023478-746-1-git-send-email-jack@suse.cz>
	 <1256023478-746-5-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:35865 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbZJTOg4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Oct 2009 10:36:56 -0400
Received: from spaceape12.eur.corp.google.com (spaceape12.eur.corp.google.com [172.28.16.146])
	by smtp-out.google.com with ESMTP id n9KEaw5d029254
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2009 07:36:59 -0700
Received: from pwi18 (pwi18.prod.google.com [10.241.219.18])
	by spaceape12.eur.corp.google.com with ESMTP id n9KEaam7002198
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2009 07:36:56 -0700
Received: by pwi18 with SMTP id 18so703405pwi.34
        for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2009 07:36:55 -0700 (PDT)
In-Reply-To: <1256023478-746-5-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 20, 2009 at 12:24 AM, Jan Kara <jack@suse.cz> wrote:
> We cannot rely on buffer dirty bits during fsync because pdflush can =
come
> before fsync is called and clear dirty bits without forcing a transac=
tion
> commit. What we do is that we track which transaction has last change=
d
> the inode and which transaction last changed allocation and force it =
to
> disk on fsync.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
> =A0fs/ext4/ext4.h =A0 =A0| =A0 =A07 +++++++
> =A0fs/ext4/extents.c | =A0 =A05 +++++
> =A0fs/ext4/fsync.c =A0 | =A0 40 +++++++++++++++++--------------------=
---
> =A0fs/ext4/inode.c =A0 | =A0 34 ++++++++++++++++++++++++++++++++++
> =A04 files changed, 63 insertions(+), 23 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 984ca0c..5639f30 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -702,6 +702,13 @@ struct ext4_inode_info {
> =A0 =A0 =A0 =A0struct list_head i_aio_dio_complete_list;
> =A0 =A0 =A0 =A0/* current io_end structure for async DIO write*/
> =A0 =A0 =A0 =A0ext4_io_end_t *cur_aio_dio;
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Transactions that contain inode's metadata needed =
to complete
> + =A0 =A0 =A0 =A0* fsync and fdatasync, respectively.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 atomic_t i_sync_tid;
> + =A0 =A0 =A0 atomic_t i_datasync_tid;
> =A0};
>
> =A0/*
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 10539e3..3e167f6 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3315,6 +3315,11 @@ int ext4_ext_get_blocks(handle_t *handle, stru=
ct inode *inode,
> =A0 =A0 =A0 =A0newblock =3D ext_pblock(&newex);
> =A0 =A0 =A0 =A0allocated =3D ext4_ext_get_actual_len(&newex);
> =A0 =A0 =A0 =A0set_buffer_new(bh_result);
> +
> + =A0 =A0 =A0 atomic_set(&EXT4_I(inode)->i_sync_tid, handle->h_transa=
ction->t_tid);
> + =A0 =A0 =A0 atomic_set(&EXT4_I(inode)->i_datasync_tid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0handle->h_transaction->t_tid);
> + =A0 =A0 =A0 printk("Datasync tid %u\n", handle->h_transaction->t_ti=
d);

Both here and in ext4_ind_get_blocks() below, I think you need to
guard the atomic_set() calls with ext4_handle_valid().

Curt

>
> =A0 =A0 =A0 =A0/* Cache only when it is _not_ an uninitialized extent=
 */
> =A0 =A0 =A0 =A0if ((flags & EXT4_GET_BLOCKS_UNINIT_EXT) =3D=3D 0)
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index 2bf9413..03e0fe9 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -51,25 +51,26 @@
> =A0int ext4_sync_file(struct file *file, struct dentry *dentry, int d=
atasync)
> =A0{
> =A0 =A0 =A0 =A0struct inode *inode =3D dentry->d_inode;
> + =A0 =A0 =A0 struct ext4_inode_info *ei =3D EXT4_I(inode);
> =A0 =A0 =A0 =A0journal_t *journal =3D EXT4_SB(inode->i_sb)->s_journal=
;
> - =A0 =A0 =A0 int err, ret =3D 0;
> + =A0 =A0 =A0 int ret =3D 0;
> + =A0 =A0 =A0 tid_t commit_tid;
>
> =A0 =A0 =A0 =A0J_ASSERT(ext4_journal_current_handle() =3D=3D NULL);
>
> =A0 =A0 =A0 =A0trace_ext4_sync_file(file, dentry, datasync);
>
> + =A0 =A0 =A0 if (inode->i_sb->s_flags & MS_RDONLY)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> +
> =A0 =A0 =A0 =A0ret =3D flush_aio_dio_completed_IO(inode);
> =A0 =A0 =A0 =A0if (ret < 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0/*
> - =A0 =A0 =A0 =A0* data=3Dwriteback:
> + =A0 =A0 =A0 =A0* data=3Dwriteback,ordered:
> =A0 =A0 =A0 =A0 * =A0The caller's filemap_fdatawrite()/wait will sync=
 the data.
> - =A0 =A0 =A0 =A0* =A0sync_inode() will sync the metadata
> - =A0 =A0 =A0 =A0*
> - =A0 =A0 =A0 =A0* data=3Dordered:
> - =A0 =A0 =A0 =A0* =A0The caller's filemap_fdatawrite() will write th=
e data and
> - =A0 =A0 =A0 =A0* =A0sync_inode() will write the inode if it is dirt=
y. =A0Then the caller's
> - =A0 =A0 =A0 =A0* =A0filemap_fdatawait() will wait on the pages.
> + =A0 =A0 =A0 =A0* =A0Metadata is in the journal, we wait for proper =
transaction to
> + =A0 =A0 =A0 =A0* =A0commit here.
> =A0 =A0 =A0 =A0 *
> =A0 =A0 =A0 =A0 * data=3Djournal:
> =A0 =A0 =A0 =A0 * =A0filemap_fdatawrite won't do anything (the buffer=
s are clean).
> @@ -87,23 +88,16 @@ int ext4_sync_file(struct file *file, struct dent=
ry *dentry, int datasync)
> =A0 =A0 =A0 =A0if (!journal)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D sync_mapping_buffers(inode->i_=
mapping);
>
> - =A0 =A0 =A0 if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto flush;
> + =A0 =A0 =A0 if (datasync)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 commit_tid =3D atomic_read(&ei->i_datas=
ync_tid);
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 commit_tid =3D atomic_read(&ei->i_sync_=
tid);
>
> - =A0 =A0 =A0 /*
> - =A0 =A0 =A0 =A0* The VFS has written the file data. =A0If the inode=
 is unaltered
> - =A0 =A0 =A0 =A0* then we need not start a commit.
> - =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 if (inode->i_state & (I_DIRTY_SYNC|I_DIRTY_DATASYNC)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct writeback_control wbc =3D {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .sync_mode =3D WB_SYNC_=
ALL,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .nr_to_write =3D 0, /* =
sys_fsync did this */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 };
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D sync_inode(inode, &wbc);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret =3D=3D 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D err;
> + =A0 =A0 =A0 if (jbd2_log_start_commit(journal, commit_tid)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 jbd2_log_wait_commit(journal, commit_ti=
d);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> =A0 =A0 =A0 =A0}
> -flush:
> +
> =A0 =A0 =A0 =A0if (journal && (journal->j_flags & JBD2_BARRIER))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blkdev_issue_flush(inode->i_sb->s_bdev=
, NULL);
> =A0out:
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 9105f40..412de4e 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1024,6 +1024,10 @@ static int ext4_ind_get_blocks(handle_t *handl=
e, struct inode *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto cleanup;
>
> =A0 =A0 =A0 =A0set_buffer_new(bh_result);
> +
> + =A0 =A0 =A0 atomic_set(&EXT4_I(inode)->i_sync_tid, handle->h_transa=
ction->t_tid);
> + =A0 =A0 =A0 atomic_set(&EXT4_I(inode)->i_datasync_tid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0handle->h_transaction->t_tid);
> =A0got_it:
> =A0 =A0 =A0 =A0map_bh(bh_result, inode->i_sb, le32_to_cpu(chain[depth=
-1].key));
> =A0 =A0 =A0 =A0if (count > blocks_to_boundary)
> @@ -4777,6 +4781,7 @@ struct inode *ext4_iget(struct super_block *sb,=
 unsigned long ino)
> =A0 =A0 =A0 =A0struct ext4_inode_info *ei;
> =A0 =A0 =A0 =A0struct buffer_head *bh;
> =A0 =A0 =A0 =A0struct inode *inode;
> + =A0 =A0 =A0 journal_t *journal =3D EXT4_SB(sb)->s_journal;
> =A0 =A0 =A0 =A0long ret;
> =A0 =A0 =A0 =A0int block;
>
> @@ -4842,6 +4847,34 @@ struct inode *ext4_iget(struct super_block *sb=
, unsigned long ino)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ei->i_data[block] =3D raw_inode->i_blo=
ck[block];
> =A0 =A0 =A0 =A0INIT_LIST_HEAD(&ei->i_orphan);
>
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Set transaction id's of transactions that have to =
be committed
> + =A0 =A0 =A0 =A0* to finish f[data]sync. We set them to currently ru=
nning transaction
> + =A0 =A0 =A0 =A0* as we cannot be sure that the inode or some of its=
 metadata isn't
> + =A0 =A0 =A0 =A0* part of the transaction - the inode could have bee=
n reclaimed and
> + =A0 =A0 =A0 =A0* now it is reread from disk.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (journal) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 transaction_t *transaction;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tid_t tid;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&journal->j_state_lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (journal->j_running_transaction)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 transaction =3D journal=
->j_running_transaction;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 transaction =3D journal=
->j_committing_transaction;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (transaction)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tid =3D transaction->t_=
tid;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tid =3D journal->j_comm=
it_sequence;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&journal->j_state_lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_set(&ei->i_sync_tid, tid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_set(&ei->i_datasync_tid, tid);
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_set(&ei->i_sync_tid, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_set(&ei->i_datasync_tid, 0);
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE=
_SIZE) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ei->i_extra_isize =3D le16_to_cpu(raw_=
inode->i_extra_isize);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (EXT4_GOOD_OLD_INODE_SIZE + ei->i_e=
xtra_isize >
> @@ -5102,6 +5135,7 @@ static int ext4_do_update_inode(handle_t *handl=
e,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D rc;
> =A0 =A0 =A0 =A0ei->i_state &=3D ~EXT4_STATE_NEW;
>
> + =A0 =A0 =A0 atomic_set(&ei->i_sync_tid, handle->h_transaction->t_ti=
d);
> =A0out_brelse:
> =A0 =A0 =A0 =A0brelse(bh);
> =A0 =A0 =A0 =A0ext4_std_error(inode->i_sb, err);
> --
> 1.6.0.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
