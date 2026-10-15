Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122BC58E2C6
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2026 20:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792097794; cv=none; b=ZxzOs4PHeoQ5WuXGAnvpGUfWIHMqdKqiz2MQPvzjlEvEMXytlDobMySKQd0hexP+5ZP5V7riKgLbm3uorlsNMquAwJjCO8BMsvkdnh2k6MaTMGbZv60WiAt/l30WHy0dVSLiRwatseLQeODHNtFljFMXhvNPqHBQKBW30ulvHys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792097794; c=relaxed/simple;
	bh=ciee2zWhT8lxantCi46yYHD5wYqbH4IopJ2MwJBGLz4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RiMXCQkQ8rNGHGvEAB3n+BGfb0Y7FeKzdgYG3NokZ3UOznD99meBx/zESq0VRFkadw0oXhDvU/JN8R5+TnNQQ/iAz4H/8pNxDHjsRJhpEIakEWyLK0B8I7Ru1qAEDmtTgMajEnNSPj5JtmX9Qk9xejvPP53jWLgHcLjgP2ZH1Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=TDyYyGK6; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=hvpEcmYw; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="TDyYyGK6";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="hvpEcmYw"
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FKaGdd2463582
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2026 16:56:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=8Px1
	FtmNtK6xsqmbcUZAty0eeqDU/9nNBMTp6lOdRrg=; b=TDyYyGK6J88TACC41n0t
	CMA5kTgLTfwY3VvarwMTuxVrMgCTd4LD0bdMSDbPbW2Dags+l1XcK8MptcE8v+0N
	T1et+iv3YZWIW0l/1J2c3NAr9UB+FQyYgAV/hYK8oErQCjFkcLqV7MtjbqXjzoxY
	4q3XjxXSA19l7MbwBWs9uRAKteu+OVB1x4CPTl/nAb0Ngq8K+gxalVt3b1UXbSvG
	Gf7PyfNdW5oX0cuuxGeKnTcHW2pTKXLpwVTWQ1gMtlWTRr8YL5aVX4/fkEU8iVCd
	jTlXyaevmtyagRawAl0gVgYTbAh4cLs7k7DSNbnal3CNUmf/1mvRVZxGa4crSlJ3
	pw==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hb303sv0v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2026 16:56:24 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93e834ff4d0so1499158485a.3
        for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2026 13:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1792097784; x=1792702584; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8Px1FtmNtK6xsqmbcUZAty0eeqDU/9nNBMTp6lOdRrg=;
        b=hvpEcmYw2gDDysN2ykQWNMxfsnlNt2TetBhD1egFOiWs4Ns5t1/qngOU3wtFSggtLt
         UpUPFNbJeMYSDEWfFFAY/pbybD00khntK518BXd3p1TZMbuLKDa41Gp96tMQT4kkrqEu
         fCc/RmeqanFhRzhbTk26/odI6y8RYJiC5ed3e9e0zJl7Cj2wcHySNdPb1Nct9BQm2Omj
         Szj0RjNUJagpkQ/RoMAz5Gqx/GpaaK0xVwAnSaWB8aOvyazFIBl6B4kc6CQbYkoWM1OB
         ifL9xmGRw/Z0jNMrPFCL245fARvewBvn4C0gDZFzIlpz6oPpiVgxvMNZYuhJpkPV6nsq
         tzUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792097784; x=1792702584;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8Px1FtmNtK6xsqmbcUZAty0eeqDU/9nNBMTp6lOdRrg=;
        b=fIhBVJlKQW+Rvmjb2gAtC0d83ykW+WH8RRaY+IAVQk5aKtORAgcwbnQLG4xQTQQatS
         GtdFH5XN1EGUNIF/ndBphctF/+83vAjsDWDzmxolrlGfxGU6jaHQG5LJ00EmW7Dfj0wQ
         el+5GCV2miiKb+lrZXV1yBwb/uN/lUjUQmPxNFGKYEtY2ZhyK8CB5DICHchzVc8MTkTs
         z6DQCPBZO9qDom5ndELo7Sg0QLnWIJnxEOyTkEQfAKKR2PhESrHPCOQSNnRRctMCixEs
         MK6TG5wZytIVMqxpQcA1zmu9CY/PJ0oGeZ0C2tKbmqa2P0yaoNMG/fOj6ROyJu3KbrtW
         za7A==
X-Forwarded-Encrypted: i=1; AKwUvBz7cW+lzRteWIs3/IaTBpOace5LQ4EhI2tFnLxGAqfV+yLP7f4s05eMJEZV+cmEuLXCvJwnu0kl2vyu@vger.kernel.org
X-Gm-Message-State: AFq9FYKjFg/VGCCEN3iDhtroJ4Q5nYEyf/YkGit2uuEM6O87Luu6Jc8p
	cIGaCRdyDC5HEBPO3UtLOlm32p/lpSzJ7/o0MGr0NrV906xjF4mNXh1r8EE4IEumcgy5CQcsjqj
	SyQAEMxvprLlL+TfKT3WsGr96zyikywa1zUrSdr9tWnjmkXMiyWh4S19f4xY=
X-Gm-Gg: AYBFou01a0U6Ig/EpnMJh83PyUJwI8ZjUD0i1SKbhjs19ofoHqBg6xf9eoKxZkvqYtX
	XeHrZ0paYf39zT73lJ28Y1qZg64ur2wMVVmBX2ZEJFkOrILyDhtxApHoEtiWNiPNcYnWFV5k2zc
	NxPNA0UIdQf/JTcRPjt/xK7KIlHDp6hQ7YcY3tKCJtwhviC6cQ0CENyz+EdyE6wm375aQ7NVTV8
	0/Qp9NZC8dO/KsJzjvQOunzctq/U7/bTlmB9+x0dwpv2pQTVsDV98naba6xi6PZqOKSqmuHbsB2
	GLAZFhC47rqo1q3znCsVhh+E1kgSZ/STVU7QjtGohMRW57uM3T98JWT2w/hDb0JSj437VR2PL63
	FMCZVIXb49ipHd4Vqbr5VTjRqnwkSVb50EhGGXp3WgI2v
X-Received: by 2002:a05:620a:710e:b0:93e:5e2c:8c12 with SMTP id af79cd13be357-93ebd2aae46mr3259512885a.60.1792097784347;
        Thu, 15 Oct 2026 13:56:24 -0700 (PDT)
X-Received: by 2002:a05:620a:710e:b0:93e:5e2c:8c12 with SMTP id af79cd13be357-93ebd2aae46mr3259508485a.60.1792097783725;
        Thu, 15 Oct 2026 13:56:23 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-51.net.columbia.edu. [128.59.176.51])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a1d1bf6sm29062485a.47.2026.10.15.13.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 13:56:23 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 15 Oct 2026 16:54:04 -0400
Subject: [PATCH 3/3] generic/810: check that RWF_DONTCACHE I/O drops its
 folios
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-dontcache-test-v1-3-6aa7583973a9@columbia.edu>
References: <20261015-dontcache-test-v1-0-6aa7583973a9@columbia.edu>
In-Reply-To: <20261015-dontcache-test-v1-0-6aa7583973a9@columbia.edu>
To: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <djwong@kernel.org>,
        Jan Kara <jack@suse.cz>, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792097779; l=3694;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=ciee2zWhT8lxantCi46yYHD5wYqbH4IopJ2MwJBGLz4=;
 b=9TnIgvCxwMMJAO5OLRloZAbaDesQ0h773ImjEbA/dXoHu/0bFm12h5OClVrb3/UM4YF6pY4Vc
 y8U/xT8ZX5eDinW3M9NJCi+h2iIEsdca3dJqz8JkGM7Z5ENFcrhQtPo
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: 88SRmoVE9NQ6OAXTvc1HdFSDW-3PDlJG
X-Authority-Analysis: v=2.4 cv=IJmXmQvG c=1 sm=1 tr=0 ts=6ad13df8 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=NKoNGjn6KhAaSQkl0TXC/A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=VwQbUJbxAAAA:8 a=aE_N2tjmDNVO8T2WUesA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-ORIG-GUID: 88SRmoVE9NQ6OAXTvc1HdFSDW-3PDlJG
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA4MyBTYWx0ZWRfX4DXlssNSm6m4
 2LF67v1i37EXg9lbjBB3Sc2JudoQuX+bLCFDzOtVUBpCqFS5SSPRC7PwqBhFNlJBt9puVgTPaed
 zfpe2lCEw/26sTanS7Ov4CiKk9DdPYUxzGlnkQntVgNmBUvSvsxU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA4MyBTYWx0ZWRfX+vYxi337IZte
 dSVRCgSqx2vS+NkUEr2xeBg6ikaH448SD7je9JcLTK40KeYZrFwwV+mg5gPuWYMqH9q88PVjiUv
 bkrg2pkl1Yof6ElWqJQiLHzJ1nY+rFbLlI/U5HXovRCS6nANM6uGF8GwauScbqZVYlzDU2gtQz8
 p/b45TUolcyYqLZNNsVBZ87YrB7LBGXjGOU/TUQy4SpDz5ib3+5Pc53rlwukHWMykxyKpd2wPdd
 uthCQsSloiG8jB35DJzQfQ1GYTzuXWgVG4gsqe2BysbRS+d8ddmKG+sWbvV/pDv1Suw6jjm4mKD
 GmrJ6to8ByDsW34E+hwwY/uO6AmFzo7E7y8maLNVJPBDW/0Miz8g7WgXxs2DNdW5uJJndLVpf4U
 nljFNwKo579gznaxI1P4iFgBEwRSscLWLEkRXKIb0P/qTiWb8NqU5I+3e6kMN4crbgdiv5SKWmW
 4wnn+Ab+e/yRYYfRyxw==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11936
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 lowpriorityscore=10
 clxscore=1015 bulkscore=10 impostorscore=10 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610150083

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
 tests/generic/810     | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/810.out | 11 +++++++
 2 files changed, 93 insertions(+)

diff --git a/tests/generic/810 b/tests/generic/810
new file mode 100755
index 00000000..9022c26a
--- /dev/null
+++ b/tests/generic/810
@@ -0,0 +1,82 @@
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
+report_cached()
+{
+	echo "$(cached_bytes) of $size bytes cached"
+}
+
+# Dontcache writeback drops a folio right after it clears the writeback flag,
+# so a check immediately after fsync returns can run a moment too early. Give
+# the drop a little time before reporting.
+report_cached_after_writeback()
+{
+	local i
+
+	for ((i = 0; i < 50; i++)); do
+		[ "$(cached_bytes)" -eq 0 ] && break
+		sleep 0.1
+	done
+	report_cached
+}
+
+echo "plain write"
+$XFS_IO_PROG -f -c "pwrite -q 0 $size" -c fsync $file
+report_cached
+
+echo "dontcache write to a new file"
+rm -f $file
+$XFS_IO_PROG -f -c "pwrite -q -U -V 1 -b $size 0 $size" -c fsync $file
+report_cached_after_writeback
+
+# Start each of the remaining cases from an empty page cache.
+echo "dontcache overwrite"
+_scratch_cycle_mount
+$XFS_IO_PROG -c "pwrite -q -U -V 1 -b $size 0 $size" -c fsync $file
+report_cached_after_writeback
+
+echo "dontcache read"
+_scratch_cycle_mount
+$XFS_IO_PROG -c "pread -q -U -V 1 -b $size 0 $size" $file
+report_cached
+
+echo "plain read"
+_scratch_cycle_mount
+$XFS_IO_PROG -c "pread -q 0 $size" $file
+report_cached
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

