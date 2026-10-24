Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792857918;
	b=VR6mhRDIKUuaGd0nBN3JEdUB5MJpX285qjaTyJ2dZhajemkKfJEspeAfYJlTcyPBGOx7
	 /bba5WAANbXVX6wiOKK7ocDeSWVlb8+jitvGRpIhPw8I+5ShAyz4brKApagf+7E7G4g1D
	 BWglZK36C6Z2AxXOTBwEi908zImIkQo+82S+Si10Bsy8oX1bPc65kuoSyX02FAxOoMidW
	 RN1kxvt2idnMa+eTcgYOByzuao4GzLyK2+Sw/2q71DqTnq6WXyKT3mOWI4WEAvOIA/UJo
	 oL/GoElyFT+NYYFrCWNaFqNH3IX9j/k4Ri+WWLbd1xz2CTtzahUPGWd9QwEtI0kT9Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792857918;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=hg/xM/fhrYdXH5V/+pVkRTixW33zqZoPai4puh8v8bs=;
	b=EBZ9/9Swfn0Z55sp6FeHU5XOsm7N9s1KLSrpURKprvIX+9usluLl1+E7axThEEqvHOY8
	 zT0OFA4cA1jKplo4HeIvvHzo6FTe1vFprfPVsZS3dmwCNQudmOT7utB23AnmOdxITvpxE
	 3Y2MbSZmLr4W2ZWDDQObL7YolOvZfm21QjVn1L+ZHt/1Yf/0+W694aQDY3RREoEOYt53R
	 xU7JchZoLV3WRK82T8yC9vITjLSNMfQqfxq+DrCJe6swQeaevWnDYy1iV5ObB1TpwV6fq
	 qofQSzm7jB1XQqlBxt/DpktHGCV7bXjqYuiWgHKfO7wQkQWIJyYZvpd4g40fHHUECww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=czerner.cz;
	spf=pass smtp.mailfrom=czerner.cz;
	dkim=pass header.d=czerner.cz header.i=@czerner.cz header.a=rsa-sha256 header.s=protonmail3 header.b=BQfo2758;
	arc=none smtp.remote-ip=109.224.244.108
Received: from mail-244108.protonmail.ch (mail-244108.protonmail.ch [109.224.244.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79684606A31A
	for <linux-ext4@vger.kernel.org>; Sat, 24 Oct 2026 16:05:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79684606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=czerner.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=czerner.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=czerner.cz header.i=@czerner.cz header.a=rsa-sha256 header.s=protonmail3 header.b=BQfo2758
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=czerner.cz;
	s=protonmail3; t=1792857913; x=1793117113;
	bh=hg/xM/fhrYdXH5V/+pVkRTixW33zqZoPai4puh8v8bs=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=BQfo2758mvJDxAF99qkzl4Nw/bkCRcaR8uybYH/lzSbSRGZyRY2hFy/jEf9mSvPRb
	 k7YBGTIIJOU90xkpgDllBV/QFfAaZwzlhngIIZEiHG/2BmarubK8ALMqxlPBU6+jaJ
	 LnPHeGQ320acxg3OV5pD1ha/RFgBgHZ1FHYT3pkEVj4w+894b7I6njD54s99AmGWSj
	 1/1kvzHPKG7GSmGXni1bi5RGzxuh37Mo6wDIuQi2JQZvfrIUBxJDcdiV203mCGxvUD
	 g6mL0JBwNnRyfnio+YbO/fbk/xMqGCGtq1izyo/+IlpKEZHc8NEReb2E56JeZFlqBM
	 WLSfkZKnI0jGA==
X-Pm-Submission-Id: 4jBl8m2CyXz1DFSy
From: Lukas Czerner <lukas@czerner.cz>
To: linux-ext4@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Lukas Czerner <lukas@czerner.cz>
Subject: [PATCH 0/4]  e2fsck, libext2fs: fix resize_inode with too many backup groups
Date: Sat, 24 Oct 2026 18:04:48 +0200
Message-ID: <20261024160452.1818872-1-lukas@czerner.cz>
X-Mailer: git-send-email 2.56.0
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

A crafted image with resize_inode, no sparse_super and more than
blocksize/4 groups makes e2fsck read and write past a one-block buffer.
Patches 1-2 add the missing bounds checks, patch 3 makes e2fsck disable
resize_inode on such a filesystem so the repair can finish, and patch 4
adds a test.

Lukas Czerner (4):
  libext2fs: limit index in ext2fs_create_resize_inode()
  e2fsck: limit index in check_resize_inode()
  e2fsck: disable resize_inode when too many backups
  e2fsck: add test for resize inode with too many backups

 e2fsck/problem.c                           |   6 +
 e2fsck/problem.h                           |   3 +
 e2fsck/super.c                             |  29 +++++
 lib/ext2fs/res_gdt.c                       |   4 +
 tests/f_resize_inode_many_backups/expect.1 | 144 +++++++++++++++++++++
 tests/f_resize_inode_many_backups/expect.2 |   7 +
 tests/f_resize_inode_many_backups/image.gz | Bin 0 -> 69405 bytes
 tests/f_resize_inode_many_backups/name     |   1 +
 8 files changed, 194 insertions(+)
 create mode 100644 tests/f_resize_inode_many_backups/expect.1
 create mode 100644 tests/f_resize_inode_many_backups/expect.2
 create mode 100644 tests/f_resize_inode_many_backups/image.gz
 create mode 100644 tests/f_resize_inode_many_backups/name


base-commit: 8fd79523d051d5ea881237f27eb1c664486e0078
-- 
2.56.0

