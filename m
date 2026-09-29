Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE10237E5E9
	for <linux-ext4@vger.kernel.org>; Tue, 29 Sep 2026 00:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790641925; cv=none; b=pY+cODNHLDsaxRLoBFytJg8kAtIOz2BlmtKcQnCS0mXOIcSSh9r7pTWp+G/g8e6yUQo7kPy7ZV7LWn2QiYtat171fbA3iFKXghNwziaGMXDaTl/P47BzoH5rI/huvmEpo3IBbtcO4rdWdGSnV5+rfgdPVWq1kmwDdEjptG5AWvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790641925; c=relaxed/simple;
	bh=VBABSdUzDb/aorIuS1nDVoLmYDdSvDf3IZgxPWR+kLg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=d9b4p+aQvIDg6Fs2Zf0JUlYNZS70Zhrto2TWARhoL4APv4Eos3zmulD9iEo8quRPjpwZ55DxuDxg+gEVOVc74J4/wJTFZLrtW1Q9/fL8tFunbp67gpxBBqkZG+cDSgHCmIMXXOCYOQ4XCRLXThGZucV2yIt4zAQSlVzGrTFPPMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-46617932071so2315312fac.0
        for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 17:32:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790641923; x=1791246723;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ZLffks9/ER+F4kgvHy8nh++1FamV3QNKPwYl45V2rI0=;
        b=koT7NbNhSOoAQwH7wQS9/+xHloEWIdNa9Djv7xmEjGJwjh3chF1WJ2YjxcmOHkSe7g
         M2aWq38C70FY2fQeRsKU4XXMJoWsmcUqOySlNyb0kzkzVRg7xVaSXTB9Bi5lLhnHvq7K
         EY/EetzVQ66evRg6ZHfznDnTwJNnyuQ10SEhFbJnUQfBdygg1oXCEg/2/GIh+VIDqcBm
         duxMz/p8SXAGXwe8L6pEuvBFOFMC41Fx0y+kh86+afLQonwWahxEgzdqUkFj2Db5aw/4
         cjcNom8BMsguo77S35Et5j/E/zpY+slII0/oX+faaLWLznIORfGSuqe1PTf65J32xY05
         m4eA==
X-Forwarded-Encrypted: i=1; AKwUvBwHocfr9krjUOm3pSRBZGD8a3Zo+ZEkIW0vtZGfzK+a4tr4Ob1TGsTD9ILJsD6bsJ5ucJivD0asQJdq@vger.kernel.org
X-Gm-Message-State: AFuF++k9VKhPduMrRSB8V/F68mE1/1+aXR2hs6ead0WX+cnM4UsQ8+e8
	Z0RZThegXnxX+8HmsTUlT9L/YjxF5GCWPP1jMuj5ZkRaYAeO2EV1qC8TUJfWqGC3Rbz5bZgYHYv
	CY3p5ehMB5EaURQqWVnxXEpnX1gGx591G9w5YzCPTFdNePtm6TczNqNs7UvE=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:67c5:b0:4b2:8d89:69d4 with SMTP id
 5614622812f47-4d72a441c08mr14740711b6e.13.1790641922954; Mon, 28 Sep 2026
 17:32:02 -0700 (PDT)
Date: Mon, 28 Sep 2026 17:32:02 -0700
In-Reply-To: <6abae226.69bd487b.a6f8c.000a.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6abb0702.80e1c6cc.1e8e5f.0075.GAE@google.com>
Subject: Re: [syzbot] [ext4?] KASAN: slab-use-after-free Write in do_split
From: syzbot <syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, boris@bur.io, dsterba@suse.com, dsterba@suse.cz, 
	fdmanana@suse.com, jack@suse.cz, libaokun@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, syzkaller-bugs@googlegroups.com, 
	tytso@mit.edu, wqu@suse.com, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 3f757b56f1c4579fe32b810bce1d39f202964412
Author: Filipe Manana <fdmanana@suse.com>
Date:   Fri May 16 16:07:40 2025 +0000

    btrfs: unfold transaction aborts at btrfs_create_new_inode()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16bbf315580000
start commit:   72d3fcf802c4 Linux 7.3-rc5
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15bbf315580000
console output: https://syzkaller.appspot.com/x/log.txt?x=11bbf315580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=718e346eb0b8f38
dashboard link: https://syzkaller.appspot.com/bug?extid=09bec78ee77613a3efdd
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12379605580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=127f6325580000

Reported-by: syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com
Fixes: 3f757b56f1c4 ("btrfs: unfold transaction aborts at btrfs_create_new_inode()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
