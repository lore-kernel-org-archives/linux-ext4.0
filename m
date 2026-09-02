Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853A74A3855;
	Wed,  2 Sep 2026 14:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788359650; cv=none; b=oQfd5K+0uHAUM04blCzgxwHaE3yEbvzOySf7jSH7w1w7Jm/Dscou7PqIzPoKNy2bE6vragdhRw3B6cTKG3PXbL4pyjLbYXaJWwbCXhbMf+12wTU5DaUQdGvidl7w7bxixQzgPumhMGFrozK7JZRiVxwdHY/k6YOEV4nUAdtVqMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788359650; c=relaxed/simple;
	bh=TDAMQcRJZLiAzLI12fnV4tjg3ILK2nDC2eR7M5Ar+r0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RwBIz3IO6prYjC9v+FrXe+WSZfe8ej09wZ4Nlq7UnIEo+Blxl9QaXqaQ2dXepEHKIj2nBsWiMjDGnYq5cFyWcHIggtUThGAaD7+h8HtTJSjYtzNsKpIT3QxyaWeN0f8p82PfnoPAcINFusZpk0DER5hJGfXMKupE2YZQVT//YAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=By97vhbH; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=hpE+b36Y; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="By97vhbH";
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="hpE+b36Y"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4hZlbc74dpz8v5B;
	Wed, 02 Sep 2026 16:34:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1788359645;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uZCAftz672lWEvyNDdezzsIOeB60zjmmnIS7f4lBq70=;
	b=By97vhbHljYw/T5y5+nlvS/WkKIDSm4w0rpssiiLwdihyHB8O4Bo+xyZIfP54rZ29xZ63n
	FWWuxDz580selIKTyyBNzBNv7Z81n9D0iVqEyWR+eTvM6HjvyabuMv3WlppWLoGQ0Qugf8
	kHNMSmWgP0CgmtsWb6yGVPPLloyNYgk9evJnrHP1o/rz/p6MZiwouEyvCnyVD3VG6Wav49
	xGXI8GacnXf9IGATZBoOE9IVo1ONCUnKuIPwZbloHrFF5l2uLIZtrg63v0sP4MsBeu+HfX
	NrIL2F7wd3Sf8Gfr6lRjHk1uSWLkYU9S3kwyu3gtdwM2aeFTtcjCQsEXIoPBjQ==
Authentication-Results: outgoing_mbo_mout;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=hpE+b36Y;
	spf=pass (outgoing_mbo_mout: domain of manuelebnerli@mailbox.org designates 2001:67c:2050:b231:465::1 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org
From: Manuel Ebner <manuelebnerli@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1788359643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uZCAftz672lWEvyNDdezzsIOeB60zjmmnIS7f4lBq70=;
	b=hpE+b36YKbuHHpQxF4k8YCzGvMLoTinDth3e4avZ3x4ECYEfdYcztYpjNFJqEw5rBMsSUt
	v6gPRbptAM9W64Qd1VXVgJqQ0JgHOB/0+tVlgHAsKiUtNLbbg7Jdv+hx3VapM242n/1eZY
	XZxiMKwQFI0spfw45jKk8FE6gX0yRvdzjxLRZD1oePaI3tISEmPJIvrshaXmdtd2l6YpJq
	f7zou6bk/9Zj3MYeyZS2LnnJ0HW9c5CCbtSvrMFiRnLQIjwPFQQCwuk/rD7fyWyYp9+lpP
	QvAB+HMpB63WiRC6R++iFmhWx26aolMwsECiWIXOWv0XqE8RC2ES/FWoFjhhig==
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>,
	linux-ext4@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ext4, doc: remove unnecessary bracket
Date: Wed,  2 Sep 2026 16:32:53 +0200
Message-ID: <20260902143254.702971-2-manuelebnerli@mailbox.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: akofodgkk53b1hq7u37frm46b5j6rwf3
X-MBO-RS-ID: 76847804af03d6dfa21
X-Rspamd-Queue-Id: 4hZlbc74dpz8v5B

Remove needless '('.

Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
---
 Documentation/filesystems/ext4/directory.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/filesystems/ext4/directory.rst b/Documentation/filesystems/ext4/directory.rst
index 9b003a4d4..f3eeca844 100644
--- a/Documentation/filesystems/ext4/directory.rst
+++ b/Documentation/filesystems/ext4/directory.rst
@@ -429,7 +429,7 @@ block (precisely the length of one dx_entry) are used to store a
 ``count`` entries in the dx_root/dx_node structures are adjusted as
 necessary to fit the dx_tail into the block. If there is no space for
 the dx_tail, the user is notified to run e2fsck -D to rebuild the
-directory index (which will ensure that there's space for the checksum.
+directory index which will ensure that there's space for the checksum.
 The dx_tail structure is 8 bytes long and looks like this:
 
 .. list-table::
-- 
2.54.0

