From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH v0 RFC] ext4: Fix a bug in ext4_journal_start_sb().
Date: Mon, 4 Apr 2011 20:31:41 +0800
Message-ID: <BANLkTikqPbxutbLRWYu4hs4JURZjVW2L=Q@mail.gmail.com>
References: <1301647493-13163-1-git-send-email-xiaoqiangnk@gmail.com>
	<20110403095512.GB5141@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37207 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab1DDMbl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Apr 2011 08:31:41 -0400
Received: by pwi15 with SMTP id 15so1339131pwi.19
        for <linux-ext4@vger.kernel.org>; Mon, 04 Apr 2011 05:31:41 -0700 (PDT)
In-Reply-To: <20110403095512.GB5141@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 3, 2011 at 5:55 PM, Jan Kara <jack@suse.cz> wrote:
> =A0Hello,
>
> =A0thanks for the patch. I have some suggestions for improvement belo=
w...
>
> On Fri 01-04-11 16:44:53, Yongqiang Yang wrote:
>> ext4_journal_start_sb() should not prevent active handle from being
>> started due to s_frozen. =A0Otherwise, deadlock is easy to happen, b=
elow
>> is a situation.
>>
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> =A0 =A0 =A0freeze =A0 =A0 =A0 =A0 | =A0 =A0 =A0 truncate =A0 =A0 =A0=
 =A0 =A0 =A0 | =A0 =A0 =A0kjournald
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0ext4_ext_truncate() =A0=
 =A0 =A0 |
>> =A0 =A0 freeze_super() =A0| =A0 starts a handle =A0 =A0 =A0 =A0 =A0|
>> =A0 =A0 sets s_frozen =A0 | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0|
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0ext4_ext_truncate() =A0=
 =A0 =A0 |
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0holds i_data_sem =A0 =A0=
 =A0 =A0 =A0|
>> =A0 ext4_freeze() =A0 =A0 | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0| =A0 commit_transaction()
>> =A0 waits for updates | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0| =A0 waits for i_data_sem
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0ext4_free_blocks() =A0 =
=A0 =A0 =A0|
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0calls dquot_free_block(=
) =A0|
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0dquot_free_blocks() =A0=
 =A0 =A0 |
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0calls ext4_dirty_inode(=
) =A0|
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0ext4_dirty_inode() =A0 =
=A0 =A0 =A0|
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0trys to start an active=
 =A0 |
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0handle =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0|
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0block due to s_frozen =A0=
 =A0 |
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =A0Actuall, kjournald isn't needed for the deadlock at all.. Just the
> truncate and freeze threads are enough. So you can simplify the
> description.
Agree.

>
>> Messages reported by Amir:
>> while running phoronix test suite and taking a snapshot every 10 sec=
onds,
>> the following hang happened during tiobench [64MB Random Write - 32 =
Threads]:
>>
>> [20868.207441] snapshot: snapshot (913) created
>> [21000.040021] [Hardware Error]: Machine check events logged
>> [21001.300039] INFO: task jbd2/sda6-8:3560 blocked for more than 120=
 seconds.
>> [21001.300043] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" di=
sables
>> this message.
>> [21001.300048] jbd2/sda6-8 =A0 =A0 D 0000000000000000 =A0 =A0 0 =A03=
560 =A0 =A0 =A02 0x00000000
>> [21001.300055] =A0ffff880037a8fce0 0000000000000046 0000000000000000
>> ffff880100000000
>> [21001.300063] =A00000000000014000 ffff880037a1bf40 ffff880037a1c2c0
>> ffff880037a8ffd8
>> [21001.300070] =A0ffff880037a1c2c8 0000000000014000 ffff880037a8e010
>> 0000000000014000
>> [21001.300078] Call Trace:
>> [21001.300089] =A0[<ffffffff8124ebcc>] jbd2_journal_commit_transacti=
on+
>> 0x1cc/0x15d0
>> [21001.300095] =A0[<ffffffff815bea70>] ? _raw_spin_unlock_irq+0x30/0=
x40
>> [21001.300102] =A0[<ffffffff810746dc>] ? lock_timer_base+0x3c/0x70
>> [21001.300108] =A0[<ffffffff81075ae0>] ? try_to_del_timer_sync+0x90/=
0x100
>> [21001.300113] =A0[<ffffffff81088d30>] ? autoremove_wake_function+0x=
0/0x40
>> [21001.300118] =A0[<ffffffff81075bf2>] ? del_timer_sync+0xa2/0xe0
>> [21001.300123] =A0[<ffffffff81075b50>] ? del_timer_sync+0x0/0xe0
>> [21001.300129] =A0[<ffffffff81254b71>] kjournald2+0xc1/0x220
>> [21001.300133] =A0[<ffffffff81088d30>] ? autoremove_wake_function+0x=
0/0x40
>> [21001.300138] =A0[<ffffffff81254ab0>] ? kjournald2+0x0/0x220
>> [21001.300143] =A0[<ffffffff810887d6>] kthread+0xb6/0xc0
>> [21001.300149] =A0[<ffffffff8100ce24>] kernel_thread_helper+0x4/0x10
>> [21001.300154] =A0[<ffffffff815bea70>] ? _raw_spin_unlock_irq+0x30/0=
x40
>> [21001.300158] =A0[<ffffffff815bf054>] ? restore_args+0x0/0x30
>> [21001.300163] =A0[<ffffffff81088720>] ? kthread+0x0/0xc0
>> [21001.300167] =A0[<ffffffff8100ce20>] ? kernel_thread_helper+0x0/0x=
10
>> [21001.300171] INFO: lockdep is turned off.
>> [21001.300175] INFO: task tiotest:6277 blocked for more than 120 sec=
onds.
>> [21001.300178] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" di=
sables
>> this message.
>> [21001.300182] tiotest =A0 =A0 =A0 =A0 D 0000000000000000 =A0 =A0 0 =
=A06277 =A0 6276 0x00000000
>> [21001.300188] =A0ffff88003789d9d8 0000000000000046 ffff88005b87a068
>> 0000000000000002
>> [21001.300196] =A00000000000014000 ffff8800ac435ee0 ffff8800ac436260
>> ffff88003789dfd8
>> [21001.300203] =A0ffff8800ac436268 0000000000014000 ffff88003789c010
>> 0000000000014000
>> [21001.300211] Call Trace:
>> [21001.300216] =A0[<ffffffff81088fe0>] ? prepare_to_wait+0x60/0x90
>> [21001.300236] =A0[<ffffffffa0297745>] __next4_journal_start+0x85/0x=
1d0 [next4]
>> [21001.300241] =A0[<ffffffff815beb1b>] ? _raw_spin_unlock+0x2b/0x40
>> [21001.300246] =A0[<ffffffff81088d30>] ? autoremove_wake_function+0x=
0/0x40
>> [21001.300259] =A0[<ffffffffa027d98e>] next4_dirty_inode+0x2e/0x70 [=
next4]
>> [21001.300266] =A0[<ffffffff811942e8>] __mark_inode_dirty+0x38/0x220
>> [21001.300283] =A0[<ffffffffa02af022>] __next4_free_blocks+0xb42/0xe=
b0 [next4]
>> [21001.300300] =A0[<ffffffffa02a297e>] next4_ext_truncate+0x8ce/0xa9=
0 [next4]
>> [21001.300315] =A0[<ffffffffa0283921>] next4_truncate+0x601/0x860 [n=
ext4]
>> [21001.300331] =A0[<ffffffffa02a6da3>] ? __next4_handle_dirty_metada=
ta+0x83/0x1d0
>> [next4]
>> [21001.300344] =A0[<ffffffffa027ccc0>] ? next4_mark_iloc_dirty+0x480=
/0x6b0 [next4]
>> [21001.300358] =A0[<ffffffffa027d7b6>] ? next4_mark_inode_dirty+0xa6=
/0x250 [next4]
>> [21001.300372] =A0[<ffffffffa0285c00>] next4_evict_inode+0x3a0/0x490=
 [next4]
>> [21001.300378] =A0[<ffffffff81186c44>] evict+0x24/0xb0
>> [21001.300382] =A0[<ffffffff811872a6>] iput+0x1f6/0x2f0
>> [21001.300388] =A0[<ffffffff8117b06f>] do_unlinkat+0x11f/0x1e0
>> [21001.300394] =A0[<ffffffff815be0d9>] ? trace_hardirqs_on_thunk+0x3=
a/0x3f
>> [21001.300399] =A0[<ffffffff8117b146>] sys_unlink+0x16/0x20
>> [21001.300405] =A0[<ffffffff8100bf82>] system_call_fastpath+0x16/0x1=
b
>> [21001.300408] INFO: lockdep is turned off.
>> [21001.300411] INFO: task chsnap:6510 blocked for more than 120 seco=
nds.
>> [21001.300414] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" di=
sables
>> this message.
>> [21001.300418] chsnap =A0 =A0 =A0 =A0 =A0D 0000000000000000 =A0 =A0 =
0 =A06510 =A0 6481 0x00000000
>> [21001.300424] =A0ffff8800ac2ffba8 0000000000000046 0000000000000000
>> ffff880107fe5688
>> [21001.300431] =A00000000000014000 ffff8800ac599fa0 ffff8800ac59a320
>> [21001.300439] =A0ffff8800ac59a328 0000000000014000 ffff8800ac2fe010
>> 0000000000014000
>> [21001.300447] Call Trace:
>> [21001.300452] =A0[<ffffffff8124cc55>] jbd2_journal_lock_updates+0x9=
5/0x100
>> [21001.300457] =A0[<ffffffff81088d30>] ? autoremove_wake_function+0x=
0/0x40
>> [21001.300473] =A0[<ffffffffa0295756>] next4_freeze+0x46/0xa0 [next4=
]
>> [21001.300479] =A0[<ffffffff811a27e4>] ? __sync_blockdev+0x24/0x50
>> [21001.300484] =A0[<ffffffff8116ec2d>] freeze_super+0x7d/0x100
>> [21001.300500] =A0[<ffffffffa02bbe48>] next4_snapshot_take+0x268/0xa=
70 [next4]
>> [21001.300506] =A0[<ffffffff8124c910>] ? jbd2_journal_stop+0x1e0/0x2=
c0
>> [21001.300520] =A0[<ffffffffa0287558>] next4_ioctl+0xc28/0xcc0 [next=
4]
>> [21001.300527] =A0[<ffffffff812f66b4>] ? do_raw_spin_lock+0x54/0x150
>> [21001.300532] =A0[<ffffffff8117e175>] do_vfs_ioctl+0xa5/0x5a0
>> [21001.300537] =A0[<ffffffff8109e6ad>] ? trace_hardirqs_on+0xd/0x10
>> [21001.300542] =A0[<ffffffff8116dc5c>] ? fget_light+0x1ec/0x370
>> [21001.300547] =A0[<ffffffff8117e711>] sys_ioctl+0xa1/0xb0
>> [21001.300552] =A0[<ffffffff8100bf82>] system_call_fastpath+0x16/0x1=
b
>> [21001.300555] INFO: lockdep is turned off.
> =A0Not sure these traces are needed in the changelog. The description=
 in the
> beginning seems to be enough to understand the problem so I'd prefer =
a
> shorter description. But I leave this up to you.
Agree.
>
>> Reported-by: Amir Goldstein <amir73il@users.sf.net>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> ---
>> =A0fs/ext4/super.c | =A0 49 ++++++++++++++++++++++++++++++++++++++--=
---------
>> =A01 files changed, 38 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index ccfa686..f35b53e 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -242,27 +242,49 @@ static void ext4_put_nojournal(handle_t *handl=
e)
>> =A0 * journal_end calls result in the superblock being marked dirty,=
 so
>> =A0 * that sync() will call the filesystem's write_super callback if
>> =A0 * appropriate.
>> + *
>> + * To avoid j_barrier hold in userspace when a user calls freeze(),
>> + * ext4 prevents a new handle from being started by s_frozen, which
>> + * is in an upper layer.
>> =A0 */
>> =A0handle_t *ext4_journal_start_sb(struct super_block *sb, int nbloc=
ks)
>> =A0{
>> =A0 =A0 =A0 journal_t *journal;
>> + =A0 =A0 handle_t =A0*handle;
>>
>> =A0 =A0 =A0 if (sb->s_flags & MS_RDONLY)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(-EROFS);
>>
>> - =A0 =A0 vfs_check_frozen(sb, SB_FREEZE_TRANS);
>> - =A0 =A0 /* Special case here: if the journal has aborted behind ou=
r
>> - =A0 =A0 =A0* backs (eg. EIO in the commit thread), then we still n=
eed to
>> - =A0 =A0 =A0* take the FS itself readonly cleanly. */
>> =A0 =A0 =A0 journal =3D EXT4_SB(sb)->s_journal;
>> - =A0 =A0 if (journal) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (is_journal_aborted(journal)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_abort(sb, "Detected a=
borted journal");
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(-EROFS);
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 return jbd2_journal_start(journal, nblocks=
);
>> + =A0 =A0 if (!journal)
>> + =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* Under no-journal mode, vfs_check_froz=
en() is not neeed.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> =A0Why is this? Previously we waited also in the nojournal case and I=
 don't
> see anything that would stop modifications in the nojournal case afte=
r your
> change...

I think that ext4 in the nojournal case should do as filesystems
without journal, such as ext2.   ext4_ext_truncate() upwrite
i_data_sem only if ext4_journal_extend() fails before
ext4_journal_restart() is called, ext4_journal_extend() however always
succeeds in nojournal case.

I am not sure if I am right.

>
>> + =A0 =A0 =A0 =A0 =A0 =A0 return ext4_get_nojournal();
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* Before vfs_check_frozen(), the current handle should =
be allowed
>> + =A0 =A0 =A0* to finish, otherwise deadlock would happen when the f=
ilesystem
>> + =A0 =A0 =A0* is freezed && active handles are not stopped.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 handle =3D ext4_journal_current_handle();
>> + =A0 =A0 if (handle) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(!(handle->h_transaction->t_journal =
=3D=3D journal));
>> + =A0 =A0 =A0 =A0 =A0 =A0 handle->h_ref++;
>> + =A0 =A0 =A0 =A0 =A0 =A0 return handle;
> =A0Please use jbd2_journal_start() to get the reference for you (alth=
ough I
> agree it's slightly inefficient). I don't like messing with JBD2 inte=
rnals
> like handle use counts in ext4.
Agree.

Thank you.
>
>> =A0 =A0 =A0 }
>> - =A0 =A0 return ext4_get_nojournal();
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* Special case here: if the journal has aborted behind =
our
>> + =A0 =A0 =A0* backs (eg. EIO in the commit thread), then we still n=
eed to
>> + =A0 =A0 =A0* take the FS itself readonly cleanly.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 vfs_check_frozen(sb, SB_FREEZE_TRANS);
>> + =A0 =A0 if (is_journal_aborted(journal)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_abort(sb, "Detected aborted journal")=
;
>> + =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(-EROFS);
>> + =A0 =A0 }
>> + =A0 =A0 return jbd2_journal_start(journal, nblocks);
>> =A0}
>>
>> =A0/*
>> @@ -4131,6 +4153,11 @@ static int ext4_sync_fs(struct super_block *s=
b, int wait)
>> =A0/*
>> =A0 * LVM calls this function before a (read-only) snapshot is creat=
ed. =A0This
>> =A0 * gives us a chance to flush the journal completely and mark the=
 fs clean.
>> + *
>> + * Note that only this function cannot bring a filesystem to be in =
a clean
>> + * state independently, because ext4 prevents a new handle from bei=
ng started
>> + * by @sb->s_frozen, which stays in an upper layer. =A0It thus need=
s help from
>> + * the upper layer.
>> =A0 */
>> =A0static int ext4_freeze(struct super_block *sb)
>> =A0{
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
