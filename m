Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A4633993
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2026 20:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792097795; cv=none; b=YIg5OpfsnVK3bCZgu6xrL9XkdCwweoiQxcMqyZaLgIRy5gk3qVSbjzFlqCO6eVfP5Q4pLH4MBxRyNwKkmGC1Y7ibO4N63saTsTNLpw3cPS2SQ6IPCfd4ovQC0mrjJdIjaCHRYLCntz447nmvvZRDheph1yy1lazBCocmTJPOxjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792097795; c=relaxed/simple;
	bh=KewLqlkj9HfaC+aOJYKAu061lljKKowhtkC9ghOwU38=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YbO9XZrMfy7dB1YkNy8Da9ZWqifASCGmbtGmdsPDoZSyqjQh45HLKUfct1L7yCXWSc4Z6VamHswa28mOAi7P/UVu+RfHKEfsQlmeanHY9TY56idgYN6/cN2bcuqifbh86h6B69Svh0u4YEZPwQOHXLvNq3Pvai00EqhQoTtSVg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=GX5gIjGP; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=JcTXeW28; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="GX5gIjGP";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="JcTXeW28"
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FKaWxB2787701
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2026 16:56:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=dfSs
	h0cs3XLj2wlU1kGst3AnO7cgcsSohbFCtj+DeeM=; b=GX5gIjGPRc+YhDVJlK07
	8iRgH3cWRzheqRoQRLxh+Z88CkXiyM0/RzHeTwEk2XtiAZedp7HLqpawtsi4zGpc
	/H+++IIaFE+WaKrDSh2sLFg4ALTkxjH+I96nXZtZ7PcYizvcB8koH9EUX1GnhrPM
	Unkx9pGBTVqgwZy0HFr0pTAVlVaBDoEijfZi0aPRchL+8DTN1NAQ+C6hNKMP2/dw
	jE0weC+dN8TkZZL9HsfchNxzqU4+LEg4VSpYS2QBFrjbc+n0bjXUbYM1M5OqCDY8
	xXUb9JW2R9iGVlqwbXckP0dt9tH2tAfw8J94v5/lqHIvDGeuY0dNzDp9sA67/O56
	yA==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hb0dukp38-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2026 16:56:23 -0400 (EDT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-91786abb5abso24666406d6.3
        for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2026 13:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1792097782; x=1792702582; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dfSsh0cs3XLj2wlU1kGst3AnO7cgcsSohbFCtj+DeeM=;
        b=JcTXeW28sUP8lbCHvaoyZoaq2u9/VYez4O10riNicexgp1ICAp/r+/yINSfFNnZd/n
         OP88JsMwO4GkVe61cJxMRqE1UTmVO/Gulj/M2s6MzLVC0Pq09WavgyKJTCnMT77z0Lcu
         cTs0zesKerNYSP2jQLZR+1gNBHDKWL+9CblnSLDVEwTDtCdI0QFsjDuv6+ZjXTiJa2Ia
         7SYD4/9Skq/ZiV5FeHz+pNGH/dYE5stLofpaKHe4F7PnU2B8J0CBWF+ehnNd0ifw4LRM
         HJ+t0fU50M/x8KaEN94IcrMcoQ2z3yFl/UqxknVRHEo8QAuh232ynvM72ZyvOkRA7hvH
         Gg9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792097782; x=1792702582;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dfSsh0cs3XLj2wlU1kGst3AnO7cgcsSohbFCtj+DeeM=;
        b=xUZPOyuDFVyk+HvJI/SGZjd0/jgw/Laz+jzGtBxAABK0u32WXg9xV/ZDHPa0vk4Fv9
         kSWOELyUcQCYfNJhLkegPdpp67f7cY+2HD6dlQCH4FiB64St90UOBfUFQsdnMcogJaAY
         L2AnZlwQJHpulgu8YXU66dzKn7QSwBQU+y/pXRQqOe7a82zwpSc81hIgAOW1mvlQ5lCx
         GsxxRNYE/gE3R9FqjGJ6TTDSiyM+M/VCHduHRG52EAlW3+O5FvmfrYEUH2YgoiP9ScxK
         N/dfLCvKod50v8GHOq3cjTuGwVw5oUpchE8G9FcWiR011LMo0ssa6B4tpUSfZ3nSXFJl
         BbRg==
X-Forwarded-Encrypted: i=1; AKwUvByM9efDWJPimrOogPHQ7Aofy0aBjl6u9iBuI43h0PW+S76sBs/WlyVl4EePlbWX85ZzwSyvoYymBeco@vger.kernel.org
X-Gm-Message-State: AFq9FYLFNDtlJ7jhRUesoY9r5/NfVEeHxuxD+7R3PhIlOgF1vik1dsBT
	/ZPcKxNw6k3aCEF59SpuuJL73gW5w9wCsENPif9+kcyfD4kyrpa8NL9laquJk2hfl9rFv3LrF55
	McfEGCaDtFU7ZKH5b6jtwSo+f+tMBgylr6CwduBcsw52cBqov80+7dJ8516g=
X-Gm-Gg: AYBFou0rdFTuzlAuAh1D3fscaTS7ctLawcd6Qdt9gcaSAq31ULaaQ97vMNiyFBq1fNp
	rRwE5AoxDRSgSR13+xIiJdQgmxLKTk5aGGNEX9Ko8dbFXnzTQq7XQuO6zbuNsQSvLT/UqKDQb9T
	i+8CjngEN1L9HKZF+gRORrqDeHXPOM531ujlLk2Vu7cs1mAfXmzOt7/5cfVX2kP9tXuZFMSS6a9
	bpxjfF56513xuZcoVQ+TWHS6kri+KXPLrpyPAXwE1OQf9Gh1ulIEC3SRt6qb1Gp2ZSCcoDkQ9zr
	ll4mUwi1VY4kfETZez/d+5cIkhkXEvPgH4ekP4xVTZVD1zC7WcUcJO5FAA+68dyE1fF4sIt2/+w
	HSip6ZXumr7oDX5Xrzuw/+kiOHK9ffLatNnGqGba3i85s
X-Received: by 2002:a05:620a:c50:b0:914:afc1:c66d with SMTP id af79cd13be357-93ebd0e4d5bmr3487233685a.11.1792097782377;
        Thu, 15 Oct 2026 13:56:22 -0700 (PDT)
X-Received: by 2002:a05:620a:c50:b0:914:afc1:c66d with SMTP id af79cd13be357-93ebd0e4d5bmr3487230485a.11.1792097781953;
        Thu, 15 Oct 2026 13:56:21 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-51.net.columbia.edu. [128.59.176.51])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a1d1bf6sm29062485a.47.2026.10.15.13.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 13:56:21 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 15 Oct 2026 16:54:02 -0400
Subject: [PATCH 1/3] common/rc: probe pread options with a real read
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-dontcache-test-v1-1-6aa7583973a9@columbia.edu>
References: <20261015-dontcache-test-v1-0-6aa7583973a9@columbia.edu>
In-Reply-To: <20261015-dontcache-test-v1-0-6aa7583973a9@columbia.edu>
To: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <djwong@kernel.org>,
        Jan Kara <jack@suse.cz>, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792097779; l=965;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=KewLqlkj9HfaC+aOJYKAu061lljKKowhtkC9ghOwU38=;
 b=WSyRU2SY8Sew3m9bOIxFRL9FVHk1D0DpCPckLSn3Ls6NVlmM092jU6uF/Rn+8mnHV/Iw+8ZVw
 TcG7BbWA2DWD2aJorUG1m8LMvUG49aRvLHuYmIG+e2Rii2gADw8ObAc
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: xHnSoaTTfAotRNxeo4El51YqRSDHt04g
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA4MyBTYWx0ZWRfX+OosWFTpNrwG
 IGlURDYJKID7cgKwGicODGnHHLPrPwl+KuhZ9ZWwm8PFSiAAMYScxnE1gX/P9fPxNiJy+Fe3blu
 dv8omd8f8sNkQ9p34nF19+J6ktePWfD8Bf1/9kpXZ0AAkt4AzRGL9XnCQebjjD8czljGM6YMHdH
 aW7o5ZvbRLmD1Zypc/OMyjFqnHWF1YxU+PMIChUTA9mDmqm9Z4Uv9XT+f/52rrXFtQvR7Aah+uB
 Q83PgNVdDFWgc4bLxtxTxCnu8yquW54AFIaKPPWvOmlx8fjy4Ou4s09lAiHwZ6wdRp+pVOMpNRJ
 kJxD9fSfNYaDaxcX+yff89xLV1dI5yyj29UNsUQAMv78aQgZuy/bu8qxFda2uvg3KjSlJN0ZPIB
 qbVOTvk337kUuShu22wVmyX2um0W3zNB8bJ0uiaHeWIetYgQEWUwk/y4Kp7sMaGKdnvOcM3qtKF
 27xenf9WOY4bhlzganQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA4MyBTYWx0ZWRfX+Z7XQ5+0Tm/z
 5J5hwPaWgP0oBUpb7Yz5u6QIc+990z4oRIvVkWyntgSCB1tcU5Jm2BBJbD8n60aNEjDMSMf2Cm8
 26CDnIO45l7QWKhIocCRWrNqTiKAbiRKDu7zeNv7N/6K9FBffc51
X-Authority-Analysis: v=2.4 cv=PPOaavqC c=1 sm=1 tr=0 ts=6ad13df7 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=NKoNGjn6KhAaSQkl0TXC/A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=zozjgnHnxDr4c7FHEr8A:9 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-GUID: xHnSoaTTfAotRNxeo4El51YqRSDHt04g
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11936
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 impostorscore=10 spamscore=0 bulkscore=10 adultscore=0
 suspectscore=0 priorityscore=1501 malwarescore=0 phishscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610150083

_require_xfs_io_command has no pread case, so a pread option falls back
to a grep of the help text, and that only matches options that take an
argument. A bare -U is reported as unsupported even when xfs_io has it.
Add a pread case that does a real read with the option, like the pwrite
case does.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 common/rc | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/common/rc b/common/rc
index 1eccd60c..945c9e42 100644
--- a/common/rc
+++ b/common/rc
@@ -3120,6 +3120,11 @@ _require_xfs_io_command()
 		        "pwrite $pwrite_opts $param 0 $write_size" $testfile 2>&1`
 		param_checked="$pwrite_opts $param"
 		;;
+	"pread")
+		testio=`$XFS_IO_PROG -f -c "pwrite 0 4k" \
+			-c "pread $param 0 4k" $testfile 2>&1`
+		param_checked="$param"
+		;;
 	"scrub"|"repair")
 		test -z "$param" && param="probe"
 		testio=`$XFS_IO_PROG -x -c "$command $param" $TEST_DIR 2>&1`

-- 
2.39.5

