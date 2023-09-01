Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF98CA0FE2
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Sep 2023 00:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347914AbjIAACo (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 31 Aug 2023 20:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242636AbjIAACn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Aug 2023 20:02:43 -0400
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8A2E6A
        for <linux-ext4@vger.kernel.org>; Thu, 31 Aug 2023 17:02:40 -0700 (PDT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-68a3de043b7so1765704b3a.2
        for <linux-ext4@vger.kernel.org>; Thu, 31 Aug 2023 17:02:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693526560; x=1694131360;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CPKlspD/ZSfWixUM8SglUnOrdGxitKBWwWP9lEY6reA=;
        b=Xjhoxvshhof2ZREKJ5f/lh39UcoLXN2UsdniT+ERqwzw34mKNdaQ2mXYm214SVINz9
         yaA/FYjDOSU6gFCmYZo7akb8eIED0R2PNjn6coKihJxxSsaVlgdbNFeTHwYF7UCS4tEJ
         ETGN0AkQf5P68w9Span/QNyy+fkOTt19yIEuEK6egtA1vKfqw2/pJ+8BVIGm3xJ0RBb0
         R8QjwdRFIdR/mW0NgsDFHi9GZS+VSRg4EPrCVxRJC3BM9CZjVECJlpgZd/8FlObW6r7o
         sqPODh6cUtHqwU1C+BsSd7nKNPOxAcpFz7PrWUYdDpOAngfC7g990A1ryU9CQD7sqTTN
         u7MA==
X-Gm-Message-State: AOJu0YyoQUI6aXPMspwKMBQAdvWErf1/sI2ofWmXNxR9a6U8klpnI8S6
        zQUdO2HTZKzAaVy3LIZeNcQ4yKynMEvPGV/oEQ6jQyUzj2En
X-Google-Smtp-Source: AGHT+IF+ylw0gT3Xy8SIJAWdbbDdmlrV0uN6kdH1gZ0c/ju+uaTJHsJ1wYGaUsKA9q1rW1f2+12UZds3LPTrzy/vmrF/i5inWBLj
MIME-Version: 1.0
X-Received: by 2002:a05:6a00:2d96:b0:68a:3762:72c3 with SMTP id
 fb22-20020a056a002d9600b0068a376272c3mr509835pfb.0.1693526560157; Thu, 31 Aug
 2023 17:02:40 -0700 (PDT)
Date:   Thu, 31 Aug 2023 17:02:40 -0700
In-Reply-To: <0000000000006fd14305f00bdc84@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000093820060440e1c5@google.com>
Subject: Re: [syzbot] kernel BUG in ext4_do_writepages
From:   syzbot <syzbot+d1da16f03614058fdc48@syzkaller.appspotmail.com>
To:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This bug is marked as fixed by commit:
ext4: fix race condition between buffer write and page_mkwrite

But I can't find it in the tested trees[1] for more than 90 days.
Is it a correct commit? Please update it by replying:

#syz fix: exact-commit-title

Until then the bug is still considered open and new crashes with
the same signature are ignored.

Kernel: Linux
Dashboard link: https://syzkaller.appspot.com/bug?extid=d1da16f03614058fdc48

---
[1] I expect the commit to be present in:

1. for-kernelci branch of
git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git

2. master branch of
git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

3. master branch of
git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

4. main branch of
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git

The full list of 9 trees can be found at
https://syzkaller.appspot.com/upstream/repos
