Return-Path: <SRS0=oERZ=R2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 905F2C43381
	for <linux-ext4@archiver.kernel.org>; Sat, 23 Mar 2019 07:16:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 591AA218B0
	for <linux-ext4@archiver.kernel.org>; Sat, 23 Mar 2019 07:16:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tuYtwl0s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbfCWHQt (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 23 Mar 2019 03:16:49 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:52414 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbfCWHQt (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Mar 2019 03:16:49 -0400
Received: by mail-it1-f193.google.com with SMTP id g17so6878922ita.2
        for <linux-ext4@vger.kernel.org>; Sat, 23 Mar 2019 00:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TkFN6mZO3jzTkDHV/Hmyrf49PT5DaBxkKPm0fJ0JB7Y=;
        b=tuYtwl0sHaOtGRyid88R8OtvWqz5AG2NwDMia7jT+e90eHXqDasnpyMefZi2K/GvPT
         U3on/kdx21QSFCm9IPSlvNpcSjtK8tx16vJ9ETOe9kGwfzM8dgj4KEa5QGWzR6fDe2Hn
         CTCLi3dqKZjeM2+LkTvCYoYxuGAAXc/J5EaupsrUj8NjZyS5WGNtQbhDsXuXLWHXyKMR
         TpkNS+GdHeKvgfzrJPyIV7S6gWcvbHtf1s3SRVrAEuAHBwWPLTa2EK33+iLp4pFIOIT3
         pgmJC3U1wTUXK77iRBp0EH5YVV721kW33C3zP0zreR/SgUTgd6QGmyS5pS0VGdQ7P8aj
         iEmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TkFN6mZO3jzTkDHV/Hmyrf49PT5DaBxkKPm0fJ0JB7Y=;
        b=KwoJeheqzbp5vNxkxxaorvfO9uNXFfeA1s1iZHyPYTxcmJLLqRYMqj2R3pxMJYH3y3
         gbPde4KulvVEiMQImI26dLu5oYcjMkyiBcTl2a9J2BHWwqcHeunzdbthBIYZ7Vo6d+hO
         MJcFda1lV1XZERDQp6c8sBLKnYSMhnj8E7MrWtvg0MhsVl2SeD2AouzTOWZgQLzBEm7V
         Zf/zmkdwA/KyE8o72KVQcycHjbijVh8aYZs9hWaqNcvEws/Cpf3UOQiWckr7NHCivvPa
         ZVzCsiAP5wiSuA/W6ogc4yyidcGOYj3zyL4k4kLDD8ZG/rOkazHBmHCJTODHfh91LRmm
         hFCw==
X-Gm-Message-State: APjAAAVdnXANj56Z5Qgzx/lFAfV4ZU9gGmN+Kap9UlFkwyhGlLMocdVz
        bQ9nF+M1xr+a+xAUWp/uEPjt6tTgaJVIYVGk+4vSMw==
X-Google-Smtp-Source: APXvYqwu0jZl1WMHUfwjCc8eNXQNMtRUY6cTb9zGogIf9gHJFZeSly1uN/MHdmpZevTU/Dnp0Zw/aw7coEIvqtnVR94=
X-Received: by 2002:a24:3281:: with SMTP id j123mr3898152ita.166.1553325407533;
 Sat, 23 Mar 2019 00:16:47 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000cd1e2205785951c2@google.com> <00000000000088ea3e0584b5872d@google.com>
In-Reply-To: <00000000000088ea3e0584b5872d@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sat, 23 Mar 2019 08:16:36 +0100
Message-ID: <CACT4Y+bBPvfnU4T=4ojw67FP0GBC49L2kKV+HQYxsV-DwT2b7w@mail.gmail.com>
Subject: Re: possible deadlock in __generic_file_fsync
To:     syzbot <syzbot+5cd33f0e6abe2bb3e397@syzkaller.appspotmail.com>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Mar 22, 2019 at 10:28 PM syzbot
<syzbot+5cd33f0e6abe2bb3e397@syzkaller.appspotmail.com> wrote:
>
> syzbot has bisected this bug to:
>
> commit 9022ada8ab6f1f1a932a3c93815061042e6548a5
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Fri Aug 24 20:16:36 2018 +0000
>
>      Merge branch 'for-4.19' of
> git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15330437200000
> start commit:   270b77a0 Merge tag 'drm-fixes-2018-10-20-1' of git://anong..
> git tree:       upstream
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=17330437200000
> console output: https://syzkaller.appspot.com/x/log.txt?x=13330437200000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b3f55cb3dfcc6c33
> dashboard link: https://syzkaller.appspot.com/bug?extid=5cd33f0e6abe2bb3e397
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1436fc45400000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11058e2d400000
>
> Reported-by: syzbot+5cd33f0e6abe2bb3e397@syzkaller.appspotmail.com
> Fixes: 9022ada8ab6f ("Merge branch 'for-4.19' of
> git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq")
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection



This is a lockdep-detected bug, but it is reproduced with very low probability:

testing commit 270b77a0f30e7bc61a9081b86d74dbb62fa6a69d with gcc (GCC) 8.1.0
run #0: crashed: possible deadlock in __generic_file_fsync
run #1: OK
run #2: OK
run #3: OK
run #4: OK
run #5: OK
run #6: OK
run #7: OK
run #8: OK
run #9: OK

I would expect that for lockdep it's only enough to trigger each path
involved in the deadlock once. Why is it so hard to reproduce then? Is
it something to improve in lockdep?
