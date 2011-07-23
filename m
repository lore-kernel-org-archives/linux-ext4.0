From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ext4: Fix data corruption in inodes with journalled data
Date: Sat, 23 Jul 2011 16:21:55 +0300
Message-ID: <CAOQ4uxjef-LrZvJkhw=2HvUN6UGtteW30gNUi2yU3LPP_oQhzw@mail.gmail.com>
References: <1311381577-31406-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58783 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab1GWNV5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Jul 2011 09:21:57 -0400
Received: by wwe5 with SMTP id 5so2911503wwe.1
        for <linux-ext4@vger.kernel.org>; Sat, 23 Jul 2011 06:21:56 -0700 (PDT)
In-Reply-To: <1311381577-31406-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 23, 2011 at 3:39 AM, Jan Kara <jack@suse.cz> wrote:
> When journalling data for an inode (either because it is a symlink or
> because the filesystem is mounted in data=3Djournal mode), ext4_evict=
_inode()
> can discard unwritten data by calling truncate_inode_pages(). This is
> because we don't mark the buffer / page dirty when journalling data b=
ut only
> add the buffer to the running transaction and thus mm does not know t=
here
> are still unwritten data.
>
> Fix the problem by carefully tracking transaction containing inode's =
data,
> committing this transaction, and writing uncheckpointed buffers when =
inode
> should be reaped.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
> =A0fs/ext4/inode.c | =A0 29 +++++++++++++++++++++++++++++
> =A01 files changed, 29 insertions(+), 0 deletions(-)
>
> =A0This is ext4 version of an ext3 fix I sent a while ago. It receive=
d only
> light testing but I figured you might want get the patch earlier rath=
er than
> later given the merge window is open.
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index e3126c0..019995b 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -190,6 +190,33 @@ void ext4_evict_inode(struct inode *inode)
>
> =A0 =A0 =A0 =A0trace_ext4_evict_inode(inode);
> =A0 =A0 =A0 =A0if (inode->i_nlink) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* When journalling data dirty buffer=
s are tracked only in the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* journal. So although mm thinks eve=
rything is clean and
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* ready for reaping the inode might =
still have some pages to
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* write in the running transaction o=
r waiting to be
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* checkpointed. Thus calling jbd2_jo=
urnal_invalidatepage()
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* (via truncate_inode_pages()) to di=
scard these buffers can
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* cause data loss. Also even if we d=
id not discard these
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* buffers, we would have no way to f=
ind them after the inode
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* is reaped and thus user could see =
stale data if he tries to
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* read them before the transaction i=
s checkpointed. So be
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* careful and force everything to di=
sk here... We use
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* ei->i_datasync_tid to store the ne=
west transaction
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* containing inode's data.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Note that directories do not have =
this problem because they
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* don't use page cache.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ext4_should_journal_data(inode) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (S_ISLNK(inode->i_mode) || S_IS=
REG(inode->i_mode))) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 journal_t *journal =3D =
EXT4_SB(inode->i_sb)->s_journal;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tid_t commit_tid =3D EX=
T4_I(inode)->i_datasync_tid;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 jbd2_log_start_commit(j=
ournal, commit_tid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 jbd2_log_wait_commit(jo=
urnal, commit_tid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 filemap_write_and_wait(=
&inode->i_data);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0truncate_inode_pages(&inode->i_data, 0=
);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto no_delete;
> =A0 =A0 =A0 =A0}
> @@ -1863,6 +1890,7 @@ static int ext4_journalled_write_end(struct fil=
e *file,
> =A0 =A0 =A0 =A0if (new_i_size > inode->i_size)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0i_size_write(inode, pos+copied);
> =A0 =A0 =A0 =A0ext4_set_inode_state(inode, EXT4_STATE_JDATA);
> + =A0 =A0 =A0 EXT4_I(inode)->i_datasync_tid =3D handle->h_transaction=
->t_tid;
> =A0 =A0 =A0 =A0if (new_i_size > EXT4_I(inode)->i_disksize) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_update_i_disksize(inode, new_i_si=
ze);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret2 =3D ext4_mark_inode_dirty(handle,=
 inode);
> @@ -2571,6 +2599,7 @@ static int __ext4_journalled_writepage(struct p=
age *page,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0write_=
end_fn);
> =A0 =A0 =A0 =A0if (ret =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D err;
> + =A0 =A0 =A0 EXT4_I(inode)->i_datasync_tid =3D handle->h_transaction=
->t_tid;
> =A0 =A0 =A0 =A0err =3D ext4_journal_stop(handle);
> =A0 =A0 =A0 =A0if (!ret)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D err;
> --
> 1.7.1
>

Hi Jan,

Patch looks correct to me, but I am uncomfortable with i_datasync_tid
being treated differently
in journalled write - that is, being set on different places in the wri=
te paths.

How about setting i_datasync_tid in a more generic place like
ext4_{,da_}write_begin()?
I know it's a bit redundant to setting dirty pages, but at least this
way i_datasync_tid can be
checked in all journal modes and have a consistent meaning.

Perhaps we can even use i_datasync_tid to optimize away things like
fiemap checks for dirty pages.
Just a though.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
