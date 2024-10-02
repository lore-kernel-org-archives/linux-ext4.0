Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618002F34
	for <linux-ext4@vger.kernel.org>; Wed,  2 Oct 2024 06:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727852045; cv=none; b=Tg+e9e1dI3WrgjkADZyFfwHmy1iINH4K0U4NOkivH3XT89AjsHaBq45e64qiv78cJ/ITb4IQDcWohDcMmB27VQ5MmIGYhuE0zipZIInFVmR9SBvzwNW5tz3BlOMqr3RCl3SQALENTTKUeOWLYCxjWokzXzOIN6vY2GXoJ1Nke0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727852045; c=relaxed/simple;
	bh=qa3infaQCAo057F7Q3AM/+WiiB9MI1QyjSlvDB9tifc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=mtKjMwpaBaaBtDGTuART307HVL5PI7HuzRvs0uvFEXlwRQ1l/aHmWrLrVDkUivCIw9BiR1FvpMot96ft1NlG1PfqdrkW/fFtRbpfXLs+vTWtCu6VsXgoMEwWtBMmmYxlelF2wEku/V40xvbQ3DL7Bvx8j5D+UNJInWZPhIz8ciQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a3496b480dso52399585ab.2
        for <linux-ext4@vger.kernel.org>; Tue, 01 Oct 2024 23:54:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727852043; x=1728456843;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OAo2yMDD2BRuUPOels5Mo7AQowaBqVEM1zOH2WU7XjU=;
        b=vV1jWh+YReZJSgJ3uzeL0prnqeQcR5Ep2f0E1luz3J8Rt3dDa8kf6PkU9HPgg39xxd
         MfMHbLJFnq55w8aD/vr+Ip1Y9CzsfbG9WSSO2EFYTbyrI8W/o4z31P/6yKOXXoFVvrLt
         fHlwyIJviuV5TGAuSL+k6ICDe0S7qnaOFz7QumQT+/7H/wISFCJ2cP9C7iaTtuquyn4A
         SfIgPVUsYZ9FHyqZ0xJRFjidJFiaBw+kSroprAJ3/owOLmYqQVwIS/50j8Z01FYE5kcm
         nKQuehKqOIbnY7FkcGbVVXBWuUfTb12/C7ged/EvT9aT8qgY8QI7ZNAIDecKvWHaeqNc
         X66g==
X-Forwarded-Encrypted: i=1; AJvYcCU3hFXjvR1rTc081xjI687Ffb+r/MqIDzsAbfgbry3mOHqk3gJLbiLPOdKjtIcD527opX25wF3LvgHS@vger.kernel.org
X-Gm-Message-State: AOJu0YyWlTSqT6KnMtE7/8u0Arvr3U22L+X2ZPnyQoVrdHkp25sgpSU7
	LZ/t9/wDTTTCqkEGPzekSzwy616vkADffyH7QIaOB3Tutq9swYbh8PI55z9/hO7u0JPgzZldyZU
	BXpXefDcIjxXHqfNfeJv7m8FGmV2cSu5OuXgkRy/GoS1KXIqKCtlH7sw=
X-Google-Smtp-Source: AGHT+IEwUKkE6qT/FibZWUQl1zRTmkwHlgJFklLjNT9xLfKilC7YHJEl8j+wfeA4u0VwKv6ta/zYGiNuYsQ0Ps2OIofME+lrVMEm
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a6e:b0:3a0:ab71:ed38 with SMTP id
 e9e14a558f8ab-3a36592a7b6mr19288205ab.14.1727852043506; Tue, 01 Oct 2024
 23:54:03 -0700 (PDT)
Date: Tue, 01 Oct 2024 23:54:03 -0700
In-Reply-To: <Zvzo1RC8scv-muur@fedora>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66fcee0b.050a0220.f28ec.04f5.GAE@google.com>
Subject: Re: [syzbot] [ext4?] KASAN: out-of-bounds Read in ext4_xattr_set_entry
From: syzbot <syzbot+f792df426ff0f5ceb8d1@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ojaswin@linux.ibm.com, qianqiang.liu@163.com, 
	syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+f792df426ff0f5ceb8d1@syzkaller.appspotmail.com
Tested-by: syzbot+f792df426ff0f5ceb8d1@syzkaller.appspotmail.com

Tested on:

commit:         e32cde8d Merge tag 'sched_ext-for-6.12-rc1-fixes-1' of..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13657dd0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=286b31f2cf1c36b5
dashboard link: https://syzkaller.appspot.com/bug?extid=f792df426ff0f5ceb8d1
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=122da580580000

Note: testing is done by a robot and is best-effort only.
