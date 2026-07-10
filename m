Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF862C1594
	for <linux-ext4@vger.kernel.org>; Fri, 10 Jul 2026 20:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783715558; cv=none; b=p7g8TiEnn8RTLsxRKHcCmUUNzFN01QyRJ74ykA+wAFjazPxUqzgGlQK1XoVtpZh90TPHi7nocJEtN3AJJQNg+R7DETWPlXRnDDeBeDtjeQZ+cVqSFOOror9gZhfeE2/zVmAEJEvxR+EXdXvFJ97Thpos+AX5cF6WAH/C2brcDc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783715558; c=relaxed/simple;
	bh=mWYD7Q50FDfQf6w7M4HUN6gmfnf/y3B0S+J4f7n0cB4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=pbYjkgge4plZNVC0H07HFZKqpUJAVxv6qxQ6mJNQbACYRkVr8a5NwS0//GADL+FxzBXlSmNA1nCeWQyUXFI79Q3kUQ9h5UmVGSLZkIVSxEw1g98TDI4Uf8dgLGcSbdVHSdf8oXBgotUjEx/qOhtlOWYNn5pW3aVinnRA0m+1EGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-495f7693e7dso1815893b6e.0
        for <linux-ext4@vger.kernel.org>; Fri, 10 Jul 2026 13:32:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783715556; x=1784320356;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nUEgiD1J/jUpSu7xqyRakoZnB2687wEHAw9UnAHeRGQ=;
        b=N4poJ3bwJfKOxKkv019EWdVZ7CJX8GbfHemQLaRslgIwpycoIMZVEfFgLiwV0uslRK
         kKbYDzj/qpp2aK5HxYS/QyNTlqYVvoPpNW38q8ZR9Nvcqvp34tgBCgeWadMrvXnMXMxE
         nE1PzI/r/efhxzbbCcm6e0YhIzlfcWW2Zm64HU7rlzOWVVAup8Nnt6fzNW4cH8gDPkZL
         RrrxM0ikmHXh2pwEpPyaMEE9AjSd/WCVTNV1O2iE0MQWgQ/ZSRw4iHvukNb62JzXtaZm
         5ZKIR/YwwL9ORIiKUJ7uwf7SLOQexdIPyOfeLjVX1RhBP40M+UVMA1Wngi7l9jroC2b2
         bTEQ==
X-Gm-Message-State: AOJu0YwsbH/DTp8DTR45E6euxFld0NCupVOid1u3k0wgQz97D14oGGPP
	eJj48lH5MSS0nBey8YX9+gJxjk1pe2GF1e+7JXczs/82PSR9SrnhgbBapZ3N0jV5ULqXYHKGsIf
	gWdfw0PjB4NYmz+eYphSjRPVQ8vMWx3SuwIl3/hZm96JHMKEGb6JKYngamVE=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6a94:b0:496:117b:1f04 with SMTP id
 5614622812f47-4a40ecbe896mr2874028b6e.2.1783715556486; Fri, 10 Jul 2026
 13:32:36 -0700 (PDT)
Date: Fri, 10 Jul 2026 13:32:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a5156e4.278cdcd2.e885.0006.GAE@google.com>
Subject: [syzbot] Monthly ext4 report (Jul 2026)
From: syzbot <syzbot+listc4528d3e21bc58f7fcb2@syzkaller.appspotmail.com>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ext4 maintainers/developers,

This is a 31-day syzbot report for the ext4 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ext4

During the period, 3 new issues were detected and 0 were fixed.
In total, 44 issues are still open and 178 have already been fixed.
There are also 8 low-priority issues.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  16116   Yes   possible deadlock in ext4_writepages (2)
                   https://syzkaller.appspot.com/bug?extid=eb5b4ef634a018917f3c
<2>  7757    Yes   KASAN: out-of-bounds Read in ext4_xattr_set_entry
                   https://syzkaller.appspot.com/bug?extid=f792df426ff0f5ceb8d1
<3>  132     Yes   WARNING in ext4_iomap_begin (3)
                   https://syzkaller.appspot.com/bug?extid=626aa13bf52efc3aa86e
<4>  30      No    possible deadlock in evict (4)
                   https://syzkaller.appspot.com/bug?extid=a30a00d3e694e4fa1315
<5>  7       Yes   divide error in qnx6_mmi_fill_super
                   https://syzkaller.appspot.com/bug?extid=6a0633f11d3fb88860bf
<6>  4       No    WARNING in jbd2_journal_dirty_metadata (3)
                   https://syzkaller.appspot.com/bug?extid=a5f824f1c49dd97fcff0
<7>  3       Yes   INFO: task hung in ext4_write_end
                   https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
<8>  2998    Yes   INFO: task hung in sync_inodes_sb (5)
                   https://syzkaller.appspot.com/bug?extid=30476ec1b6dc84471133
<9>  2204    Yes   INFO: task hung in jbd2_journal_commit_transaction (5)
                   https://syzkaller.appspot.com/bug?extid=3071bdd0a9953bc0d177
<10> 810     Yes   possible deadlock in do_writepages (2)
                   https://syzkaller.appspot.com/bug?extid=756f498a88797cda9299

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
