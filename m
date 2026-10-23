Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792729204;
	b=CaIjQw4qEb2KCpEPZKOpJYO3fSGL69MySybAsn0JS+2D73oOq8tiAz6nPz0I7l/cSuH8
	 j1LN4ilGn+ZPRDgHpkJLElKz3iY1bvTJppTAf8pQibt/qty7tG29T8L1ZAaRxh7mtaAyR
	 u5vu08XdLWKxe1YUou06QlSIj7MQo+qBZABiC51IJp0JUm6/asdGEn6QyIjA3jQaqG2h7
	 qI08fAfZHGMreDJxyC2C4xPluG8jiWg2VHl6aZvfI0+Mc7GYGMe4S6vyh4K3X0KfsxRrt
	 8zTMen0c1zGOrairViw2DfDbNG32dk+RJb1Y1yAYRO/1osjX287APhYgmr2Jv1KpNwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792729204;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:In-Reply-To:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=em572WSOzHeArHqFlz8x1vJT9zsCcLHK5PpLJVvHPaQ=;
	b=kk8ARoU9E5fm2sCwisV8EcuXphVfoZIufUE0Rg3iJvRz5X7tX8PFNhAmlvc3DS1UFPMO
	 hBiqYk+fNOT3miS6XOKre1Zr2u+H/UiHiPGfaAsNf2Vw0iGARnTDe9fSgBZO6kmeOFcT7
	 4PjecDIV6PWq6pu+PvdmpRGgXplRXu4TCoFmQWFyYf6S6Vn55dsBbbOlSWF1+N5mMbVi9
	 NXkjkHlM6CEkCpjmrpkW84Hsv2IoKfrEX5hfbXSzNLphnxBes7tbNmBeyk0GfywhJYdgq
	 GWbSDsjNGkZMMVTELpELdIKXCu57CU+OYKqlLWGIW0HjDvNSwUL8SYQB8lI9XB3EHfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.160.71
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B05606A319
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 04:20:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72B05606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-482966c4f4fso2787436fac.1
        for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 21:20:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792729203; x=1793334003;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=em572WSOzHeArHqFlz8x1vJT9zsCcLHK5PpLJVvHPaQ=;
        b=Oe650y/gsgojb2jDEpFob5ZEL8Rjex/RKVw1jD3wIqGLLpe2QTnNdQm59OwtULG9/C
         icP/RQLgj2nlLgHEJ/wtoOpwoH9LgY5tOfebhhuAJvv0kmTXdWHWMN/H6VNXi1qyWLi7
         GX2BF4Hisd0Bi4eWyF7Hw3Usx4DLT5Z0751LIvtOkExaQUk7GJ+Ij720OgBiRWGbf9eX
         aKHb+rAcT/xfgbnm0+ct5Tt32FV70cFh773F9F2aa6qsnxGbyu2U7xiI7fDm/O/Iqlyb
         m2LKSY40043EZHAlghFvP/1djbtWDX0HHGi76ctIDvUY/lY6JjePJx7WfBJOTtOCqdQ2
         Qhcw==
X-Forwarded-Encrypted: i=1; AKwUvBxX2Qlt3h68ezsr6UzEImrDZLFP4u9PmlRUxRdOUtgisB9HZsD6PWwuwtWnbeAkKXJmdeAYLyFDVi36@vger.kernel.org
X-Gm-Message-State: AFq9FYIsL6YJa+SIbeHf0HdLVoIyFw3xAVg0oUW0+wCnMr4yozRvATZg
	NYorn/AVyn6xsOga61/YqG9C+3NEkYiwNGDEUHHD0WKI1rjmTDL0H8uaKJM3IxuPsXRUFwwYvSC
	wNqFEsUT/u1WWPDSJ2zO5a9GrnCjlVTKJGZCwW7jmnpqs5xhO8Jni6VrStXI=
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2e43:b0:4d6:9133:cfe4 with SMTP id
 5614622812f47-557ef21ed3fmr2642395b6e.41.1792729203484; Thu, 22 Oct 2026
 21:20:03 -0700 (PDT)
Date: Thu, 22 Oct 2026 21:20:03 -0700
In-Reply-To: <691591fd.a70a0220.3124cb.0020.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6adae073.d1cee5ca.8df35.0001.GAE@google.com>
Subject: Re: [syzbot] [ext4?] possible deadlock in ext4_xattr_set_handle (7)
From: syzbot <syzbot+f0b58a1f5075a90dd9a5@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, jack@suse.cz, libaokun@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, syzkaller-bugs@googlegroups.com, 
	tytso@mit.edu, yi.zhang@huawei.com, yun.zhou@windriver.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 7461c60b9c6a839b13ad4c3490681a0cf5aa0637
Author: Yun Zhou <yun.zhou@windriver.com>
Date:   Tue Jun 23 06:19:02 2026 +0000

    ext4: skip extra isize expansion during mount to prevent deadlock

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=124e0a95580000
start commit:   61c03dfde854 Merge tag 'ntfs-for-7.2-rc3' of git://git.ker..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=98da55a882774dfe
dashboard link: https://syzkaller.appspot.com/bug?extid=f0b58a1f5075a90dd9a5
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=165aeb89580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10185432580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: ext4: skip extra isize expansion during mount to prevent deadlock

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
