Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.254.49.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793528518;
	b=lkbcnZIQ+mXGyoripTGw2DCpTxPNSg9/T6vHw3JqJtyKbzsHIfSXunt1nxwNo06nZqq4
	 Em2m+kde3+/xIH9RDHlhd0qN2AoM8VogonuIOtBG0Fbq94sA4AYQGq08VbWd9V6tASGHv
	 rtZUKbjIDxC8KXRuaZ2aF3PJplZmQPwnKsedXkqYtT3vi+lSxdfu+aSsKxSzZRtB7Zoki
	 OBF0y2ndTvDm6BR78ixRDt8Nh+CqNkPTaOJu5UCFOHbwyxQ1GKgP1rv9Io99Pxl8fvNRK
	 JgFHV/rGkG7iO0u4rOLlEUsocexIeeT1nE0E51C9+TJ+3rzOeY0hr7adnJ//UGhPVJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793528518;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 X-HM-Tid:X-HM-MType:X-HM-Spam-Status:DKIM-Signature;
	bh=3z57bIMXIND8G5rY6VRLuXH5ZQ9d9/N9uPr3oSByqgo=;
	b=BU698n68a54sjDaEexNorUeawdJIEysK+Zp3oOsgpu8n+qPAfJ/eq2VMu9v9OE3XfCW5
	 tpl90ifYWQLk+6wuq090wrNJ2pCgH+y5IlDPeiCLy6H8K2iC/A1gwtM1Z4FRWveMunBMO
	 V+rw2UUa4tJcIITOXTa808WdwN1q2Rgyt6FWlwUsNEjvM4WQId5IQ01TklxfQrHxv6YnO
	 ihNS9va3KsedP1krnz9wbaaW9yh5OXv6LUhBGV5QD75GsEc3AZsSHc5WoIHi8a+aYsOs0
	 V22qgqJ/W58A7UhOsPC6jMAz9BgqUo4WpRFVI3bKn1p9KYf1ODISBjnMuh4H0OMK2Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=tju.edu.cn;
	spf=pass smtp.mailfrom=tju.edu.cn;
	dkim=pass header.d=tju.edu.cn header.i=@tju.edu.cn header.a=rsa-sha256 header.s=default header.b=ewsQVTzr;
	arc=none smtp.remote-ip=45.254.49.198
Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E904606A324;
	Sun,  1 Nov 2026 10:21:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E904606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=tju.edu.cn header.i=@tju.edu.cn header.a=rsa-sha256 header.s=default header.b=ewsQVTzr
Received: from localhost (gyproxy-mailtls2-entmail-virt217.gy.ntes [IPV6:2409:8d28:136:d3d:cd91:ad5e:f000:5295])
	by smtp.qiye.163.com (Hmail) with ESMTP id 531059eae;
	Sun, 1 Nov 2026 18:21:48 +0800 (GMT+08:00)
From: guolingxing <guolingxing@tju.edu.cn>
To: Jan Kara <jack@suse.cz>,
	Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	guolingxing <guolingxing@tju.edu.cn>,
	stable@vger.kernel.org
Subject: [PATCH v2] ext4: report unwritten extent conversion failures as writeback errors
Date: Sun,  1 Nov 2026 10:21:45 +0000
Message-Id: <20261101102145.647496-1-guolingxing@tju.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261015102943.74632-1-guolingxing@tju.edu.cn>
References: <20261015102943.74632-1-guolingxing@tju.edu.cn>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa196a12f4f03a2kunm512d3c44a6024
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZGB4dVkxOSE8YHx1CSBpDHVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJT0tCQUMfSUNBSkhNQR9IH0EYH0JKQRofTh5BHUtLS0FOSU
	JOWVdZFhoPEhUdFFlBWU9LSFVKS0hKTExJVUpLS1VKQktLWQY+
DKIM-Signature: a=rsa-sha256;
	b=ewsQVTzr0EEilhB+js5lmjC2bRzqPvrOis2pxmiYr3QJkp414/Kzhm2RZS/dQaqS0trhm0sMijJzD6s4fwDigFQSSxJ4WDPxNCvo4TL+jM1KhNFPzItMnbabDJaSwNbiWEeG4LmdWyBM+L/Wa2cZ62ZheCcYYFfFvKH2cafoxX8=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=3z57bIMXIND8G5rY6VRLuXH5ZQ9d9/N9uPr3oSByqgo=;
	h=date:mime-version:subject:message-id:from;

When a data writeback bio completes successfully but the subsequent
unwritten extent conversion fails, ext4_end_io_end() does not record
the error in the inode's mapping writeback error state.

Bio failures are already recorded by ext4_end_bio(), but conversion
failures are not. When the conversion is processed asynchronously,
its return value is not propagated to userspace, so fsync() may
return success despite the failed conversion.

Record conversion errors with mapping_set_error() before
ext4_release_io_end() ends folio writeback and wakes waiters. This
allows fsync() to observe the failure.

Cc: stable@vger.kernel.org
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
Reviewed-by: Jan Kara <jack@suse.cz>
---
Changes since v1:
- Drop the incorrect Fixes tag. The conversion error was already lost
  before commit b82e384c7bb9, as pointed out by Jan Kara.
- Collect Reviewed-by from Jan Kara.

 fs/ext4/page-io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 734d856a6d478..2701452fa65ca 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -192,6 +192,8 @@ static int ext4_end_io_end(ext4_io_end_t *io_end)
 			jbd2_journal_abort(EXT4_SB(sb)->s_journal, ret);
 	} else {
 		ret = ext4_convert_unwritten_io_end_vec(handle, io_end);
+		if (ret < 0)
+			mapping_set_error(inode->i_mapping, ret);
 	}
 	if (ret < 0 && !ext4_emergency_state(sb) &&
 	    io_end->flag & EXT4_IO_END_UNWRITTEN) {
-- 
2.34.1

