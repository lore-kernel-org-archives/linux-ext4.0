Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.135.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794104393;
	b=eYl8zY5KAmQeNvHFdG3iMJiLrfRo1yEQcdcV9d8HpVMV43C/7KzOk53yuEiAy0StQuD7
	 nHc0/nGdj2/m3ECaVrYuBiXDCT0xxasdBWv2iQx6l6Sv4KObSKM+DjCXky9eUTQ/WquNP
	 trq/+PlKjnmwxcIpzNGoJDf4LMBcsooy2EUDRfCpK/HwQTni5iyMgVYIahRdy2RJs8HGX
	 Yqs29ImPDUJJwtuERZFB/4wvsI2WvlcB6UQjUTv/mLZVjwfoVoGdQADmBKGd5k8Br3jPO
	 fuy2cGKooAojw98+NAfMj0Eon9UGPM0GAI/SKTDKksaoYOjePWEx8xDCo4wz98ADthw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794104393;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=cCdrrxx7mhDNtuHXVTKYbLje1iTXY6HrNZ9671EV91E=;
	b=kC3Qwhy2cfc/rCDcspMEQhuqOsExzzxEfCpryp7kKFbLnb0ypSG/N8u2GYB2WGOuEWNa
	 sylBqdm15UH/HWi17BeTHw9L9C0KQ7hD61ZR8OxpvFFq5I6iceauE3e/u5aRmp1fgATmi
	 eEEb+j0uIHR0x3uFjvobv7spa87CSs5H5dq7Ds9cFG5MCUqLcgtxgxAW6KX9gGPvmW3cC
	 nBt+jwBucNnlB9aas2ojEF6OlnEk/nEreAHlQOq/M4JjUtTH6nPkwtQJogvGJLDh/bp0a
	 aSx1k0PKdaFa0KXqQo5eUtIM77VxhRPs9Ztvsc5eZWyE1O7Q0/CV/wiA5yzc7/klu8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=cL7EFWth;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=W0n9Wuhb;
	arc=none smtp.remote-ip=148.163.135.74
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5164606A331
	for <linux-ext4@vger.kernel.org>; Sun,  8 Nov 2026 02:19:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5164606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=cL7EFWth;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=W0n9Wuhb
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A7Ncsvj2033891
	for <linux-ext4@vger.kernel.org>; Sat, 7 Nov 2026 21:19:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=cCdr
	rxx7mhDNtuHXVTKYbLje1iTXY6HrNZ9671EV91E=; b=cL7EFWthlbV0AsCq1cXL
	4XtPz2pXol1EcfsuAYG4BOE+jldqt6pWv3BjUgT6bo0Rg6YnhHo2LRRWyE16HPdJ
	9fMcQNVowmgGUy/4gObjcLywe/PMT2e59+arLa0AvVz4JoA/z8UwHzIjMcGYQ7XZ
	fe+Gl+LU+2hu2wamm+MMCzepY+TeE00LATBTfFJgCSBIY+C92tSborkbgudS5wLs
	S1W/MF/W/fjm/aQsSKSHtNUpefLL1CJtmDyBMUxUUsDmMZ2iFiXsGp8DKPZL8nS2
	zUA3rfa548R/VcTcjkXpLkOTm+39rO/zrEs70mjmv06W8siLtFYHIHyFQjSq0/k4
	aw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hsy4um1y0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Sat, 07 Nov 2026 21:19:45 -0500 (EST)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5337f26ee19so2182181cf.2
        for <linux-ext4@vger.kernel.org>; Sat, 07 Nov 2026 18:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794104385; x=1794709185; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cCdrrxx7mhDNtuHXVTKYbLje1iTXY6HrNZ9671EV91E=;
        b=W0n9WuhbZi+p1ustNkNv0hbTZRs13aOkEuclRc5Ot9rnIpf65Slaa+fjLUeS0VGrf7
         bPdeEYZ/gSagRWEaY/aciIgHUpLynhGjjSzStj/fcMkzeOtfUuurR3WUaGFGYri91D8R
         dRfmbZsvv/B0BJBYTC7b74aXGgFJmWDz76+DAo9dKXeDL5eWcHzjVLICmENCssJfSmsd
         4C5QUx92Gh58diExoovAilavWBOtV37tKZeDsKvV39EwLM34lgaJ5dEeZ33GnkFR8xGO
         J7JIyEviu5h9tJmugT/bQSFsnKzOPGNUqd+QjGKTPHSLRCiZPTbFSxkvor2Z+6/w94Hd
         pbyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794104385; x=1794709185;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cCdrrxx7mhDNtuHXVTKYbLje1iTXY6HrNZ9671EV91E=;
        b=G1fpWcwsB/QNhBleiWzeEAV+5SVKTmVNh6efX10jVnWr893XEFlVAzJWbWRAfoGG9y
         wRYKxBh8JKPlL+nrTG472wA8LdyLa/3rjH0VLVlW3cM/AG2udOLjKAPIZDACdHZK+dTn
         nlFAHHFDCZP1HV8XEyEFS06h0sMZ0n6KV3mJGU1s3AGdexRRkug2jgxQ8IE2oIhU7HRb
         MTvHJjMWPW+QTHcDu8wBSiM6GIwtY9/r1WWEEuTmQ7vrcIV6N3kdk4qkLyXNzA5za4eO
         uedwH32pf29ykUgDJcbkGvGkZ9/B+73gRBjeq8sntbQ7iSEHP4ox9UatWu6eMsRt57j3
         nEDA==
X-Forwarded-Encrypted: i=1; AKwUvBx03OB56c393AAvorilg55wjCqrYSYvgscaSm9/gPcW6t1ouD1+fz7nRPgC3m+RCN8PHQlWSpqTPRqE@vger.kernel.org
X-Gm-Message-State: APuU4Z9CxrQLrfepoNYkVE/PGxdAAEixP7nER1mlFZVWPiEE4cgz4aUb
	ZcULZWxObNmfoAbnCJNH4B2CXkcl8dEUwoaTp9cULHFowBPT3yhR7iAYwOZbqXtP2fjbsPu/b/5
	Jrpy+l1LhUi9qHuspv4ivV5Di2mBqAB8zZSOIsNOUEtVCEwjHJX7zPalYfHUprYGG9+Y=
X-Gm-Gg: AYBFou27V2GxqXqdSRij0vAGKexqMtahqObaNUt7cV1GsReKkSqsIaM/YAyBKAJF7u9
	D4X+LTw0jgIXmAkLMS+Z6mUtsuWWIt2bvyV2SxfAU71LGNPwRZmgVIY+Yc4nL7GlELWtfQ0Geyo
	cZC0nbyGdZRD3wXup6XTBJm5mnUjWlZBOo9zihUTX3+KMw38rMjWpm/g9b4DlLZh/6dMHfL/a3p
	WWpsM9dJj68hgxtGruboNnVB5PrJXMqNmWUmQgt0htI5e3kxkE7LBH1B3sV1u/RpmZ7zo3z7Iy4
	SKk6Ep3udDQ9YVA6J3WC9/3JJUI6MKYqjebfXGGc7jYMozXFXU2aSLaZu1BlhyGwOcFHfzMXmWI
	AqN01OutAafz4KdvKKZzQyrJsrJ95ajVQurfXvncLtn1+rkkCC5T8R7MinlTohJhbiRtAHJks84
	V+9nncFKLDz8suChvx+g==
X-Received: by 2002:a05:622a:13ce:b0:534:d369:f398 with SMTP id d75a77b69052e-552a5a71827mr4424781cf.41.1794104384981;
        Sat, 07 Nov 2026 18:19:44 -0800 (PST)
X-Received: by 2002:a05:622a:13ce:b0:534:d369:f398 with SMTP id d75a77b69052e-552a5a71827mr4424611cf.41.1794104384617;
        Sat, 07 Nov 2026 18:19:44 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55263e65c37sm7398731cf.11.2026.11.07.18.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 18:19:44 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sat, 07 Nov 2026 21:19:40 -0500
Subject: [PATCH v2 2/3] common/rc: pass -V 1 when probing pwrite and pread
 -U
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
Message-Id: <20261107-dontcache-test-v2-2-7655bf08d6d1@columbia.edu>
References: <20261107-dontcache-test-v2-0-7655bf08d6d1@columbia.edu>
In-Reply-To: <20261107-dontcache-test-v2-0-7655bf08d6d1@columbia.edu>
To: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <djwong@kernel.org>,
        Jan Kara <jack@suse.cz>, Brian Foster <bfoster@redhat.com>,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794104381; l=1379;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=bl2XVOU514ZVTDOk9o3rGSu3PXlMZ7AH+3VsW9sOo0A=;
 b=a7hotu4mJZ5ra8tG+YPWDnJoODG5oPGdJ5UucsopP1udghS7eYUZ/LI1R0SDgzY7LT7EHJhI7
 8UzAs+fHuq4CbWQkFWskHfgsBBsuQb0f51jbpbYGuIkyo5azxdGjkSj
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA4MDAwOSBTYWx0ZWRfX7WolDftlBakm
 0j/uLjyULqMNAe28OGTO7st9CA+TmnKZ7WjjOHRIOzpHBseL9ncbDvYchlN4NThWsVZ3ETWC9lx
 tga43qPfYdPKa43vUUlsxAq895EZu/vVRsiXoRkbL15sBFpWsWnoy70k+JuSIE4dF4aqBYHc5e6
 3c9IDYkb1P+oWniBw1/ex9rPwge31F07YRFHJAkZgotKHrTTNrltmMSDW9YC8ksDbi130glHgiW
 eKR9IU1SSe5CCdNcM9L7UFIo2cMROs3bY/pZBxRHh1PuPgX88JmjeQFfp0Tds5yT2TZenubM3Wz
 XfXxqldsonQLqdN65gXF0k0rHEfpXKz4KPDReXAjN/SH1wybaKUjoojBTbvAubwb3W3qTqu8xoT
 v4ct3E0bzE+0HRTb2aY+4iAA+jI8CNPBL/79GC9mR0CWUJyDDGvGXPf8Vo5wpILSKjSlaeqOInh
 H0RpwJhxGTXZemky7VA==
X-Proofpoint-GUID: RlALaBX5iTaqU3nqceRvUJiVALra6SJ5
X-Authority-Analysis: v=2.4 cv=S9JMU4sP c=1 sm=1 tr=0 ts=6aefdc41 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=20KFwNOVAAAA:8 a=DjKFJ4GTv1yLP1aJ184A:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA4MDAwOSBTYWx0ZWRfX/71AeWJ/N0M9
 s/l9z9nNO6i0Q3Th+yZc9nousA+X0BWCU283Cn8DPep3koWfbES6fRjpcjsZl1Ro6dsK+U+cwNx
 wsbu0O9244tq0JZeiEAxHuNuAzzOmr7HrSJKRf9+oc9POS2CHuMS
X-Proofpoint-ORIG-GUID: RlALaBX5iTaqU3nqceRvUJiVALra6SJ5
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11959
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 adultscore=0 spamscore=0 impostorscore=10
 bulkscore=10 clxscore=1015 phishscore=0 lowpriorityscore=10 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611080009

xfs_io refuses pwritev2() and preadv2() flags unless -V is given, so
probing -U without it always fails. Pass -V 1 for -U in both the pwrite
and pread cases.

Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 common/rc | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/common/rc b/common/rc
index 945c9e42..a0239034 100644
--- a/common/rc
+++ b/common/rc
@@ -3105,6 +3105,10 @@ _require_xfs_io_command()
 			opts+=" -d"
 			pwrite_opts+="-V 1 -b $write_size"
 		fi
+		# -U (RWF_DONTCACHE) only works with vectored I/O writes
+		if [ "$param" == "-U" ]; then
+			pwrite_opts+="-V 1 -b $write_size"
+		fi
 		if [ "$param" == "-A" ]; then
 			opts+=" -d"
 			# try to write the minimum supported atomic write size
@@ -3121,9 +3125,14 @@ _require_xfs_io_command()
 		param_checked="$pwrite_opts $param"
 		;;
 	"pread")
+		# -U (RWF_DONTCACHE) only works with vectored I/O reads
+		local pread_opts=" "
+		if [ "$param" == "-U" ]; then
+			pread_opts+="-V 1 -b 4k"
+		fi
 		testio=`$XFS_IO_PROG -f -c "pwrite 0 4k" \
-			-c "pread $param 0 4k" $testfile 2>&1`
-		param_checked="$param"
+			-c "pread $pread_opts $param 0 4k" $testfile 2>&1`
+		param_checked="$pread_opts $param"
 		;;
 	"scrub"|"repair")
 		test -z "$param" && param="probe"

-- 
2.39.5

