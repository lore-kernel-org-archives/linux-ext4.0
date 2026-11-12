Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794486812;
	b=hiLppGuEz1yV5hbvuZ0y2oqVlB0httuugzrOVWKZyIwKzBsd1m/R5fVvOEHymWGFNso8
	 6D+p/7qvUc1tgSy7ucdhvlwZaIzGGcLkcVjiswEbBZB0dN6aHt0s90AiS4J3qvoFK0+Sy
	 SzM+wSqgdKsI18qw1D+mWc/t34V9OoT+k8VfbfuV7dJqRefwdA2OaPiuj8Y7blMOYN5iR
	 961Nyd49zssz3SuTR7IkXFS4QElMaWzVr/s3VBpRFMUFwpRRIXuo+ZU/HRhm791ueATF9
	 csbL8nACKfonAK1IS70/HBJKsUyPzd2a6x1CgrVnPUzHrGfd9vV+rF80n4o/kYk7J9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794486812;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:
	 Content-Type;
	bh=J7e/HQWh9pXQoKTp7kH2sZAez1f8qPQApyE7NMQ7Dcc=;
	b=qjKw05BswEau4MzEfpO+dGxnxOSViABiuS2lW4NAvde6cV5oN1t2N5whUdaj+58HP3R0
	 AxtinMk3GBkob+dcB69BThDDug7dreQanvdFRKB6T4j5xlHPylKpB/DT1dvplbx/pFGrC
	 C3OwdRQpV9ooOi0o4BA8txytThgGDBqH27NSeWMT5JOHX5cy/BJJx5AM+pyU7a/Uk/hI0
	 7PfeqMl4P5G58eaJWBh4dZlX8nNaeyeDfRzCFmyS/w3igbFrg28ALCHseZcFo9m1tBZlt
	 bjh5VXiPr8CeOWjO0gI+IGfghR3zFcdozRBZIGsV3MrPyB7IZobmu0/CgcnvFSaNqmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAC7606A330
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 12:33:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5BAC7606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4c467e19391so6356036b6e.3
        for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:33:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794486811; x=1795091611;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J7e/HQWh9pXQoKTp7kH2sZAez1f8qPQApyE7NMQ7Dcc=;
        b=dN4+Enuc5r5lo2QJDOaVH25Hf1njklSrYlwQxniEOtjMyB7Ufnw13U3KSTTX81clv6
         OipmwXOtLeIcSJx2iO1eDek4iY+oOyKM6DBrbxpEyTV1avc36/YsbE+ffKDWgqwMKjbr
         FOA0AdOvz/6ZxVlqu1dOxY2PM6Lq9VREUOr0uknYpiSMk4hUnJJHs7A/wcVxNmP+42Ke
         CCb0hzLhRKWKS4KsKgI/W3V4Mw/B9qui+TB9Jj28NRVLCioXrHm1q0UMAZ4U/jaN81PN
         StlMsWwAv30C8JLRPClS7b+E3PiCsAe+f0BFNBgLnqOny72A5B+TS/180EXdBvlzXBS5
         w0BQ==
X-Gm-Message-State: APuU4Z8CKMwdcDKCFeeUdSDf517c/596AHorZly1MHABKJ1eurFDZubu
	RDHDd5hAy9S4JRrR2U/kYVtftIydioJCbTQ1w+AyO9z8l0+kTXUkEm5yawvT1fJ9f3lqBVjAwz5
	6h3tDfqPmQzwTj5yPRMQpqGi9kemMzIXFsTLe9i/9nL6pX6Cp63crcfxmhg4=
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4fe3:b0:556:82f5:5aaf with SMTP id
 5614622812f47-56b97d11f1amr5246723b6e.49.1794486811208; Thu, 12 Nov 2026
 04:33:31 -0800 (PST)
Date: Thu, 12 Nov 2026 04:33:31 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6af5b21b.0f67a820.5686f.00e7.GAE@google.com>
Subject: [syzbot] Monthly ext4 report (Nov 2026)
From: syzbot <syzbot+list388317f27f7b9295f8ac@syzkaller.appspotmail.com>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ext4 maintainers/developers,

This is a 31-day syzbot report for the ext4 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ext4

During the period, 2 new issues were detected and 1 were fixed.
In total, 29 issues are still open and 189 have already been fixed.
There are also 13 low-priority issues.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 8189    Yes   KASAN: out-of-bounds Read in ext4_xattr_set_entry
                  https://syzkaller.appspot.com/bug?extid=f792df426ff0f5ceb8d1
<2> 6060    Yes   kernel BUG in ext4_do_writepages
                  https://syzkaller.appspot.com/bug?extid=d1da16f03614058fdc48
<3> 588     Yes   WARNING in ext4_mb_load_buddy_gfp
                  https://syzkaller.appspot.com/bug?extid=fd3f70a4509fca8c265d
<4> 358     Yes   WARNING in ext4_iomap_begin (3)
                  https://syzkaller.appspot.com/bug?extid=626aa13bf52efc3aa86e
<5> 3       Yes   KASAN: use-after-free Read in xattr_find_entry (2)
                  https://syzkaller.appspot.com/bug?extid=fb32afec111a7d61b939
<6> 1       Yes   KASAN: use-after-free Read in ext4_read_inline_data (2)
                  https://syzkaller.appspot.com/bug?extid=085a394c92518a04fd09
<7> 1       Yes   memory leak in __pcs_replace_full_main
                  https://syzkaller.appspot.com/bug?extid=4d078516add5f4f12cea
<8> 545     Yes   kernel BUG in ext4_mb_use_inode_pa (2)
                  https://syzkaller.appspot.com/bug?extid=d79019213609e7056a19
<9> 79      Yes   INFO: rcu detected stall in wb_workfn (4)
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
