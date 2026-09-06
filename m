Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8692E7367
	for <linux-ext4@vger.kernel.org>; Sun,  6 Sep 2026 10:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788691730; cv=none; b=eoKQ1rK0xV141/eWv3u3hvXOKFEU+cVIBRI7ewI3e8b2RFcIrL9wYHpCyNfrmT5QACOdhK/qqo11L9YjTZLez8hLqTtpXyA63sVMVKFozGU3cLBr0Zqoq8olZ2nap5/dUqQyW5vf/sm9t9Bsl/0vcDRQtiEReqLoZ7H45CZJQLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788691730; c=relaxed/simple;
	bh=RmUqCgZ9L6DO7/W5h5AILnii8iFAuwgpG2ZXNyAa6vg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YrE/Qmmp/ERfNubCPzpo7A6bOfXTI4FcBdFSrRJ2ZsHlx+KavyOpBwuEzPVO5bQXhAlYJCEA2Qcwn0nlDL0LAXJo/cLxtR6NWR1ioYA2M6/82qLC3W7RJuu8W+H4cJpskdZBhfulgKcCigbCdL5go38Q97SKyiNPZrE7vcORLGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q/IZW05T; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q/IZW05T"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ce98cb8165so25893025ad.1
        for <linux-ext4@vger.kernel.org>; Sun, 06 Sep 2026 03:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788691728; x=1789296528; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Wv1cfZwLKzZeWrvuS+xOzOTfsWHJrJaMBO0fO2QG8Mw=;
        b=q/IZW05Tz9CUSIYeTJEZP0nFGFV2iXet95I/jD/wTGcPPovWHXgysQfLq9wMlW8892
         7cYlEEjsDDwKrngwKH7wz90tSD4rn/NFib6IqPcarT30dlX7m4qpWhnbU813Zl+3/ESf
         L0V0la7P03NUJVAU6p1ZrPj6DdPuYHkH/FIK5Ig8k985Qv6nIbpImyayPnIFgQQ7Jh+k
         4GsxP+3vOaCgyn9aaAv/Y9s2cx1cIldfq+g1GzWNNMbb4+EX8M69FxZs2TJ6m5lnQ/N+
         RgOn0uCu+0Y10sKsQpm/qqiVmQVPgnCrgf5tIwhqq9VelUcONZsRxHapq0Xe5vPCfZVX
         Y9zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788691728; x=1789296528;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Wv1cfZwLKzZeWrvuS+xOzOTfsWHJrJaMBO0fO2QG8Mw=;
        b=dKnILcFnyo2/TVdswhlcw/qELf+205g+hpFrveEsM4OrRCFqprv4hHWwqFfz+yeRtA
         ph+navY6H1B/rrfLC6PeRrGnW3fseYIVQ50Uexxp5jl75KWj/21LYbmsswnpJwiQpz+S
         mjRQKmgJRi3Gq1PLY7ix6dcFan87wMAr9Y44y6uTo8+10qRJcxk293Zq7GNM+xs57Md5
         Emm8/bA9rdKryizZDrYVpdRbQtXVMYQ7r0tz/x/QLXSg5fXWkSDvo+hhqsQbc/3+GRg1
         GmX4yZNdgrAGwEinMWvx4pdnRpUXqQ8eHXoJWVAS2rTfYfrky20mgvWD60t6R+lXwc1v
         qhVQ==
X-Forwarded-Encrypted: i=1; AKwUvBwv33KA/wwxWP4m1W90M+qWLupQRV/2uJjVgDC9MZ/zAZY+JmajEc/YeYiVk6O9/RZnspXH540rP8tP@vger.kernel.org
X-Gm-Message-State: AFuF++nc270ELzxebz+afcfjVSyqiKcoLZteqwhz0Aa/GCNh7jQ++0DM
	UmpOfbjYn0l+lm7igN+Z7ZGzqb/lL2QBRrDto9yAp+BWzBporuLExLhB
X-Gm-Gg: AYBFou3Qz/whIslGMpP+05exfNKMMLY2Mi4SP8ehJyO2q3MTcqG39DW6GtC0qDWdHTH
	KDt+StAT9FTqV/mCPnOXQ8yrk76aXns9WmGg6LECcJEfZBMZ3DhqW2m4qR4sAMC+3o31TtFbc/U
	LuIS/yWfKFBagAZ2q0j7oyrvApmkLTOgWMfZMrXJIw8iivvX4KAOuNerHwl7U8NGI82LYkbbDvS
	qCsevzMszNkzIV6/fItcQyYJxQNiIkCdkEqLkvw4npM+0MC3sDVOlfiDHzIyWMCLpkXlx/YcGxL
	pOSaaJaanuc9k636qi2ROpuI7iIrIokPpZ8QGAp708vhDYfwEnMz8XdwhSbhqnYLLCRqPICdP3O
	szB05HZxZ9bDH+R+gDNUfAWMZzdEoxrZGkfVH3ySt8wWBB46Net7cMQSikgl+ZqFFBps9klozkZ
	C33/+yyNMoDTRmR9YadvUpPBGHXvYqZ4gVTZ9VTqay4WVro+jxsRm0i3bSaTp7z4PM642kRhYnF
	elCn1rM
X-Received: by 2002:a17:903:1247:b0:2d8:d4d2:d137 with SMTP id d9443c01a7336-2dafb136bd7mr198929335ad.19.1788691728133;
        Sun, 06 Sep 2026 03:48:48 -0700 (PDT)
Received: from thangnn-ASUS.. ([2405:4802:1d38:5c70:7bb9:b8bf:8aa8:fb0d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db14aeaf74sm31452185ad.81.2026.09.06.03.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 03:48:47 -0700 (PDT)
From: ThangNN99 <ngocthang2710.1999@gmail.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ThangNN99 <ngocthang2710.1999@gmail.com>,
	syzbot+03afbb29537f0336b7ad@syzkaller.appspotmail.com,
	Claude Sonnet 5 <noreply@anthropic.com>
Subject: [PATCH] ext4: avoid buffer/folio lock inversion in __ext4_get_inode_loc()
Date: Sun,  6 Sep 2026 17:48:41 +0700
Message-ID: <20260906104841.56075-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The itable-block bh is locked, then the "is bitmap cached?" probe calls
sb_getblk(), which can block on that bitmap block's folio lock. A
concurrent block_read_full_folio() on the same bdev folio locks buffers
in the opposite order (folio lock, then each bh), so the two tasks can
deadlock on each other's lock. Use the non-blocking cache lookup here
instead; a miss already falls back to make_io exactly as before.

Only ext4_reserve_inode_write() reaches this probe with a real inode
(ext4_iget() passes NULL, which skips it), and it normally runs right
after the read that loaded that same inode, so the itable buffer is
still warm and the early "already uptodate" return skips the probe.
The window needs the folio reclaimed between load and writeback, which
is why this is rare and why syzbot's bisection could not pin it down.

Reproduction status: root-caused from source and confirmed against
both syzbot stacks (inode.c:__ext4_get_inode_loc vs.
buffer.c:block_read_full_folio); the lock_buffer()/reserve_inode_write
path was exercised live (orphan cleanup on mount) to confirm reachability
and to confirm this patch introduces no regression there. The deadlock
itself was not reproduced locally -- doing so needs the itable buffer
genuinely reclaimed between inode load and writeback, which a small
single-shot QEMU test doesn't naturally produce.

Reported-by: syzbot+03afbb29537f0336b7ad@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=03afbb29537f0336b7ad
Signed-off-by: ThangNN99 <ngocthang2710.1999@gmail.com>
Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
---
 fs/ext4/inode.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index bd4b778df9eb..13e3cb829461 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4942,8 +4942,12 @@ static int __ext4_get_inode_loc(struct super_block *sb, unsigned long ino,
 
 		start = inode_offset & ~(inodes_per_block - 1);
 
-		/* Is the inode bitmap in cache? */
-		bitmap_bh = sb_getblk(sb, ext4_inode_bitmap(sb, gdp));
+		/*
+		 * Is the inode bitmap in cache? Non-blocking lookup: bh above
+		 * is locked, and blocking here would folio_lock() against a
+		 * block_read_full_folio() that locks bh the other way round.
+		 */
+		bitmap_bh = sb_find_get_block(sb, ext4_inode_bitmap(sb, gdp));
 		if (unlikely(!bitmap_bh))
 			goto make_io;
 
-- 
2.43.0

