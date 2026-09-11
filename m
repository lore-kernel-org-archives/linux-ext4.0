Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BCD2F5A0E
	for <linux-ext4@vger.kernel.org>; Fri, 11 Sep 2026 04:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789101208; cv=none; b=pckUuRv8nULjLg3SSYd3mL2C9qmnqgbs39L2tfQVamj0Q6SIl6VcTjsrIP4+/VyUVrN/YX6m8d4LX5+B7Y8xyinv5n3NHbMSszo2Uyya7Y26Kwh4Jehk36ZWENIvD8w2IOtcsIZmTA1dNUWdByK+w1hadPJyhemlnOZlc+CpF/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789101208; c=relaxed/simple;
	bh=M0vpayOJusPZNC5TxT6ZBVxJWPK9fbSc3dLYXof4CcY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=qdJDF8ZM9DUPsmNTWhnWBqnfNbDPyH9fXhZ+sC7pGgFzHH7SQMd9u4baLouDW6oLrLUGRFFoBLlK/fWt+1hi+7JyMPiymv0xcXqza732Zqb/dQ6B7fUpmvtFrQ+PrPcCMfEFG/3RFVvbuZXuRlynAHFWq9YsFnuphlysRQ3jGnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4b325074c26so987896b6e.2
        for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2026 21:33:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789101206; x=1789706006;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NhICgvIzJELQ84zwtgc/jRZJI7hwENPGveWeZp0zBhI=;
        b=HmY6YTlxUCFAnJXtDjAOZc29Zp8HvxG1VLThINev7AAip0yl1gDnp4B5TMdI/URDdo
         HBgkRoUxRKEmps+9sbn3yJAxWzRtx4/gRHnBnngEwwISW0mTY5byXxGVm9p9hqfSHc1v
         MsXUPmhCyMC5wuCgxUNzE7dDdJkXXz8UgncKISiX1aTWgPVJji0zoHXO/8OQJ8QUeGwh
         a1iZ1j929+G1A683kWzmoXXYbEk7P0KBmbsWiacbOpZSm91OXvvqssPxoS9xGJRUSvUs
         mZPaNVKVevFZgNkgjDaHqcDba9u3hduEMxPjN+M/u8TgFsoDa1/8HELBBC/9naUIbxpz
         Q16w==
X-Gm-Message-State: AFuF++lt/e4hSelx4NSoMsmWLlNhiY+XQlCwrkU+IRM5BhCS2D95/HYr
	ByQ5jBSCHu4JDQOle9Mvs/TpsQkw5c1NL+MNTxKtdoHH7aV2D8KUJrM5NXTTwfj67IdC32RGx5F
	U5C2Q0MNdxAnG5kGElBMTWEXe0mjL6YRepZicmkp8alptO94vP7OoSxlZAbk=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1849:b0:6b1:4cb:39ec with SMTP id
 006d021491bc7-6c0ba244d68mr1614687eaf.12.1789101206230; Thu, 10 Sep 2026
 21:33:26 -0700 (PDT)
Date: Thu, 10 Sep 2026 21:33:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa38496.6e6c5f9e.28f11f.003e.GAE@google.com>
Subject: [syzbot] Monthly ext4 report (Sep 2026)
From: syzbot <syzbot+listf3145eb1fa111ea03ab9@syzkaller.appspotmail.com>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ext4 maintainers/developers,

This is a 31-day syzbot report for the ext4 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ext4

During the period, 3 new issues were detected and 1 were fixed.
In total, 39 issues are still open and 184 have already been fixed.
There are also 8 low-priority issues.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  21100   Yes   possible deadlock in ext4_writepages (2)
                   https://syzkaller.appspot.com/bug?extid=eb5b4ef634a018917f3c
<2>  7962    Yes   KASAN: out-of-bounds Read in ext4_xattr_set_entry
                   https://syzkaller.appspot.com/bug?extid=f792df426ff0f5ceb8d1
<3>  4881    Yes   kernel BUG in ext4_do_writepages
                   https://syzkaller.appspot.com/bug?extid=d1da16f03614058fdc48
<4>  2502    Yes   possible deadlock in ext4_xattr_set_handle (7)
                   https://syzkaller.appspot.com/bug?extid=f0b58a1f5075a90dd9a5
<5>  228     Yes   WARNING in ext4_iomap_begin (3)
                   https://syzkaller.appspot.com/bug?extid=626aa13bf52efc3aa86e
<6>  82      Yes   WARNING in ext4_mb_load_buddy_gfp
                   https://syzkaller.appspot.com/bug?extid=fd3f70a4509fca8c265d
<7>  16      Yes   INFO: task hung in ext4_write_end
                   https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
<8>  3026    Yes   INFO: task hung in sync_inodes_sb (5)
                   https://syzkaller.appspot.com/bug?extid=30476ec1b6dc84471133
<9>  481     Yes   kernel BUG in ext4_mb_use_inode_pa (2)
                   https://syzkaller.appspot.com/bug?extid=d79019213609e7056a19
<10> 111     Yes   WARNING in ext4_journal_check_start (2)
                   https://syzkaller.appspot.com/bug?extid=b75d75f957975f3d40e3

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
