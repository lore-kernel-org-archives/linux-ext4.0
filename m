From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Fix data corruption in inodes with journalled
 data
Date: Mon, 25 Jul 2011 17:47:36 +0200
Message-ID: <20110725154736.GE6107@quack.suse.cz>
References: <1311381577-31406-1-git-send-email-jack@suse.cz>
 <CAOQ4uxjef-LrZvJkhw=2HvUN6UGtteW30gNUi2yU3LPP_oQhzw@mail.gmail.com>
 <20110725142614.GA6107@quack.suse.cz>
 <CAOQ4uxgja6HNEnQpRgHeEmRJw9KobK2-01hrXM8xpw_ob=2nNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34032 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab1GYPrj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jul 2011 11:47:39 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgja6HNEnQpRgHeEmRJw9KobK2-01hrXM8xpw_ob=2nNA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 25-07-11 17:58:03, Amir Goldstein wrote:
> On Mon, Jul 25, 2011 at 5:26 PM, Jan Kara <jack@suse.cz> wrote:
> > =A0Hello Amir,
> >
> > On Sat 23-07-11 16:21:55, Amir Goldstein wrote:
> >> On Sat, Jul 23, 2011 at 3:39 AM, Jan Kara <jack@suse.cz> wrote:
> >> > When journalling data for an inode (either because it is a symli=
nk or
> >> > because the filesystem is mounted in data=3Djournal mode),
> >> > ext4_evict_inode() can discard unwritten data by calling
> >> > truncate_inode_pages(). This is because we don't mark the buffer=
 / page
> >> > dirty when journalling data but only add the buffer to the runni=
ng
> >> > transaction and thus mm does not know there are still unwritten =
data.
> >> >
> >> > Fix the problem by carefully tracking transaction containing ino=
de's
> >> > data, committing this transaction, and writing uncheckpointed bu=
ffers
> >> > when inode should be reaped.
> >> >
> >> > Signed-off-by: Jan Kara <jack@suse.cz> --- =A0fs/ext4/inode.c | =
=A0 29
> >> > +++++++++++++++++++++++++++++ =A01 files changed, 29 insertions(=
+), 0
> >> > deletions(-)
> >> >
> >> > =A0This is ext4 version of an ext3 fix I sent a while ago. It re=
ceived
> >> > only light testing but I figured you might want get the patch ea=
rlier
> >> > rather than later given the merge window is open.
> >> >
> >> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c index e3126c0..01=
9995b
> >> > 100644 --- a/fs/ext4/inode.c +++ b/fs/ext4/inode.c @@ -190,6 +19=
0,33 @@
> >> > void ext4_evict_inode(struct inode *inode)
> >> >
> >> > =A0 =A0 =A0 =A0trace_ext4_evict_inode(inode); =A0 =A0 =A0 =A0if =
(inode->i_nlink) { +
> >> > =A0 =A0 =A0 =A0 =A0 =A0 /* + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Wh=
en journalling data dirty buffers
> >> > are tracked only in the + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* journ=
al. So although mm
> >> > thinks everything is clean and + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
* ready for reaping the
> >> > inode might still have some pages to + =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0* write in the
> >> > running transaction or waiting to be + =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0* checkpointed.
> >> > Thus calling jbd2_journal_invalidatepage() + =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0* (via
> >> > truncate_inode_pages()) to discard these buffers can + =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0*
> >> > cause data loss. Also even if we did not discard these +
> >> > =A0* buffers, we would have no way to find them after the inode =
+
> >> > =A0 =A0 =A0 =A0* is reaped and thus user could see stale data if=
 he tries to +
> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* read them before the transactio=
n is checkpointed. So
> >> > be + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* careful and force everythi=
ng to disk here... We
> >> > use + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* ei->i_datasync_tid to sto=
re the newest
> >> > transaction + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* containing inode'=
s data. =A0+
> >> > =A0 =A0* + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Note that directorie=
s do not have this problem
> >> > because they + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* don't use page c=
ache. =A0+
> >> > =A0*/ + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ext4_should_journal_data=
(inode) && +
> >> > =A0 =A0 =A0 =A0 (S_ISLNK(inode->i_mode) || S_ISREG(inode->i_mode=
))) { +
> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 journal_t *journal =3D EXT4_SB(inode=
->i_sb)->s_journal; +
> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tid_t commit_tid =3D EXT=
4_I(inode)->i_datasync_tid; +
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 jbd2_log_start_com=
mit(journal, commit_tid); +
> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 jbd2_log_wait_commit(jou=
rnal, commit_tid); +
> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 filemap_write_and_wait(&inode->i=
_data); +
> >> > } =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0truncate_inode_pages(&inode->i_=
data, 0);
> >> > =A0goto no_delete; =A0 =A0 =A0 =A0} @@ -1863,6 +1890,7 @@ static=
 int
> >> > ext4_journalled_write_end(struct file *file, =A0 =A0 =A0 =A0if (=
new_i_size >
> >> > inode->i_size) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0i_size_write(inode=
, pos+copied);
> >> > =A0ext4_set_inode_state(inode, EXT4_STATE_JDATA); +
> >> > EXT4_I(inode)->i_datasync_tid =3D handle->h_transaction->t_tid; =
=A0 =A0 =A0 =A0if
> >> > (new_i_size > EXT4_I(inode)->i_disksize) {
> >> > =A0ext4_update_i_disksize(inode, new_i_size); =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0ret2 =3D
> >> > ext4_mark_inode_dirty(handle, inode); @@ -2571,6 +2599,7 @@ stat=
ic int
> >> > __ext4_journalled_writepage(struct page *page,
> >> > =A0 =A0 =A0 =A0write_end_fn); =A0 =A0 =A0 =A0if (ret =3D=3D 0) =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D err; +
> >> > =A0 =A0 =A0 EXT4_I(inode)->i_datasync_tid =3D handle->h_transact=
ion->t_tid;
> >> > =A0 =A0err =3D ext4_journal_stop(handle); =A0 =A0 =A0 =A0if (!re=
t) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret
> >> > =3D err; -- 1.7.1
> >> >
> >> Patch looks correct to me, but I am uncomfortable with i_datasync_=
tid
> >> being treated differently in journalled write - that is, being set=
 on
> >> different places in the write paths.
> >>
> >> How about setting i_datasync_tid in a more generic place like
> >> ext4_{,da_}write_begin()? =A0I know it's a bit redundant to settin=
g dirty
> >> pages, but at least this way i_datasync_tid can be checked in all =
journal
> >> modes and have a consistent meaning.
> > =A0Well, I kept the meaning that i_datasync_tid is ID of a transact=
ion that
> > must be committed for a data of an inode to be safely on disk. It i=
s true
> > that in data=3Djournal mode, we need to update this number differen=
tly than
> > in other journaling modes but that's not important I think. Current=
ly, we
> > just force commit in data=3Djournal mode in every case and thus we =
do not
> > really care about the value of i_datasync_tid for fsync. In future =
we could
> > be more clever and avoid transaction commits for fsync in data=3Djo=
urnal mode
> > in some cases. =A0So in fact I'd say the code is now *more* consist=
ent than
> > it used to be. =A0The only thing that isn't quite consistent is tha=
t I didn't
> > bother with updating i_sync_tid because we currently do not use it.=
 If
> > people want, that might be a useful cleanup which I can do.
> >
> >> Perhaps we can even use i_datasync_tid to optimize away things lik=
e
> >> fiemap checks for dirty pages.
> > =A0Umm, I'm not sure which checks do you mean...
>=20
> I thought that ext4_ext_fiemap_cb() looks for dirty pages to display =
as delayed
> allocation extents and that this lookup can be avoided if we know tha=
t the inode
> data is not dirty, but I could have been wrong.
  No, that won't really work. We don't want to update i_datasync_tid fo=
r
delayed allocation write. We don't really have a valid tid to store in =
that
call path.

BTW, you made me look at the checks in ext4_ext_fiemap_cb() and that co=
de
is just broken. It can oops in a number of ways when it races with page
reclaim. I'll write to Yongqiang who seems to an author of this...

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
