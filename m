Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CEB35B64E
	for <linux-ext4@vger.kernel.org>; Wed,  8 Apr 2026 06:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775630674; cv=none; b=g3VSmiOrgnuBnrT4LCEVeQbH8ud7yvpKrbRfwNHVgwOcliryCE9ZVPWoGVCsDKt6F2QZ9l0/2gY+P83p5RTjbZt4t2kkNqioqD76UGfdWeo8/mCM3t6tG88Rm/D3yOk0lzQXo5aaxsXH05yTyPAKV/xgi8w16wXifjqgHryzfpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775630674; c=relaxed/simple;
	bh=CVVBeDbV8zvlupMyaYMfUQ897oynGr9TrCQ9lAI5WKM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ETxZITqd8cMDwWURcE3eg+TGPQMMY3eqPlYG20n/feUCDjtNEYUYHnuimDJCGZ7mzI+iLQdJj9+DP9NE07a9Py1T68yuHEymRHku6gYlw5rfSpHV4X0BDHQifJ1fYUDZmRcwIRFRqCRa0zk400VqabjDUgodK6DdypkYE7sMJMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7d4c7afa9e0so13874651a34.0
        for <linux-ext4@vger.kernel.org>; Tue, 07 Apr 2026 23:44:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775630672; x=1776235472;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xwnt5Mr4/oqMLIxaguav9PJNNfbmeKc0Nb29a6/ZsPY=;
        b=nPbmkdmrrWhxUbI0XZkSNs+XnadzgVlXvVJRIYgB1bcKuLTbOKlZDX44Me4P91ozJe
         tnSVaFufzlxmbbhq60KFmi2eylD9GYWsOKBDvWAxnB6lrPt/77RQOkSLTlwVlZb41zAJ
         +wXp4fbjhuN89lncM7QT7EFOw3G7ppYd+V90OTQRVxR72xPcStlBM7z+IIaRv3tXWH+m
         wXipn7SkaCYxyJ0W2XnT4ae1wbK8bo5sC58wkHiuBVnhr8mmNlruv1qEYAXbuoesYb54
         pLNOc+c6D/9Sshm3x0a+/5Fw7vN3D1sCbX8Nf400e0MJHU3pU+1JHR96xUI117RPj10Y
         YjNw==
X-Gm-Message-State: AOJu0Yy5hddp6ZybxApymejsum1S2jWeWTfnMh4jeWu8rPnKegT3aScl
	hguFltexohXQviFY78BfSrHfuVC2Lwq2TAGHRZcCfdcc0MK7t33KASlYV+iNAn70RITfPkM3luu
	DLwrrhJcMPuV/nqrrMq1eiI5LfA3R81eL0jvFc9C9+J5AvpbPSM8nq96kCOI=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:210d:b0:67e:33a2:5963 with SMTP id
 006d021491bc7-6821d33c707mr11026653eaf.15.1775630671781; Tue, 07 Apr 2026
 23:44:31 -0700 (PDT)
Date: Tue, 07 Apr 2026 23:44:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69d5f94f.a00a0220.468cb.0007.GAE@google.com>
Subject: [syzbot] Monthly ext4 report (Apr 2026)
From: syzbot <syzbot+listedd41b7869cfdcd57096@syzkaller.appspotmail.com>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ext4 maintainers/developers,

This is a 31-day syzbot report for the ext4 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ext4

During the period, 0 new issues were detected and 2 were fixed.
In total, 49 issues are still open and 175 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  7355    Yes   KASAN: out-of-bounds Read in ext4_xattr_set_entry
                   https://syzkaller.appspot.com/bug?extid=f792df426ff0f5ceb8d1
<2>  6598    Yes   WARNING in ext4_xattr_inode_update_ref (2)
                   https://syzkaller.appspot.com/bug?extid=76916a45d2294b551fd9
<3>  5264    Yes   possible deadlock in ext4_writepages (2)
                   https://syzkaller.appspot.com/bug?extid=eb5b4ef634a018917f3c
<4>  3018    Yes   kernel BUG in ext4_do_writepages
                   https://syzkaller.appspot.com/bug?extid=d1da16f03614058fdc48
<5>  2945    Yes   INFO: task hung in sync_inodes_sb (5)
                   https://syzkaller.appspot.com/bug?extid=30476ec1b6dc84471133
<6>  2495    Yes   possible deadlock in ext4_destroy_inline_data (2)
                   https://syzkaller.appspot.com/bug?extid=bb2455d02bda0b5701e3
<7>  2178    Yes   INFO: task hung in jbd2_journal_commit_transaction (5)
                   https://syzkaller.appspot.com/bug?extid=3071bdd0a9953bc0d177
<8>  994     Yes   WARNING in ext4_xattr_inode_lookup_create
                   https://syzkaller.appspot.com/bug?extid=fe42a669c87e4a980051
<9>  658     Yes   possible deadlock in do_writepages (2)
                   https://syzkaller.appspot.com/bug?extid=756f498a88797cda9299
<10> 464     Yes   INFO: task hung in do_get_write_access (3)
                   https://syzkaller.appspot.com/bug?extid=e7c786ece54bad9d1e43

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
