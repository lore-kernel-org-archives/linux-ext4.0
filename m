Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E977DC32789
	for <linux-ext4@archiver.kernel.org>; Tue, 23 Aug 2022 17:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbiHWRxE (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 23 Aug 2022 13:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbiHWRwo (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Aug 2022 13:52:44 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E706D555
        for <linux-ext4@vger.kernel.org>; Tue, 23 Aug 2022 08:54:12 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id l20-20020a056e02067400b002dfa7256498so10765999ilt.4
        for <linux-ext4@vger.kernel.org>; Tue, 23 Aug 2022 08:54:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc;
        bh=YORKRMrGh1zHmTJn3Q8vpb+7xewfCJwmWBrDZuO9Hvk=;
        b=TB7HBREpwu6Y8SI8AF9LrYn/4kzE04q/DQa2i/Xj0GM6KncmYhkH7bb+63OgFHv8VA
         n0KAx1npCWLBb5RXLPOBMl2JsXXmK62DZmExE/qQWn/eOG0jnG/HtosC+QdysZm2V5/w
         OHKf+pcBVH3g8HNx86JNY4aN5PlzvX0TXykjR4cnuWoxJ+h0ZCy1/r4gAPJH+PK81lhN
         MjxXncr8IWigCihwylgN5GPWK18d9pHHmPptoQVJwt9VIphktFfl8bBZqhGwmJvr9fFJ
         aENtCqg9gZYus3TaT36wEZQ5OSDDTOEswRPwRYsoEvYNjFkSNes0GzS9Q4ScEYEXMN6z
         BiFQ==
X-Gm-Message-State: ACgBeo1AUHQxorxBr6HWKcF2Mn4zb+GKAN26/ciMEytUb3lbSe/1bcWG
        y7zoB+ncGxRtJfGmKmXcHQ4PP7WAmnsQPLub02Tu1PSaNgjX
X-Google-Smtp-Source: AA6agR7DlJVunae3GLR7JIa5CdMoF6d825J9cnKYadOmoeVZl/kMpo9A6rnXBwiLn6b23Z3kvfFODw1snEpilyS3FSBFHKm/eGjF
MIME-Version: 1.0
X-Received: by 2002:a05:6638:4197:b0:349:fc58:d66a with SMTP id
 az23-20020a056638419700b00349fc58d66amr873003jab.101.1661270052061; Tue, 23
 Aug 2022 08:54:12 -0700 (PDT)
Date:   Tue, 23 Aug 2022 08:54:11 -0700
In-Reply-To: <20220823153542.177799-1-code@siddh.me>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000054488105e6ea93c8@google.com>
Subject: Re: [syzbot] WARNING in iomap_iter
From:   syzbot <syzbot+a8e049cd3abd342936b6@syzkaller.appspotmail.com>
To:     code@siddh.me, david@fromorbit.com, djwong@kernel.org,
        fgheet255t@gmail.com, hch@infradead.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        riteshh@linux.ibm.com, syzkaller-bugs@googlegroups.com,
        willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+a8e049cd3abd342936b6@syzkaller.appspotmail.com

Tested on:

commit:         072e5135 Merge tag 'nfs-for-5.20-2' of git://git.linux..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=123599b5080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3f885f57a0f25c38
dashboard link: https://syzkaller.appspot.com/bug?extid=a8e049cd3abd342936b6
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=160ef0a3080000

Note: testing is done by a robot and is best-effort only.
