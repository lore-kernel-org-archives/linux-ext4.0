Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65603C433EF
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Mar 2022 15:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244899AbiCWPIr (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 23 Mar 2022 11:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbiCWPIq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Mar 2022 11:08:46 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A80D75E49
        for <linux-ext4@vger.kernel.org>; Wed, 23 Mar 2022 08:07:16 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id j12-20020a056e02154c00b002c81c9084b9so985159ilu.22
        for <linux-ext4@vger.kernel.org>; Wed, 23 Mar 2022 08:07:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=OCNxa9n6u0UYsSpngdxE2RzTqlLKDflz8tjBWq7Q28s=;
        b=ZoJy4jzmyHVnmOBcec+DDtO02L+MLQE/+GYUdFJgSAekMC8tQcoauCApKYnekBIbCf
         v6dxr38XSCwCLlqma0hAxfRimREq2lqLpJ35qSKMvZtNOEAObQB53s3a/iu08ieRFUwJ
         WL82KvyE4YCwfv0nabn2qKSG/9cMlK8XaZA1XVaKW8hxqolSKMzXWUpzDDsomdUpitXd
         /rClwwibz3v3dxA9gfFZeE0fhDtQ4aFRK1H28Zf5+KHzC2VovSEYFbSROLIPUJdFQgGD
         3putsnAVcmiks5w4ao78GPLeUHRvIA7d8/oH2RkWqkQtOkad1F+d+PAeTZzhR8+nLv9s
         faIA==
X-Gm-Message-State: AOAM533G7zWV8u7mEr9Ed5jb6ULqgPT+hcFWiND1TJBHtA0Ncm0fVfeK
        jj1IW2UJJ9mnoNaFMaQ5uucWEL1RiT5rvKBHRkIS3KIvl3sp
X-Google-Smtp-Source: ABdhPJws14Yfc6W/f6AeMeaXwEcAaKf4KKbckIBCk2WA1PXSi3Ym6qbtgZlUT0YzULj9ZhdyGN8lcTD2cRxHyl+/k4g7AJstdvLR
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:17c9:b0:2c7:f556:da52 with SMTP id
 z9-20020a056e0217c900b002c7f556da52mr262922ilu.96.1648048035383; Wed, 23 Mar
 2022 08:07:15 -0700 (PDT)
Date:   Wed, 23 Mar 2022 08:07:15 -0700
In-Reply-To: <00000000000079c56a05ba1c18c3@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b8cdba05dae41558@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in ext4_xattr_set_entry (4)
From:   syzbot <syzbot+4cb1e27475bf90a9b926@syzkaller.appspotmail.com>
To:     adilger.kernel@dilger.ca, cmaiolino@redhat.com,
        lczerner@redhat.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, sjc@chobot.com,
        syzkaller-bugs@googlegroups.com, tytso@mit.edu, wanjiabing@vivo.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 6e47a3cc68fc525428297a00524833361ebbb0e9
Author: Lukas Czerner <lczerner@redhat.com>
Date:   Wed Oct 27 14:18:52 2021 +0000

    ext4: get rid of super block and sbi from handle_mount_ops()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=100bc10b700000
start commit:   f8ad8187c3b5 fs/pipe: allow sendfile() to pipe again
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=96b123631a6700e9
dashboard link: https://syzkaller.appspot.com/bug?extid=4cb1e27475bf90a9b926
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11131f94d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15c3761b500000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: ext4: get rid of super block and sbi from handle_mount_ops()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
