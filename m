From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: ext4 unkillable lseek.
Date: Tue, 12 Jan 2016 14:17:43 -0700
Message-ID: <723A6BDE-4D73-47A5-BF0B-7A3D4ACD2C6A@dilger.ca>
References: <20160112145348.GA15634@codemonkey.org.uk>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_C6B6C2E1-6D22-4B91-92AC-808ED90DC296"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Dave Jones <davej@codemonkey.org.uk>, Ted Tso <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:35404 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbcALVRu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jan 2016 16:17:50 -0500
Received: by mail-io0-f178.google.com with SMTP id 77so366530228ioc.2
        for <linux-ext4@vger.kernel.org>; Tue, 12 Jan 2016 13:17:49 -0800 (PST)
In-Reply-To: <20160112145348.GA15634@codemonkey.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_C6B6C2E1-6D22-4B91-92AC-808ED90DC296
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Jan 12, 2016, at 7:53 AM, Dave Jones <davej@codemonkey.org.uk> wrote:
> 
> I was investigating a case where it looked like Trinity was getting
> into a deadlock.
> 
> The running task is doing an lseek(fd, <bignum>, SEEK_DATA) on a sparse
> file that looks like this..
> 
> $ ll trinity-testfile4
> --wxrwx--- 1 davej davej 4947802326691 Jan 12 09:14 trinity-testfile4*
> $ sudo filefrag trinity-testfile4
> trinity-testfile4: 3 extents found
> 
> The kernel trace for that process looks like..
> 
> trinity-c11     R  running task    22192 11483   2439 0x00080004
> ffff8800428a7c98 ffff8800a2ef87dc ffff8800a3bdf758 ffff8800a3bdf730
> ffff8800a2ef8008 ffff8800a2ef8340 ffff88009f8e9980 ffff8800a2ef8000
> ffff8800428a0000 ffffed0008514001 ffff8800428a0008 ffff8800935499e0
> Call Trace:
> [<ffffffff8f5e8bd2>] preempt_schedule_common+0x42/0x70
> [<ffffffff8f5e8c1f>] preempt_schedule+0x1f/0x30
> [<ffffffff8e003058>] ___preempt_schedule+0x12/0x14
> [<ffffffff8e7a1e90>] ? ext4_es_find_delayed_extent_range+0x2a0/0x780
> [<ffffffff8f5f6f81>] ? _raw_read_unlock+0x31/0x50
> [<ffffffff8f5f6f94>] ? _raw_read_unlock+0x44/0x50
> [<ffffffff8e7a1e90>] ext4_es_find_delayed_extent_range+0x2a0/0x780

It looks like ext4_es_find_delayed_extent_range() is being called once
for every block in the file looking for any delalloc data, which is
pretty awful.  Checking the git history for this code, it seems it was
fixed once upon a time in commit 14516bb7bb:

    ext4: fix suboptimal seek_{data,hole} extents traversial

    It is ridiculous practice to scan inode block by block, this technique
    applicable only for old indirect files. This takes significant amount
    of time for really large files. Let's reuse ext4_fiemap which already
    traverse inode-tree in most optimal meaner.

    TESTCASE:
    ftruncate64(fd, 0);
    ftruncate64(fd, 1ULL << 40);
    /* lseek will spin very long time */
    lseek64(fd, 0, SEEK_DATA);
    lseek64(fd, 0, SEEK_HOLE);

    Original report: https://lkml.org/lkml/2014/10/16/620

    Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

but it was later reverted in ad7fefb10 because of a problem with ext3 and
never restored.

    Revert "ext4: fix suboptimal seek_{data,hole} extents traversial"

    This reverts commit 14516bb7bb6ffbd49f35389f9ece3b2045ba5815.

    This was causing regression test failures with generic/285 with an ext3
    filesystem using CONFIG_EXT4_USE_FOR_EXT23.

    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Looks like that patch needs to be revived.

> [<ffffffff8e69c307>] ext4_llseek+0x567/0x870
> [<ffffffff8e69bda0>] ? ext4_find_unwritten_pgoff.isra.12+0x790/0x790
> [<ffffffff8f5edafc>] ? mutex_lock_nested+0x51c/0x8e0
> [<ffffffff8e20e5f9>] ? trace_hardirqs_on_caller+0x3f9/0x580
> [<ffffffff8e56e1a5>] ? __fdget_pos+0xd5/0x110
> [<ffffffff8e20e78d>] ? trace_hardirqs_on+0xd/0x10
> [<ffffffff8f5ed5e0>] ? mutex_lock_interruptible_nested+0x9f0/0x9f0
> [<ffffffff8e00508f>] ? enter_from_user_mode+0x1f/0x50
> [<ffffffff8e005338>] ? syscall_trace_enter_phase1+0x278/0x470
> [<ffffffff8e248527>] ? debug_lockdep_rcu_enabled+0x77/0x90
> [<ffffffff8e518acd>] SyS_lseek+0x10d/0x180
> [<ffffffff8f5f7457>] entry_SYSCALL_64_fastpath+0x12/0x6b
> 
> It's currently been running for a hour.
> Even though it's preempting back to userspace, it's ignoring
> all the SIGKILLs that trinity has been sending it for taking too long.
> 
> Meanwhile all the other processes are backing up on the f_pos lock.
> 
> trinity-c7      D ffff880066857d50 24240 11628   2439 0x00080004
> ffff880066857d50 0000000000000007 ffff8800a3bdf758 ffff8800a3bdf730
> ffff880045286608 ffff880045286940 ffff8800a0150000 ffff880045286600
> ffff880066850000 ffffed000cd0a001 ffff880066850008 dffffc0000000000
> Call Trace:
> [<ffffffff8f5e8e0f>] schedule+0x9f/0x1c0
> [<ffffffff8f5e9588>] schedule_preempt_disabled+0x18/0x30
> [<ffffffff8f5ed92d>] mutex_lock_nested+0x34d/0x8e0
> [<ffffffff8e56e1a5>] ? __fdget_pos+0xd5/0x110
> [<ffffffff8e337fe3>] ? acct_account_cputime+0x63/0x80
> [<ffffffff8e56e1a5>] ? __fdget_pos+0xd5/0x110
> [<ffffffff8f5ed5e0>] ? mutex_lock_interruptible_nested+0x9f0/0x9f0
> [<ffffffff8e248527>] ? debug_lockdep_rcu_enabled+0x77/0x90
> [<ffffffff8e56e1a5>] __fdget_pos+0xd5/0x110
> [<ffffffff8e51c029>] SyS_read+0x79/0x230
> [<ffffffff8e51bfb0>] ? do_sendfile+0x1280/0x1280
> [<ffffffff8e20e5f9>] ? trace_hardirqs_on_caller+0x3f9/0x580
> [<ffffffff8e003017>] ? trace_hardirqs_on_thunk+0x17/0x19
> [<ffffffff8f5f7457>] entry_SYSCALL_64_fastpath+0x12/0x6b
> 
> Eventually it does complete, but waiting a half hour every time
> trinity picks lseek as a syscall is kinda crappy.
> 
> Shouldn't lseek be a killable operation ?
> 
> I notice this doesn't seem to happen with btrfs, suggesting it's
> an ext'ism.   This has probably been there for a while, I've not
> been doing fuzz runs on ext4 enabled systems for a long time.
> 
> 	Dave
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_C6B6C2E1-6D22-4B91-92AC-808ED90DC296
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVpVteHKl2rkXzB/gAQiCLA//WEdTUnGEeG+44vfBgRMhjUXs46b9dzuq
JN8+lMKTnldWKUaEHF2rhkKqTAeEy8MRB6H1d/PlHeZRrLCsQ14l5UjsJMwKQAeE
DHdRw0al13IIQdfDxE8Psou0mWgHov9dhxheg/JaVF2b4SqROJ4fedRLfJi0XST8
AYqyCrPwkhmbSRt87HLMkr9Oi0K5AfRBOWLAodMZ0rALxiTS/M72ZTHAgl5Lb8Y7
hRFASOBAOw973jRmROJKUyKNfvD60DtFTM/YbHSx8Zy1abr0m+RcpcCp/rJ0QZX5
B0kOtehsH4dmiEj3z/97/vCSea8VPX3K6lSMxAj1n23RnLtTD355sWRJF2P0QZi4
6/88rooFDeSj/AizKxbRg1BY5p4TmhknGAnq8whFIg9aDi8SJWdxmOg1zEs+jy+S
07vaovVTgcs4NqiaS+UQx9WY8TqwgHdWgJ3nWjOXuVUs4YkAXyi/LdhMldn0Q4X7
peN/RXN2qFiYEcsLntLztGOJJqONUw1z17jmyFuObU6BgNc2HDGDInmtr28pnGto
4jJ6OuNJSp3P14wPtph3rp5QkM8tj2keR8KoOcsBNmtgzQ5Xi50ixc+AYWysUlVb
6BTeeDS8LB3eA+EXxG/DhHB2qCW/u0a3SwECOZ5Zcbm7GE8sQfV0UWwcpoL3kpWp
w7RfbmXpO7A=
=ZlAx
-----END PGP SIGNATURE-----

--Apple-Mail=_C6B6C2E1-6D22-4B91-92AC-808ED90DC296--
