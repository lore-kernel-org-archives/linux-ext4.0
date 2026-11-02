Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793588103;
	b=oakZ8x0RkVepsrP0VhcwfE78OOYPg704oJucFzbMmOwwXSvX5kSf/d/Zl4EueRjI8aVx
	 SVXNovkQrle0Kb7oQNYmg9LhR+OtT7PXbIWodxDNNL50xo8Oduw/0aWg70AfqQgz5Qawd
	 KtRmaJMNcf7FxOrf+JcNE3DQD9eRq+aI8f23NUqJnq1n8oeV/wzbPNEqVQG0Yp09Wxx+o
	 fpwdNnQ7Qp1ex8/64aaFBZuRsnEBz+EbNc27Qczx3uRUJST4S0ElCSlYc5DZ7feLGmLXL
	 upzgD0BVRd8Ja3GSSgUAa6PqhTN0BOZZScNd+3KXzB6IVg0q4qEc4VdH8V1KKcQRFPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793588103;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:In-Reply-To:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=js2+aFipwjc1iEKrWbKe4EukgHY4QeQ/3UuzBqQXiBg=;
	b=JnL5ivUCxqQdiY0P5QTaOF2R4kdjfSDghJUgBA+r/PqNEY+/fvszqAieaDVlocVKSNkg
	 xQ5zk+WteERFpyM5JrL1rMx92vBZZ1Ivq5Beg0PhTFenmWcFZGzVgERWI4Vz88zkgcFYU
	 rZv7mjp+imhng2CZ3If6kTKZdQJmfvEVny/NU0d19s1+JF1bBwMON031LDt6yd9htD+j4
	 Xa4JoUtfdxiZ5QX16arfMF6q190VjDNK2LKQhZb6ExvLCNr2S0ouv3Ri5dsSDJmlaui2B
	 SwV+iW26DpgHcytqMAhhfbhuT4VrdxG6OrOyHtxvK7nyA04QyMboJd6DAFAYHpCCSkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60589606A32C
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 02:55:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60589606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4b26d8d2498so3544679b6e.2
        for <linux-ext4@vger.kernel.org>; Sun, 01 Nov 2026 18:55:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793588102; x=1794192902;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=js2+aFipwjc1iEKrWbKe4EukgHY4QeQ/3UuzBqQXiBg=;
        b=FJojpAkK+NdtzinvcFNisEmW9413D315K+GhDpdl3s9oo5tKe4RoalG26PdlZCm6I3
         8ATP/d/tO2gTuxR9UrOk37TlzaS0nY+ByDT/pwgAertjlOl1crB/egGpy9jXyuZC0STZ
         0N7kIvR5kOFqS4ijNwYqjXgy29e6l17FfHsd7Frz6bAO/fnTYhr6E52rhlPF1215O96l
         vnXV4BC4gj812TyuLPFILO/eUk8aESkQ3Mf9wHvF3rc73EMN0YZ5HTlrrwqGp02VCCRC
         QNg4l6QkT0Qm9uq1JAc0BPJhZlfQVo7LM8WyLgClluvxgH5b/rP8V/cWMKf2Ay1ppUd4
         BTcg==
X-Forwarded-Encrypted: i=1; AKwUvBxETokCb0QxDoju12qtnlGPA5qr2yw/uJYxA142gVY38yMq3gB8zcO9Aq/ObT4QgzCsd7UfKFXozg7L@vger.kernel.org
X-Gm-Message-State: AFq9FYIHPtoXEvsoMIZggkvbl6ULipoSP5ao7Fj3NsRqUfYh1LcfmkHD
	tssQ+h1gmy5sgm4n/oKSSnRKbwOcNhS/JwXNdOEafTDjzuI1TssZMWeyw3smF+qlhVMS34z+3Eu
	DmS0/bHI7cyKHW+adEjRXT7DJAtbYiJKLeT2SWbBmva3e95I+u+cJ3MYQgf0=
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1520:b0:4ec:d521:9124 with SMTP id
 5614622812f47-5640de27b0emr6173623b6e.30.1793588102382; Sun, 01 Nov 2026
 18:55:02 -0800 (PST)
Date: Sun, 01 Nov 2026 18:55:02 -0800
In-Reply-To: <0ba396c9-1881-4ce9-a84e-6b96c2445228@huaweicloud.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae7fb86.c8ffc79a.e3697.0029.GAE@google.com>
Subject: Re: [syzbot] [ext4?] WARNING in ext4_do_writepages
From: syzbot <syzbot+97fbc97fdd4e4fa2ed3a@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, jack@suse.cz, libaokun@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, syzkaller-bugs@googlegroups.com, 
	tytso@mit.edu, yi.zhang@huaweicloud.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+97fbc97fdd4e4fa2ed3a@syzkaller.appspotmail.com
Tested-by: syzbot+97fbc97fdd4e4fa2ed3a@syzkaller.appspotmail.com

Tested on:

commit:         6628e7d4 Linux 7.4-rc1
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12bddc8d580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2a4f87c7d3edc25f
dashboard link: https://syzkaller.appspot.com/bug?extid=97fbc97fdd4e4fa2ed3a
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1549028d580000

Note: testing is done by a robot and is best-effort only.
