Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E05CC4361B
	for <linux-ext4@archiver.kernel.org>; Thu, 10 Dec 2020 19:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B36212067C
	for <linux-ext4@archiver.kernel.org>; Thu, 10 Dec 2020 19:26:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393383AbgLJTZB (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 10 Dec 2020 14:25:01 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:35868 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393324AbgLJTYo (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Dec 2020 14:24:44 -0500
Received: by mail-io1-f69.google.com with SMTP id y197so4713402iof.3
        for <linux-ext4@vger.kernel.org>; Thu, 10 Dec 2020 11:24:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Xa0iQU8Q/C+YSjMiw9XJ96Kz4N4tah7/BH4NCXeOx4M=;
        b=a+hG1AqXPAfEu+sTBbLYY1yPFodvb1dSsJp9uRr08Al8ssLwjjlQ3+HgBe8wWj+zV+
         G5dw5Ihwr0ezlIGwNtiNbrCKpMkfvl+fSWEvK8qDofcYc0N8rkl5GqCcsPRlAZsUYfte
         p6wwtmOVjq6wY5Srl/ZzvjBKMjBRNZR2eC51LlIufSM1tXxTxJTa6I1IpDng8AKNvdPM
         KyFdnHW3xnFsNDglm+v1QgSMEBs5kdukCRPKTEDXXGN2GgUxNGJjoJUbgxvwKlO0l03U
         ez3Zrs6eZUqDUK6DQgNd0KKi4IJqOX+6x/fAPB8wcaeAsWutEd4e3HC9GcrRf1/58fiv
         XhDg==
X-Gm-Message-State: AOAM530KZfePlnIDS877r1b/rQ62KB3bsqgjeYXIMTt4Kdmoam0/vRpU
        wdSc/zQa4y+4M84cfGATL1bfqqooquOa6LGF2OQhlZzffGQ5
X-Google-Smtp-Source: ABdhPJw89+a7UPMpCsZTfxcSNJBk4rtWLQnGEptKIq8hWLFCqIinN+sPXA8GzWSfq1CEL5GO5Krtdag6Leg0Ep3Ab4QTo1ofp8+a
MIME-Version: 1.0
X-Received: by 2002:a92:d0c8:: with SMTP id y8mr10133578ila.46.1607628243790;
 Thu, 10 Dec 2020 11:24:03 -0800 (PST)
Date:   Thu, 10 Dec 2020 11:24:03 -0800
In-Reply-To: <CACT4Y+a+ZwwEup7xgfsJth-=T-o-tYNHpVc0m4ePx0fj9LBHZw@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000066f16005b6211ed2@google.com>
Subject: Re: UBSAN: shift-out-of-bounds in ext4_fill_super
From:   syzbot <syzbot+345b75652b1d24227443@syzkaller.appspotmail.com>
To:     adilger.kernel@dilger.ca, clang-built-linux@googlegroups.com,
        dvyukov@google.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, syzkaller-bugs@googlegroups.com,
        tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+345b75652b1d24227443@syzkaller.appspotmail.com

Tested on:

commit:         e360ba58 ext4: fix a memory leak of ext4_free_data
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
kernel config:  https://syzkaller.appspot.com/x/.config?x=fe9725f8845d9fe6
dashboard link: https://syzkaller.appspot.com/bug?extid=345b75652b1d24227443
compiler:       gcc (GCC) 10.1.0-syz 20200507
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1166cf17500000

Note: testing is done by a robot and is best-effort only.
