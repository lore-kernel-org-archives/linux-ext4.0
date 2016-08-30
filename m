From: Anatoly Pugachev <matorola@gmail.com>
Subject: [sparc64] sigbus in e2fsck
Date: Tue, 30 Aug 2016 15:42:20 +0300
Message-ID: <CADxRZqwws+5t-hjO=70yP84p4+1_YYZO5ER3-=faFh1JbWjTeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: debian-sparc <debian-sparc@lists.debian.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ua0-f178.google.com ([209.85.217.178]:32968 "EHLO
        mail-ua0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757333AbcH3MmW (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Aug 2016 08:42:22 -0400
Received: by mail-ua0-f178.google.com with SMTP id l94so30044084ual.0
        for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2016 05:42:21 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello!

I'm getting SIGBUS (unaligned access?) in fsck.ext4 / e2fsck running
on debian sparc64 sid/unstable linux:

root@ttip:/home/mator/e2fsprogs# git describe
v1.43.1-14-g9a23fa8
root@ttip:/home/mator/e2fsprogs# git remote -v
origin  git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git (fetch)
root@ttip:/home/mator/e2fsprogs/build/e2fsck# gdb -q
(gdb) file ./e2fsck
Reading symbols from ./e2fsck...done.
(gdb) set args /dev/vdiskc2
(gdb) run
Starting program: /home/mator/e2fsprogs/build/e2fsck/e2fsck /dev/vdiskc2
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/sparc64-linux-gnu/libthread_db.so.1".
e2fsck 1.43.1 (08-Jun-2016)
/dev/vdiskc2: recovering journal

Program received signal SIGBUS, Bus error.
0x0000000000142f54 in scan_revoke_records (journal=0x2decd0,
bh=0x2e9b70, sequence=36855, info=0x7feffffef68) at
../../e2fsck/recovery.c:866
866                             blocknr = ext2fs_be64_to_cpu(* ((__u64
*) (bh->b_data+offset)));
(gdb) bt
#0  0x0000000000142f54 in scan_revoke_records (journal=0x2decd0,
bh=0x2e9b70, sequence=36855, info=0x7feffffef68) at
../../e2fsck/recovery.c:866
#1  0x0000000000142bf8 in do_one_pass (journal=0x2decd0,
info=0x7feffffef68, pass=PASS_REVOKE) at ../../e2fsck/recovery.c:767
#2  0x0000000000141c54 in journal_recover (journal=0x2decd0) at
../../e2fsck/recovery.c:273
#3  0x0000000000139570 in recover_ext3_journal (ctx=0x2d1000) at
../../e2fsck/journal.c:940
#4  0x0000000000139750 in e2fsck_run_ext3_journal (ctx=0x2d1000) at
../../e2fsck/journal.c:978
#5  0x00000000001152d0 in main (argc=2, argv=0x7fefffff6e8) at
../../e2fsck/unix.c:1678
(gdb)

It should be the same sigbus which I have on debian boot (log cut):

[952000.246726] sunvnet: eth0: PORT ( remote-mac 00:14:4f:f8:38:39 )
Begin: Loading essential drivers ... done.
Begin: Running /scripts/init-premount ... done.
Begin: Mounting root file system ... Begin: Running /scripts/local-top ... done.
Begin: Running /scripts/local-premount ... done.
Begin: Will now check root file system ... fsck from util-linux 2.28.1
[/sbin/fsck.ext4 (1) -- /dev/vdiska2] fsck.ext4 -a -C0 /dev/vdiska2
/dev/vdiska2: recovering journal
Signal (10) SIGBUS si_code=BUS_ADRALN fault addr=0x10000164a8c
fsck.ext4(+0x313f0)[0x100000313f0]
fsck exited with status code 8
done.
Warning: File system check failed but did not detect errors
[952005.583237] EXT4-fs (vdiska2): INFO: recovery required on readonly
filesystem
[952005.583350] EXT4-fs (vdiska2): write access will be enabled during recovery
[952005.666515] EXT4-fs (vdiska2): recovery complete
[952005.680055] EXT4-fs (vdiska2): mounted filesystem with ordered
data mode. Opts: (null)
done.
Begin: Running /scripts/local-bottom ... done.
Begin: Running /scripts/init-bottom ... done.
[952005.743934] ip_tables: (C) 2000-2006 Netfilter Core Team
