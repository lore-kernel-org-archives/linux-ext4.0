From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ext4: Fix data corruption in inodes with journalled data
Date: Mon, 25 Jul 2011 17:58:03 +0300
Message-ID: <CAOQ4uxgja6HNEnQpRgHeEmRJw9KobK2-01hrXM8xpw_ob=2nNA@mail.gmail.com>
References: <1311381577-31406-1-git-send-email-jack@suse.cz>
	<CAOQ4uxjef-LrZvJkhw=2HvUN6UGtteW30gNUi2yU3LPP_oQhzw@mail.gmail.com>
	<20110725142614.GA6107@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39293 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab1GYO6E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Jul 2011 10:58:04 -0400
Received: by wyg8 with SMTP id 8so2805007wyg.19
        for <linux-ext4@vger.kernel.org>; Mon, 25 Jul 2011 07:58:03 -0700 (PDT)
In-Reply-To: <20110725142614.GA6107@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 25, 2011 at 5:26 PM, Jan Kara <jack@suse.cz> wrote:
> =A0Hello Amir,
>
> On Sat 23-07-11 16:21:55, Amir Goldstein wrote:
>> On Sat, Jul 23, 2011 at 3:39 AM, Jan Kara <jack@suse.cz> wrote:
>> > When journalling data for an inode (either because it is a symlink=
 or
>> > because the filesystem is mounted in data=3Djournal mode),
>> > ext4_evict_inode() can discard unwritten data by calling
>> > truncate_inode_pages(). This is because we don't mark the buffer /=
 page
>> > dirty when journalling data but only add the buffer to the running
>> > transaction and thus mm does not know there are still unwritten da=
ta.
>> >
>> > Fix the problem by carefully tracking transaction containing inode=
's
>> > data, committing this transaction, and writing uncheckpointed buff=
ers
>> > when inode should be reaped.
>> >
>> > Signed-off-by: Jan Kara <jack@suse.cz> --- =A0fs/ext4/inode.c | =A0=
 29
>> > +++++++++++++++++++++++++++++ =A01 files changed, 29 insertions(+)=
, 0
>> > deletions(-)
>> >
>> > =A0This is ext4 version of an ext3 fix I sent a while ago. It rece=
ived
>> > only light testing but I figured you might want get the patch earl=
ier
>> > rather than later given the merge window is open.
>> >
>> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c index e3126c0..0199=
95b
>> > 100644 --- a/fs/ext4/inode.c +++ b/fs/ext4/inode.c @@ -190,6 +190,=
33 @@
>> > void ext4_evict_inode(struct inode *inode)
>> >
>> > =A0 =A0 =A0 =A0trace_ext4_evict_inode(inode); =A0 =A0 =A0 =A0if (i=
node->i_nlink) { +
>> > =A0 =A0 =A0 =A0 =A0 =A0 /* + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* When=
 journalling data dirty buffers
>> > are tracked only in the + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* journal=
=2E So although mm
>> > thinks everything is clean and + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* =
ready for reaping the
>> > inode might still have some pages to + =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0* write in the
>> > running transaction or waiting to be + =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0* checkpointed.
>> > Thus calling jbd2_journal_invalidatepage() + =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0* (via
>> > truncate_inode_pages()) to discard these buffers can + =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0*
>> > cause data loss. Also even if we did not discard these +
>> > =A0* buffers, we would have no way to find them after the inode +
>> > =A0 =A0 =A0 =A0* is reaped and thus user could see stale data if h=
e tries to +
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* read them before the transaction =
is checkpointed. So
>> > be + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* careful and force everything=
 to disk here... We
>> > use + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* ei->i_datasync_tid to store=
 the newest
>> > transaction + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* containing inode's =
data. =A0+
>> > =A0 =A0* + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Note that directories =
do not have this problem
>> > because they + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* don't use page cac=
he. =A0+
>> > =A0*/ + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ext4_should_journal_data(i=
node) && +
>> > =A0 =A0 =A0 =A0 (S_ISLNK(inode->i_mode) || S_ISREG(inode->i_mode))=
) { +
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 journal_t *journal =3D EXT4_SB(inode->=
i_sb)->s_journal; +
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tid_t commit_tid =3D EXT4_=
I(inode)->i_datasync_tid; +
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 jbd2_log_start_commi=
t(journal, commit_tid); +
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 jbd2_log_wait_commit(journ=
al, commit_tid); +
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 filemap_write_and_wait(&inode->i_d=
ata); +
>> > } =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0truncate_inode_pages(&inode->i_da=
ta, 0);
>> > =A0goto no_delete; =A0 =A0 =A0 =A0} @@ -1863,6 +1890,7 @@ static i=
nt
>> > ext4_journalled_write_end(struct file *file, =A0 =A0 =A0 =A0if (ne=
w_i_size >
>> > inode->i_size) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0i_size_write(inode, =
pos+copied);
>> > =A0ext4_set_inode_state(inode, EXT4_STATE_JDATA); +
>> > EXT4_I(inode)->i_datasync_tid =3D handle->h_transaction->t_tid; =A0=
 =A0 =A0 =A0if
>> > (new_i_size > EXT4_I(inode)->i_disksize) {
>> > =A0ext4_update_i_disksize(inode, new_i_size); =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0ret2 =3D
>> > ext4_mark_inode_dirty(handle, inode); @@ -2571,6 +2599,7 @@ static=
 int
>> > __ext4_journalled_writepage(struct page *page,
>> > =A0 =A0 =A0 =A0write_end_fn); =A0 =A0 =A0 =A0if (ret =3D=3D 0) =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D err; +
>> > =A0 =A0 =A0 EXT4_I(inode)->i_datasync_tid =3D handle->h_transactio=
n->t_tid;
>> > =A0 =A0err =3D ext4_journal_stop(handle); =A0 =A0 =A0 =A0if (!ret)=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret
>> > =3D err; -- 1.7.1
>> >
>> Patch looks correct to me, but I am uncomfortable with i_datasync_ti=
d
>> being treated differently in journalled write - that is, being set o=
n
>> different places in the write paths.
>>
>> How about setting i_datasync_tid in a more generic place like
>> ext4_{,da_}write_begin()? =A0I know it's a bit redundant to setting =
dirty
>> pages, but at least this way i_datasync_tid can be checked in all jo=
urnal
>> modes and have a consistent meaning.
> =A0Well, I kept the meaning that i_datasync_tid is ID of a transactio=
n that
> must be committed for a data of an inode to be safely on disk. It is =
true
> that in data=3Djournal mode, we need to update this number differentl=
y than
> in other journaling modes but that's not important I think. Currently=
, we
> just force commit in data=3Djournal mode in every case and thus we do=
 not
> really care about the value of i_datasync_tid for fsync. In future we=
 could
> be more clever and avoid transaction commits for fsync in data=3Djour=
nal mode
> in some cases. =A0So in fact I'd say the code is now *more* consisten=
t than
> it used to be. =A0The only thing that isn't quite consistent is that =
I didn't
> bother with updating i_sync_tid because we currently do not use it. I=
f
> people want, that might be a useful cleanup which I can do.
>
>> Perhaps we can even use i_datasync_tid to optimize away things like
>> fiemap checks for dirty pages.
> =A0Umm, I'm not sure which checks do you mean...

I thought that ext4_ext_fiemap_cb() looks for dirty pages to display as=
 delayed
allocation extents and that this lookup can be avoided if we know that =
the inode
data is not dirty, but I could have been wrong.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
