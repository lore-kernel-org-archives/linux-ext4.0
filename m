Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B29E728D2
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Sep 2023 17:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbjI2RpT (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 29 Sep 2023 13:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233410AbjI2RpR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Sep 2023 13:45:17 -0400
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85AA19F
        for <linux-ext4@vger.kernel.org>; Fri, 29 Sep 2023 10:45:15 -0700 (PDT)
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-6be515ec5d2so28115191a34.3
        for <linux-ext4@vger.kernel.org>; Fri, 29 Sep 2023 10:45:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696009515; x=1696614315;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4joDohMXuDXDS0TPuwLacimtIm3hUTJJK3majX08NFE=;
        b=t6WIX/eIPrl8AdQm4wLim5lwgLckbTsjjFYEemDrdeXQ0aMaYFVgMsHXRiHMZTjdOq
         lTG/+1Sf/Xf9468kaJU6qcNZK9k2gIYGwcE32ArWOrr7aHROOGl2PImDZmeTwgvgfEMk
         VL7JccYM5Bn+unOvj66kMsvKwuiod0NTepTR2oTUSlxq9fm7v5zPw+IBeDQlIsGHChIf
         KXrMM6L19Vi0oR80FP5F8EqY+vwKyA2aoUHlvqV2lfV8lEpUvn0zVH2GDVWCu0hTFCHb
         MkUJY/XitUj1j81ldL4bZZnG06Pkj3Hj/nqN+bdzORTCjqLVqrrpE3LTGUoU0c4zuVXB
         hjJg==
X-Gm-Message-State: AOJu0Yz1IgnbebJb0Rfg9YEx5gF18z9JThX9i448KHiS1oh1Yub2+wsL
        nysVyweujCoywNrK2KIaSat/NjpA6jiBGpGhwIHcBDpUrtoD
X-Google-Smtp-Source: AGHT+IGG8vcMAMmZ/3ADr8cay11JqakLmrgchs5navv7RcKS7i3kBH1cLAvbIvWAMrIcX/l74tp72FmMTd40JFimfKpKj5odDg0c
MIME-Version: 1.0
X-Received: by 2002:a05:6830:6b46:b0:6c0:e336:7b81 with SMTP id
 dc6-20020a0568306b4600b006c0e3367b81mr1448108otb.4.1696009515072; Fri, 29 Sep
 2023 10:45:15 -0700 (PDT)
Date:   Fri, 29 Sep 2023 10:45:15 -0700
In-Reply-To: <ZRcIdBOnpNyCQ4qh@bfoster>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ae8241060682fc8a@google.com>
Subject: Re: [syzbot] [ext4?] WARNING in ext4_iomap_begin (2)
From:   syzbot <syzbot+307da6ca5cb0d01d581a@syzkaller.appspotmail.com>
To:     bfoster@redhat.com, linux-ext4@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+307da6ca5cb0d01d581a@syzkaller.appspotmail.com

Tested on:

commit:         71e58659 Merge tag 'gpio-fixes-for-v6.6-rc4' of git://..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=176a0d01680000
kernel config:  https://syzkaller.appspot.com/x/.config?x=12da82ece7bf46f9
dashboard link: https://syzkaller.appspot.com/bug?extid=307da6ca5cb0d01d581a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=16d320b2680000

Note: testing is done by a robot and is best-effort only.
