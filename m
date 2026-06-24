Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BE8389E1A;
	Wed, 24 Jun 2026 07:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782284445; cv=none; b=hHPFJKppvQYNv7QwsvbmmCQ7N3qPuA0jLuNpppkzm+Ig2fLfWovjM2K24jTUccb31cyAziIdT+nD1AS83G5DAperM4IlDpVaA/VNdFttnmftgMqkIO1eDBySI5Uw7yc44fOMSovGhm3tyP6gGL4eiLJv7jMyvc4/34KDOqgcONU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782284445; c=relaxed/simple;
	bh=ggV0YlVXI7DTbFlsUaAX4URfNCfmC1nJrLJMMdvOKtU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bq+Yvw1geCF2X3rtrHYQoNTMWcbaDN+6lk0OzD2oMyVnuty8T6v+JYFW0bY75IZiT2zhdGg6KyYBACP/W0hA9EyMcWpJUxFdw0QIbtXUgmvXiKXoo93izcY/lw9yHMnmuWuWe32Vkm96jwGId13XTNgnRh/ESuJzdDwhekKNpv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=Al3Db5u2; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="Al3Db5u2"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65O5tR8s1541164;
	Wed, 24 Jun 2026 06:59:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=ssK4+tt9A
	hggdla44TnItEVKxHpVDYREzC6KKMhvxFw=; b=Al3Db5u2rkV9YXkaIr0Cu1cz/
	3fPe3Zase5tvptagk+Ui8vo9QlgG1xsP6641DDZiKqoNwlIOdjNOwD84tIrmLQfn
	LTIz8wKUHLv2Uxe4hoVCGM0r5iW5MNi2sX0GCtyNn92vPNm8FsYgy/faJdInwKY/
	STfGb3dHFwljgHnzun7ek+l5SNHKYOF+hOxd90jwNOgLAz66iehVoP1qwRVR7oPR
	0KBmO0vFu6P2g3YWkQVogKkEbJ7P0InPUsdrxQBonH3uehydtgfWrKjXEynxFiMP
	4o/wto1cCVJW5bMftSNtgH7PRC6uSmaBXRLsRLqPEUbNr6M9fnfg99IV3o6cg==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4ewg2wvsjq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 24 Jun 2026 06:59:52 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Tue, 23 Jun 2026 23:59:51 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Tue, 23 Jun 2026 23:59:49 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH] ext4: zero non-uptodate buffers before encryption in writeback
Date: Wed, 24 Jun 2026 14:59:48 +0800
Message-ID: <20260624065948.85415-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: k4GGvfsE8oqU6y5virmR4R1pGZebZv3H
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI0MDA1NiBTYWx0ZWRfX8r7ByVbXFNS0
 6zQr8DJlppfKMnHHf9/10UzdDvV0BQiJaIZ55QzBkYbjeHDx2rZGP5wOhD6jC7ycPVyRLcsmcRf
 4kNwv/pR6604IgD+IalNHVeRxNAyshj25K7vQxrSJGRLde0DVP5a
X-Proofpoint-GUID: k4GGvfsE8oqU6y5virmR4R1pGZebZv3H
X-Authority-Analysis: v=2.4 cv=Xdm5Co55 c=1 sm=1 tr=0 ts=6a3b8068 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=zHBmtUlt6j9fkuvYlXkA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI0MDA1NiBTYWx0ZWRfXw9kDDMDwgata
 bcYknCFUL5121f9GadhiFX3r049cNLL/xlHfd6LVmYqxVRA09Ol8VMQDNQdZ/RVimATM1k0gCmX
 9hn2e0f29gvaVdQ84htXsZ7pGnhSLYRS8rtQkr0nVP1u6UnUcoFoA6bHIcqjSXVjMYAEODCiwV7
 WIxu1YHuCPXKbJngKtH02H3rvQx25vo1iZ7BL10EbgdrqThDlz2svrXUBu9gYtvOF/48+n/ktbP
 4ugsZ+QBXI+KGxaM4a9AeHr8hd9DrGwfKSJmGMz6B3sy5vA6o3jwigAo4wF86lV2r/3H9QP0J2C
 IqVNJWEwYjiGuplUkG+i59JN8mmCEU1AaBSYzYOdBuxSKBdg2ydX7t4UrHBO/16qUIgGXc3fwt8
 tEc6Y2m9krBB0UE7jlb6BfbtHDL5p6DUYn4eW+SJOkIlyoXoxP0bygp7NXxrgefyCk+mXE6WXI+
 GD+HTB3k1vEJb6KH/IQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-24_02,2026-06-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 malwarescore=0 clxscore=1015 bulkscore=0 suspectscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606240056

ext4_bio_write_folio() encrypts the folio content from offset 0 up to
round_up(len, blocksize) before submitting IO. When blocksize < PAGE_SIZE,
this range may include blocks that are not being written out (holes,
delay, or unwritten blocks). If the folio was freshly allocated by the
page cache (via write_begin) for a partial-page write, these non-target
blocks may remain uninitialized from the buddy allocator.

The encryption engine (AES-XTS) then reads these uninitialized bytes as
operands, triggering a KMSAN uninit-value report in aes_encrypt().

Fix this by zeroing any non-uptodate buffer that is not being written
out, before calling fscrypt_encrypt_pagecache_blocks(). This ensures the
crypto engine never operates on uninitialized data regardless of which
blocks are actually being submitted for IO.

The common case of blocksize == PAGE_SIZE is unaffected since there can
be no non-overlapping blocks within a single-block folio.

Reported-by: syzbot+7add5c56bc2a14145d20@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7add5c56bc2a14145d20
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/ext4/page-io.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index bc674aa4a656..2d380b5a1501 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -555,12 +555,22 @@ int ext4_bio_write_folio(struct ext4_io_submit *io, struct folio *folio,
 	 * block which might be needed.  This may cause some unneeded blocks
 	 * (e.g. holes) to be unnecessarily encrypted, but this is rare and
 	 * can't happen in the common case of blocksize == PAGE_SIZE.
+	 *
+	 * Zero out any non-uptodate buffers that are not being written out,
+	 * to prevent uninitialized memory from being fed into the crypto
+	 * engine.
 	 */
 	if (fscrypt_inode_uses_fs_layer_crypto(inode)) {
 		gfp_t gfp_flags = GFP_NOFS;
 		unsigned int enc_bytes = round_up(len, i_blocksize(inode));
 		struct page *bounce_page;
 
+		do {
+			if (!buffer_async_write(bh) && !buffer_uptodate(bh))
+				folio_zero_range(folio, bh_offset(bh),
+						 bh->b_size);
+		} while ((bh = bh->b_this_page) != head);
+
 		/*
 		 * Since bounce page allocation uses a mempool, we can only use
 		 * a waiting mask (i.e. request guaranteed allocation) on the
-- 
2.43.0

