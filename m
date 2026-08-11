Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A032472B8
	for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2026 04:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786422749; cv=none; b=r0J0z+UrRLlElWcLo4X7Awke6KxbBpnIO3RrjYqH4LE2mXARNfjEZ8F2IWfqH1wS9/5aL9cz7od5M78G0UiE2KB3OVYyKp5hM7Z93/KBgrYnXNN1oLo1Jclis9ZuIUBznyYW7JK9nWRPTkEMD3GnniKh7qN0VAGgXGZIMfSZhMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786422749; c=relaxed/simple;
	bh=YmTU0cuMrz6q1nj4v3rJi+xBLsvhVgrxATKUYqY4x1A=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=c8o9d8Zwxof5FIbRFLrWwoq61wZ1wprdm0yjebC+0+GUEzQ2M2Rmjyi1Dg5gTLxOkxkk17dnC7q+3KBHZDkdQvg4f2R/xWQdiwC+MHXt6STDi1UaHEH6qi90ERaGpLrFaMSCprqiICIsguVF2aNhBlnVqfP39/21oN1ToqkstGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6a0f261aeb6so2855262eaf.3
        for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2026 21:32:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786422746; x=1787027546;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GDtETnbSqyF0P4E2VpKMycx6tqmfKVV7fNJad8d02Fo=;
        b=Oi8BsrWsfAuvLLp+eFN32DuaZn7weMmsDTfMmq7z8VGMYvoQAWP/UnxHMsKJepCEdm
         Drc01c6WBhGLG9MPDucnANbyfgPekH4h9Nc3HdLgeRlj5o1cMvCUJY/vDYkoY/7wyFU+
         lGM11zb/si37xWvXqYENMEJ2PKVNcCy4AArulfMd8DIkNH2u6Y0M8YkGbNMtB/l5nN0f
         z7aGScw+iuQim20d5LzehuwwztCRDfnFWi4T1lZ/8qZy349RP6EQr9g3vNWg+xJFdutg
         Jx/2ui/jIxIIDApabgvE7DDzJ9N48oj/uCpVwADTuzXy1Zkq5hn0nzyG8wYjqJf6m2fY
         rMig==
X-Gm-Message-State: AOJu0YyUBhJV3tLwjMUmABMEKOltA9KdstAbwtHmCZ4ZxBWnjvVz476z
	gDswaLBCuEQrK38mlBONYDgdxpkQssMT4+QQkv3jiv+/GJcPmMAMCS4vM5bM2f32VO6ImejTsOs
	r1kfmxtCiAi7xL1CJvq/0lkWXCyc451WnXl512qO5SMBj1x3h/CfLqUktnko=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:308a:b0:6b0:4e2b:17d0 with SMTP id
 006d021491bc7-6b0a3244865mr142728eaf.30.1786422746681; Mon, 10 Aug 2026
 21:32:26 -0700 (PDT)
Date: Mon, 10 Aug 2026 21:32:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7aa5da.9c11d2ce.289b96.00fb.GAE@google.com>
Subject: [syzbot] Monthly ext4 report (Aug 2026)
From: syzbot <syzbot+list0ea3bdd8794fd95d58a4@syzkaller.appspotmail.com>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ext4 maintainers/developers,

This is a 31-day syzbot report for the ext4 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ext4

During the period, 2 new issues were detected and 0 were fixed.
In total, 41 issues are still open and 179 have already been fixed.
There are also 8 low-priority issues.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  19578   Yes   possible deadlock in ext4_writepages (2)
                   https://syzkaller.appspot.com/bug?extid=eb5b4ef634a018917f3c
<2>  7874    Yes   KASAN: out-of-bounds Read in ext4_xattr_set_entry
                   https://syzkaller.appspot.com/bug?extid=f792df426ff0f5ceb8d1
<3>  3863    Yes   kernel BUG in ext4_do_writepages
                   https://syzkaller.appspot.com/bug?extid=d1da16f03614058fdc48
<4>  2206    Yes   possible deadlock in ext4_xattr_set_handle (7)
                   https://syzkaller.appspot.com/bug?extid=f0b58a1f5075a90dd9a5
<5>  147     Yes   WARNING in ext4_iomap_begin (3)
                   https://syzkaller.appspot.com/bug?extid=626aa13bf52efc3aa86e
<6>  132     Yes   INFO: task hung in sb_start_write (2)
                   https://syzkaller.appspot.com/bug?extid=b3fba2e269970207b61d
<7>  43      No    possible deadlock in evict (4)
                   https://syzkaller.appspot.com/bug?extid=a30a00d3e694e4fa1315
<8>  21      No    WARNING in jbd2_journal_dirty_metadata (3)
                   https://syzkaller.appspot.com/bug?extid=a5f824f1c49dd97fcff0
<9>  21      Yes   kernel BUG in ext4_write_inline_data (5)
                   https://syzkaller.appspot.com/bug?extid=53c8bd6136cfbe85197e
<10> 11      Yes   INFO: task hung in block_read_full_folio (3)
                   https://syzkaller.appspot.com/bug?extid=03afbb29537f0336b7ad

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
