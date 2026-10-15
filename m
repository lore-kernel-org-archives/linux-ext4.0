Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519CA286D5D
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2026 20:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792097796; cv=none; b=VL1TPfrZtHzThPlBaHNO8fo+R0le0JqbJ55nrFtmoJ7qLbDQqXgUY4B4FlCdQGChdL/lrGNufovIqutGTB6TrLV+QKWRuKhQPNZsgsCHG+LOGwDfz6MiSQmt52KhnQTZzPrepGsjGQoRJMIpd0g8EmSGAa+RmrUDur8ztrViSso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792097796; c=relaxed/simple;
	bh=t3ERFHDYX9eivIjhmvdakTJ30No0XhqVZ3vAER4OqH4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=I1Flrrc9N3cWGAz4r5KG4KTDFUfECTalSSQFSKbHoVMDho5Avic9TTfgqU0Bsb2PERdFJxh9B7dGPVODf7EJ4FfrAzbiLdD/T7JWlryH2C6HbLCULHChrpIAmMjnKQfPkGuttiMq3rBdMLZz5J4kfHHFmfj3+0TQn8Cc8WO1W/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=dFnsRPSj; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=WU1zYAvs; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="dFnsRPSj";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="WU1zYAvs"
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FKaE0c1706693
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2026 16:56:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=aiIoU40pPrOXmxbOialhJTA1St
	nxujJBLhmfDkeENBA=; b=dFnsRPSjLE+yrgWxGIrcdPeMDzhhqlEKuD0TG5Z+ds
	AUuHlN9ZCH6838dfB6JVmoFac/c3nL6TWo7x946MyGxK/eSPYoF0K87Ga1bnuTtv
	MaP/Q7SVnyGawUm3+L536QzGKuIwqMSNrvW5yo2mW5Xk5tWvvcABPNPfuXIXKG5G
	2wFGUl56pOWN4wL75ovfH1NZ7WUnBiOps/frc2gw5PO33JRHdnovk/1DRArkSis4
	C12vVSvHm+b18iRnbY5jGnO4NpFeNg8lonMDEJhEVyqsHXeSkIfc5TiYcpbh/otg
	5dK7HfWVZs1B8eXLKA1Ier0p45BGaQsifZFzIRe5T1DA==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hb5m38bus-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2026 16:56:21 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93ae8e7e546so1221884685a.1
        for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2026 13:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1792097781; x=1792702581; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=aiIoU40pPrOXmxbOialhJTA1StnxujJBLhmfDkeENBA=;
        b=WU1zYAvseWb0lJwwJaAbOvFczstYh0qq1PasrjoqMTJFXkD3fsdhk4n56eAwpASVt1
         2iq+dEH5ID+W8xpge4dqY51rPkxkMxs7TVuDh4KPHLzUcDLAiCm15WwjcSFSBmI7FK2s
         aQfz2nIEQOrZR+ilcDy/HPCaPHks/PRjQDm9gfu/xY5bDGPK/EshpK3d8lv9mzO6O7Z4
         plQWnqhTIu/9he7lsrecA/2DlB7pi1nGHQtZ9CUP6DUDEY6hyjMRrc1fum2ac9aQsy1N
         u3ovzpWVKk4XwH6ElZA3mLoNrYFyxArtmMDtiVnoKqmK+gzDcyLYrfI2v5Y1eZ3G/e8y
         9dhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792097781; x=1792702581;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=aiIoU40pPrOXmxbOialhJTA1StnxujJBLhmfDkeENBA=;
        b=AJTqn9t12THC6r+rLx5SPku70Fj1bhA9DwmEWhHoQ7oMsY3X8xkC6t/CCWUasQSA8+
         m7hxrdKAe6ISNE0lXH0M7FwDai6+Nt5nXTxb1UETHP4HrEeCGl6iUlDUhAerxENpJCyj
         FbiSqhNOjeVA0Ff58doEfcsCjjnX6aO3QtbJsGxhI5Nm9En1pTfRVumc1se2NQWPDgZU
         SjHB48Vtt4zpulROdMStZk9jxjAAQpP6UWs0/LEOVBLcOBp2l0XLogth1jJflYrD/i5h
         3Yk9RFzkULT6B5ZQLSs67+frXba3cOKVjZ4Y1BHvwV5lWwBtY7C6T9M99tJcmRznhfkq
         CdsA==
X-Forwarded-Encrypted: i=1; AKwUvBw3u4N1Tm6LhU8ApBlJF1kv/+xHSP+KHys+0OHDAkWPtNlXiMU6FbZbFkvyfaXem8LSkuAHqX9l42R4@vger.kernel.org
X-Gm-Message-State: AFq9FYLDED772sZAFpMk4O7E0vIbheNcdaJtLAveDdhqNtRg5E5XQrNc
	n7QP2yu+80EEU9kqIPtUYOzbqLYq0WOQLkcqws2xVsjtwV2m0CYsryzkvP8GgiomMWn+9JS8ko5
	Uoho/WWWTZm22DaMCvVQlyxs5VxqI6jYynhhluCu/3GYp/JIwbW26FQW6qme41uS1EI8=
X-Gm-Gg: AYBFou2TAbLYHu6wK2YZIiYHrCl+cLAFGoJyJ0xXCyW+w698qvu8OwRPMJD+Ps0cfcc
	YiXmGYdgYwXNkHLB4+R9yLfAPk7N0uzn/OBeUN4aaoizSRv9Jt29FPdjYo0yxp56/Si0ku3cuvq
	Z2uJD+BkeFCCbkX7QBVNIUd/QYXGt0AGJntvx8cpL5DpwQENbcqBgkTSLUBpoRUJZ865IW/Qhrh
	uwOrdGQW32ggD6IR83JBqa+TO4dggHC6MYO8FxtCd9/4StQmfLHoZGSwY85OHhGJo0inSAUlQo/
	owPU/apyfarvQjZOStSHsZ0CFLoXkXN8ngNhDM4FRp3GIwsl+TSXX0qh9OII02UaM9FvDESRarv
	lzYmx9hZ61jrMtz/z9GQlXaVHK8ePJQU2YR4NExCyyNgT
X-Received: by 2002:a05:620a:6f05:b0:93e:5fff:db02 with SMTP id af79cd13be357-93ebd1dc7camr3348688985a.28.1792097781501;
        Thu, 15 Oct 2026 13:56:21 -0700 (PDT)
X-Received: by 2002:a05:620a:6f05:b0:93e:5fff:db02 with SMTP id af79cd13be357-93ebd1dc7camr3348685085a.28.1792097781051;
        Thu, 15 Oct 2026 13:56:21 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-51.net.columbia.edu. [128.59.176.51])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a1d1bf6sm29062485a.47.2026.10.15.13.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 13:56:20 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH 0/3] fstests: test that RWF_DONTCACHE I/O drops its folios
Date: Thu, 15 Oct 2026 16:54:01 -0400
Message-Id: <20261015-dontcache-test-v1-0-6aa7583973a9@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGk90WoC/yXMQQqDMBBG4avIrBtIYhXaq0gXMf7quIiSiSKId
 zfW5bd47yBBZAh9i4MiNhaeQ4Z5FeRHFwYo7rLJalsbbSrVzSF550eoBEmqRa0/b+fK3mrK0RL
 R8/4fNr/HsrYTfLovdJ4XDEUlvnIAAAA=
X-Change-ID: 20261015-dontcache-test-be6094aa3f20
To: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <djwong@kernel.org>,
        Jan Kara <jack@suse.cz>, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792097779; l=1071;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=t3ERFHDYX9eivIjhmvdakTJ30No0XhqVZ3vAER4OqH4=;
 b=aTe1GsCeWgX96xARGRDkdTsAWzQyK+GVufXhmuoXRf5cN0IqkTJK98n/wPoomUQnyrGq6DLDZ
 dlDSw2itHfIDkyO4LhumqIbai2HN5tggFvUmmpyVh+23P3Sui4JC4uN
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: w4GWxjkEsHgrpQz-8_koMWbmF54Dbs2p
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA4MyBTYWx0ZWRfXxQK22arylgbT
 mBNDPrjkQQ+ooWe5aVM1Z15T9rDt3+Nv7zhpVDQv/qGTkNVgygdv7Es4/OgcDebJO3iMbBmI44h
 FHbSf60viz/NH0iV0/R1CEcTDCUenJ0GQI2BvbumUKsYR4BjjjyRrfN6KFBjl1EKXsRZvjgJYAj
 rIJ2NNIfKupq+TtRRtyvdP07ic3TXAnPG6fcbVRPOiJL9v/zrb4BU+CZlUqQMeRWvqdql5TUHvK
 n+4Jw02H8tCnlCNownPBgGIUQ1/0teZ2Xi0o/gNZwznFTWA3muN0ykSXIE+oA+LDiZo5mxi3L+v
 SPhE13H7t5Ii8htBQjxao3wmTPnwmjRMvRQpHhTVfEcebIFo02Ir+JV1kizJwKCjWknpfeP+y2q
 JjIsXNFHme8d5AUCyjuozW8qShhKNdxDRgjBFrxmX/SxskajauuxGVeOnfxLmXDxAAngvUy+IHm
 Kguc9kPnfNeFV16xV+g==
X-Authority-Analysis: v=2.4 cv=RYAFmFtv c=1 sm=1 tr=0 ts=6ad13df6 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=NKoNGjn6KhAaSQkl0TXC/A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=VwQbUJbxAAAA:8 a=Ty6xO_GhrNNmo2U9QisA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA4MyBTYWx0ZWRfX1gGcJQTi+IPM
 m3TY3VjBsm3fPz7G2zLelblIdR3I47FPkshVq9nkr0rsB1fJtJY7DfL9EnkPcdu+qERa+h+qgwC
 OC9k7ePRB31c/2110LPPAGN5XsK3lsDu9mCJSnTZgsBMM72uAZhM
X-Proofpoint-ORIG-GUID: w4GWxjkEsHgrpQz-8_koMWbmF54Dbs2p
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11936
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=10 priorityscore=1501 adultscore=0 clxscore=1015
 suspectscore=0 spamscore=0 lowpriorityscore=10 phishscore=0 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610150083

Add a test for RWF_DONTCACHE, as suggested by Christoph. [1]

generic/810 writes and reads a 1M file with and without RWF_DONTCACHE
and checks with mincore how much of it is still cached after each step.
On ext4 without the fix, the dontcache overwrite leaves the whole file
cached.

The first two patches make _require_xfs_io_command able to probe
"pwrite -U" and "pread -U".

[1] https://lore.kernel.org/linux-ext4/20261012-ext4-dontcache-complete-in-task-v1-1-6ac801557041@columbia.edu/

---
Tal Zussman (3):
      common/rc: probe pread options with a real read
      common/rc: pass -V 1 when probing pwrite and pread -U
      generic/810: check that RWF_DONTCACHE I/O drops its folios

 common/rc             | 14 +++++++++
 tests/generic/810     | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/810.out | 11 +++++++
 3 files changed, 107 insertions(+)
---
base-commit: d07dca72d2455f4ba8c660ad4c008541ccccb707
change-id: 20261015-dontcache-test-be6094aa3f20

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>

