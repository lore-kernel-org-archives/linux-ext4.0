Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.106
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792959493;
	b=db/g2r1b6HzjDy8Kk0/3aB6IQ21eNVdra9h3dgh5W5mSjaCsEmR+07C1vyvSlQWm5K+V
	 LayrUS43zK/lZN3pxth65G1Usn2bReosr6ddKYELeYHxSHQRJt4iE+iQwpLox+8fZ1Gjf
	 da34iVrjBrkx1hcu32oqfWY2RKjRBDZr/kZtABaDxOMyXFyKEB9DNI6Ve6fZ1+9MCgUnp
	 FPBZRK8q0y0RRchPOCCqZlKTWwjFzwkAQKUrKx8FYmd5LMSW45qdZTmmdDzqaz6E0PSyb
	 /Jvk/+q1HqAiC72E7aBvSJRHkIiwooL3pNy5wVoMp0TtnO3xrbwKNx56KrkIarXHf4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792959493;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=N92BKgP5eP6ifs0EUiOE5wU7rTxrZqHxuhTJu9Sgh+k=;
	b=WF+dBQV8ZMnHd6oYIUVW9Kl1dyzApKFT9AwrsHX6QkPFoLzftcYGB2DT7XiGgF6Kd3cB
	 pU0iNLxpMajL7vwAuZyXLI9vxnZ/S88xAXlt4dsDb9nv7nN/zJjf0yGrJQaXAyh5hbTrB
	 wrkV4+XNs4zqgYjArzkFcHrip9pNjQj2vdFnNb9UVSGjTIpCODUr3R8FrgqakScNzBszC
	 2JyBAHyiPf8BspdYz8AR9nHg/3TjSQaukv1C5cJvhLE1+/3KokPE0Yhml4l+IhYYE8jWx
	 hie8VsE53+/asg0+igfBlScXlkTnpknyZIKpX10NFKc7ufhRQIOxuQDUOSuyvmc6DbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=czerner.cz;
	spf=pass smtp.mailfrom=czerner.cz;
	dkim=pass header.d=czerner.cz header.i=@czerner.cz header.a=rsa-sha256 header.s=protonmail3 header.b=V0d6vat0;
	arc=none smtp.remote-ip=109.224.244.106
Received: from mail-244106.protonmail.ch (mail-244106.protonmail.ch [109.224.244.106])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542C3606A31E
	for <linux-ext4@vger.kernel.org>; Sun, 25 Oct 2026 20:18:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 542C3606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=czerner.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=czerner.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=czerner.cz header.i=@czerner.cz header.a=rsa-sha256 header.s=protonmail3 header.b=V0d6vat0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=czerner.cz;
	s=protonmail3; t=1792959490; x=1793218690;
	bh=N92BKgP5eP6ifs0EUiOE5wU7rTxrZqHxuhTJu9Sgh+k=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=V0d6vat04WQh2Dxe4AI4hE9XHx26qAPhT/0A12vX8r8GgrdMP6AhV8mUoCqHEFhV7
	 jFB+DtIEkzTUtEXUYRCm+WEwgJ62zMPKpfEkD7DPuwLzlJOmfv/Nsgmq7H8m/5GvI9
	 EzJ5bimgfOe/JqRc6dwlbEiKSqUAzEEb2t7KpH2y94th9mmhchTgJKVidtTaywBrk+
	 Avbjw+NX2XQ5rG7islkJFuisBDwNXpElH1wqRLLl8l26giNYPbdhfXhy1QHyOZgAzU
	 TjdHPu5JK3+8aUlzu3Tj/slA8J4L1hfsil0r7/f4j96UsY/ydyArIJyYVTtMTVCWMn
	 vDQut1qibnVUg==
X-Pm-Submission-Id: 4jCSk90d6kz2ScNf
From: Lukas Czerner <lukas@czerner.cz>
To: linux-ext4@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Lukas Czerner <lukas@czerner.cz>
Subject: [PATCH 0/2] ext4: fix error handling of failed migration
Date: Sun, 25 Oct 2026 21:18:01 +0100
Message-ID: <20261025201803.3043712-1-lukas@czerner.cz>
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

When converting an inode from indirect blocks to extents (the
EXT4_IOC_MIGRATE ioctl) fails, two problems can show up.

ext4_ext_swap_inode_data() can fail after the temporary inode's extent
tree has already been copied into the original inode. The error path
then frees the extent tree blocks via the temporary inode, leaving the
filesystem with multiply claimed blocks. Fix it by resetting the
temporary inode's extent tree and i_blocks right after the copy, so the
cleanup can neither free the original inode's extent tree blocks nor
truncate its data.

Also, ext4_journal_ensure_credits() overwrites whatever error the
migration ran into previously, so the ioctl reports success even though
the migration failed. Use a separate variable for its return value.

Tested with xfstests quick with defaults, home-brewed EXT4_IOC_MIGRATE
stress test and a reproducer written by AI.

Lukas Czerner (2):
  ext4: fix failed migrate freeing extent tree blocks
  ext4: don't lose the error of a failed migration

 fs/ext4/ext4.h    |  1 +
 fs/ext4/extents.c | 11 ++++++++++-
 fs/ext4/migrate.c | 22 ++++++++++++++++++----
 3 files changed, 29 insertions(+), 5 deletions(-)


base-commit: 5b0764a53235d3c77e1ed674e836e1b3fe1a4b1f
-- 
2.56.0

