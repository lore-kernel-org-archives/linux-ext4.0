Return-Path: <SRS0=JWMb=RZ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8B08C43381
	for <linux-ext4@archiver.kernel.org>; Fri, 22 Mar 2019 21:28:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 800E321900
	for <linux-ext4@archiver.kernel.org>; Fri, 22 Mar 2019 21:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbfCVV2C (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 22 Mar 2019 17:28:02 -0400
Received: from mail-it1-f200.google.com ([209.85.166.200]:33306 "EHLO
        mail-it1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfCVV2C (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Mar 2019 17:28:02 -0400
Received: by mail-it1-f200.google.com with SMTP id a184so4004513itc.0
        for <linux-ext4@vger.kernel.org>; Fri, 22 Mar 2019 14:28:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=INpl/ImInpVvjNg6VwEIcNPDm6BB2I+j6XhGbJu9JZM=;
        b=lPIf0WGHWohjrxqoFsZ+XahK7agy560VZPj/4Qm+W4IBCeVclUyn901xi4S48GvZwh
         WeHpL3wwju93MeHxKF9O4aK5VuWxbeVLPaq4y7QlPFIePR8ciUmRWi1n6cmLUUx8F0Nb
         QoEPE/lpK2TAYJUxiB7wy+14ATGVBsu0S1JBv1OqgNna0zEvsFrjdAEx0NiZXR0JX5Dy
         p4WdPwupMYSS6cTKQyzNb1cx/YHFDUkWemIfNQG69CGtHhnkBdpOCYLb/h3W84wQWPFL
         aelFk9SmYoSGBpFJ6a2I6Ty5PYVey6Gm4Gc+WIsR6LPz9FHKU0imYeSVNk4AabiOag6R
         lVQg==
X-Gm-Message-State: APjAAAWoHO4PpGn9EoYpPmgKlNnFr7xGAAI6sjfeyJv6znV9IR92ENbu
        Jigs7WA1kObxhNKTBjsqexevWRzD6Fp2pDqYiM1Ii3+uHEhj
X-Google-Smtp-Source: APXvYqwVb9A5zyH076xjfKH6jANX5aTwiLOj7SbypYsinLvTB/jSN5NNa+XCnr57mt6sD2F849iSWjBJOYF/V7SU/hZ7lYJPkAms
MIME-Version: 1.0
X-Received: by 2002:a02:f8b:: with SMTP id 11mr9069901jao.53.1553290081395;
 Fri, 22 Mar 2019 14:28:01 -0700 (PDT)
Date:   Fri, 22 Mar 2019 14:28:01 -0700
In-Reply-To: <000000000000cd1e2205785951c2@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000088ea3e0584b5872d@google.com>
Subject: Re: possible deadlock in __generic_file_fsync
From:   syzbot <syzbot+5cd33f0e6abe2bb3e397@syzkaller.appspotmail.com>
To:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org,
        tytso@mit.edu, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

syzbot has bisected this bug to:

commit 9022ada8ab6f1f1a932a3c93815061042e6548a5
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Aug 24 20:16:36 2018 +0000

     Merge branch 'for-4.19' of  
git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15330437200000
start commit:   270b77a0 Merge tag 'drm-fixes-2018-10-20-1' of git://anong..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=17330437200000
console output: https://syzkaller.appspot.com/x/log.txt?x=13330437200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b3f55cb3dfcc6c33
dashboard link: https://syzkaller.appspot.com/bug?extid=5cd33f0e6abe2bb3e397
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1436fc45400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11058e2d400000

Reported-by: syzbot+5cd33f0e6abe2bb3e397@syzkaller.appspotmail.com
Fixes: 9022ada8ab6f ("Merge branch 'for-4.19' of  
git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
