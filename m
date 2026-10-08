Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D53B47DD66;
	Thu,  8 Oct 2026 09:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791451825; cv=none; b=uyQLc7JtmLRnUbJzyVhTYkvUeuJLTTxqh3pmfME3vpJAri6wpe7hiwWUGAw8cg3E+yRDWllf7iRoVINdJPnuuxEEZpmdWFLK0RPMhQC/WAzVB/N9lIVYwpegzVAiGYoJaGNhyekrwR0p5lwif6chzKhtgtidt5OVMtIjYhAypD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791451825; c=relaxed/simple;
	bh=szWUn2Z09IwILyg4dNQto1P8fbxdxlHgSh0qR+zHlbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t8sP4dv3P23jTqvWe51JXIy1WLQGRZfBoPJ7hvlBIG9fUJy1z5P3HWafGAK1DKvxn7q1rJNuKoyBx1z7ddhdDQkeSOzTRlabFgxjARVyDYMsL/Vvu952bW74FNEDJbzvDm9vh6JWh5CoI6kvIAbuBDBtut0cTFID6UHlFsP/k34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CrudIeqj; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CrudIeqj"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6987ZaGW702560;
	Thu, 8 Oct 2026 09:29:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Zg1x9kxs9ecEssEghsU1kmsNQnFOxM
	Yztjakko+yFzU=; b=CrudIeqjOg89wlbvAENYUvLktnUkIVmkITYH/RkVwW7H/F
	/dwqkEVjgoUP+SAlzqc3dhKK/s74q6qoimh5IGj68hwti13UHwWb+OErU3GYZKaA
	IWJyh7TVXkapyOr9t7mSYI/KNr2JudzAHQoEwcuPRLpXgHr/2b4sUwrtjiyN76wY
	+TA7ies7aavJmOUF8NbBJ1wJiHyQK7hZxmSkqrirFPbrRlnJB0pYvf00+MQRvkCr
	ZW2R2MlZALp4AMoYmbtQ7uf5tOKbUV3On5VjZRFVYdyithaV1Iqeqi7q8O42lw0h
	BgdGrn0ZeH4G8cj1ZBGQ4fAA4aFWD8AvXFWJaFYA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h5xjvapkw-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 08 Oct 2026 09:29:55 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6987Ik8b3089408;
	Thu, 8 Oct 2026 09:29:54 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h58d5psuh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Oct 2026 09:29:54 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6989Tqw750528558
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 8 Oct 2026 09:29:52 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3626320043;
	Thu,  8 Oct 2026 09:29:52 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ED88820040;
	Thu,  8 Oct 2026 09:29:47 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.26.191])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  8 Oct 2026 09:29:47 +0000 (GMT)
Date: Thu, 8 Oct 2026 14:59:45 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Daejun Park <daejun7.park@samsung.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>, Zhang Yi <yi.zhang@huaweicloud.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Li Chen <me@linux.beauty>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: (2) [PATCH 1/2] ext4: don't cache unzeroed blocks as written
 after a failed zeroout
Message-ID: <asdiieQcOVZhUqoh@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <asc2BOOFgO8Nupw7@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <20261007-ext4-fc-zeroout-v1-0-b86de6439431@samsung.com>
 <20261007-ext4-fc-zeroout-v1-1-b86de6439431@samsung.com>
 <CGME20261008062023epcas2p17ab2f934eeb6ba157103b01c9cb59f5b@epcms2p2>
 <20261008074714epcms2p27e156e29471fdc7a8f50cc8a422989a1@epcms2p2>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008074714epcms2p27e156e29471fdc7a8f50cc8a422989a1@epcms2p2>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: 5GOWeN5Zovyq93IB0jh7zkh9SNJgsQmn
X-Proofpoint-ORIG-GUID: -_EiglpFgUjPOz_beA2U444eH-BujXz2
X-Authority-Analysis: v=2.4 cv=H8NOUOYi c=1 sm=1 tr=0 ts=6ac76293 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=hD80L64hAAAA:8 a=VnNF1IyMAAAA:8 a=UM7FyKtycEQPynifnK8A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDAzNiBTYWx0ZWRfX8grqSwIyWaJS
 VWGm4qPgrUmlhxoeCeibx+WTSrABnfchL3UvMtvSZZyEJVoR3gRFWzDSJE2Zboh1hw4u2PyxFNa
 Yu1PN4UYNcu/rDfpYgcm7GNdItHQXLCv/3AEIlLpWOW/ABuqytp49GWRDCELN0AoeJ5uU/zbNJj
 omL97LaRCHJ+AdQRPByVxE0Hml7oe8Zey6k+bL3gawaLjPfu88RwPMpp+c+sTHwvrmgkmNr/E2w
 JJYWfZcwVVkkCZBs4BoNWWfwvkonfKwMgpxBuL8eYgOs31vX6aaZYRtLC25MiOwbEzQ3qeYB3oM
 yyXN9Oqt2vZ74js4AjHlxwvOM2pjNeWg3MLuaV2VfdUKX/lemw7g94d4CV//dl7r9Ki38ZDAA4m
 mINee5f51L74Hn/ckM4Op/Y5zyB6wxeuCwJaf2UlmjctvPns2lneCF7TKN4th5RMxenGlPVuN1V
 sUN9RUTp5j6IlXOVpjg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDAzNiBTYWx0ZWRfX6C4Z8R/esqqb
 Huzxw5VYYSGvAVuOuoKRYuaG2lQeDr65u48iAwYfkGWYAr1OT3+esPg3P79UrhmMUD3oRdRF2+k
 JFOidZMm6XmhRRd3Ri4pAmnnHGQHURM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 clxscore=1015 spamscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080036

On Thu, Oct 08, 2026 at 04:47:14PM +0900, Daejun Park wrote:
> Hi Ojaswin,
> 
> On Thu, Oct 08, 2026 at 11:49:48 +0530, Ojaswin Mujoo wrote:
> > Feel free to add:
> >
> > Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> >
> > btw, did you catch this with some fstests? If not I think it would be
> > good to add a test for this.
> 
> Thanks for the review.
> 
> No, it wasn't fstests. I ran into it while working on 2/2: when adding
> the fast commit tracking next to ext4_zeroout_es(), I checked what it
> caches when the zeroout fails, and saw that zero_ex1/zero_ex2 keep their
> length on that path. To confirm it, I put dm-error under the file system
> and failed only the zeroout.

Yeah, its a bit tricky to hit this in kunit test cause it needs one
zeroout to pass and one to fail, so good to have a test for this case.
Thanks for sending that, I'll take a look!
> 
> I turned that into an fstests case [2]. The existing dm-error tests
> don't reach this path: they write with direct I/O, which leaves the
> extent unwritten until the I/O completes, and so does a buffered write
> with the default dioread_nolock.
> 
> v2 [1] keeps this patch unchanged, so I'll carry your tag if there is a
> v3.

Ohh, i missed the v2, I'll send it there as well no worries.
> 
> [1] https://lore.kernel.org/r/20261008-ext4-fc-zeroout-v2-0-55cab1e24fa3@samsung.com
> [2] https://lore.kernel.org/r/20261008-ext4-zeroout-eio-test-v1-1-9bb66deaf646@samsung.com
> 
> Daejun
