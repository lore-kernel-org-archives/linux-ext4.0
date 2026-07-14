Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5719F3DB337
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 06:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784010718; cv=none; b=jkqRGbm20yqr8FyXHlngKFNNvC7uvubj2/Mg9/aF8P8kgMHAnciRMcHLEq4j/aW9LNCjA416hprCYvJQUlAprjOMu1wGhH6LA1nuyJw9rHtr3lES7q66GL2bEUOZHQoEH1bioznrmLXjty6Jm8684jRroGZJTkGE0+DB9TDr1J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784010718; c=relaxed/simple;
	bh=joSuT1DG4Eg3titRvz/hRVyLwTSdSH9Lwtw2g5P33nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ak5vVkGcu0LInMxD7F5PxtfQtMA6na0zemWAlsRbudfQ4APqaXqNYlJzsxSESVAFTmSFZ+Fm9go5FkCNHO9zCAFuXFVSzCONXiBfc87tcOeguRyMdi7KYnB4oH+f4mn0xandMffNzGoxMdivlXGI30kUz2uuk64MbZdt8IFucFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=jMet40ge; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="jMet40ge"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784010707; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=m4y6BeESVK27o2CFYq/6maYrhad3JTRweprWmGyq5Tk=;
	b=jMet40ge9p0b8wkUzzkFnIQ1k6cx5bg8Ej1RUm9PQ2TkVd8shw6pua6iZVQ+odbT0FNZ3xPCEPSDp+XcgYqkwxreu4nIYo4la5uoHPcaE//ihrTit6otwZfGGmyfqWg9SXiyfaYFmmFLSkXm7eHaOWZ0sYIvvQhO7RPLy8D+gN0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X73IA16_1784010706;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X73IA16_1784010706 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 14 Jul 2026 14:31:47 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com
Subject: [PATCH e2fsprogs 2/5] fsck: fix -C fd option parsing when fd is a separate argument
Date: Tue, 14 Jul 2026 14:31:33 +0800
Message-ID: <20260714063136.1284287-3-libaokun@linux.alibaba.com>
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

The e2fsprogs fsck wrapper (misc/fsck.c, installed via make install)
supports the -C option for progress reporting. The fd can be passed
either attached (-C6) or separated (-C 6).

Currently the wrapper handles "-C6" correctly, but fails to handle
"-C 6" properly:

  # fsck -h | head -n1
  fsck 1.47.4 (6-Mar-2025)
  # fsck -C6 -N /dev/sda
  [/sbin/fsck.ext4 (1) -- /dev/sda] fsck.ext4 -C6 /dev/sda
  # fsck -C 6 -N /dev/sda
  [/sbin/fsck.ext4 (1) -- /dev/sda] fsck.ext4 6 -C0 /dev/sda

When "-C 6" is passed, it is parsed as "-C0" with "6" leaked as a
stray argument. This is because in PRS(), the separate-argument branch
uses argv[i] (which is "-C") instead of argv[i+1] (which is "6")
to parse the fd value. string_to_int("-C") returns -1, so progress_fd
stays at 0 and the "6" is never consumed. Later the wrapper generates
"-C0" from progress_fd=0 and the stray "6" is passed before the device.

Fix by using argv[i+1] to correctly parse the separate fd argument.

Note: this is the e2fsprogs fsck wrapper (misc/fsck.c), not the
util-linux fsck wrapper (disk-utils/fsck.c) which handles this
correctly.

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 misc/fsck.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/misc/fsck.c b/misc/fsck.c
index cb935e1b4b71..318ecfcb4102 100644
--- a/misc/fsck.c
+++ b/misc/fsck.c
@@ -1188,7 +1188,7 @@ static void PRS(int argc, char *argv[])
 						goto next_arg;
 				} else if (argc > i + 1 &&
 					   argv[i + 1][0] != '-') {
-					progress_fd = string_to_int(argv[i]);
+					progress_fd = string_to_int(argv[i+1]);
 					if (progress_fd < 0)
 						progress_fd = 0;
 					else {
-- 
2.43.7

