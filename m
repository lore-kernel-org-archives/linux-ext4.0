Return-Path: <SRS0=tfh/=RD=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E9CC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Feb 2019 09:34:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3A672171F
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Feb 2019 09:34:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tt/IhnnT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732160AbfB1Jem (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 28 Feb 2019 04:34:42 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:36960 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbfB1Jel (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Feb 2019 04:34:41 -0500
Received: by mail-io1-f68.google.com with SMTP id v10so16066145iop.4
        for <linux-ext4@vger.kernel.org>; Thu, 28 Feb 2019 01:34:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=nKotgps3dNTeWXxoCTNOk7PR/4UzeovGKyvC/PglSYo=;
        b=tt/IhnnTtsSLg0QDVee45lFT4pOMGGRtyYA91xKR+yZG0pyHzwmqrTUl1SJUqRy5eC
         myKCzvorwfSAtK8grZBNp/lsZo7RrBw73llQFYdEk7ocYMVbyb2z/pDkTBx1a0DY6O6D
         hxJrBDnOvEnpD5bPTej+t0zX2r7Vx8c6WpV+L/8p1hXwUKQZNYOFNlvnfQ8A5uhoEHst
         MYxWXPJVNH/2M/o0+/Py3VkmQahNM8NYgVElp4DMicR9tC9mHNRahWgV3fWMhZyVjlaU
         MJ5/D9MY4HkarSBGhDtiTJoltVP7atDpycM+eaTQ8vzijqon0xZyGAQhCoyg9I9N2x+D
         iSZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=nKotgps3dNTeWXxoCTNOk7PR/4UzeovGKyvC/PglSYo=;
        b=Tl25stNgWY+L2x5lt+GXUbJGTXuvT8EdMb9TtnkrCvISWk2cZMCBkTm1v1inGtI4L9
         ydK/ti7J/ATs5lxuTkszJnybkdwJAtxEIS030/NzYjVoBnEH/XG0qdEoDBLEyCrZjASB
         t3jBir/wD3T8tHqD9RYqN7APdZkNuei/Tv4//hrtA9vk6BxXc6jAB/sl8Xmdfkfxa75J
         u/R3XEjkNNT7byeTHRzXSGyiFhRchRmAUIVpsC76PJZtgJornANlxUSghXBBZp6L9g+9
         5e3Ft1Hadc/0kEnSKqZiOBGTr6YioRjyp8dqRU0VG0dTgp36J5KCXxDdo+WLGngz+Il2
         lq4Q==
X-Gm-Message-State: APjAAAUW+ab3GJ1o//qzi7+Lw1jzxcM3x8LdUWhjzhbDX5MD+QX8VaSm
        m/LH0VeU8a+HsnlD4XcS9eD+9vWij84F7WlHxrY1lQ==
X-Google-Smtp-Source: APXvYqz27RCLQermokAxQHX6FmAP6sl1nzwe0aHtdTeEjKFi/mMldbYViDLGXx4chOWAcNw5veVsYxl/dbfawUJf6Zw=
X-Received: by 2002:a5d:84c3:: with SMTP id z3mr4692780ior.11.1551346480461;
 Thu, 28 Feb 2019 01:34:40 -0800 (PST)
MIME-Version: 1.0
References: <0000000000009a01370582c6772a@google.com> <20190226151738.GA6430@mit.edu>
 <CACT4Y+acnJnZ4rN3Ta-6ftFv4A=1q7hsVQSVJeh9PGCK0e4BbA@mail.gmail.com> <20190227215755.GD10828@mit.edu>
In-Reply-To: <20190227215755.GD10828@mit.edu>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 28 Feb 2019 10:34:29 +0100
Message-ID: <CACT4Y+Z=7+UZk9cxOaGC9B-=U=YsKj9AWyOYZKBGpZZSPdU9mg@mail.gmail.com>
Subject: Re: INFO: rcu detected stall in ext4_file_write_iter
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Dmitry Vyukov <dvyukov@google.com>,
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

On Wed, Feb 27, 2019 at 10:58 PM Theodore Y. Ts'o <tytso@mit.edu> wrote:
>
> On Wed, Feb 27, 2019 at 10:58:50AM +0100, Dmitry Vyukov wrote:
> > Peter, Ingo, do you have any updates on the
> > perf_event_open/sched_setattr stalls? This bug cause assorted hangs
> > throughout kernel and so is nasty.
> >
> > syzkaller tries to remove all syscalls from reproducers one-by-one.
> > Somehow without sched_setattr the hang did not reproduce (a bunch of
> > repros have perf_event_open+sched_setattr so somehow they seem to be
> > related)
>
> FWIW, at least for me, the repro.c with sched_setattr commented out
> (see the repro.c attached to a message[1] earlier in the thread) it
> was reproducing reliably on a 2 CPU, 2 GB memory KVM using the
> ext4.git tree (dev branch, 5.0-rc3 plus ext4 commits for the next
> merge window) using a Debian stable-based VM[2].
>
> [1] https://groups.google.com/d/msg/syzkaller-bugs/ByPpM3WZw1s/li7SsaEyAgAJ
> [2] https://mirrors.edge.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests/root_fs.img.amd64
>
> > But even with perfect repros machines still won't be
> > able to tell in all cases that even though the hang happened in ext4
> > code, the root cause is actually another scheduler-related system
> > call. So thanks for looking into this.
>
> To be clear, there was *not* a scheduler-related system call in the
> repro.c I was playing with (see [2]); just perf_event_open(2) and
> sendfile(2).

Let me correct the statement then:

But even with perfect repros machines still won't be able to tell in
all cases that even though the hang happened in ext4 code, the root
cause is actually another perf-related system call. So thanks for
looking into this.
