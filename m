Return-Path: <SRS0=GcgC=RC=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1AE2C43381
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Feb 2019 09:59:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF285205F4
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Feb 2019 09:59:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kzcdXrKd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729860AbfB0J7D (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 27 Feb 2019 04:59:03 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:39658 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729341AbfB0J7D (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Feb 2019 04:59:03 -0500
Received: by mail-it1-f193.google.com with SMTP id l15so8956971iti.4
        for <linux-ext4@vger.kernel.org>; Wed, 27 Feb 2019 01:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=IOXtnxKwJD/kSMBqEz70PSiNhFPnIQhhJlaCfw9Hv8I=;
        b=kzcdXrKd7kQZJIlkQOYpHgrjHD8FgytJ+CCuIsEI/pN8VszbuDmOKSOuI02r1vCQj0
         JRqUU7JF9uRQRK4YFvhf8K2mmjiyZHYHMAx4c8yPcg38S3FM7/KvAt2owphLc4UR67QC
         P56qmCX4I+zhuzkBQvP3bnxfy8ArrlQK5UkYhB8kfwjJA6Ulxj4uTd3s0JACSJUl83gK
         M6ts8hVAFlYTTvRPN8UeQ57vkVMWHXrWCGKlvl5DWJ1AuQT9YH7hmt5ASu48mcq26sOm
         KrdS/nE6uJUz0sI7cjftQU7Fsqd2aeWb2I4gwaiLheG3Di9zDVaYRs0qjCmmUw/QSrUA
         fGqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=IOXtnxKwJD/kSMBqEz70PSiNhFPnIQhhJlaCfw9Hv8I=;
        b=qfoq3XXqKiUgzXIdp0Ee1ju5kVU/wpFYk8RlJ5Ad0oUrUqTCkk9FPAjIOcUugbz1Kx
         caLIqhFsB/SBd61k2f1slwxRfhclHlhp0k7myfoDJfcB0nEI13OpkUj8iksgm5ooXNTy
         ljzdxEsefa95s144ie+ac6vDmiMs94NsFppylR3p/tp+cBaUjtkSt3TQfCAN5ocqJgXr
         DPkgBgqQkKfd7ntRCWzmisawbRkQQOWpgovea8X4BQKMJF/LqOLgKhRcaqMYm5BSF34q
         8egAGB4vPU9n3+hhzibJ69AD/mrBSnkNEP0FnP62RXA94ZMTFmgzPQDFOwAkzlu5fN8f
         dviw==
X-Gm-Message-State: AHQUAua3R8gpl8VeO3dJ3Ugi30NpJds1ZnP74xGVWnfn8+g6/jLNviJ5
        StYM1IBY1PFuMmWuPuGVJkYYuTK8xSc1+Pw9LNsG/Q==
X-Google-Smtp-Source: AHgI3IaXg6Xu/hRy9skwKUWnTYZwov3yDyNffcxV3u+mnjZ9+GRmlj5bDMesC3QBqQrhk4DT5b4SMVcuEjmnAqIssic=
X-Received: by 2002:a02:4985:: with SMTP id p5mr743685jad.35.1551261542048;
 Wed, 27 Feb 2019 01:59:02 -0800 (PST)
MIME-Version: 1.0
References: <0000000000009a01370582c6772a@google.com> <20190226151738.GA6430@mit.edu>
In-Reply-To: <20190226151738.GA6430@mit.edu>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 27 Feb 2019 10:58:50 +0100
Message-ID: <CACT4Y+acnJnZ4rN3Ta-6ftFv4A=1q7hsVQSVJeh9PGCK0e4BbA@mail.gmail.com>
Subject: Re: INFO: rcu detected stall in ext4_file_write_iter
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        syzbot <syzbot+7d19c5fe6a3f1161abb7@syzkaller.appspotmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Feb 26, 2019 at 4:17 PM Theodore Y. Ts'o <tytso@mit.edu> wrote:
>
> TL;DR: This doesn't appear to be ext4 specific, and seems to involve
> an unholy combination of the perf_event_open(2) and sendfile(2) system
> calls.
>
> On Mon, Feb 25, 2019 at 10:50:05PM -0800, syzbot wrote:
> > syzbot found the following crash on:
> >
> > HEAD commit:    8a61716ff2ab Merge tag 'ceph-for-5.0-rc8' of git://github...
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=161b71d4c00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=7132344728e7ec3f
> > dashboard link: https://syzkaller.appspot.com/bug?extid=7d19c5fe6a3f1161abb7
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=103908f8c00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=105e5cd0c00000
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+7d19c5fe6a3f1161abb7@syzkaller.appspotmail.com
> >
> > audit: type=1400 audit(1550814986.750:36): avc:  denied  { map } for
> > pid=8058 comm="syz-executor004" path="/root/syz-executor004991115"
> > dev="sda1" ino=1426 scontext=unconfined_u:system_r:insmod_t:s0-s0:c0.c1023
> > tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file permissive=1
> > hrtimer: interrupt took 42841 ns
> > rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> > rcu:  (detected by 1, t=10502 jiffies, g=5873, q=2)
> > rcu: All QSes seen, last rcu_preempt kthread activity 10502
> > (4295059997-4295049495), jiffies_till_next_fqs=1, root ->qsmask 0x0
> > syz-executor004 R  running task    26448  8069   8060 0x00000000
>
> This particular repro seems to induce similar failures when I tried it
> with xfs and btrfs as well as ext4.
>
> The repro seems to involve the perf_event_open(2) and sendfile(2)
> system calls, and killing the process which is performing the
> sendfile(2).  The repro also uses the sched_setattr(2) system call,
> but when I commented it out, the failure still happened, so this
> appears to be another case of "Syzkaller?  We don't need to bug
> developers with a minimal test case!  Open source developers are a
> free unlimited resource, after all!"  :-)
>
> Commenting out the perf_event_open(2) does seem to make the problem go
> away.
>
> Since there are zillions of ways to self-DOS a Linux server without
> having to resert to exotic combination of system calls, this isn't
> something I'm going to prioritize for myself, but I'm hoping someone
> else has time and curiosity.

Peter, Ingo, do you have any updates on the
perf_event_open/sched_setattr stalls? This bug cause assorted hangs
throughout kernel and so is nasty.

syzkaller tries to remove all syscalls from reproducers one-by-one.
Somehow without sched_setattr the hang did not reproduce (a bunch of
repros have perf_event_open+sched_setattr so somehow they seem to be
related). Kernel is not as simple as a single-threaded deterministic
fully-reproducible user-space xml parsing library, more (almost all)
aspects are flaky and non-deterministic and thus require more human
intelligence. But even with perfect repros machines still won't be
able to tell in all cases that even though the hang happened in ext4
code, the root cause is actually another scheduler-related system
call. So thanks for looking into this.
