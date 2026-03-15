Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6679E245012
	for <linux-ext4@vger.kernel.org>; Sun, 15 Mar 2026 06:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773557103; cv=none; b=YidL74JsUh/K3RHy1FNtMgdxQWcxZyJeK76qFIT2RIvz+7PJCC6KSc+zNRO580ogLMxO78La0efP19iOqcwqY2uP86vXXRjvhlhuCsSx1+ju/o2/SgERgoybrB9V1XjrMGftZsrL1UWLIaCF5+kiyVQLm1Ub31zoY+J33+K7UYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773557103; c=relaxed/simple;
	bh=QdzYuQCB3AOMpofT0ix9ceTFwhD9TK8TylkyNTYFBDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I4GHCjk9awqkrAWi6xt9XYbAgSK7Q3N5yotpElD1S0zWTPF7IV0iU8UYeHAaBEo9QIAdoKHEYuamW88n40as2ZB4iVVBQ45wopPSqh6n2AFjNMfza6zWqtMRsKKTClPZ2P84exQGN7Gy/DKaXzcFKRdh53pBy2usC01UNbKZFdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=M+68sUnK; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="M+68sUnK"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62F605LN3243346;
	Sun, 15 Mar 2026 06:44:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=zQS5K2ZUwvySVz+4dx2+emAT7KSY8i
	W1XuBsNU/VZIc=; b=M+68sUnKPdIS7uUYL6eCMri6NNG0Pqcf/RQf7k4rwcXbtq
	MltTVXhioVGGrjinoPlixItCWqsbbV5pbOjhdodQhMLRzNKooUbaANNsBFVikfjb
	do9AKx3UJdg5Z9+MH0Dp0SnLNaPrHgyRK3eJ6gqguWzk1Lbw93+OcSmco1V/aTun
	veD+LXb9t77E+/6LXi6S0Qziar0+Kl93KSm2UJr4UWfPlj7fS7n3CVpcg1HXa/Ht
	/jHw7MM5e05lHcycZzDPdaz/8hoGzIUkHXWw5Vkal5h+h5ZrfI5Y6Q1cY1IKdcBH
	lhIxnQtJ2dcvK84EmEYJ2YtXctJZ9XtOGwQN37hg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cvyd3bd20-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 15 Mar 2026 06:44:41 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62F3FKHj028455;
	Sun, 15 Mar 2026 06:44:40 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cwmq10d3x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 15 Mar 2026 06:44:40 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62F6icXr51642818
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 15 Mar 2026 06:44:38 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7EDAC2004B;
	Sun, 15 Mar 2026 06:44:38 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EFC0820040;
	Sun, 15 Mar 2026 06:44:36 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.23.251])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Sun, 15 Mar 2026 06:44:36 +0000 (GMT)
Date: Sun, 15 Mar 2026 12:14:34 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Ye Bin <yebin@huaweicloud.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        jack@suse.cz
Subject: Re: [PATCH v2 0/3] decoupling the ext4 test module
Message-ID: <abZVUmszFisfOdmz@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260314075258.1317579-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314075258.1317579-1-yebin@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=PbPyRyhd c=1 sm=1 tr=0 ts=69b65559 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=i0EeH86SAAAA:8 a=gv3OZY6CR5bBL3F8J5oA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: mkLE9nP8skTs3nIAb-za9cuMky0BlenF
X-Proofpoint-GUID: mkLE9nP8skTs3nIAb-za9cuMky0BlenF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE1MDA1MCBTYWx0ZWRfX+k2/bTs1LUYL
 2tmpy6j+EZbZBpLExVKUSrbAfay7rixtXNtDjJX974iUsW+FLG7y2t0FuBgfcpbxOzbcNQavIx+
 Y75mYo/hVDJAk2WEua+hHF+9DCNC9aA0GX+W2MtQsZtyEPWl8QilGJ26t22KRxNDfHrnteoDCBP
 iOqMqZWz5FRNH5mGR1HjlBJhUNhMRzv5NkQrUqlcQErkNn0ecojdv6XsENbhCwv/15YcDpQSbLK
 fhyxAIcecDJElksNvVQT9gpFnc1Ham9w7fANe5HLpQlcTXCACX1qpz1MXlWHO/TV/AwdW7TxTHN
 XXjSOC6z4eKICjW0hdP+rtFVYuKSgfeJZI+HgqR74sENhuBtQNjRZVcMC6RDHqyPlNeAdIOYaFy
 Dcl+5D2r61y/B7egC66dzk53Z75Qx2DLSk2PCg4XRnFbDh7MimJVyRgJOR/rIKFybcJ88nWCnjK
 QuL1K9jVfICpNTQMHvQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-15_03,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 malwarescore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603150050

On Sat, Mar 14, 2026 at 03:52:55PM +0800, Ye Bin wrote:
> From: Ye Bin <yebin10@huawei.com>
> 
> This patchset is split out from the "Fix some issues about ext4-test"
> patchset. It decouples mballoc-test.c and extents-test.c from the
> ext4 module, resolving the issue where these two tests could not be run
> when EXT4_KUNIT_TESTS is set to M.
> 
> Ye Bin (3):
>   ext4: introduce EXPORT_SYMBOL_FOR_EXT4_TEST() helper
>   ext4: fix mballoc-test.c is not compiled when EXT4_KUNIT_TESTS=M
>   ext4: fix extents-test.c is not compiled when EXT4_KUNIT_TESTS=M

Hi Ye,

So thinking about this a bit more, is there any reason we are not using
the VISIBLE_IF_KUNIT and EXPORT_SYMBOL_IF_KUNIT macros directly?  Is
there any case that they don't handle?

[1] https://docs.kernel.org/dev-tools/kunit/usage.html#testing-static-functions
> 
>  fs/ext4/Makefile       |   5 +-
>  fs/ext4/ext4.h         |   5 ++
>  fs/ext4/ext4_extents.h |  12 +++++
>  fs/ext4/extents-test.c |   8 ++--
>  fs/ext4/extents.c      |  39 +++++++++++++---
>  fs/ext4/mballoc-test.c |  81 ++++++++++++++++----------------
>  fs/ext4/mballoc.c      | 102 +++++++++++++++++++++++++++++++++++++++--
>  fs/ext4/mballoc.h      |  30 ++++++++++++
>  8 files changed, 227 insertions(+), 55 deletions(-)
> 
> -- 
> 2.34.1
> 
