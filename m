Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE8F19D093
	for <linux-ext4@vger.kernel.org>; Sat,  9 May 2026 12:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778329954; cv=none; b=VjkijjY4OSyVeQajRdbQIcABxLU8lm91O94Wb9Z7Ztpdw6harhr4uNxXIBy4+9nvCUjQc9i2+mogT/nj9shhE1BBlULugdlHFAwGPU0xV2RKd3lbkjM+W8zpnyiGR63vWkNUMLIO7yb7ncU7xzeRDdSGwec2AY2EAbiQOh+hddU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778329954; c=relaxed/simple;
	bh=VZtHtJPL+CmlRo0utUwLoHFxPvfs1GG5opBcxMkbnBM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=etLOYI38fKzVwpwkaKDzFLGQKL66UqsVTCBzEKMDOPGni8qnHg0BLJJZ6jnyaGpUs/hGZPT5f6ED7xzo1xKUo5ppZ9gXjM5OtEVpzMAX/LfuLKVLEShMlkCklcmva7ljl0eDBkZZ/kaOmVUQpFmkXKP+R4Ypa7ZmbslZlb0twnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7dbd60b7ecbso5615456a34.1
        for <linux-ext4@vger.kernel.org>; Sat, 09 May 2026 05:32:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778329952; x=1778934752;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BZfxlCBCsXqLC01X9BwXRre55Kj8VeyvFqC1qipPd6k=;
        b=LjsEDL+ihkqbP/B+j9mtkkBXlIknV7LmzV8ys1efTaxz7eYufh5SzHG9R94USsWvmT
         wh5of7gd6w5ltDVuWTkaDI6+2GPPYo0dw3zjmQ4YPrGVUqSvvp9Kw7cEoRlljbn2Y1Lb
         KBKK7cv7LBZhYKon3pbjpau7WCh9gD4Z0ylf+seSuDuHifEEV1e//tMW8P2zArPc09BK
         /QwdofBQYCd/tipEXRNuxtppCqAp+4Ur0yaeCqfmYbpgYL0lPOJwZ/TSun/Sj2UOze5I
         vqDHRfDsbG0StbSuifKl7V0zUQrHOYT1PjQMqPSga70ObT4EQJxklHo4/SQ14P3gGisy
         n4Vw==
X-Gm-Message-State: AOJu0YzTB33i14QEAiL5+LzRQqTP46qLIaR/g9B08XCvFd8rsdPd5Jtb
	OVZLeGu8MRwT/IPKeAMFaOVtX/dpCZApF4qE06o7MRShoN6gBH914oNyu5i9A1TyNvzV2BCLIlG
	nuPYA5qaB4FhC/n3FySUghY87oYm23Cg2XNXkttqmhgfmEKMMO1wci+zkvxs=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f034:b0:696:8e8b:2097 with SMTP id
 006d021491bc7-69998cb0d2fmr9276444eaf.21.1778329952305; Sat, 09 May 2026
 05:32:32 -0700 (PDT)
Date: Sat, 09 May 2026 05:32:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ff2960.a00a0220.1c3806.0007.GAE@google.com>
Subject: [syzbot] Monthly ext4 report (May 2026)
From: syzbot <syzbot+liste9396a8c025ba9b36a4e@syzkaller.appspotmail.com>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ext4 maintainers/developers,

This is a 31-day syzbot report for the ext4 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ext4

During the period, 4 new issues were detected and 0 were fixed.
In total, 50 issues are still open and 175 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  7887    Yes   WARNING in ext4_xattr_inode_update_ref (2)
                   https://syzkaller.appspot.com/bug?extid=76916a45d2294b551fd9
<2>  7431    Yes   KASAN: out-of-bounds Read in ext4_xattr_set_entry
                   https://syzkaller.appspot.com/bug?extid=f792df426ff0f5ceb8d1
<3>  6043    Yes   possible deadlock in ext4_writepages (2)
                   https://syzkaller.appspot.com/bug?extid=eb5b4ef634a018917f3c
<4>  3089    Yes   kernel BUG in ext4_do_writepages
                   https://syzkaller.appspot.com/bug?extid=d1da16f03614058fdc48
<5>  2985    Yes   possible deadlock in ext4_destroy_inline_data (2)
                   https://syzkaller.appspot.com/bug?extid=bb2455d02bda0b5701e3
<6>  2947    Yes   INFO: task hung in sync_inodes_sb (5)
                   https://syzkaller.appspot.com/bug?extid=30476ec1b6dc84471133
<7>  996     Yes   WARNING in ext4_xattr_inode_lookup_create
                   https://syzkaller.appspot.com/bug?extid=fe42a669c87e4a980051
<8>  723     Yes   possible deadlock in do_writepages (2)
                   https://syzkaller.appspot.com/bug?extid=756f498a88797cda9299
<9>  429     Yes   possible deadlock in ext4_evict_inode (5)
                   https://syzkaller.appspot.com/bug?extid=212e8f62790f8e0bc63b
<10> 290     Yes   kernel BUG in ext4_mb_use_inode_pa (2)
                   https://syzkaller.appspot.com/bug?extid=d79019213609e7056a19

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
