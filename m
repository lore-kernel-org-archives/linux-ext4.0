Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D7A4BF949
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 18:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791828296; cv=none; b=f9MFKgVu39sOlxqX/52xm81qYXnXupGYA+8gTh2eTXJUtB46KY5nXw78SHsEcwaYe1F8YgOvrijsA034kenvjWWgCHHLVcZrmpIktov8hnI6CkyIPOPNFvL/CiVJGRy1Oki815Wj1b2p1EWZxtdU22AQsMjUDPnORex9O3fNCUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791828296; c=relaxed/simple;
	bh=yMAE+axqhHNPEO0r3w89DgnUjCm4JVbOCv0EiFEtye8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=luH125BagOzSv6Cc8eaohYrVuoHhQVl5C84XJ2p6ROorz5EIIN0xLQ2+n1AupEYMSVxqd80nIfIfjOCOmJhrQe4A0uU0UyRUDAQRQvswX/7mYgDVtjHNnB1lckttNWdfu0JobNSabQbwbOQiFYTUVuKxPeUKWaqNw0AvmWijWG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=S6fIleg0; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Kb03W59D; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="S6fIleg0";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Kb03W59D"
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69CHgqDt1667371
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 14:04:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=AEvXv8hXTQ/+FloKei3WHiBVPc
	CGjN1A74Vjs2aWpmI=; b=S6fIleg0TZK9er2lnRL01OlLuScvEy5mgxHB2196KD
	jg2XUVNnPEhl5gmrpHPgKscpL3uX4iNuwblre5lvsDVEJ6CYWOaVrKjyvOZI1Oj/
	8+zpS4N6AOTjJ6QXijAELE5ouH1c1VHmyct4buOxOa4dO6Zh/OXB8i+P2wh9io57
	+cIPEDxijoK3gpL6I8E7+80JMsqsxE+oOhexyHU0maMygSvarCsr5HD1TNGX1CD/
	WA9cmSMnNPMJsi14bbvHk1mDAM+02oBtBw6QD8Kdph/lyWySkWbtH3RWnaJkuMwv
	fxUpM1AcLaVClcvlimHzvT6cJyjHr8mSpfxUI9diVstw==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4h8y4w3mh8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 14:04:53 -0400 (EDT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-91b861c0618so17915446d6.0
        for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 11:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1791828293; x=1792433093; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=AEvXv8hXTQ/+FloKei3WHiBVPcCGjN1A74Vjs2aWpmI=;
        b=Kb03W59DpxuBaa6DZMQ8suXvGhy9zNjyIy4+nvnd2mcbIgLkt4m/SvpVDby0Jp2LvC
         fU2XDK37QZf2tNar0nokoMmDpwlDsPG6TLqWqKtr7xJtP78JBYDMNSXmsKgnfDhsd/N/
         Y3PJlLJhjXCD39WLNkPE5v2advo4VJg2ST+XmyWV4T7EzjfaXRSBhHQDK4AYUWRfBQzS
         D7mrNF4Ciew7WwKrkfCnUe4KcJMz1jWflmM6xyygpl3yFiE04RyvcJfZswpBzbmAyMbA
         Tq10qvgew+T6bD1uE0M31IVthG3f+fWb6B+fmh9sZTbQxbikxVn4uO9iFjyh3zs7AkrW
         XuMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791828293; x=1792433093;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=AEvXv8hXTQ/+FloKei3WHiBVPcCGjN1A74Vjs2aWpmI=;
        b=xlNx46ahy3XAdIn4bGMjEzCSncXKg3d91fQy5ZOpWK5ee4EkQGT3y8dYQoJvsE+j59
         RrpP11/87F2l3i/nIcFXZ+ZrVPr8VfyytWS4MsTe3bizFWHGLXFZFn64qsS6mkhFb/wQ
         R/J5McT7RwQ5oMhgEnTCFu1kH1tP4TffvDbwS7xOTEjBirfwg9EXcNjHs8hZqL1pSlfi
         V54Ao8pT+i36C+BJrKs/1zhSYrvZ2u4RodwGKvMDMABqS96WrfuKwNB3zVUBH0yoLUNw
         1KFx940P7ZfLd5zW0ktT96BZxCRGYwjzgyP0ju7QkXdiRGGhymeGVKIw//sAsbVrwYN0
         2jzw==
X-Forwarded-Encrypted: i=1; AKwUvBxx2XHyHNKQdMoeGNX2f+KuElb2eMi7Kdha56RbRHihFJRdtUwd9iCYf3hxTh4T5CmM0W1+uCjfWYL6@vger.kernel.org
X-Gm-Message-State: AFq9FYLgVdsBGNqDfsU+ggznXXl9nXGv4Vc3JuhW2oGd78zmiq/Z0uTp
	9HRYI5JsX4L2LAlS5ptG86K+4HtLvLY38INsW5/vBmtlU9LO5s/e6gCSbgw3zj6syuTFsatFioB
	CFeOpOh+jv3tdRe4ML6JwNfPoVG86NgYzOY0INGVcVQ0sBCrhrT5PZQNsbMM=
X-Gm-Gg: AYBFou1K01Bxg7cSBYb5HG1md6baOZkemuzZ7ez1b5KA2hUP2rVEg5OcmDkrBje+Q36
	o2t3BZg79G9b/eLUkB9AGj59wWltB7OW6P94v1cs73Xhf5+sPI/qpeATUgfLOPtbLpvgcVWZMVT
	C5U/SAMPpYAxeMAQSfRWuxMuktdaY7NJieW5oSCIsSffBZG9w0DRAxO4Ikpa9vcQaWvILq5kpP7
	Csc+QOA14Hc6b3Oyk3jgP34q+XWYRkXbtHLClW84UPtWPJkO2SqdeRnrK2928xWIROKlgnZj2mK
	mrc4cyhN00HnJS8yxOKFMF8kLZI76PLVJJBd/2HgctlKmjtbPbP2rNJJCUhnFrYTMQQF7E6GgoB
	W9RIw3mEtjQ/EKLA6WJhlkuqFid/eaz0KYgtzlJkGRJBwLOY=
X-Received: by 2002:ad4:5ce4:0:b0:919:75be:48d3 with SMTP id 6a1803df08f44-91b554d02d7mr189784116d6.22.1791828292644;
        Mon, 12 Oct 2026 11:04:52 -0700 (PDT)
X-Received: by 2002:ad4:5ce4:0:b0:919:75be:48d3 with SMTP id 6a1803df08f44-91b554d02d7mr189783596d6.22.1791828292207;
        Mon, 12 Oct 2026 11:04:52 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-231.net.columbia.edu. [128.59.178.231])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b383dasm3692516d6.8.2026.10.12.11.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 11:04:51 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 12 Oct 2026 14:04:37 -0400
Subject: [PATCH] ext4: complete dropbehind writeback in task context
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-ext4-dontcache-complete-in-task-v1-1-6ac801557041@columbia.edu>
X-B4-Tracking: v=1; b=H4sIADQhzWoC/yXNywrCMBCF4Vcps3YgSaOgryIu4mRq4yUpmakUS
 t/dqMsPDv9ZQbgmFjh1K1R+J0klN9hdBzSGfGNMsRmccQdzdB55UY+xZKVAIyOV1/RkbbOMGuS
 BrveG437orfXQKlPlIS2/h/Plb5mvdyb9ZmHbPgOeD5aDAAAA
X-Change-ID: 20260924-ext4-dontcache-complete-in-task-2340ed5f3114
To: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>,
        Taotao Chen <chentaotao@didiglobal.com>,
        Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791828290; l=2877;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=yMAE+axqhHNPEO0r3w89DgnUjCm4JVbOCv0EiFEtye8=;
 b=bSPBAdCA4pOYUnbb2s2+Pl3dJXOOEl2JBL0fOAF3bJjYAKXsfNyL9k52aP27evamE1F5FeWEb
 ucPomjMlHUqDUISMb0rMuckpSWkyRLDAgU31Qq52IJedOfg0Z/NVgM7
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDA3MSBTYWx0ZWRfXxF+FtH/OtwbV
 +lxGAIkl0nTSaB+kAtrZcaGbR+E1iBAQgTVT3fdXTTGain1/9eTdJXy85WqW7awBqSsdwF3f2e7
 P2fV1wu6sCedoMOgaBtU4hrryzvMMU3YGHBy2vVn/ntwzZXNNEUg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDA3MSBTYWx0ZWRfXzbRc7x/f5F46
 OrhJLLoPIsht3yoFJ5mPsmVkkHOrAf1GZ5OneCj5ZIZ6sole2hH+Egi5d5SXkSrmJ4JW4vyMxM7
 4CkQBvvAMgWuyTRT6cfXLPapCrXjX8OTtPzLdcyefgFjGL2TAu6VSoyyVxIhtLcWFosxXwfPe+G
 Pyg+A/bGb5Sf1h7qx0GI0H+31dwvHik0jr9q6qAVaDbAFuyDJq/oPNtqnjJT9YpoDzzfn6qGXQE
 oOpHQKWKL7kplmv97jOuJp9MZj/whl/eeG0b40qvg4qSGp11kCr6zsFPRg/kVPC1zIRhzY4A5+c
 xv8KT/4cf4ufYqk/wb8aaWQef3D8MrE/Ov+h6MM2jRsv8u2zMdo9uZPXGDZeMMGtKdnt7X7bVLt
 AaYM9qbCMchPH2QFiseF3tZR4ElMNXw41u8JbA1Or+vROdI0eoq0f4iMd2y4v2XldnoWozgNw1N
 1rzcnaYbeP0/FyTXZ5A==
X-Authority-Analysis: v=2.4 cv=GOydgeNK c=1 sm=1 tr=0 ts=6acd2145 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=9fnr1hFzp71kSIFw8uYQYA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=fU5PloRAk5hQnq9Bk-MA:9 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-ORIG-GUID: aXOGts3S-Ln89BTXAQtnZPaOR9wKZP4r
X-Proofpoint-GUID: aXOGts3S-Ln89BTXAQtnZPaOR9wKZP4r
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11933
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=10 phishscore=0 adultscore=0 impostorscore=10
 malwarescore=0 priorityscore=1501 lowpriorityscore=10 clxscore=1015
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610120071

ext4_end_bio() ends writeback directly from bio completion, which
usually runs in interrupt context, unless the io_end has unwritten
extents to convert and is completed from ext4's workqueue.
folio_end_dropbehind() only invalidates the folios of an RWF_DONTCACHE
write when it runs in task context, and silently skips them otherwise.
So on ext4, dontcache writes that overwrite blocks that are already
written, or that allocate blocks without unwritten extents, leave their
folios in the page cache. Dropping them was best effort so far, as there
was no way to get task context from bio completion.

Use the task-context bio completion infrastructure instead: set
BIO_COMPLETE_IN_TASK on bios that carry dropbehind folios in
io_submit_add_bh(), so that bio_endio() runs their completion from a
worker. ext4's iomap buffered I/O path already gets this from iomap, so
only the buffer_head based writeback is affected. Skip the flag when the
io_end already has unwritten extents, as ext4 then defers the completion
itself. A later extent can still make the io_end unwritten after an
earlier bio was built. That bio's completion is then deferred twice,
which is not optimal, but harmless.

This changes behavior only for bios that carry dropbehind folios: their
completion now runs from a worker instead of in interrupt context.

On the unpatched kernel a dontcache overwrite of already-written blocks,
or a dontcache write into a new file on a dioread_lock mount, leaves
every folio in the page cache (16384/16384 for a 64M file). With the
patch, none remain in the page cache. A dontcache write into a new file
with unwritten extents already drops its folios on both kernels, as
expected, and a plain write keeps them.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ext4/page-io.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 734d856a6d47..e556598ce9e1 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -458,6 +458,16 @@ static void io_submit_add_bh(struct ext4_io_submit *io,
 		io_submit_init_bio(io, inode, folio, bh);
 	if (!bio_add_folio(io->io_bio, folio, bh->b_size, bh_offset(bh)))
 		goto submit_and_retry;
+
+	/*
+	 * Dropbehind folios can only be invalidated in task context. An
+	 * io_end with unwritten extents is completed from ext4's workqueue
+	 * anyway, so only ask the block layer to defer the others.
+	 */
+	if (folio_test_dropbehind(folio) &&
+	    !(io->io_end->flag & EXT4_IO_END_UNWRITTEN))
+		bio_set_flag(io->io_bio, BIO_COMPLETE_IN_TASK);
+
 	wbc_account_cgroup_owner(io->io_wbc, folio, bh->b_size);
 	io->io_next_block++;
 }

---
base-commit: 35aefefd7aba0801bab635b11943f932626be3b2
change-id: 20260924-ext4-dontcache-complete-in-task-2340ed5f3114

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>

