Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F0C389108
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 06:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784010718; cv=none; b=FFQ7TWdrp6INNvBHvKVPCaRLsd8eek4A4rgy7IP1WT1lIdBpLhq6BXgO69r1m1lLtQC9D60lFqnR76bNQjIk6p3+D+b0b199iT9p3Ct8ITuN1/ti1iLXj4RurvwAraMn4+3PfVtRhW7pjAFpEhukAgFeFSNDWg5dbtWrn0hpDZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784010718; c=relaxed/simple;
	bh=/oV41zv5X0LM/MheSekhf3Y9KtgQxdn7aghusowDZwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTrbuk4JmeDVJDhe0o5zwicoOShGCA+69wPpu9m/cLJA45qu6+diSbXlVkm4OFGJ67SoeycEayII5yclYuoaKvVs5pfTziTmhj/54PLVTLe01Lh76lJtLOuZxP1Og7ZPF1FgLNnHzeJ7vW4zZv960NwqqSNZTOasbpow+9Gc0U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=JC8XTUBR; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="JC8XTUBR"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784010707; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=itTaMvMLxHPDuFMDgtjystvGHi2gmWwGuLMX5wftSDg=;
	b=JC8XTUBRfy7u9WupLbOWPy6cx0M1IXxZSIl6rgs+JRBm6mu79YLyE26aKv+zKqCeFZGCwmh2VmhyOtvXzSQHQCKqO1X1yboboh+IMboOz4POQA6vcFpezU/ZDKYNfvY5g+u0yUU83dNNhiqVT0H2pV/n4sW+XBaiTzVnVxsQTL4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X73IA0s_1784010706;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X73IA0s_1784010706 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 14 Jul 2026 14:31:46 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com
Subject: [PATCH e2fsprogs 1/5] fsck: consume -l option instead of passing to e2fsck
Date: Tue, 14 Jul 2026 14:31:32 +0800
Message-ID: <20260714063136.1284287-2-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260714063136.1284287-1-libaokun@linux.alibaba.com>
References: <20260714063136.1284287-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The -l (lockdisk) option was introduced by util-linux in commit
dd0bd943f9 ("fsck: add support for whole-disk locking (-l option)",
2010-10-26, first released in v2.19). systemd-fsck passes -l to
/sbin/fsck for parallel fsck support since commit 87c3e6c ("fsck:
pass -l to fsck").

Currently the e2fsprogs fsck wrapper (misc/fsck.c, installed via
make install) does not recognize -l and passes it through to e2fsck.
Since e2fsck's getopt string declares "l:" (requires argument), it
consumes the next argument as the bad_blocks_file parameter. This
triggers a chain of failures:

  systemd-fsck -> fsck -a -T -l -M -C6 /dev/sda
    -> wrapper consumes -a,-T,-M,-C6, adds -C<fd>, passes -l
      -> fsck.ext4 -a -l -C<fd> /dev/sda
        -> e2fsck getopt: -l consumes -C<fd> as bad_blocks_file
          -> journal recovery
          -> orphan cleanup (orphan inodes processed)
          -> fopen("-C<fd>", "r") fails -> E2F_FLAG_ABORT
            -> superblock not flushed (s_last_orphan still non-zero)
              -> kernel: "bad orphan inode" on next mount

This is because the e2fsprogs wrapper lacks a case for -l in its
option parsing, unlike the util-linux wrapper which handles it
correctly (lockdisk = 1).

Fix by adding case 'l': break; to consume the option in the wrapper,
matching util-linux's behavior. Users can still pass -l to e2fsck
via the "--" separator (e.g., "fsck -- -l badblocks_file /dev/sda")
or by invoking e2fsck directly.

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 misc/fsck.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/misc/fsck.c b/misc/fsck.c
index 44577590bca5..cb935e1b4b71 100644
--- a/misc/fsck.c
+++ b/misc/fsck.c
@@ -1212,6 +1212,9 @@ static void PRS(int argc, char *argv[])
 			case 'M':
 				ignore_mounted++;
 				break;
+			case 'l':
+				/* lockdisk option from util-linux fsck, consumed by wrapper */
+				break;
 			case 'P':
 				parallel_root++;
 				break;
-- 
2.43.7

