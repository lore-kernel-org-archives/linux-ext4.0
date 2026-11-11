Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794372363;
	b=thyIvPFNxo5Mj8NdSXqMU4u60LT2UxKSjsbhZ3IAKIAHsCaEmFlJt4WSRZJoYxbdoqqQ
	 ojGe+dgXOgqJgkI0OV8vjDVocSjhhhU7uQmj+ZfWiKfBGE1lGR3u6ghByDxj4JnjkYdPo
	 ESKgpmWnvD3hre+WkCKxPhBA0RzzBFrlS95f5rhgzysRgmkNJzP9wwTAcN39fjhllqIjU
	 Seirlagr4AY4STs5UBdAztWb/lFlv+Bi/IIMtpQ5cCuSrO3/KV7Zz1+kRTJz48CWEG+TE
	 IRIzDn4IA3WLWBnCRM/E/qa7aQ3/wecDw9a1TNw8i2OPopv1HAZ03nAhbK2k9y0aTIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794372363;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:In-Reply-To:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=tc06brEby95ail1F4lHOJFrAbzbjGxWAEQqRmICG19U=;
	b=pZLDCcnFRS/If0Yo9u7/PPstQYlf4HCqSQtnV/3a5hhdWpSbn7WOQSlxEjp2MP2t9+e9
	 /+blHionoa3aWsx93g58ZC4zIbL6eU+/qoNjvc56PJIMkPe9VRpFpkkBXB9k7y77K2jBH
	 TTN4sHrH7I2wXrAP8VfdrJzMd8uVh0Nhd/x9FMWV7YzqTvXedLSLKX7mpFWvHdoWVJb5l
	 m23j4eQLCvHeSCn7egd+Kbk3k7bgRlEFUBitu9RvJIxzQmpWpLn4+EU5m9nruTN4PPEP8
	 57b9yMYGTb3Dt3LuVFs4SuHDZTJKGteOKxEr30acIqtMvnYNGpWx/dEsbqV+pS/QgbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5368F60A3815
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2026 04:46:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5368F60A3815
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-5641cd2cc13so3198810b6e.0
        for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 20:46:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794372362; x=1794977162;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=tc06brEby95ail1F4lHOJFrAbzbjGxWAEQqRmICG19U=;
        b=rV82TMD1eKSt9xFWDrP6Subz/eXBsOFqOYQnJmTYnD41JlilvmOTewGL8q+Seg1Ptm
         1G8bhUjIlh4wKyD68gpvKoX0/yo4OKPQJOj71v1U9hPgOpFaRn5np+D5a5eVfK+ZBQub
         ITdzpMyl4h97sRtdNw3AkaxyIC687A6GiftkftItcdwKoPIOS81Pxf5b7wZdbJMSFiJj
         Nr9Tfq3+5NI5zParIALsdjcJHX4m7VofzG9NnTQTOBR3sZld5os6RQf9U1Esbsn/+dgY
         gNLqhbMuybqT2Y5XR0gRgupxcbrqr9KFVTnmQCWsUVFonxeuD/6qWhsm6p0OMP/RKi/U
         oyaA==
X-Forwarded-Encrypted: i=1; AL+hErGcNWSfG+BG7CArjPlIIKs0iCWQkMoqesSxpZwdT/ZL5SXHRqr+3VKPuPo5sjLTcxKQO+rPpS/GEPTQ@vger.kernel.org
X-Gm-Message-State: APuU4Z8f56KOAvTk8kb/b2aFvt7i03eBSk2Rl8ZgHvp+haQdF8PDFAWF
	E0bLXBz6UhDGqqdw7pmzM7vQ6/K211DhsEOR6Xon3SsifKvpIoL+KZKywS/x5HuLR7crU9T2xWb
	kLMc5AlBgrOT4L0TdH/aO4UqVNR9Xj31g4qyUOfWkPL+zkI5x5pJrwbBCMdY=
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c123:b0:4f1:a873:6efc with SMTP id
 5614622812f47-56b98c19490mr1069217b6e.64.1794372362344; Tue, 10 Nov 2026
 20:46:02 -0800 (PST)
Date: Tue, 10 Nov 2026 20:46:02 -0800
In-Reply-To: <20261111032743.549426-1-diasyzhangqing@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6af3f30a.926a6ce0.263fd.0199.GAE@google.com>
Subject: Re: [syzbot] [block?] [ext4?] INFO: task hung in bdev_freeze
From: syzbot <syzbot+d4ecb9a1e5b3dcf8baec@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, axboe@kernel.dk, diasyzhang@tencent.com, 
	diasyzhangqing@gmail.com, jack@suse.cz, libaokun@linux.alibaba.com, 
	linux-block@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	syzkaller-bugs@googlegroups.com, tytso@mit.edu, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to checkout kernel repo git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/master: failed to run ["git" "-c" "core.hooksPath=/dev/null" "fetch" "--force" "f569e972c8e9057ee9c286220c83a480ebf30cc5" "master"]: exit status 128


Tested on:

commit:         [unknown 
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=a58b6b4d667e7a61
dashboard link: https://syzkaller.appspot.com/bug?extid=d4ecb9a1e5b3dcf8baec
compiler:       
userspace arch: arm64
patch:          https://syzkaller.appspot.com/x/patch.diff?x=17f58b69580000

