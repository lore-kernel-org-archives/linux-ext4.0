Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795409310;
	b=3C0ksYJa3hG3Y3bx/bwWO/sYY7N4sEexPenY47r1vY5rlfJ0hPHpYaU07iK6+L1i1us9
	 raiG9Xph+S/rqKcrucKWKNrAoin+n8Gf34CJzIU5c8cl2Ju2/S4teAo0P+JYU6xTfy4Gc
	 F7XGCw85rqPydBuWod/h0MriES85uCsvQFd2NOtU581Se549F/WDjJUyjSNVa3yjbHFtC
	 7GGAuzrpspjzs4ZO4IWY4JnKRP08jO5MKZTDRqQIkL+7HwDRZuBMveovVUJY/3xVwQwd5
	 S/m/28fvT99ldDsQf4QGgLlEr/UBrBhCjGtGMhBAbsIa94pwZpEzgrVFm3yW4+ex1Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795409310;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9LwHk4+XfiVWcini/p0wITn3rkrF/emyL7uB22g7Jlk=;
	b=S576lWq/5TXesxJaCMHiDGq3d/GC1FrkONJQm7iBeKpU18q6BNEJcBgnRW26NLhGjfxZ
	 mmy+NHrHHvoSolfd0UApFcif1XY/euY8lEBCpYIFh3+L+yDXyEj9OSWLxpGZODVzzWMIz
	 4i7t86b14PMogZkZf6ddOv4xbP3SIsYhdlJ2wRJx+cFlubRi8BdXltUAASCgZz5mpiR0m
	 F5JWn1nEKCdgE3JY9y6PJOYScuqS/A0reJ8Pg2vvmgnKWElQKYNhAyYxOQjENoWuvGfVP
	 EENmtwTtK0HFedxlgyWFnyJFnaWkg1jjiTpDEIyi2BTwjvq0uuOroylDfwCkiaJ7Lug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U4pvZ29H;
	arc=none smtp.remote-ip=209.85.214.172
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A7C606A31A
	for <linux-ext4@vger.kernel.org>; Mon, 23 Nov 2026 04:48:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84A7C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U4pvZ29H
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2f0621eec70so14565635ad.2
        for <linux-ext4@vger.kernel.org>; Sun, 22 Nov 2026 20:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795409310; x=1796014110; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9LwHk4+XfiVWcini/p0wITn3rkrF/emyL7uB22g7Jlk=;
        b=U4pvZ29HOzdV8hRsjlq8fUDu5eD6Hao2TSMu3A/a4DaMM1miFQtdTt4H+5FsloL783
         DoNPKDoFc1HaEkE8t6u9S3xRVfycuVAtvUE69BjNOwNSc/nfm8D0TGX7yGA+tL4KR0Do
         cgDiCv4rL3qplEFlEdH5a31WiK0w1mEa2TmCZ8DfEKExnIli+Gb4G0UxHAnPjaGULxN0
         q6n6u7L0UL4gW2OnnLO/pMMKaJ6SqjvQ8bIe1wThDdlJ0AkcLMInq1VIXPxC64UtFx08
         EU2MFQ/ncJIqGAzCmh/K5D7vZL2wb2D9XrBr4uwvFzR4QO6jTIOs+FxQIhSObQGKchLU
         3bng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795409310; x=1796014110;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9LwHk4+XfiVWcini/p0wITn3rkrF/emyL7uB22g7Jlk=;
        b=qb5XdeVhQMpwGpivm2jQr+ruSWtfNPHU+8llT5WQDgAFv6qAS3nT2J74VXyhgY4l23
         zNso+8mfMjivMrOHXcaW8AT7i4eAIiXqrryjOvG6NyP3lRshmosLmlcZDAaDpttt8Sqj
         wTbJuLHTBc+y392xh1GAy++SX/9X3eWPsRkd3JLQlw1uQRAP6xsKcr3QUhMuM9vmCWaT
         ld5mwazGpXUjaILjXGe+jE7XusOYwKCyt/pmejAWgqyzx+Fd68zHY0oqSwjHKf8hJi7A
         XIwguAqixgSIlNygw72+vgoyDCm5Ei0mC9MfYc480zOEA3bzQ5rG0ziLngp+AhUpC6PT
         RQaw==
X-Gm-Message-State: APuU4Z+8VadoUfyyOL1aCdWsBXHJh2q2xVt0UC427e7LdLOqliZDS4jV
	BPO9/D4JVF3o+fHLJTr8XpXp617SheO0LwN2z+Yiwg5Uha3MddbVQIfw
X-Gm-Gg: AZFdTZc/YgZZQAqiVVpNQDwFkDXAFen/TZF+oJ91Nv3IfBaP1M9pVq1348GFhGAepLd
	0x+EDzQHR4RZrqddQyQycUebSVnwaDHkmllDKqjVg/j2wFFSFSaWvfAfigrhDML7MqxjdeN807U
	Ggo4FpfTsMrq+Ks9j4a4o4pgdK7O84DWc94sHPUYQyehMWJUeKLtslu6quVOF8MM6jbTXV1/pJM
	MAQFcNreCUylowaTryMN/CO21bkxeH3fiJoX9AtZAfbF3THq61RWjTO1X8MmSEoqT64xs9meGHy
	D1sizVhHnmemtlMNkY1fQBBh2FLfOlcz7UPCHxspieu2dq0QiH74ArJ1+/jAnPuaoPsG0pLYZDi
	5rJML+vtKMbS+cj1K+uemgr1B8cH4+dsTBO58txiM8jeTPheIytI9AvukcuGkZGAqYLBiMgOERq
	JvGWS6xzq7A30/w2wCRk3/VUdbv48kkDeFFthe3+styYdFF8/86lqBEgZ1trnKpQtCTZQ2ten22
	FOBayHRMjADWDCJTl3JZdluYP/Zq+90r5LdE/40ZHCcyN/YW37cPUGtZWp4BRxr9Rs0E2PUEQRq
	idDp1i3Bux7TyxyuLsqKMmMYE2k0k2jfi1gXm/w5rUtboVqyZUR6gEf6lFU1b6vUiPnP1B4=
X-Received: by 2002:a17:903:41c2:b0:2dd:b795:9cb6 with SMTP id d9443c01a7336-2f03f1cfad8mr109002225ad.21.1795409309830;
        Sun, 22 Nov 2026 20:48:29 -0800 (PST)
Received: from FLYINGPENG-MC2.tencent.com ([43.132.141.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f120830sm45356575ad.61.2026.11.22.20.48.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 22 Nov 2026 20:48:29 -0800 (PST)
From: Peng Hao <flyingpenghao@gmail.com>
X-Google-Original-From: Peng Hao <flyingpeng@tencent.com>
To: jack@suse.com
Cc: linux-ext4@vger.kernel.org
Subject: [PATCH] ext2: Set the superblock UUID
Date: Mon, 23 Nov 2026 12:48:26 +0800
Message-ID: <20261123044826.93953-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.47.0
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
index a40f530872a4..5e36007b3ffd 100644
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

