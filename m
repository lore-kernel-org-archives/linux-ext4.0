Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6004E335093
	for <linux-ext4@vger.kernel.org>; Tue, 10 Feb 2026 20:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770756845; cv=none; b=FY9BtfDv07dY+SPD2HOnl8SE/NGGdQQCekayHNz67OoaixpZtTLM3qeSMnCeTw+OygijKLAfSzZ0nNYIFy3vBMwTO0XdV0dItFKk+CpR0SM6rQgvThc3K2GKfWozR+xNLw3FjmTYVVtaU6Ih2k9CPQNdGOG2IZ/Yxf8huAkUAgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770756845; c=relaxed/simple;
	bh=0Amr4176xDg2mGRjpjP3t3clrUUqfHTlr+5cikBfPmo=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=gWLsHFTXXyKcCSvZBvbzyd0pZMaQpifcyfpXsFLLgWz5kc4XcFygS65kiptE00Zy2H/CFQfBYX8YtKRxhIi685wuV9/QFiKJcgi2ImX108N6xps3M421M9iY/ReIDADP0F8iE2NioZty1N1UIscqdaDws9uJIgBlFS5O71qntao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-66ad91bd85bso6322779eaf.3
        for <linux-ext4@vger.kernel.org>; Tue, 10 Feb 2026 12:54:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770756843; x=1771361643;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lVlE/3nxrkgiu6PQgWHepWh1UYoFXEex2w+VvPfW6xw=;
        b=DVg2gkKzCtAA44ViF9RZ+OCzGn+Ls2v+UCkbYNUsD7jHbSK/+ca+ui6sr/XhZLW8tq
         0dxr/RKpw1tIfXwrdp5eM8c+q07pUxIw+Bk3gbMco1QiLqySg/nF4KuGKBv24jUVH842
         u2rxksYDQfkbW3XQ/XRa11xxWTPY5sXeqPgB3dBsOR6TJzCUZ/GdIKFciHk0JydWydKc
         ytYHnJFQM0l7gZivlKfCyeYlq5NoJ9xSlgr4eiwyJTfPu04gs7+I910Tw7HbcHmAChQx
         Qgdxa2MIbkB6PzkA9GehV4r6ukQMzkyrCWfYLjyYARsdMvdDW5XWZUymi0uyX7tSAiAE
         y7iw==
X-Forwarded-Encrypted: i=1; AJvYcCVgPt7LIWRMmpuBUWjHDWuMi+/U9vvd+8aT+HufsS+Qis3cDNH0G/2JJYG56tNylYES2L7PNo2xb36X@vger.kernel.org
X-Gm-Message-State: AOJu0YwsN1Nwjxkw41dOtbClJlbEWqpoPg0FNI4mFYxyOdQ5BpwMsufb
	t9L/chvXLfOKrHuDSCsdvbcvwzWKoSAqtiihkTQvnbCNHzhVj/6BaGbDckvvT9Lpl344Xm+tk/I
	0FPo6QmYnEc7y59y60bwjQJRJ3Y1ua3tu4Fw47odaxL+ifyQwYEVGhPC23bs=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4dc8:b0:65f:10ea:4772 with SMTP id
 006d021491bc7-66d0a286913mr7030505eaf.19.1770756843348; Tue, 10 Feb 2026
 12:54:03 -0800 (PST)
Date: Tue, 10 Feb 2026 12:54:03 -0800
In-Reply-To: <aYuOGWks1hXSx-Uk@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <698b9aeb.050a0220.2eeac1.008e.GAE@google.com>
Subject: Re: [syzbot] [ext4?] kernel BUG in ext4_es_cache_extent (4)
From: syzbot <syzbot+ccf1421545dbe5caa20c@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ojaswin@linux.ibm.com, 
	syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+ccf1421545dbe5caa20c@syzkaller.appspotmail.com
Tested-by: syzbot+ccf1421545dbe5caa20c@syzkaller.appspotmail.com

Tested on:

commit:         4f5e8e6f et4: allow zeroout when doing written to unwr..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
console output: https://syzkaller.appspot.com/x/log.txt?x=15739b22580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a535ad5429f72a2
dashboard link: https://syzkaller.appspot.com/bug?extid=ccf1421545dbe5caa20c
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=12d6f33a580000

Note: testing is done by a robot and is best-effort only.
