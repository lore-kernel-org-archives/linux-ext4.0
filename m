Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D57A6C433EF
	for <linux-ext4@archiver.kernel.org>; Sat,  5 Feb 2022 22:39:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380940AbiBEWjI (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 5 Feb 2022 17:39:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380757AbiBEWjI (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Feb 2022 17:39:08 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E1DC061353
        for <linux-ext4@vger.kernel.org>; Sat,  5 Feb 2022 14:39:07 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id d3-20020a92d783000000b002bdfbe72c13so1565153iln.6
        for <linux-ext4@vger.kernel.org>; Sat, 05 Feb 2022 14:39:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Up70b3+pLCOVWXRm8xQGxM6soIoNpamDU4Qviu67t6s=;
        b=Slm4kNPdWGEzTa0z8F1mSTFYoM/uHaBhhdCSh55e3y5S9/IKp2j85Q/Lh90Bf4j1DD
         Zs4S19VgzdE2kTTP84CRxCLZoyH3YcmXF5Jf9D+NMjHW35+CGj/TZipjYX0S9CqbppdM
         AkpWCEX/cooJQqKknkYhSxN+DvOSQEgZEeBZci1HvutX0hiJFShRLUgC06tjfYCPEr3P
         yIwE4s8lbOPXy1Bq20LlI6IGlFCawSYm6JpYzJPF8rCGxqRVBWu6MOwVqkxKNGRXPhl+
         Dbkktww0jehwjiEQ392EcnKmoijd10O46uDZXEhFYTSKHfYLgKqC/8Rbh/jlAcD4Qy6A
         NPxw==
X-Gm-Message-State: AOAM531mQJm/3V2ouVcC8LFNwVRC9pn0/Azy1oapB95xJbolSZuuitX4
        V5RwWFcm35u2sW7gfji23xUkS/m1pMQa+/GxUyjqHHCzERDz
X-Google-Smtp-Source: ABdhPJwhXVky5srzWBAsfF1q1R4zzGYARXATF9jvvYWrr7M3ptKfEHCqn/PdpC+3ZcIv6FBX3fauuvSw8FwpN57klvVaV++1frpl
MIME-Version: 1.0
X-Received: by 2002:a92:cda9:: with SMTP id g9mr2419625ild.29.1644100746734;
 Sat, 05 Feb 2022 14:39:06 -0800 (PST)
Date:   Sat, 05 Feb 2022 14:39:06 -0800
In-Reply-To: <0000000000001e0ba105d5c2dede@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fbf22d05d74d08fb@google.com>
Subject: Re: [syzbot] general protection fault in ext4_fill_super
From:   syzbot <syzbot+138c9e58e3cb22eae3b4@syzkaller.appspotmail.com>
To:     adilger.kernel@dilger.ca, cmaiolino@redhat.com,
        lczerner@redhat.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        nathan@kernel.org, ndesaulniers@google.com,
        syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

syzbot has bisected this issue to:

commit cebe85d570cf84804e848332d6721bc9e5300e07
Author: Lukas Czerner <lczerner@redhat.com>
Date:   Wed Oct 27 14:18:56 2021 +0000

    ext4: switch to the new mount api

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14902978700000
start commit:   0457e5153e0e Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16902978700000
console output: https://syzkaller.appspot.com/x/log.txt?x=12902978700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cd57c0f940a9a1ec
dashboard link: https://syzkaller.appspot.com/bug?extid=138c9e58e3cb22eae3b4
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17f7004fb00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=178cf108700000

Reported-by: syzbot+138c9e58e3cb22eae3b4@syzkaller.appspotmail.com
Fixes: cebe85d570cf ("ext4: switch to the new mount api")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
