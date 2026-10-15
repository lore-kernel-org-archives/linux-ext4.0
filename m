Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B2C59B69A
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2026 20:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792097802; cv=none; b=WefGyTtDUcxlnkdgohvR9KKEI3eYPYh0nmPx0B5dgVtitWJVWdS2le/jC9+StFxD0nfUTGistilt0mhElpSsEFnyj2iIWV0aTv2CJ8tcd+Uef793sKZm7Du35ZcwlUsXLVLBrxDETB8OPEPvEGUKm5fH6G5CtkX7URA7os0Yo84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792097802; c=relaxed/simple;
	bh=E61kXJGQb67DL5v3Mwx8ZATO0AV/wCVRoPGkb22S4aY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CWyX74w98qWA9mmjE3Xh0jZEpzZ3VIBZ1hlf3rC7FejtSxq088tQ5iQNRKbVGi1sBnLXJ9JxUfPKWZiTf/JEHZNYKp/D7l9yWeib8MdMhXkDxFGXlOkL4xuNJjsK5o7uzkAQAZDI382BjEPQZ3dYkMu8pnkIRK9z2NmeS8wak/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=hsVBu4Dn; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Qarb8DLg; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="hsVBu4Dn";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Qarb8DLg"
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FKaKLS2263459
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2026 16:56:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=8YrZ
	n9RoZwckQ8cIZWMwacpPTzEwwZIsjiX8ntsBR5k=; b=hsVBu4DnOFCwdDUCzVOb
	5sKFxc/wWbMy0ciESscs221bRLuyR3tDCTk3kpI8jOwKGVLzwpeepBYSjmhxSZxk
	9lKAvw1mbGOrk1C0TTsC1ysqAhQteDgt59XKSYMUSC9NlqCRqtqyY/5j47A0jlzE
	ku0HNKxkz1HyW9b7DG88gx0E3UDrYQn2cAochsd1g/dt0aNc3f45+phhCKyUif+Y
	cPYCtHG9ygws0B4giRyO62q2PhZ42vXkDmIHoHxG+5nrh1o2fHTG6LurYpnomoG4
	ra1rRo+VjbZM8T0Vp3l07ukSo8zGmB3Lhv6vwsrzcX2nssyxgHtiRQWXlWVVg/JE
	Xw==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hb1yham9g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2026 16:56:23 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93cc0b31ecaso413163185a.1
        for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2026 13:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1792097783; x=1792702583; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8YrZn9RoZwckQ8cIZWMwacpPTzEwwZIsjiX8ntsBR5k=;
        b=Qarb8DLgMCo57BMYOaSyK+MjTtadJqIN6ShG8baczg1wNY0ffHqlEobBNlsHOAUEWk
         kH1Fbg4dYRxcutmMDskqEGg/qOH/m0nSq+JIy2mOX1bkYINn7jWYbcY9KRugJ0WNIb84
         fFJYwig5FRQXdsa2SXCfY9JcYk+Fqvv8MZ753ronOJRvOjBW2JD+Qf1Z1jrPkxjizhKF
         vDBRySqy8wlgGsiPy/DCd2L563hq+Oj+XXgYhsTLvSzlw04cAhVdYOh/r6bjfyy7+k9U
         RQQWmqnqq2Xs1A9+pUTzwg4BnVugKB+VUCpmP9oN9eczJsgoU77cONGkrygZhShdRTNH
         YgaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792097783; x=1792702583;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8YrZn9RoZwckQ8cIZWMwacpPTzEwwZIsjiX8ntsBR5k=;
        b=c6t1zfa7rrzOUsWabBK1VqJo4nT4DvheTfQjN6a2cjnycC20qmrih6d85XLCAb903r
         GGYebHnf8tO0R6oIXZy+0noUg5JtKRa5zHKR4WF3Hs+ga4ZO9DKNHYjaLTvx7jTLtuZm
         Sk4pt0UP48w/4MxvyVr8/f98XWgaj+dX4XdFPJBK427f0XDtTfagG0W1h5e+O4vldWJ2
         9e0LlgesWm8skgxZVZ330LXJDMLNHiqswJyjDFVfc4R/QpnbHd90izn2Qo6oKuWSYrvb
         X0gN/XYP45mXyUYpTSHAEflON4p29A9Sz4NBKGpP+jTGa2yod9PXO8ZnqstFjIG6aJ1F
         ODAg==
X-Forwarded-Encrypted: i=1; AKwUvBwUquaxaGRWz47B6DJmqq++cUn3B9ZObV3jQKne63Ujl8a18qYmO8XKgESQb+3LXjHg1bPXXydbKQlU@vger.kernel.org
X-Gm-Message-State: AFq9FYIzXGU3APHrWsOYfJ8QQNUSgf9HyE7Q0If58jdG8tP2gvx0d4UK
	aYcYuwEsSwF/4H1SwYAw5dOg0SISw/ow7//rtBBDn/msfJCBI/jJCwJYh7ghMlbWmAfxm4824kH
	fKiQJ2j0xaL0Q1tv6CXQGbMJrtA2ZTmQrsZeAYkVuu1Ohv3sCjMyYanmHwEo=
X-Gm-Gg: AYBFou27hf5jLChU5UiwGGr3IrRZaJP2Jc2o1Msj5up/bfhTdjqcRVLWBpAWI6Ybks+
	wYX30dgVuWcVuQ5PIhdrSZCSFt6mPR6dU4VEoSdIUTVDDQ4l7x/7jjO9H3aJU/BIBqgD1pwxhBA
	6JpmADjBcqXp6EgkEOZ7kiEiwsLeLpzUF/HNIdJY+1LsP/luAHW3U0AbBwyQjPd4aWy2nyC2uof
	/SJ8O+6fJjwaznOxL69Kevt+g8IBWIfhoEHdV6SAkqdTtLf76/sprMEItsHlc/jqGeqvWn79oW+
	i5Yuu42yxs2b9ozcskUiVtpwtAoR9/Sob/LipIHP/mW9eiCJwVMdKubSenovt5mmjXYfL8uzEB2
	02uUmPbbbiURimL7GJhgP60k8otwmp2diVLK34HlPy7Yk
X-Received: by 2002:a05:620a:2a14:b0:93b:d7ed:ff3d with SMTP id af79cd13be357-93ebd2aa64cmr3203870085a.63.1792097783234;
        Thu, 15 Oct 2026 13:56:23 -0700 (PDT)
X-Received: by 2002:a05:620a:2a14:b0:93b:d7ed:ff3d with SMTP id af79cd13be357-93ebd2aa64cmr3203866985a.63.1792097782803;
        Thu, 15 Oct 2026 13:56:22 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-51.net.columbia.edu. [128.59.176.51])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a1d1bf6sm29062485a.47.2026.10.15.13.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 13:56:22 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 15 Oct 2026 16:54:03 -0400
Subject: [PATCH 2/3] common/rc: pass -V 1 when probing pwrite and pread -U
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-dontcache-test-v1-2-6aa7583973a9@columbia.edu>
References: <20261015-dontcache-test-v1-0-6aa7583973a9@columbia.edu>
In-Reply-To: <20261015-dontcache-test-v1-0-6aa7583973a9@columbia.edu>
To: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <djwong@kernel.org>,
        Jan Kara <jack@suse.cz>, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792097779; l=1331;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=E61kXJGQb67DL5v3Mwx8ZATO0AV/wCVRoPGkb22S4aY=;
 b=wc02po/5ct5ddrg26iR5Ne4D+b/96rF6xvcVKoBp/avVpRWWV0778KRr+NwPR5sxqyNNYL5Za
 yeRoghiVY7kB9bdad6wzXq7tVSBJKRavhiMsKf9qGtHpYbxmiiLPfVy
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: xkoXHgzb92fX9k7U6gjfmwwC3ch89CSl
X-Proofpoint-GUID: xkoXHgzb92fX9k7U6gjfmwwC3ch89CSl
X-Authority-Analysis: v=2.4 cv=TMnQ2Fla c=1 sm=1 tr=0 ts=6ad13df7 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=NKoNGjn6KhAaSQkl0TXC/A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=DjKFJ4GTv1yLP1aJ184A:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA4MyBTYWx0ZWRfX9ngco3qOhwUd
 KLAzyFnKIF5fOpEVL2q92d3ZTJt31O+HBT2qld2ISPTytAojW7ENLvVcsw8OPAQ62HQlbrTmPVK
 HpATsbB675H6+oxd83uzl7dHO/NbV4xqey9yY3jbs+92WUdoKfLL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA4MyBTYWx0ZWRfX/ba2k7GaPOvf
 yH05JKxfgjqYruBI7GAFhg/m6559mnz07XBFm0NjAfkQfaP8ZoY9h/7qCJ49w1+3LmTEwtKSlMt
 jr1Vth0yyz9mWsrPlDLRMU7HgmsmWPWpyOGYwRJJI80KWMPhkmj11mF5pyYQeVwKH1NzxVfTwPy
 nLbTV5HRWF2FIPyxGpBdnYLm/DhJbZU7J1u+VerI7fG9DSCP3zDEkbtddq7k6yTtUc2aiSz+94C
 i3s/SOg3MAHnMJOAj9epHnf4/yBDQKnMxLvAl47G8N9k50CSMJKNc/GvO8vJSs+YVc8YNS/ew3f
 xaBEzLeQmCFWUKjFe2G2I9zCD3fbzb9c63/ndv2Zq8IvqGZVCtkwkY96Ms5MeVkDX9IHZwQcg8C
 1dFLfcxZHpT9ISBG0kCfhhLPKk0h6d65SYQzFx1bPM7OcXQBeIi6cSXg2OCagmaOtHycHUtJQIj
 gTFgteFdOMCBVOjreCQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11936
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 lowpriorityscore=10 bulkscore=10
 impostorscore=10 adultscore=0 clxscore=1015 priorityscore=1501 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610150083

xfs_io refuses pwritev2() and preadv2() flags unless -V is given, so
probing -U without it always fails. Pass -V 1 for -U in both the pwrite
and pread cases.

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

