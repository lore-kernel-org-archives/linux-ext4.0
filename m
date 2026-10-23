Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792780865;
	b=1nbpQow84XuaJ8ETN5ToacL64UDS0/PH9+wIkRBx+clkfhvq7hgBSWlGXQ+r4u/4DkGs
	 p96qoeO79l33hc3M42RV6uzUYahFfmrPvmc+7Obz6cnPtWF9mVc1NS2nPusp4HyDogXSr
	 dTMpr5/MfPu8P8vyvuKBKeEXs7mCw3Ebj2jtfrr9OoNT+D12TGacCE00GRThT1jMoMC9v
	 AN7Ma3z149ekHpr5bKSIePwmRtX5N4J0fI42Cqe0k9gFb7GFM0jwB+WimZqueQC46JOAd
	 A7KYyd1m2QUpizHef14wGhmo/0DN1veFQR44Pr6GIXbf+9Fsz8/RQ+B0Cb9fGAjdmNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792780865;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:In-Reply-To:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=k9tAcHgucxjRPGnV+rTtZYrbnfzK1zdVFYrqtBoNa+c=;
	b=QK47Jwk5uE6LQU7sbq7URmXHtCgxIOtABe0fakM55PnhdwF28xmtNbqFwpfsilYseBsx
	 g0ati3jVqW67g+pKoBj3EKKltK9LcOoW4uGiPZ9FD8K0GRB5TD6osllZL1Q9ZsYy8qhoD
	 ux52gq04feMH3TQqaYvlVDVE5XK78N6/zrFb11w/XYscopWkSu3aU1hJd/377+XYEUj/v
	 yU8MwKglWqFSEBhAb05VPgBu6JkBIYBcHl4vohc6KiRn5z3E8+ViIEFcY7yxFzpIo7gmQ
	 D3XJncLUdxtM+xGNG32Bt6XlX+s5zi5l8oxmfZFGzAv6C9LMyRwx2yLm4kas8ePUdcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9FA606A31E
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 18:41:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B9FA606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4cc89e86e4dso1857745b6e.2
        for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 11:41:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792780864; x=1793385664;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=k9tAcHgucxjRPGnV+rTtZYrbnfzK1zdVFYrqtBoNa+c=;
        b=gV03fkiiGgvmxuWtAI5lDGWM67mgaU+3Ux+mtN6XOl37OLizKPbzuPMxtM2CsrbEQt
         tpWVVCal54DLpr6vvyqXuQDA+puRoX4ctxGtdvMkC++z+R/uIoiBN9o4nyEZy6AYwWEB
         LqghcZXZNKSkY78ra21Mt6Nt/T7srjcp9/1Zn6F/xlzYskK+puQgGRVHoxKwH+opQeeY
         B+qoZ1hkuFXfCoszJgJKrYIt5ndmQaQxGcMzvSZOfCVE59RPqPwVt2ONif3T9Cqwv3Gw
         nabetmCVm/Zmtpg6zTj2zk7pLLOJ1zsk5J4ahvY5aRPQqyEpLn/hhqkTLWR3/3L93IaK
         s70g==
X-Forwarded-Encrypted: i=1; AKwUvBwpURWDdzEOFHwkDtiVmULor0Vo0Mh+gzhr5s6rj/JUz7q9n29OtLF17OQS2C9jfo3zqu9xPCX9ENpx@vger.kernel.org
X-Gm-Message-State: AFq9FYJdayJ1eV0wxidcnnXPjfnf0OxMKEA4dHLiu84Edjl64LtNDWb9
	Jfv4DcKs3CAsCvoePpU3A47yB6tbvmP3yyher3Kvk2EG1J9Ygmc0rgfAS3nBFMgVjH285OnWwXc
	+hHZup0guBZQKwWeh6BHlnZ0HMGou4LJwwWTPpn7qs+p8TdPUYTFxgfgTStY=
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:308a:b0:4d6:90d3:e18f with SMTP id
 5614622812f47-55c0026b6eemr56404b6e.46.1792780864428; Fri, 23 Oct 2026
 11:41:04 -0700 (PDT)
Date: Fri, 23 Oct 2026 11:41:04 -0700
In-Reply-To: <67141631.050a0220.1e4b4d.002e.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6adbaa40.a6443767.132891.0000.GAE@google.com>
Subject: Re: [syzbot] [ext4?] possible deadlock in ext4_writepages (2)
From: syzbot <syzbot+eb5b4ef634a018917f3c@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, hdanton@sina.com, jack@suse.cz, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tytso@mit.edu, yun.zhou@windriver.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 2c3447a9c4fe17c713c014f79d2df485f3829c0e
Author: Yun Zhou <yun.zhou@windriver.com>
Date:   Fri Jul 24 10:02:55 2026 +0000

    ext4: validate EA inode i_nlink in ext4_xattr_inode_iget

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13436931580000
start commit:   f5bbbfec59b4 Merge tag 'probes-fixes-v7.2-rc7' of git://gi..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=158601bb8cb292dd
dashboard link: https://syzkaller.appspot.com/bug?extid=eb5b4ef634a018917f3c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14fe5079580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17e0d2c6580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: ext4: validate EA inode i_nlink in ext4_xattr_inode_iget

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
