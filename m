Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.159.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794169177;
	b=KB9TeepCEWHFas4OnN6zrS+yTgeq3bk8ad7Oj0TZfgmdBhiGeZG/y/v8P9k+H3Tx9Ot4
	 uj+5Ljcw1qoANxMZUUdKw2sJtn08F1GPDuECng2EjwFu7umzeWYB3pwW6faqt3OiZ/PRE
	 AHOVKxB8RBO1StUFl01Vs8+gJLtr24TRX/r/R4y/9QUNWuDzS+AuRSIsSB/Ugjg/E+Spi
	 wV9R1s0zfbekHbOlltIJ9bGpSAD47elXqaXsPjtiZ9a7RlbKiSmbSNNwCcbpsWj/aofeU
	 T+Y6CMmFU03Mmwgi6MQSiP88IOl7RjVCWJ9VC72iJ4DJh1VGIb5dU98C8AC/+Ii0+iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794169177;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-Get-Message-Sender-Via:
	 X-Authenticated-Sender:X-Source:X-Source-Args:X-Source-Dir;
	bh=WGxGumD/dXf5ILl4zFLVZxTHP87XH1xpUeKbtBCw9cU=;
	b=eV3TUh1Qayn6fezW9n3ufOlLxAiwHzMjWxvlzxOeMSSvkYplE8ou7ty/YbDEGcpI5RqB
	 vqOT9u0AJFo5lkba8I3pwEusPceYN/+P5Y1cqEpasJX1tXM9bYD7mXi4i7nkmhPtS0Tq4
	 32ovbPQ/umbEUdD+vakOrAcJfLgE0r74xf/S92aTpAKBtyLFWyUEiHu7NhmJ4NI9i/5+m
	 ZaZRCaeEvLDrbItJf8EJdzMsbSuRtTfUvrViNG0ikDy+k0SZbVhRcsWSBt6eX/i7OlFDc
	 V/1eaCmCQ8VDIo93UlMKiYJzDrqn7rzovTZzR71AUIOU10eGzw1iZd5x4HzzCFKQQOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.cyber.gouv.fr;
	spf=pass smtp.mailfrom=oss.cyber.gouv.fr;
	dkim=pass header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=Wvq+Hgh3;
	arc=none smtp.remote-ip=51.159.188.251
Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2285606A31C;
	Sun,  8 Nov 2026 20:19:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2285606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=Wvq+Hgh3
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Sender:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References;
	bh=WGxGumD/dXf5ILl4zFLVZxTHP87XH1xpUeKbtBCw9cU=; b=Wvq+Hgh3gBOx6FBFdLGWcTsKDN
	j2FoufL5rGTFehNxlQeP5S2O40c42C/qg+PnOsRUwSfgDwNnvnwna6t8p9kF+7zi/upRFJC1pdsna
	RPKiBgqWOZoenScoIfNp8QLuxHERkwXP9QrAG7fJN+xeZrMiV+9Yt67uMoIs3MpWYgVBmv6mN2aHp
	zLtF7nKnVBohJEm0SdESVEJ4u+WKNW2yIes7qxKobrC9LJOG0EOl/id0GWql+XgB1rFg8QINblISB
	wU7gCx1GdDkBlu/KajTxw8UrNe4+64SabATWVacfu6nS0lKLWda+9eq4JhXN5u3REXJBqsEtiOTYm
	7PNjcAew==;
Received: from [151.115.150.205] (port=47338 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1xQ9MT-0000000191p-3J8o;
	Sun, 08 Nov 2026 21:19:33 +0100
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: tytso@mit.edu
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	stable@kernel.org
Subject: [PATCH v2] ext4: validate extent root during fast commit replay
Date: Sun,  8 Nov 2026 20:19:06 +0000
Message-ID: <20261108201906.1417129-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

Fast commit replay skips extent tree validation in ext4_iget(). The
replay code then reads and updates the extent root stored in i_data
without validating its header.

The root has space for four extents. A corrupt header with eh_entries
set to 4 and eh_max set to 5 lets replay insert a fifth extent past
the end of i_data, which overwrites other fields in struct
ext4_inode_info.

Check the root in ext4_find_extent() during fast commit replay. Apply
the check even when EXT4_INODE_EXTENTS is clear, because replay can
call this function for an inode without that flag.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Cc: stable@kernel.org
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---

Changes in v2:
- Validate replay roots regardless of EXT4_INODE_EXTENTS.
- Rebase on fa4ad798f6f6.

v1: https://lore.kernel.org/all/20260821100559.3612643-2-Jeremy.Jean@oss.cyber.gouv.fr/
Sashiko: https://sashiko.dev/#/patchset/20260821100559.3612643-2-Jeremy.Jean@oss.cyber.gouv.fr
    
 fs/ext4/extents.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ad0d80e33f609..04268ed26711f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -905,6 +905,12 @@ ext4_find_extent(struct inode *inode, ext4_lblk_t block,
 		ret = -EFSCORRUPTED;
 		goto err;
 	}
+	/* ext4_iget() skips extent validation during fast commit replay. */
+	if (unlikely(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_FC_REPLAY)) {
+		ret = ext4_ext_check(inode, eh, depth, 0);
+		if (ret)
+			goto err;
+	}
 
 	if (path) {
 		ext4_ext_drop_refs(path);
-- 
2.47.3

