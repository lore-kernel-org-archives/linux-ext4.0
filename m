Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795519035;
	b=IfBFvopggHfy5OHIN7ynb/QVcQtaU/sYZLtulUP/og8auNdlhKeDY6nLf2V7LgCDUUIT
	 G+p1B82gqfndSXP7b5xaKR+QjcR+jDvvYN2jKk7bYPoWtOatGsUu5xL2CGA8KMb3XaE3p
	 syROQbEW8bxF558Vi+3IdfeLm+UIIQn7RZW2LT+ZSVzs8enlhj+m+tuL35BaNqwrKpWXy
	 x+uIbj5A76riUXch9qWlIhMCM4OiB5YH5AjEr5/yJlakhYjhRJrZxQ7fE4LHPQSh8hxkC
	 qyllpqctQn+/uCbqsH4iQIz6/h8mW4oMqLY+3FSjP9Gj1ycGop9DUv82JfRcDu7W09Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795519035;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=XFLGMtBc1JZg09Phla9Biwk3NG8/cDhQq/hZlHLhTsM=;
	b=yK1FmFdj46/PgJIplTarifAp8vukMW/g7j2zU6BWrAfDxjXucRd8dx2wAb8b2dQobNzW
	 9rYofOlw8Vsx17HwNkqsPURVmxELSvUipMRie7Vb0abdXuVJNg4y3TBQb7ZuJv8wGtL1O
	 iVXC+3NWneVdUzaBiUFRWnOPTZucZXW0mSukoUA98BgGM5qP8XbgXdTiFWXlyueVvbj1m
	 MKMnMQ2Ab8GEQRIrCOtNDPOjC6iDy0Hq2ySK15jka6/DYs+MB+TAaWKeX+1MV2T4zqGUw
	 bL3PzEJ6Q5Aux+66TXZiOI3JTrh+ZJZVQ39GNn+0+Q9+Q+tVNV8R6f1f7Cv2Dt1icgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CCiLICF1;
	arc=none smtp.remote-ip=209.85.216.41
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6ACB606A31E
	for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2026 11:17:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6ACB606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CCiLICF1
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3ae7626d14aso2102833a91.2
        for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2026 03:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795519034; x=1796123834; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XFLGMtBc1JZg09Phla9Biwk3NG8/cDhQq/hZlHLhTsM=;
        b=CCiLICF1ayGBvu6pVFCgEoiCE7xlEq2HWPfuNxnzxzimTYnU8Hmki20gEH/0cHXMZk
         XICGaZBQjw+4aIHI/OpZC7cKsBoJYNAjM5lLd52Zwpy7tP5MQXFV0r/zpTnVU1FRammZ
         QNTpzJYgPfN0X/TxSSLb+tWVPCPkcwdAJvf3PcZsqYoJiwkFyeUtEf2h5KEiEO3zLK1F
         SwgfJeKNaStJFf+HJheNzKzlpnSooca/J2iUurc4JEQCmoVoDXjF9FmlZSEjO8409JPC
         7MThc/ye8h2rDzYgiUGg8r4CnnN01iGvNbHA7b/KjkK9fiVa7uoJapI8gmVWKRCHTuRg
         rc5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795519034; x=1796123834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XFLGMtBc1JZg09Phla9Biwk3NG8/cDhQq/hZlHLhTsM=;
        b=UzA8R7V9EXSwG0xOHwj9Yfu0E6rHA+74mNugjbMdgdH6rIqtqhTpfQW46t63jErAg0
         D3GmlX/NjMZ/JA3iNA0V85+EQgX+pmAvLzm3VgwfXvKMqgJ6s1kPfHyJkEfAgxMdRA46
         FFBDfLhptqyl70JxNdaqsEyNZF6SOcaQvzMlq/I6zSQ8/Qf2R3m/GCyafS1MJLnIfsa+
         VL9NmFMAiaV99AMHO/dLSCX8SUW9wrHJO2zXxpkvDm7xQpahgbDM/nTW5CV0WO4EKGTg
         KEc7a4bIwLprn41qE3ngjun16S+jnDKrME7sdTrlJhkkVak7jgQtUbeA4CvgcnsKT0ZR
         9L2A==
X-Gm-Message-State: APuU4Z+jFd0WbNZjKiMTrv592xzVmlrl85M89hsLCERD/75JmT3yI+R3
	RG50XQaZKWa/SunmGsIfoXGHHKs19GOKnpxFKmvEWEJqshtuASAEYrgv3fYzCg==
X-Gm-Gg: AZFdTZfIkXlqGSeCsfEa4o4J8a3cCir5BdCtLXwsMx+rs0wMSvk0y7JdiNUi4DZ+I9h
	McCsFW3/0PJ0fuS40yp+RxNghSESaZC7bS87K4qPBleqQ+dh5TkdhrHgH8BjqARmm/pBdCh8skf
	h8rXzH6FQY9nsNswnQ3kP4I4XmCbieNvSJM0R4Q2Ez3cNeGJkt2KdxBRUyA14CcsDue1LOO/Fao
	Ln5cHK98S5B34AnUTp2j2pIhZS31UjcogKC0hgBkRxjbzBJU6Peamn7UQ96n98QiXWQL0R/2JXH
	KdHd66DNCN4jfQ+BqetEN1gVD7kgeYIIRBJKLXNtfEuAoF3rpWutYNclij8a+csaWu7UcxLiDdT
	PVTXcqDARR1A5OBHGm4VyBezSvgom6q0nlMLjrLwLW9AosqBqz0hV6ohIeruINP4pWAyHowFlBD
	J8x/7zq6Exn1d0u+qp3HwKrZGF46MQs0mxk2oQvSBx/riZxxRHa5HflXWi5ipgfTlwwoP5y6fzC
	BPc23L8dJSOPOdAp+W0tC21NpgqOn6rMMgJsJr/wuY6d0DiyVdjP7K2QklHNT/F4lhY9oMbUudr
	TTT7JLs7nNgzDRG7hz9OH3bIUylKrzftfs74t1oQah/JEW1O80vCDtm7+RDc2Hqkz/rePzw=
X-Received: by 2002:a17:90a:e7d0:b0:3ab:e588:c275 with SMTP id 98e67ed59e1d1-3b41c8d4881mr11754467a91.20.1795519033865;
        Tue, 24 Nov 2026 03:17:13 -0800 (PST)
Received: from FLYINGPENG-MC2.tencent.com ([43.132.141.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b44b8c2fcesm7801756a91.4.2026.11.24.03.17.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 24 Nov 2026 03:17:13 -0800 (PST)
From: Peng Hao <flyingpenghao@gmail.com>
X-Google-Original-From: Peng Hao <flyingpeng@tencent.com>
To: jack@suse.com
Cc: linux-ext4@vger.kernel.org
Subject: [PATCH 2/2] ext2: Set the superblock UUID
Date: Tue, 24 Nov 2026 19:17:08 +0800
Message-ID: <20261124111708.24204-2-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20261124111708.24204-1-flyingpeng@tencent.com>
References: <20261124111708.24204-1-flyingpeng@tencent.com>
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

ext2_fill_super() never sets sb->s_uuid, so everything that uses the
filesystem UUID through the VFS sees a null UUID on ext2:

 - IMA/EVM policy rules with fsuuid= never match;
 - EVM HMACs that include the UUID (EVM_ATTR_FSUUID) don't bind to the
   filesystem;
 - FS_IOC_GETFSUUID fails with -ENOTTY;
 - overlayfs can't tell lower layers on different ext2 filesystems apart
   and falls back to xino=off,index=off,nfs_export=off.

This was found with the BPF selftest test_ima, which creates an ext2
image, adds a "measure func=BPRM_CHECK fsuuid=<uuid>" rule and expects
a binary executed from that image to be measured.  It only passes when
ext2 images are mounted by ext4 (CONFIG_EXT4_USE_FOR_EXT2), which sets
the UUID.  With CONFIG_EXT2_FS=y nothing is measured:

  test_test_ima:FAIL:num_samples_or_err unexpected num_samples_or_err: actual 0 != expected 1

Set the UUID from the on-disk superblock the same way ext4 does.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 fs/ext2/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 8a4412231394..b4df4123313d 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1007,6 +1007,7 @@ static int ext2_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_max_links = EXT2_LINK_MAX;
 	sb->s_time_min = S32_MIN;
 	sb->s_time_max = S32_MAX;
+	super_set_uuid(sb, es->s_uuid, sizeof(es->s_uuid));
 
 	if (le32_to_cpu(es->s_rev_level) == EXT2_GOOD_OLD_REV) {
 		sbi->s_inode_size = EXT2_GOOD_OLD_INODE_SIZE;
-- 
2.43.7

