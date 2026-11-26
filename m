Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795696579;
	b=gRWiodMhr16cwTucgZUQSywbxHX6i3v8uW0mHP9RJS87ZUHdkClu1yz7G2TmKjAAvGRH
	 Hs2sMuFYlKcPsSMnObI3vgR5dnLA39uq4KzGNLJWqpQPIRh7rsAZ1DCduO5ZELjs4NRSo
	 CPYVXx+J9dGrH9Qm0bOOKItITBW6RvX16gmBvvZlFIO/O1So9WaeRsSXxGm0Eu/oKmpiC
	 PFVdIHZPtnv/TImbIg/a7qGKkH2aO7qN69ULdk4SMn+f1X29aRypCUPSmEbiOSHz/uY+r
	 Fptn5eHOSpKmRQ3oCiljRXq8x1WkC45xDVmgmJkLZ+89gLTFgy7XWoAwywTli6LEixw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795696579;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=BmdiVA37wXM2LN2Yev8MJKhtjXYfTyf9SjBGywadq0M=;
	b=IArBvE628ugsuBmIR+iDtk76GphMbHRRPlZWWplrIXJjIPEpZITqs0RiyuoVWvUjAiur
	 AMLJC+oa14rqAgTzsXpUxR5tnuMjXGs51S6jLrnttVrwH4M1Qlcp1ipmOpsWv3HjXfkGz
	 COAr/27n3tuYBhiwGNLGpc0mYhVO1ltL+tshBo1TUwHsLKmD+7XVqtWCOY1ARuP5pySTM
	 2TxFLgGV8vy0genJv38FPf317oSImh/SNHu5XSDJnDN+EpZMBubhdJ2+eUNDBEpgMM1yN
	 zOoPslFEI03dom0XgeOv6Td2MsltLKo7gtBIW9VIn58gDMa/xwsIw0SlwiqddAr5ltA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.112
Received: from dggmsgout12.his.huawei.com (dggmsgout12.his.huawei.com [124.71.93.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A39606A31C;
	Thu, 26 Nov 2026 12:36:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3A39606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggmsgout12.his.huawei.com (SkyGuard) with ESMTP id 4jZwyK0tPBz20D8;
	Thu, 26 Nov 2026 20:36:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7C46040577;
	Thu, 26 Nov 2026 20:36:14 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAXTu29JwhrXPqGFw--.16525S4;
	Thu, 26 Nov 2026 20:36:14 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 0/2] ext4: protect quota acquisition against filesystem freezing
Date: Thu, 26 Nov 2026 20:36:09 +0800
Message-Id: <20261126123611.2517017-1-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
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
X-CM-TRANSID:gCh0CgAXTu29JwhrXPqGFw--.16525S4
X-Coremail-Antispam: 1UD129KBjvJXoWxCr48uFW3Zw4UKr4fZr1rtFb_yoW5GFy3pF
	Z5C3W5Kan5JryIkrZFya13Z3yFy3Z5ZayDtrykAryDZFnxXa48tF9Fk34F9FyUZrs3Cw1Y
	vFyIyr9F9F47ArDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

This series fixes quota operations running against a frozen filesystem,
and the resulting freeze protection for ext4's dquot acquisition.

Patch 1 makes Q_XGETQUOTA/Q_XGETNEXTQUOTA consistent with Q_GETQUOTA and
Q_GETNEXTQUOTA and forbids them on a frozen filesystem.  These commands
may end up in ->acquire_dquot() when the queried dquot is not cached yet,
and thus may write to the filesystem, just like Q_GETQUOTA/Q_GETNEXTQUOTA
which commit ccf370e43e08 ("quota: Forbid Q_GETQUOTA and Q_GETNEXTQUOTA
for frozen filesystem") already handles.  They were historically treated
as read-only because they come from XFS, where quota is always coherent,
but generic quota now routes them through dquot_get_dqblk()/
dquot_get_next_dqblk() and dqget().  Running them on a frozen filesystem
makes ext4 start a transaction on it and warn.  As suggested by Jan, they
are now handled exactly like the generic commands, including taking write
access, so a Q_XGETQUOTA on a read-only mount will report -EROFS; proper
read-only querying can be added later if somebody actually needs it.

Patch 2 protects ext4_acquire_dquot() itself.  A writable open reaches
the filesystem's ->open() callback without superblock freeze protection,
so ext4_file_open() -> dquot_file_open() -> dquot_initialize() can
acquire a dquot and start a transaction after the filesystem has been
frozen.  Take sb_start_intwrite() around ext4_acquire_dquot() when no
transaction is already running; running transactions are already
protected against freezing.

Patch 2 relies on the preceding patch 1.  Taking freeze protection in
ext4_acquire_dquot() while holding s_umount, as the Q_XGETQUOTA and
Q_XGETNEXTQUOTA paths do, would deadlock against thaw_super(), which
needs s_umount exclusively to release the SB_FREEZE_FS protection.
Patch 1 forbids those commands on a frozen filesystem and thus makes the
new protection in patch 2 safe.  Both patches must be applied together.

Changes in v3:
- Rework the quota patch to simply forbid Q_XGETQUOTA/Q_XGETNEXTQUOTA on
  a frozen filesystem like Q_GETQUOTA/Q_GETNEXTQUOTA, as suggested by
  Jan Kara, instead of only waiting for the filesystem to thaw.
- Document in the ext4 patch that it depends on the preceding quota
  patch.

Ye Bin (2):
  quota: Forbid Q_XGETQUOTA and Q_XGETNEXTQUOTA for frozen filesystem
  ext4: protect ext4_acquire_dquot against freezing

 fs/ext4/super.c  | 20 +++++++++++++++++++-
 fs/quota/quota.c |  9 ++++-----
 2 files changed, 23 insertions(+), 6 deletions(-)

-- 
2.34.1

