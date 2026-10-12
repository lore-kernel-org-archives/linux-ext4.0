Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688A034AB14
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 04:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791779611; cv=none; b=l473GLJIoya4dGdEfDaBs5Oza/6pD0P8pTlgCaSkDgJP5JMmTx/lWCfkMBawTlt5Wbez5GNNPTpd36eIhrwVXrwfvBzNZFSGJ8n7BcGdg9Qzb8m2m6ULXtlz9moVk4vnISUAfZz5MWlkNJ290aPwv5ThZrzGGQWazb2NNiUx8kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791779611; c=relaxed/simple;
	bh=FVufC84ZVzl1TKa7/0P8wcTzLCOhKrh1XiephzjRhd8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=I9aozbVcz7w3SQvzRis8UgteDsTQZxSlroox3HNCCsTM0R3XUm47EezKCLMkVdGHyGQtmIm1X+XdtBILLYKkhfRC/gw+Y6hluMxDqjSJp2p+nz1joOBxrcd5Lku8qqJ2y+pkLPySaqM2nzKhVWzJ2jGQm8gh5cuczaBhKKMqm1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4b38ea4c6acso1318639b6e.1
        for <linux-ext4@vger.kernel.org>; Sun, 11 Oct 2026 21:33:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791779608; x=1792384408;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0G0E8OhRGy648DN5LKROx9KakNCqwu+0fkernSUHaGQ=;
        b=RKSJMVvuIkmUXsKaw2a/0O/WdC6IgxgRRmZuZO87ccnFzAEgkBkGZz83LGX094ToHI
         7P2BZMg01rlE7iNdOzBL2RWDr9IeiKOAebwpL4ySGN8k3qzlYi9cNflFPNnP0VV1dX4f
         9SyBsG8J/+lBZKq91KZSxIsm9AfVjUF6qzeNLun6Oml+nFkzp8sjAo+xyuHc1rjpWNQJ
         Xhh7fxPb9tTRN/nADffU3lHTJjH3Wesx4Xnx0PvJFdXsrODXbFcKStwykXAwaIWiGf8e
         8q3RvjYR+VwTW/AoiXyYhz8fBrnt4U9DJfvYMSENNSCCwg+EQYl+SCevzzIoQAFXqj+D
         6T1Q==
X-Gm-Message-State: AFq9FYJ7i8luOEYrWsyweTNIT4kRXchXLAhkDnlSY2sPxDr8TL1NXMdc
	ifnTxQ+7tK+VgUOTkHDPAcmSadFJEClc7hGQNkhSM73tUphkLWVLmFgBSVV0GPg873R3obec+2S
	NJgEmZRHcWvncdesD8OprBxV/q6gbE+z08TITq+8E7OgnPKxfO3iGY0yIQWo=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:ec2:b0:4f3:e133:c574 with SMTP id
 5614622812f47-50c4e683233mr6811203b6e.19.1791779608245; Sun, 11 Oct 2026
 21:33:28 -0700 (PDT)
Date: Sun, 11 Oct 2026 21:33:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6acc6318.a150a118.27e199.0042.GAE@google.com>
Subject: [syzbot] Monthly ext4 report (Oct 2026)
From: syzbot <syzbot+list147f02f2e5f25940476c@syzkaller.appspotmail.com>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ext4 maintainers/developers,

This is a 31-day syzbot report for the ext4 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ext4

During the period, 2 new issues were detected and 1 were fixed.
In total, 36 issues are still open and 186 have already been fixed.
There are also 9 low-priority issues.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 8084    Yes   KASAN: out-of-bounds Read in ext4_xattr_set_entry
                  https://syzkaller.appspot.com/bug?extid=f792df426ff0f5ceb8d1
<2> 5595    Yes   kernel BUG in ext4_do_writepages
                  https://syzkaller.appspot.com/bug?extid=d1da16f03614058fdc48
<3> 345     Yes   WARNING in ext4_iomap_begin (3)
                  https://syzkaller.appspot.com/bug?extid=626aa13bf52efc3aa86e
<4> 297     Yes   WARNING in ext4_mb_load_buddy_gfp
                  https://syzkaller.appspot.com/bug?extid=fd3f70a4509fca8c265d
<5> 16      Yes   INFO: task hung in ext4_write_end
                  https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
<6> 1       Yes   KASAN: use-after-free Read in ext4_read_inline_data (2)
                  https://syzkaller.appspot.com/bug?extid=085a394c92518a04fd09
<7> 513     Yes   kernel BUG in ext4_mb_use_inode_pa (2)
                  https://syzkaller.appspot.com/bug?extid=d79019213609e7056a19
<8> 175     Yes   WARNING in ext4_journal_check_start (2)
                  https://syzkaller.appspot.com/bug?extid=b75d75f957975f3d40e3
<9> 78      Yes   INFO: rcu detected stall in wb_workfn (4)
                  https://syzkaller.appspot.com/bug?extid=5b4f4f81240931b16844

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
