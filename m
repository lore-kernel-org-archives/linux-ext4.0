Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.135.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794104392;
	b=WduLbddlp4BvLaQHP/+C8wpt+L0peP0ctFNYSnV0U9yDI3lXpGiNT8p05MTUz3ciyiZO
	 DBUYtZNtrD+Jh6+UWq+N9VTWG0C1Ue7RaXtkakdOzu0oGJvOobFosf57KSd4pY0jUlGM5
	 sS3LAkAm1g/jedwZdr96LOWhM8e5tRhP0X087YfBIfC4R3qmLJ+ToOhYtxVIiCixp4sZx
	 Md8Mx0h0mhTqdoaEDaVqGLAMTDpseLyHqywiByjECN++l1WQ0FlljFsLntZo9pni0MbTl
	 ZRvA0zLtpVSP6i4RSDTb/UjwYyCMz6DQ2QNERbZsogcpuEXLavHT+mbuUIQaVtilIGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794104392;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=sCMq+RfBZIbc6QQFaznjLDgyO+p8lUR93axMHEZIRu4=;
	b=zZR4auC90W/7GhxYqhbkZpLtJZDhQugs0jl+fw8A0Huq0YMLnafH9gWoI2MMk/3zx0vq
	 CYo5LudrTgiCHnrIxk7jMoGBKNX5/DpxGDyt0qDZq5thkTps+CD0PCd4QgeXWv8izKpKE
	 pb3Z241HuJe7y2Cb59Yb/pcY4jIupXeTYftsQOuo8KY5TQX8ajGtGihPQKVxMZ0NR3FZa
	 5v7HRhqT6oUwW9vmxwIgpbGwHQ7D38/85/bohpn9mtoD9atTNeaBvGvlu51zS1WedDrS3
	 3sAdCJIRKzR2eloHNZNAqAsX+1DebtLMAKe/aS7AAO386WFnzf5N0axfs0iBmAelvfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=X+FHg4R5;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=B6PZJzbS;
	arc=none smtp.remote-ip=148.163.135.74
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52F0606A31D
	for <linux-ext4@vger.kernel.org>; Sun,  8 Nov 2026 02:19:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D52F0606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=X+FHg4R5;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=B6PZJzbS
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A7NtBNd430919
	for <linux-ext4@vger.kernel.org>; Sat, 7 Nov 2026 21:19:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=sCMq
	+RfBZIbc6QQFaznjLDgyO+p8lUR93axMHEZIRu4=; b=X+FHg4R5oYjtXqRQJ8jW
	OLBKAnJiix3XTBKSXRe8n1ldf3a6NTAa/04VuTRmlNYODuBMlqZ2mUdFj8jT9Z+p
	riqvXNP1/KtECb50a8AsmyuCZH0UpmqjQ1q8Bbf2wbhqXjbCAixq76E5gh/MVtaO
	5pIz+IPsAewfD6mlLDtFG2VOtUQBhZACi047BtUMukxvHxpbIXNDR0mmxn7QCaL4
	NRlBsHHze4E4hYmX4UgH7UgrYfyK2fF7BzMYEI6/+gDJdaAgdETFlcEWNGOPYoUe
	KyrKdlPJRGZjV8Vfjol/+kPoGgl35dgCVIrw6anRl7O+NNKOACbeWOH91rPVQdnr
	ZA==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4ht11vkqwp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Sat, 07 Nov 2026 21:19:45 -0500 (EST)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-53661e036a2so3759101cf.1
        for <linux-ext4@vger.kernel.org>; Sat, 07 Nov 2026 18:19:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794104384; x=1794709184; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sCMq+RfBZIbc6QQFaznjLDgyO+p8lUR93axMHEZIRu4=;
        b=B6PZJzbSHtWiMcxvV0XNZNfeyxmmDAKrV1V0m2HzPNsyLjbwV01eZlLAOrE2+ZHTtP
         pblYr3qMHH7OfDOy50+L4xEnGHyisGe9iZRZ/1QgphyGCUzWBfXf5n17dKBZTnn/C9i/
         B5rfoOfBkNVndIChtgSAMgCFf3yu9nNJHwhBVORXytUx+DKeUoKO+h5Vi5vczgINf8fr
         91ZqKDzTIvoPD3Wp0i5HuWaGFfpxIzWdFoLxqvbquOSEkBPj6Zn3JnzmvZDOn/I2ixyx
         ifmYPzYiJ5RhpeVN98zq/tKmThHAs6sHW53Zb/K731G+RDiNGGqUD+sm67A8BBkT6DJK
         5QlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794104384; x=1794709184;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sCMq+RfBZIbc6QQFaznjLDgyO+p8lUR93axMHEZIRu4=;
        b=CCUUkNs3N4e1Ea30JGQFN+QP2pnm0oJ+kN7+I5Qj0by9b/AIKOYX5xSA5d1u2aKTLW
         7hUjz+qBMZGi0JY1FrzTY1XWVuI0CPf+JugrFlhX8xjC1D62dpoU1mG+3E4W7Qo2O2qW
         PvOh0YIiMFAxkpwVqya/KSc8b4mk5VVvqzYkYlHlvcV2x4UoY1Vw+AP80c2S9SRR9zk1
         f/mOKvrPPOpcLgDMapV46hGCH3vnI7yFzozRPLn9aQx0z+I6VkW4NixSCZI6hy6TQ3rM
         MYxYF8cmG1G2dG5QOXZnr/a4R4ztMKNTLPUuSA6UeBEdhpykAIJpGI3Y1QJBBwbzDBUx
         hzkA==
X-Forwarded-Encrypted: i=1; AKwUvBwh7hHHGLgmAMM+TWEW1f1FNSxGEPPBqS+3xBPvVHSq+WboNJIh6VaA4ywS2vDRsdPHP5U3rbZH8iy0@vger.kernel.org
X-Gm-Message-State: APuU4Z9z3WlGZT5AXPbmpBR/GDiJ63vmPO263jE8YULYVIaN6xj7oKb+
	ztX7+1uOihL7euU2tlh76bGbi2BVHsQQoO4BjphG8IJsY5gF6siH04L1JA/i0SGSXHJFt+rupsf
	75ip5JWJ7l63+CdIvBR37OqWAMVv7RAMiS+9depOLGVGamDM297H1tMPi0mPpLVoTuvU=
X-Gm-Gg: AYBFou1xjeurzt53nCwB2rkz7qGLT1i5mJlbncBmVZ7ICsjYi9cFMCMiNd8NQpuS7o6
	kn0mnx/7txFbDSqsgjkPM+ygRAn8M9d43Mr7Q6Yui5K4U5eDBWUpoukIoSVuaGniHBa1eMJji3j
	cWyuSUjGivW4sSNs4241jqT2iv28hICigs7sKFLVt9ZVOMkezIGkQpH2p5frLgujRyKr+Wi1W/k
	P+K3x0FEZI0jP7i/eTfAXO0sNhOZJK7dWJc/bMCcc3uZ+jT1iEIKbCp4DvG2Ms1ZDt5Zt1cdOO2
	b9yD2ylP3DE/hBtye4V+neEYzyejUwpKxcOf1qhbloM7cRjEruGhfupDZB9IlN7HdqcZYJ/MZtu
	yZXegP7VoAMWc3zWCPK6KumPCkLz5eoo3g5vVPUAlw1mzYatEcQnkr7WPP5ZPKF6XkcM3jK2Ieq
	WieYuVS8aF/63xRvap6g==
X-Received: by 2002:ac8:5f12:0:b0:535:856c:1241 with SMTP id d75a77b69052e-552a578c620mr3906991cf.56.1794104384073;
        Sat, 07 Nov 2026 18:19:44 -0800 (PST)
X-Received: by 2002:ac8:5f12:0:b0:535:856c:1241 with SMTP id d75a77b69052e-552a578c620mr3906881cf.56.1794104383662;
        Sat, 07 Nov 2026 18:19:43 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55263e65c37sm7398731cf.11.2026.11.07.18.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 18:19:43 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sat, 07 Nov 2026 21:19:39 -0500
Subject: [PATCH v2 1/3] common/rc: probe pread options with a real read
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
Message-Id: <20261107-dontcache-test-v2-1-7655bf08d6d1@columbia.edu>
References: <20261107-dontcache-test-v2-0-7655bf08d6d1@columbia.edu>
In-Reply-To: <20261107-dontcache-test-v2-0-7655bf08d6d1@columbia.edu>
To: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <djwong@kernel.org>,
        Jan Kara <jack@suse.cz>, Brian Foster <bfoster@redhat.com>,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794104381; l=1058;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=g7wMEEH7lKhR5wDFpgsEHSduxWWwBO0YYNK2JcBk7e0=;
 b=ELaVECtALdtYDIJTuF+pWwmgCmyfVP2vXqXMs1wcRxui1RKAXtYVF6oGBXKuAIWzymLecvtIn
 ssvsWcHtXuwBqGDE0pthMbZqKyveqOKeCetQ8xrydtkZvVvVjpQONop
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA4MDAwOCBTYWx0ZWRfX3ulEDZ+sJIhh
 SXamOffCpKsDa9zsBeeqhVkOvxOYFW5tWqnNzcnuZqkSuUSy57bA20B435LnwHim0v9jCp/PwBQ
 wP1jShGEheIzZX3rPaYEMGC+NWd3L1+21wVkKSu1sx32+ivqtpOiCPiI9yl0kI5jWLYAKakRm4w
 i8zjwu5pFmrgx/BX1TjiAQIR3hrbjyxfhDIhRReGqn3IbU+YHcj7yWueC4wRfSdL/rAhoXHcIb4
 X8+a62xt/CE9Gb+n12hdeAfF4taciAMW4b0TWklGMe79TYwnU7lcx0YQ/J1CrM0FraHgbVZrRUg
 IUKZTPpO5bDCu+WTIoehUWdoHLOddmBeJ2srCj8QRl7ii9HJao5s7uvQa8ATD2LEZ0+ziy4on3U
 +ZilqIR8wbiOR0YqxOJl3a1+lF0Yv0SKVBsUIzdkmkpanJaHdVzg6JTx1LdYJu4J2gFphQSHiBa
 L0dfuTHGJfz85rBHsCg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA4MDAwOCBTYWx0ZWRfX4/cPQyHUMv5s
 6J1MPbjpqy27wO2PP7CVmkWwWCXEHAziXvQmfeEszsdcf/zCN41Mou/GqyosZir6tqtLNJ3NnaQ
 bc8db4urQ60QT+giE8haxUM7NipaYPfBWvqUQeVEdsTK+gYnXdT+
X-Proofpoint-GUID: mBGhmroO-7qsaiUd9i1bdq751ru3X0eR
X-Proofpoint-ORIG-GUID: mBGhmroO-7qsaiUd9i1bdq751ru3X0eR
X-Authority-Analysis: v=2.4 cv=FLiOVOos c=1 sm=1 tr=0 ts=6aefdc41 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=20KFwNOVAAAA:8 a=lXqyDxuXACF71vQqlpwA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11959
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=10 spamscore=0 adultscore=0 clxscore=1015
 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=10 lowpriorityscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611080008

_require_xfs_io_command has no pread case, so a pread option falls back
to a grep of the help text, and that only matches options that take an
argument. A bare -U is reported as unsupported even when xfs_io has it.
Add a pread case that does a real read with the option, like the pwrite
case does.

Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

