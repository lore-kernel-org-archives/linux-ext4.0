From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH v0 RFC] ext4: Fix a bug in ext4_journal_start_sb().
Date: Tue, 5 Apr 2011 13:45:33 +0800
Message-ID: <BANLkTimFwK+S7Y1crVdtDtir5qHTSCz85g@mail.gmail.com>
References: <1301647493-13163-1-git-send-email-xiaoqiangnk@gmail.com>
	<20110403095512.GB5141@quack.suse.cz>
	<BANLkTikqPbxutbLRWYu4hs4JURZjVW2L=Q@mail.gmail.com>
	<20110404140945.GB11931@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57328 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab1DEFpe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Apr 2011 01:45:34 -0400
Received: by pvg12 with SMTP id 12so15773pvg.19
        for <linux-ext4@vger.kernel.org>; Mon, 04 Apr 2011 22:45:33 -0700 (PDT)
In-Reply-To: <20110404140945.GB11931@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 4, 2011 at 10:09 PM, Jan Kara <jack@suse.cz> wrote:
> On Mon 04-04-11 20:31:41, Yongqiang Yang wrote:
>> >> Reported-by: Amir Goldstein <amir73il@users.sf.net>
>> >> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> >> ---
>> >> =A0fs/ext4/super.c | =A0 49 +++++++++++++++++++++++++++++++++++++=
+-----------
>> >> =A01 files changed, 38 insertions(+), 11 deletions(-)
>> >>
>> >> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> >> index ccfa686..f35b53e 100644
>> >> --- a/fs/ext4/super.c
>> >> +++ b/fs/ext4/super.c
>> >> @@ -242,27 +242,49 @@ static void ext4_put_nojournal(handle_t *ha=
ndle)
>> >> =A0 * journal_end calls result in the superblock being marked dir=
ty, so
>> >> =A0 * that sync() will call the filesystem's write_super callback=
 if
>> >> =A0 * appropriate.
>> >> + *
>> >> + * To avoid j_barrier hold in userspace when a user calls freeze=
(),
>> >> + * ext4 prevents a new handle from being started by s_frozen, wh=
ich
>> >> + * is in an upper layer.
>> >> =A0 */
>> >> =A0handle_t *ext4_journal_start_sb(struct super_block *sb, int nb=
locks)
>> >> =A0{
>> >> =A0 =A0 =A0 journal_t *journal;
>> >> + =A0 =A0 handle_t =A0*handle;
>> >>
>> >> =A0 =A0 =A0 if (sb->s_flags & MS_RDONLY)
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(-EROFS);
>> >>
>> >> - =A0 =A0 vfs_check_frozen(sb, SB_FREEZE_TRANS);
>> >> - =A0 =A0 /* Special case here: if the journal has aborted behind=
 our
>> >> - =A0 =A0 =A0* backs (eg. EIO in the commit thread), then we stil=
l need to
>> >> - =A0 =A0 =A0* take the FS itself readonly cleanly. */
>> >> =A0 =A0 =A0 journal =3D EXT4_SB(sb)->s_journal;
>> >> - =A0 =A0 if (journal) {
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 if (is_journal_aborted(journal)) {
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_abort(sb, "Detecte=
d aborted journal");
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(-EROFS);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 return jbd2_journal_start(journal, nblo=
cks);
>> >> + =A0 =A0 if (!journal)
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 /*
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* Under no-journal mode, vfs_check_f=
rozen() is not neeed.
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> > =A0Why is this? Previously we waited also in the nojournal case an=
d I don't
>> > see anything that would stop modifications in the nojournal case a=
fter your
>> > change...
>>
>> I think that ext4 in the nojournal case should do as filesystems
>> without journal, such as ext2. =A0 ext4_ext_truncate() upwrite
> =A0But ext2 does not support filesystem freezing...
>
>> i_data_sem only if ext4_journal_extend() fails before
>> ext4_journal_restart() is called, ext4_journal_extend() however alwa=
ys
>> succeeds in nojournal case.
> =A0OK, but again, I'm failing to see how i_data_sem behavior is relev=
ant
> for waiting if a filesystem is frozen... So to be clear I believe we =
must
> do vfs_check_frozen() even in nojournal case if and only if the handl=
e
> reference count is 0 (it's stored directly in current->journal_info i=
n
> nojournal mode).

My ignorance,  I made analysis on i_data_sem under the assumption that
ext3 supports filesystem freezing.


>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
