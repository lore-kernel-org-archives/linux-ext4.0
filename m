Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.135.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794104394;
	b=yMiOg59H1y7Ts+pxEnjRmEKE4Yev8duBTi8lZ/fv0PXf7L4VPSCG2igJtLPtxPi+f//Y
	 nna+86aPnswKE3/aV8ywvwar8+917Y4FYiQlx2hnzAu5FT2F6AyOxA95/oIk0CCnVytuL
	 3OdNG/YrFHeyg5szUpf6twnU0c4hlzXTpnk3X5qkyx2SQhi4BK7fNXh6cZfGgRadDuBWx
	 tCEQxjXEBFbsKWZp54SwxzHZbO2UnHsjTxfJ16KSbW7/8kQlHJTOvWOjLlAcLJlnY3O2h
	 EHVZYaRVYnuQjInC4npz2P2vpg40XzsQ3FnXhsszGQgXJMFwStrej2X/5Sy4/3NI7ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794104394;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=GZXHYpad4oOt5gixJMV6/CkxNmud5F9X+J+yEsrk7JE=;
	b=UCOfPAw718swDvEVHsCKqWjylDvK+dZ0IF3AQCgq/jbjnGvP9KnCiyD3FA7zyk64DJPG
	 v4lATGKOQf+g/hOCBlCuyDsy7WYzHTpnKa1YcVJw9AK+s9x+cWN6A5w+jVKrQsx0uddeJ
	 fqPhTEHKQtVeGXE+RjLj6xnIX2m2o36Am1ISVfB3zZUPa14ZpHqyDDVqTHwTU58PLB0Y4
	 UL3lTCNl67Bof2s2sFK4tzvXSRFz9bAwk/3wSbCLmbNfba9RKqjtHq7gJkXYbLT+fw9TM
	 MECkcbNrz9La7GlOd1TprKMYWuB/DQiz7x6C4dy2kwg4DjO7guOmakKr48RBszKmo6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=FjtUEa5v;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=Lxh7Dl6K;
	arc=none smtp.remote-ip=148.163.135.74
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCFD606A31F
	for <linux-ext4@vger.kernel.org>; Sun,  8 Nov 2026 02:19:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FCFD606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=FjtUEa5v;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=Lxh7Dl6K
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A7NbsDY836999
	for <linux-ext4@vger.kernel.org>; Sat, 7 Nov 2026 21:19:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=GZXH
	Ypad4oOt5gixJMV6/CkxNmud5F9X+J+yEsrk7JE=; b=FjtUEa5vOxAkt4JqNkc/
	SDKPFInVEKxSgr2PaegiD6xAczaV874iAdHPvImr5LIp71TTLO0Qqv2MG8tzfWko
	e3anoX6Ec9lf7GPI8Zm2+ccQX9E3FMjKqOdzYPiA8oLIEmGRXz4n8P5b5HRHvxm3
	+MglWcF+AeUIgFOodP0tCVUFk9swP1kl5oPppHItNpgQ/Pz7P9E7PKriNHq+23Qz
	cfLXVACEx0QMsr91ctUwPaCC9Gs7qAS5uzU5qpHmanZkkm/wZhQY2MRPeDcii/o9
	4Q5afWrcPOU2GHEBsVNvYny0GxD2/SY9OhrSe+ceZ5gHkZcvf0rcKR25fAbctSGA
	4w==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4ht5myjpbg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Sat, 07 Nov 2026 21:19:46 -0500 (EST)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5363763b556so3493131cf.3
        for <linux-ext4@vger.kernel.org>; Sat, 07 Nov 2026 18:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794104386; x=1794709186; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GZXHYpad4oOt5gixJMV6/CkxNmud5F9X+J+yEsrk7JE=;
        b=Lxh7Dl6KfqON/dbyn2uGLdVwtgwHuO3PRAoUw1GD0C9AsM2b14j+gYmNGjjn1+gIGb
         U96HvQy7sT4jlM8+af9vzt2Lr0YGubMP9iDA5if2k/joXWL4hh29XZYLNS7nYha4kH2U
         LadhlzRcgVcfrisKfXdhKzOqo7SPm85UMJdBkDi7svweJTcnqtXZu+oisedPv1sTpVct
         4FtAGi/3I1ylV/1sUlYl5PdHm1D7L+2Jrd39xXYqdCp/Rg0R02kFGPF5QPf7OPyRjPJR
         B8fAJ2AFTvU7VHDbOPW5jwFwTaR7JD2JeDoMxZV/QS9CVRsj0cVgtNzTO1M89C+wGN5/
         qhEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794104386; x=1794709186;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GZXHYpad4oOt5gixJMV6/CkxNmud5F9X+J+yEsrk7JE=;
        b=Fo4h6h5KW1FwBNqbV7Fx/XPWC7fBWyleD7CJ1ZpJqEqEWb+mtE0TG0uoLb7cYqRTg/
         eK0+z/eYenNrDQsWPyNAKguq9qg34cGfRQMo06BH/0eL5M/wQCpZtUgMWNo78b/gN11f
         Jd0keO21B7yWUFebcRPTYdWhMNohnFzOGjmA6/b7o4rT/W6SYfIOQMYilfWoAK/fN0Dr
         LirB+7T1Ojw8KL5qCV39K3LRx1rzdygT0mWuPZtbQZQ0zmLXVYHbd/LVgHCVcjhXDu9A
         oHjE+pi5J0iV99DDvAnT0zTVaB3V5uQRQnIP4gBZGX502z6u+sHVbtZTEbc4Jr0KEgE9
         eoPw==
X-Forwarded-Encrypted: i=1; AL+hErE3UmEt6Z/DnpaCVkW+h1a6pEr9p0lr/7E82NGdqgkvdGiqFg//sgsolvKP9eLw0i9IYMo8o1wSBeYR@vger.kernel.org
X-Gm-Message-State: APuU4Z/I3su+GwdSkdWEk4WUzg9egEPup95/joC2bx0AgeyFgmVZiR6S
	qRiZeLEyw4tE7xduzAmmkEZVS2gDUJbVFJn+FbVybZbN58VxtH2zXFOk+EtTInPyvDmxuG1EqD3
	hZxrZUBf71Tw9Q+cSWgzdTysA9plH/spWgMgF9DS2FGsn2pZjWYwxbfSR+aJZJduyB/Q=
X-Gm-Gg: AYBFou2SR5BTvj8RIJQO9Qo3J0Vr4QPKdaHlxDbMXsmAHJPW+bPIjxBfdt8V8Bd3390
	U80sG7x5dGODpmK3lkNm1pSO4N6pFwteAENqZPL+Rbyav9VtLj/ocNj9JmS1Zmqk32O3cJolCaz
	gYda9w+BiE7KkA0SWdxUuEhRUJ/jHQud66cvkSjTidz18vDwn9VPLbtYEbf1SfxUa6eJPqbXxxY
	0ZFF8EWLjPNRd6KngxHceOybbeYa/ky17f82qIP9U3y78u07y80Epk8YmVbOsNboLOyEVB86bUU
	ZOJtuF5LxbO7aik/lPpnvgmClgI/kdIneXqIGFPrLhI5afRR0H+5cvG6LPadTNIBhE4ytwKHaA6
	XPA9C70o4rqzmOGMFAbztx2RU0c/502VqVuCxu1W4TQIxIwWo0ENxvhc144IzwvZs+rrSdkngXk
	OXNOj1Pr4GAAlRU1zRIQ==
X-Received: by 2002:a05:622a:4d0e:b0:537:83ea:f96d with SMTP id d75a77b69052e-552a20042a3mr4502191cf.8.1794104385890;
        Sat, 07 Nov 2026 18:19:45 -0800 (PST)
X-Received: by 2002:a05:622a:4d0e:b0:537:83ea:f96d with SMTP id d75a77b69052e-552a20042a3mr4501981cf.8.1794104385482;
        Sat, 07 Nov 2026 18:19:45 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55263e65c37sm7398731cf.11.2026.11.07.18.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 18:19:44 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sat, 07 Nov 2026 21:19:41 -0500
Subject: [PATCH v2 3/3] generic/810: check that RWF_DONTCACHE I/O drops its
 folios
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261107-dontcache-test-v2-3-7655bf08d6d1@columbia.edu>
References: <20261107-dontcache-test-v2-0-7655bf08d6d1@columbia.edu>
In-Reply-To: <20261107-dontcache-test-v2-0-7655bf08d6d1@columbia.edu>
To: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <djwong@kernel.org>,
        Jan Kara <jack@suse.cz>, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794104381; l=3596;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=d79UMNtcPxXjVuqH5jzPYBfvKinUpbhjBfuy9JZMPOg=;
 b=2b9j/UUP8DpcmthOzPum0Uz2mmQVW3BRN5foKeG2ADZJciskLpvDSKg5NcEeIeAy9AYvyH2m1
 EBwQ3H+QCDnAUgaO6Re9KCNv5x/H/tXYJGWQxUQ4kdu8jzqi5h8d+lS
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA4MDAwOCBTYWx0ZWRfXzA/oiBGoxvHA
 KV37I6byiubQY+mxr66NEQP8bnzlO4JxCJZPV1x8FG7kWahdhO8cPID6ZF6FlofJTD1+GsSA9Vz
 1lU39Xn17dzcIU9iCaB6G/v70A76ORUfTomqUw4OwFzmFG2MhMdN03pPFJyJpDoYY/pmMlx5USb
 bJVBQdt71461OKYbu+ux9LLLqFrqdcXC6aofQPUFkt11qmUrXpPLnbosC4bCCXPlZwMgvgjYqsR
 akdoPWj7p0RWPoGHgO+woVVgQEL7yN7LK2r1CV0n0ku5fCmE4ljQcKhEZnjLaYGrc9L+/LMF6N2
 34NXN7M0rUEUIVRLx/3XJnKwU78heH5xVjx6ZGz3hH7xfoDNcmlgmTpkmkdqV8KzOUEFi+xPGGn
 3haZvlsZ3NNYW9pMmnlNU6HVEcRQ5Q9O3ANkmjsQt03EfCF69PFwmhVWFcxFESai7lIee972Jv6
 K3AYtwrjUWJunJzwwXw==
X-Proofpoint-GUID: BVpvS17qqL7XpTVd31dxG92hIdpGQDlr
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA4MDAwOCBTYWx0ZWRfXxiuXQTL9c+RY
 lz1TiCVk6+JwLWTS1jcbpqSIrpul/ATtoUPY39/gLWvGcVXIA009TxXP2S9dTk0aIR8fkDiUJP7
 7YcaFQ/6oyX0v33ndBFGIrpRE6CuLqMhxTL47F/y9BnTj5Fe0lAO
X-Proofpoint-ORIG-GUID: BVpvS17qqL7XpTVd31dxG92hIdpGQDlr
X-Authority-Analysis: v=2.4 cv=fuVJ914f c=1 sm=1 tr=0 ts=6aefdc42 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=VwQbUJbxAAAA:8 a=aE_N2tjmDNVO8T2WUesA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11959
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 adultscore=0 bulkscore=10 impostorscore=10 lowpriorityscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611080008

A dontcache write drops its folios from the page cache once writeback
completes, and a dontcache read drops them once the read completes.

Test this by writing and reading a 1M file with and without
RWF_DONTCACHE and checking with mincore how much of it is cached
afterwards: all of it for plain I/O, none of it for dontcache I/O.

The overwrite is a separate case because the drop is skipped when
writeback completes in interrupt context, which is what happens on ext4
without commit "ext4: complete dropbehind writeback in task context"
[1].

Link: https://lore.kernel.org/linux-ext4/20261012-ext4-dontcache-complete-in-task-v1-1-6ac801557041@columbia.edu/ [1]
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 tests/generic/810     | 77 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/810.out | 11 ++++++++
 2 files changed, 88 insertions(+)

diff --git a/tests/generic/810 b/tests/generic/810
new file mode 100755
index 00000000..1866848f
--- /dev/null
+++ b/tests/generic/810
@@ -0,0 +1,77 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Tal Zussman.  All Rights Reserved.
+#
+# FS QA Test No. 810
+#
+# Check that RWF_DONTCACHE I/O drops its folios from the page cache: a
+# dontcache write once its writeback completes, and a dontcache read once the
+# read completes. Plain buffered I/O on the same file has to leave them cached.
+#
+. ./common/preamble
+_begin_fstest auto quick rw
+
+_require_scratch
+_require_xfs_io_command "pwrite" "-U"
+_require_xfs_io_command "pread" "-U"
+_require_xfs_io_command "mincore"
+_exclude_scratch_mount_option "dax"
+
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount
+
+size=$((1024 * 1024))
+file=$SCRATCH_MNT/file
+pagesize=$(_get_page_size)
+
+# Count the bytes of the file that are in the page cache.
+cached_bytes()
+{
+	local pages
+
+	pages=$($XFS_IO_PROG -c "mmap -r 0 $size" -c "mincore" $file | \
+		awk '{ n += $4 } END { print n + 0 }')
+	echo $((pages * pagesize))
+}
+
+# Report how many bytes are cached, after waiting up to $1 seconds for the
+# cache to empty. Dontcache writeback can drop folios just after fsync returns.
+report_cached()
+{
+	local delay=${1:-0}
+	local i
+
+	for ((i = 0; i < delay * 10; i++)); do
+		[ "$(cached_bytes)" -eq 0 ] && break
+		sleep 0.1
+	done
+	echo "$(cached_bytes) of $size bytes cached"
+}
+
+echo "plain write"
+$XFS_IO_PROG -f -c "pwrite -q 0 $size" -c fsync $file
+report_cached 1
+
+echo "dontcache write to a new file"
+rm -f $file
+$XFS_IO_PROG -f -c "pwrite -q -U -V 1 -b $size 0 $size" -c fsync $file
+report_cached 5
+
+# Start each of the remaining cases from an empty page cache.
+echo "dontcache overwrite"
+_scratch_cycle_mount
+$XFS_IO_PROG -c "pwrite -q -U -V 1 -b $size 0 $size" -c fsync $file
+report_cached 5
+
+echo "dontcache read"
+_scratch_cycle_mount
+$XFS_IO_PROG -c "pread -q -U -V 1 -b $size 0 $size" $file
+report_cached 5
+
+echo "plain read"
+_scratch_cycle_mount
+$XFS_IO_PROG -c "pread -q 0 $size" $file
+report_cached 1
+
+_scratch_unmount
+_exit 0
diff --git a/tests/generic/810.out b/tests/generic/810.out
new file mode 100644
index 00000000..cb6c3f2a
--- /dev/null
+++ b/tests/generic/810.out
@@ -0,0 +1,11 @@
+QA output created by 810
+plain write
+1048576 of 1048576 bytes cached
+dontcache write to a new file
+0 of 1048576 bytes cached
+dontcache overwrite
+0 of 1048576 bytes cached
+dontcache read
+0 of 1048576 bytes cached
+plain read
+1048576 of 1048576 bytes cached

-- 
2.39.5

