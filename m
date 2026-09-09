Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4229658596E
	for <linux-ext4@vger.kernel.org>; Wed,  9 Sep 2026 20:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788987399; cv=none; b=TkKD/pBX+wkpGg2GqbakK0An5/jgQWFiQWYD1ohw8eoLFibWavw4QB5xWbFPmUHIxwuUiczp2BVvRrgHQCPXANIa+mD3+w8P9DQ7F+NZ0znPy15qJHZzP1NDamlgFZGCU3ZqQwbOy2m/67o9LCCV4mlo8H+cBseAw2xyDUXFUZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788987399; c=relaxed/simple;
	bh=Eu+0Om4nXxfhek9V2AOG88l8xsxFV6d4kLyWXbtDvRU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=JKqA/i1OSQMy/IiEAgo5The4LZEDqEVRi7M7THSGO8Re6+ZiNyEdrLxmqFF9mkCAEZ/jQctXNzDgNwV2gDFRplMHug3H91ZnbUhnV72YQdrC91xrCI4nAxjeiHk99S4VxIlrpsfo8oJSxZhPxGYZdSW41pF6JGtrigB1Ae0aP2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Pfwu2z97; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=2agyROQ/; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Pfwu2z97";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="2agyROQ/"
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689KZ6Hc1215546
	for <linux-ext4@vger.kernel.org>; Wed, 9 Sep 2026 16:56:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=wAZfefiEaDRvanKkEQj6zpo9v6
	6Gi+kDLh61ika2uy4=; b=Pfwu2z978uNChRb5pJYyTCzabmBFMKDDJ+onuIG2tU
	DrLEYqmJIggO75sD0sJRGLrMe+Z+tJTd2vGS3P21WSAX5l3GZHDz2Y5tt9j16HQY
	F2Lm+jNOaN6ZOyUqEWVIbt2R1HBoedjVZCjM5Yg4aUrEfu+B56TTsujcHaYeWCiU
	MJudNCyeA8hCjp6PiTTPO/2VbS/95jyvLSBTG2G5SORfVCVUlpa68/Aw6aMROjgV
	uopwRSlGdG+AkXpJvE7H8RChdbcigwffrkBrL0VYKIVZWBL102ZF81JQcnDyumrv
	kUT/gn3jiuEbQBAsh5jXD008jAwjIbchi4zodoFwRquQ==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gkcxyh6q0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Wed, 09 Sep 2026 16:56:31 -0400 (EDT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-92ec3146553so1437993785a.1
        for <linux-ext4@vger.kernel.org>; Wed, 09 Sep 2026 13:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788987391; x=1789592191; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=wAZfefiEaDRvanKkEQj6zpo9v66Gi+kDLh61ika2uy4=;
        b=2agyROQ/TVxnRsRyblTb5wuTuFHg5B3S1Ua1hbI9n48z5ZJsRdE7fK/eZYqnrbqa96
         j3zzNAP4COrCnLiZeCcz1KxCfJ73/UO6bJOQm51J62rZj27apA+6oGtaZZOIJK4WdCrj
         YvVGxiMfW4+k2fUb3iKO6iyC55MrxU9G2tFHKoH8Hlg48wMjo+Cqq88lMg6Alk3H5P5j
         BHJIWvqHNU3PN6TfFObWQH1pSl90Fz5Q0Nam5tCNegSbLYD9+4RMRrguZVn9zEhOYbay
         RItAgZvxkzviYQ84junsSA+2TEhQQVNWYXj6Px9OE6MOcC3WSwJDWdvWRAU8AxnVW+Ye
         P+sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788987391; x=1789592191;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=wAZfefiEaDRvanKkEQj6zpo9v66Gi+kDLh61ika2uy4=;
        b=PiCmW72X5khWobCFJ1Alykxa78lWdfa6mpU10/nrh4c9Q6n+sfQzqElMpfimUahXZk
         6iFrRXtewNGQ278UKPuQwZnJ4TZimD0n74nr/51fZn2PDpbpAlqtLxGRbiQDb0kZ5kH9
         1E/KxokjboRiXK5NWiQV8jYhdPTJYhgT/wSkthjWdcBYGVWgq5AQ1CWyuHu/TxBUJEuM
         mriDR5xMwQ9cP53QEfeNqtdnSR1E6vyWvGu39uWEB5VEgkDW6UsBmhr6ClJldHizGyOi
         sLEy5JaZeCU14NLXzvUv1v0iUcDnqEEeRSSM1V766B6mC9X3XixHwKso2p14xmLBG7BZ
         lo+A==
X-Forwarded-Encrypted: i=1; AKwUvBwNXAzHywhxaJA0ofPeDAiIWB318HUbw1vt5OshVpHU6ldx8+WSZjnTkaBeWOOTPXAo5OI4PtCEjdnP@vger.kernel.org
X-Gm-Message-State: AFuF++ldAnvcWAp/LDrovnC0dvZuC+TUDKL87qbgnHpn1jSR+j2hLK7M
	0ep4vhOFEo4lrRHneUocb0xq+Hz0JKdVyMQN8Lp0E7UnVZ7gXtgmO176p44zlhcD+KnPe1CDNnR
	0VFB2TM6HBnA9zYhlZf0phGJ78Im4wQxqxhHkbUGeh5X8n1+ZCzU2v2FEQZc=
X-Gm-Gg: AYBFou2ahK2eNeKqAcuhrY9s9j5XYSHL72Uj4mRH3FsoVYZc6f+6WHqDsa/zjgiY76d
	xweR4gMZ14VzXhvfCmnVGRllPTyxHW1tWCLCRmewpQUht0eVrMmKHP1OMxTEFsfPtufgRDn/sRx
	oJ4GGvj+6UiMvELuGaIrij/M6xtnoHEIGYbRwCsfrWAjNCa3JLKSEgOKHubgHl00SXLOzx/hT2g
	4Hop70O910bLjslMCBYURSqv2S3cojBDwGxzvk2y68sre8ScU7T//wjryv2Y9KaX4BJrm39sraQ
	egJKFE298F1mhqXo6izR4gF7Zz6facFw94ZVXK/VEy6K6wyNRKoioCxhvnj645KfzwWPJIiClv7
	tpCAZigJX2wsIG/W5khGcsDgSd6CDitHI1QZb3Q19TDiugn8z
X-Received: by 2002:a05:620a:400f:b0:939:7e48:f937 with SMTP id af79cd13be357-939806da346mr3905964585a.34.1788987386143;
        Wed, 09 Sep 2026 13:56:26 -0700 (PDT)
X-Received: by 2002:a05:620a:400f:b0:939:7e48:f937 with SMTP id af79cd13be357-939806da346mr3905960785a.34.1788987385680;
        Wed, 09 Sep 2026 13:56:25 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-193.net.columbia.edu. [128.59.176.193])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9397fba2c3esm1504798685a.36.2026.09.09.13.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 13:56:25 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 09 Sep 2026 16:56:17 -0400
Subject: [PATCH RFC] ext4: never fall back to buffered I/O for atomic
 direct writes
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-ext4-atomic-no-fallback-v1-1-5a6b9539c002@columbia.edu>
X-B4-Tracking: v=1; b=H4sIAPDHoWoC/yWMQQrCMBAAv1L27ELaWqVeBR/gtXjYrBtdrYkkU
 QqlfzfqcQZmZkgSVRLsqhmivDVp8AXqVQV8JX8R1HNhaEyzMb3pUaa8RsrhoYw+oKNxtMR3tHX
 XGdpS69hBqZ9RnE6/8wDHwx5Of5le9iacv09Ylg8o+r4egAAAAA==
X-Change-ID: 20260909-ext4-atomic-no-fallback-b1550a7a3fcf
To: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>, Christoph Hellwig <hch@lst.de>,
        John Garry <john.g.garry@oracle.com>
Cc: linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788987384; l=2513;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=Eu+0Om4nXxfhek9V2AOG88l8xsxFV6d4kLyWXbtDvRU=;
 b=hP4uTw3T93DqPxhf6WfvMmeepkGXSHcHNK0KjYju1xI/5qcBbLiisM5f2b99lfMB4oqigXcKr
 HiFHq/XknnbCc7mLX9Dl1pQGFYFWp/WTU+kgC/z3CMkQkfA6ZfOxIa/
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: ukqA7XnCBPsR1eDYajOqSU9IKSGjLlC9
X-Authority-Analysis: v=2.4 cv=Gr7XaU1C c=1 sm=1 tr=0 ts=6aa1c7ff cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=fJxgZNdXt3opHMdyAp+FXA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=ExgVtMUaGOEd3M8Mp4cA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDIzNSBTYWx0ZWRfX9bTOvZQLajR0
 3Sa4yDy/yGgPlPPn4h5AUdqiV7/E2E0RH15gS7bUXhKTMRJ/YXD6CvZgqxnFcpezClf96hqWDY2
 MR9JffRxrFVaJNpZz0wwSSzbBClLyiChbpyGAMsQuJlALhDqgeT3Z6FoLsKpMhhXIQIfFxuNx94
 7pIqIrHV+UMaRogzWon37he9oZHZzYb2F3/V/4dyzvwpVXWByXJAjKA/s83G/FToYm7yq7Mc73M
 cfNMw+2gVCQrbIAMcASnhXkQgYaQhOpQW8EXvpYhMp5fL+ozu9V0fKgDm1TY8Rpume9OL7lsIWj
 9q2ypCsOSoB7CcwGNWCtP2tN76nplcEBIQdPC2Pb3W2WBrHd9NtD5fcMuLbew82XqZ1Ku1WCmkH
 ib4/1WKPTjvuEaASxhXJ/6KbDaL7qURk/vciH0xafjb5y3q63VQxuQhi3AKrcq/S8b2DYpd/p7d
 PeXmdNPcRhcrS/jR1Nw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDIzNSBTYWx0ZWRfX0TLaGK67QOrc
 PwImsXbWXmGeCpsgmWXNyjlLmXocskMK7I+5C746ZYcPpRDZGJ3vtV4gy+cXhKqWZ2/FbzXaVij
 IDQMRsOkQtcoAyQtwW3xnL1JWFky4NpB0SwL4LMdlMmO+ifPyzll
X-Proofpoint-ORIG-GUID: ukqA7XnCBPsR1eDYajOqSU9IKSGjLlC9
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 lowpriorityscore=10 priorityscore=1501 clxscore=1011
 adultscore=0 malwarescore=0 suspectscore=0 bulkscore=10 impostorscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609090235

ext4_dio_write_iter() finishes a short direct write through the page
cache. For an atomic write that path only warns and then continues,
which would tear the write.

This came out of a block device fix [1], where an IOCB_ATOMIC direct
write could complete short when only part of the buffer could be
pinned, with the rest going through the buffered fallback. Christoph
Hellwig noted that ext4 has the same fallback and only warns in it [2],
and John Garry agreed it should reject the write instead [3].

In contrast to the block device, nothing reaches the branch on ext4
today: iomap requires the mapping to cover the whole atomic write, a
buffer that can't be pinned in full fails in iomap before the bio is
submitted, and a failed page cache invalidation returns -EAGAIN rather
than reaching the buffered fallback. Exclude atomic writes from the
fallback outright instead of WARN()-ing inside it, so any future bug
yields an error rather than a torn write with a WARN().

Link: https://lore.kernel.org/linux-block/20260828-blkdev-fixes-v2-0-32f3f40cebed@columbia.edu/ [1]
Link: https://lore.kernel.org/linux-block/20260907071217.GD934@lst.de/ [2]
Link: https://lore.kernel.org/linux-block/a7752d1e-8ec1-44d1-a266-c287c315e8ab@oracle.com/ [3]
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ext4/file.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 374b4bc25bd5..fb561c701d29 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -666,17 +666,16 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	else
 		inode_unlock(inode);
 
-	if (ret >= 0 && iov_iter_count(from)) {
+	/*
+	 * Buffered I/O provides no torn-write protection, so never finish an
+	 * atomic write through the page cache. iomap should not return a short
+	 * atomic write anyway.
+	 */
+	if (ret >= 0 && iov_iter_count(from) &&
+	    !(iocb->ki_flags & IOCB_ATOMIC)) {
 		ssize_t err;
 		loff_t endbyte;
 
-		/*
-		 * There is no support for atomic writes on buffered-io yet,
-		 * we should never fallback to buffered-io for DIO atomic
-		 * writes.
-		 */
-		WARN_ON_ONCE(iocb->ki_flags & IOCB_ATOMIC);
-
 		offset = iocb->ki_pos;
 		err = ext4_buffered_write_iter(iocb, from);
 		if (err < 0)

---
base-commit: df2908090cda368b01ff43709f51890076c56157
change-id: 20260909-ext4-atomic-no-fallback-b1550a7a3fcf

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>

