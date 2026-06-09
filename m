Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D88735F19B
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 20:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781037154; cv=none; b=SDKIqG87qQ5LRfqap+2ctUccSnGeGkJtZUjInVere8RBnFwCxKpp5m0sl0nymE50IxolmAf5mudsB2c7c72XBl6s4XCXDrEMpuqAX8va0rvQr7YErqg4uEGO3J//aT4qGzWE4n9OPWMWf04HpxAXvNxOxptt0CeBCBDd/BUB4Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781037154; c=relaxed/simple;
	bh=0SGQLFDjU5iw9uYjPX096hJaNhZuA2q9lZgLWprWZ80=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=pp7nncDtK03WZrM/yeluiz4mstIzALFNQQlQx+I6ktsPXKppoPf++uFMqSOGVJNJ5MO5JHKJFnBew1igmElsQi0UoG/uq9vYeo4WJjzwsHccgz1mgPvBcNNKnRDJTVuIo7PVEP24SBhdsc8W543/5r1EqrqLO+Q7tQJy0wj1h3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-440e399d049so6835584fac.1
        for <linux-ext4@vger.kernel.org>; Tue, 09 Jun 2026 13:32:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781037152; x=1781641952;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/vGVhoSmYtlv0YzGh4wpCudDFVpK26jtcGI13C/Jzo0=;
        b=PZKiiCxlXbZ7DVOEugYJIX2Inq13eRVNVRMSQoj5S5izVVaSXk+hq+iETel7ruwpp9
         K1SRGdg1R37mDIfv83gCi1jH+KnvgWsEWpi3Z87UaczOE4E3H/PNOe2OLdqsGKJ+2rfv
         ldA+OJlb8wo/cyHh5bFdmixbUF9KreiCK6nUT2Jrea/qLSDidB9bgwg/ehLI7ERSYcos
         ot60pdEklKmwCEVbe5qmvqhiozRb96tvSd5U3poheinWiFxhqhSEUP8iU+jI3OJHCYbt
         VnzskllyUiCtwXvilHmwdnasoasLYdLC1vfVhruBDd1TVdncNQAfHcGBJKf629GEiJAJ
         JPTA==
X-Gm-Message-State: AOJu0YyV0IwLlYLPqbp6XbmxtGuPr4Onrr6q0qMjVj09kYxFmWAWLg++
	fh5K+Gnwsf2F2Lfwt7TtLhTxEP25lnYkFfjMYS3ykY7+GkyfLtKaEGt6CHLhLlvNl5yWhlHxL6l
	Wdw1lIcDi1W3rgdZTcbK07vmZ3jBT6kCreFu+S9N9LxSzdwNFKJztjG9kIvk=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:200f:b0:69d:fc30:1cf2 with SMTP id
 006d021491bc7-69e68b18c9bmr12388728eaf.7.1781037152430; Tue, 09 Jun 2026
 13:32:32 -0700 (PDT)
Date: Tue, 09 Jun 2026 13:32:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a287860.39669fcc.33b062.009d.GAE@google.com>
Subject: [syzbot] Monthly ext4 report (Jun 2026)
From: syzbot <syzbot+list79b0622b9b462d592968@syzkaller.appspotmail.com>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ext4 maintainers/developers,

This is a 31-day syzbot report for the ext4 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ext4

During the period, 2 new issues were detected and 0 were fixed.
In total, 45 issues are still open and 175 have already been fixed.
There are also 8 low-priority issues.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  10098   Yes   possible deadlock in ext4_writepages (2)
                   https://syzkaller.appspot.com/bug?extid=eb5b4ef634a018917f3c
<2>  7580    Yes   KASAN: out-of-bounds Read in ext4_xattr_set_entry
                   https://syzkaller.appspot.com/bug?extid=f792df426ff0f5ceb8d1
<3>  3212    Yes   kernel BUG in ext4_do_writepages
                   https://syzkaller.appspot.com/bug?extid=d1da16f03614058fdc48
<4>  481     Yes   possible deadlock in ext4_evict_inode (5)
                   https://syzkaller.appspot.com/bug?extid=212e8f62790f8e0bc63b
<5>  406     Yes   possible deadlock in wait_transaction_locked (3)
                   https://syzkaller.appspot.com/bug?extid=5d19358d7eb30ffb0cc5
<6>  139     Yes   KMSAN: uninit-value in fscrypt_crypt_data_unit
                   https://syzkaller.appspot.com/bug?extid=7add5c56bc2a14145d20
<7>  20      No    possible deadlock in evict (4)
                   https://syzkaller.appspot.com/bug?extid=a30a00d3e694e4fa1315
<8>  10      No    WARNING in ext4_write_inode (3)
                   https://syzkaller.appspot.com/bug?extid=070d9738dbe6a10fadc8
<9>  8       Yes   INFO: task hung in block_read_full_folio (3)
                   https://syzkaller.appspot.com/bug?extid=03afbb29537f0336b7ad
<10> 2951    Yes   INFO: task hung in sync_inodes_sb (5)
                   https://syzkaller.appspot.com/bug?extid=30476ec1b6dc84471133

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
