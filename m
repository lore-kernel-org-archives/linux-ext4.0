From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: ext4 unkillable lseek.
Date: Wed, 13 Jan 2016 10:36:09 +0300
Message-ID: <87vb6y3p92.fsf@openvz.org>
References: <20160112145348.GA15634@codemonkey.org.uk> <723A6BDE-4D73-47A5-BF0B-7A3D4ACD2C6A@dilger.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>,
	Dave Jones <davej@codemonkey.org.uk>, Ted Tso <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <723A6BDE-4D73-47A5-BF0B-7A3D4ACD2C6A@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Andreas Dilger <adilger@dilger.ca> writes:

> On Jan 12, 2016, at 7:53 AM, Dave Jones <davej@codemonkey.org.uk> wrote:
>>=20
>> I was investigating a case where it looked like Trinity was getting
>> into a deadlock.
>>=20
>> The running task is doing an lseek(fd, <bignum>, SEEK_DATA) on a sparse
>> file that looks like this..
>>=20
>> $ ll trinity-testfile4
>> --wxrwx--- 1 davej davej 4947802326691 Jan 12 09:14 trinity-testfile4*
>> $ sudo filefrag trinity-testfile4
>> trinity-testfile4: 3 extents found
>>=20
>> The kernel trace for that process looks like..
>>=20
>> trinity-c11     R  running task    22192 11483   2439 0x00080004
>> ffff8800428a7c98 ffff8800a2ef87dc ffff8800a3bdf758 ffff8800a3bdf730
>> ffff8800a2ef8008 ffff8800a2ef8340 ffff88009f8e9980 ffff8800a2ef8000
>> ffff8800428a0000 ffffed0008514001 ffff8800428a0008 ffff8800935499e0
>> Call Trace:
>> [<ffffffff8f5e8bd2>] preempt_schedule_common+0x42/0x70
>> [<ffffffff8f5e8c1f>] preempt_schedule+0x1f/0x30
>> [<ffffffff8e003058>] ___preempt_schedule+0x12/0x14
>> [<ffffffff8e7a1e90>] ? ext4_es_find_delayed_extent_range+0x2a0/0x780
>> [<ffffffff8f5f6f81>] ? _raw_read_unlock+0x31/0x50
>> [<ffffffff8f5f6f94>] ? _raw_read_unlock+0x44/0x50
>> [<ffffffff8e7a1e90>] ext4_es_find_delayed_extent_range+0x2a0/0x780
>
> It looks like ext4_es_find_delayed_extent_range() is being called once
> for every block in the file looking for any delalloc data, which is
> pretty awful.  Checking the git history for this code, it seems it was
> fixed once upon a time in commit 14516bb7bb:
>
>     ext4: fix suboptimal seek_{data,hole} extents traversial
>
>     It is ridiculous practice to scan inode block by block, this technique
>     applicable only for old indirect files. This takes significant amount
>     of time for really large files. Let's reuse ext4_fiemap which already
>     traverse inode-tree in most optimal meaner.
>
>     TESTCASE:
>     ftruncate64(fd, 0);
>     ftruncate64(fd, 1ULL << 40);
>     /* lseek will spin very long time */
>     lseek64(fd, 0, SEEK_DATA);
>     lseek64(fd, 0, SEEK_HOLE);
>
>     Original report: https://lkml.org/lkml/2014/10/16/620
>
>     Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>
> but it was later reverted in ad7fefb10 because of a problem with ext3 and
> never restored.
>
>     Revert "ext4: fix suboptimal seek_{data,hole} extents traversial"
>
>     This reverts commit 14516bb7bb6ffbd49f35389f9ece3b2045ba5815.
>
>     This was causing regression test failures with generic/285 with an ex=
t3
>     filesystem using CONFIG_EXT4_USE_FOR_EXT23.
>
>     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>
> Looks like that patch needs to be revived.
Yes. It is in my queue. I'll do it.
>
>> [<ffffffff8e69c307>] ext4_llseek+0x567/0x870
>> [<ffffffff8e69bda0>] ? ext4_find_unwritten_pgoff.isra.12+0x790/0x790
>> [<ffffffff8f5edafc>] ? mutex_lock_nested+0x51c/0x8e0
>> [<ffffffff8e20e5f9>] ? trace_hardirqs_on_caller+0x3f9/0x580
>> [<ffffffff8e56e1a5>] ? __fdget_pos+0xd5/0x110
>> [<ffffffff8e20e78d>] ? trace_hardirqs_on+0xd/0x10
>> [<ffffffff8f5ed5e0>] ? mutex_lock_interruptible_nested+0x9f0/0x9f0
>> [<ffffffff8e00508f>] ? enter_from_user_mode+0x1f/0x50
>> [<ffffffff8e005338>] ? syscall_trace_enter_phase1+0x278/0x470
>> [<ffffffff8e248527>] ? debug_lockdep_rcu_enabled+0x77/0x90
>> [<ffffffff8e518acd>] SyS_lseek+0x10d/0x180
>> [<ffffffff8f5f7457>] entry_SYSCALL_64_fastpath+0x12/0x6b
>>=20
>> It's currently been running for a hour.
>> Even though it's preempting back to userspace, it's ignoring
>> all the SIGKILLs that trinity has been sending it for taking too long.
>>=20
>> Meanwhile all the other processes are backing up on the f_pos lock.
>>=20
>> trinity-c7      D ffff880066857d50 24240 11628   2439 0x00080004
>> ffff880066857d50 0000000000000007 ffff8800a3bdf758 ffff8800a3bdf730
>> ffff880045286608 ffff880045286940 ffff8800a0150000 ffff880045286600
>> ffff880066850000 ffffed000cd0a001 ffff880066850008 dffffc0000000000
>> Call Trace:
>> [<ffffffff8f5e8e0f>] schedule+0x9f/0x1c0
>> [<ffffffff8f5e9588>] schedule_preempt_disabled+0x18/0x30
>> [<ffffffff8f5ed92d>] mutex_lock_nested+0x34d/0x8e0
>> [<ffffffff8e56e1a5>] ? __fdget_pos+0xd5/0x110
>> [<ffffffff8e337fe3>] ? acct_account_cputime+0x63/0x80
>> [<ffffffff8e56e1a5>] ? __fdget_pos+0xd5/0x110
>> [<ffffffff8f5ed5e0>] ? mutex_lock_interruptible_nested+0x9f0/0x9f0
>> [<ffffffff8e248527>] ? debug_lockdep_rcu_enabled+0x77/0x90
>> [<ffffffff8e56e1a5>] __fdget_pos+0xd5/0x110
>> [<ffffffff8e51c029>] SyS_read+0x79/0x230
>> [<ffffffff8e51bfb0>] ? do_sendfile+0x1280/0x1280
>> [<ffffffff8e20e5f9>] ? trace_hardirqs_on_caller+0x3f9/0x580
>> [<ffffffff8e003017>] ? trace_hardirqs_on_thunk+0x17/0x19
>> [<ffffffff8f5f7457>] entry_SYSCALL_64_fastpath+0x12/0x6b
>>=20
>> Eventually it does complete, but waiting a half hour every time
>> trinity picks lseek as a syscall is kinda crappy.
>>=20
>> Shouldn't lseek be a killable operation ?
>>=20
>> I notice this doesn't seem to happen with btrfs, suggesting it's
>> an ext'ism.   This has probably been there for a while, I've not
>> been doing fuzz runs on ext4 enabled systems for a long time.
>>=20
>> 	Dave
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> Cheers, Andreas

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJWlf5pAAoJELhyPTmIL6kBAGYH/1xiYd1v6WvyBH3Dd23bcH01
AOXyyUhibOvvBup1n6fzR1jQkP+/Cw60NqiRpeg4XLVxJOzV3K9S9jthQRNycevL
DbmaVnZCPy6rmdpWFVtPXhrYfP2ofWYhz8rSTqS9AQUZtbYgVkK7F8l8Ir+Rnw61
p5idx3y3Wn7trRfRaOXV64tdRT5IDe2Wa84tns0NGD0eeQHcG5EjQRaQsecjae3K
RmQ3HhoQ1x9C5l/MBCq6Vk0O2cFY74IBMCcPDqc7aQwkLugxhfGJllb3Y5TPLEwR
8kwuNPk3O3ECpHwGUKHreFfwnHGsVSjs9OmyUXlBCDzJ+8S5Pyc4rg41AyE3BNg=
=9aSA
-----END PGP SIGNATURE-----
--=-=-=--
