Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6A138AC93
	for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2026 10:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773398115; cv=none; b=We/Ob0F45tSNOHE8mykiM7jk2hjZ0FayEV0ltFLWWo50aO6cDNWCQjhYnwMdjDOjEF3rQz0kWi4jWYh51hiTbJdCmweX3UnZFfqkt/9sr5sEAnl8/2weLSNrVm0EBKd0FaUgplF0/AHmtAUAEnph792KusGVq8L3eLn/VCza1B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773398115; c=relaxed/simple;
	bh=hRhlxu9Vyv/qCp/se/zjjbJC4GwUMWermKUAF3aqZuo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bRkBhTkkIoquXO95Etr1Z9Rld+V1pa4yZ9Vi567CexHiU5dmZt82+qlG8hQbmL1UlVCvr6B2Kx31nwJvDaht4CA7NU3+VRSpCc5VuDe9JJHExPYXr5uB34HvZWBiN6QD291nR8GojwLo4dhwFkJ0dFyB1Yoe4Fy+AWrhffzLlJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=o60gXzu1; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="o60gXzu1"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62D6ZZIj2206305;
	Fri, 13 Mar 2026 10:35:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=xLWVW+nbPTQTGLUukh7sU13nz39c6j
	ctNiuXhKGvVTU=; b=o60gXzu1+tx3PTmipR8LFaVUnKw70gh7y1GY03o80+6uTC
	8hnCdeypsNBWGsPg67U5nOrldo2q6cDiBPniox/+uGsrNww2tZ4/IWTpTALX0iLv
	uq+OgFuxDrKyfbscULbwH7r9ppE4k4AXYxrRIkqbM86I9NFRzD49BKTF+O13NLBf
	wnBT4A3UuX/yMT6iM5FZ9DzwtViTmoUfUSJJt/IA675fHp/oxw0paMSIlH8zGSkg
	7/ewufkko24KI5lyfKV0x7ilL3h6VUwOiu5x/K4uHv/4tW2ZHY7O0IlZoGXwaQ0J
	KOWjULGSpWxfSWFAoKiRbgIK/XVVrfMjrFRbYYYg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh98f1aj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Mar 2026 10:35:03 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62DA1HD8008821;
	Fri, 13 Mar 2026 10:35:03 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cuha769tq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Mar 2026 10:35:02 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62DAZ1AJ52036032
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Mar 2026 10:35:01 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0740F2006A;
	Fri, 13 Mar 2026 10:35:01 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9113D20063;
	Fri, 13 Mar 2026 10:34:59 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.23.11])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 13 Mar 2026 10:34:59 +0000 (GMT)
Date: Fri, 13 Mar 2026 16:04:56 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Ye Bin <yebin@huaweicloud.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        jack@suse.cz
Subject: Re: [PATCH -next 0/8] Fix some issues about ext4-test
Message-ID: <abPoUFviqJTmC387@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260310130412.3156753-1-yebin@huaweicloud.com>
 <abO55xo3MDyJ-NEi@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abO55xo3MDyJ-NEi@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=M+pA6iws c=1 sm=1 tr=0 ts=69b3e857 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=qNABUOcEAAAA:8 a=pGLkceISAAAA:8 a=i0EeH86SAAAA:8
 a=V06nIGNlhVeJqx2CMeoA:9 a=CjuIK1q_8ugA:10 a=Ytm653ucTKQjCvbzLygB:22
X-Proofpoint-GUID: PYx7x7I8nzIAVPPZ40XdmNE_BQpPw-NK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEzMDA4MiBTYWx0ZWRfX3rG1c7tWqmhA
 x4lAfLZ0cEM2nC6CuAaI5xJaaRtgZmksyCkxF537mTGkiIzW6/qG3RJc8sXFqTU5v/qTMBnyi3P
 amQTVKWRcNcVwz4YNB0EJb/a2m7TV4MOmU6LiMxd2aGwuiHuPlPJCy6ub8rb2g9umTOQlZg29N4
 6TOsqvCERFfjwZudeaAhYphyXddTrtLHwjtaniWEzOggsjrWcde3bfzBD6PS2DGbaaOeTes9Xiz
 kVdydyP5aOkiew8Ir2lVPQenVW5HLKGXy1mi23lOQ0WrPrEGqT99aUmGDwlKOQlFimyavfb7SmP
 2eGukAyj92MPkPE+KkhOBu1VTCmB5lT2hAovNxfd4IsGDlaGJ0wkvAKv3xPw7b21q/BYUq0Cn+d
 zhCDujDaA2Rm7FtRG507OnPV2r2LUCm+L38+kFheiQr70aAVzscP0EueXTveY++9XuKRX4B5GYy
 r+pVFHtI/mr0U1L0B2g==
X-Proofpoint-ORIG-GUID: PYx7x7I8nzIAVPPZ40XdmNE_BQpPw-NK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-13_02,2026-03-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603130082

On Fri, Mar 13, 2026 at 12:46:55PM +0530, Ojaswin Mujoo wrote:
> On Tue, Mar 10, 2026 at 09:04:04PM +0800, Ye Bin wrote:
> > From: Ye Bin <yebin10@huawei.com>
> > 
> > Patch [1]-[2]:
> > Decoupled mballoc-test and extents-test from ext4. Patch [1] does not
> > have any changes compared to the previously released version, so the
> > reviewed-by is added.
> > Patch [3-7]:
> > Bugfix for extents-test.c.
> > Patch [8]:
> > Bugfix for mballoc-test.c.
> > 
> > Ye Bin (8):
> >   ext4: fix mballoc-test.c is not compiled when EXT4_KUNIT_TESTS=M
> >   ext4: introduce EXPORT_SYMBOL_FOR_EXT4_TEST() helper
> >   ext4: fix extents-test.c is not compiled when EXT4_KUNIT_TESTS=M
> >   ext4: fix miss unlock 'sb->s_umount' in extents_kunit_init()
> >   ext4: fix miss free super_block in extents_kunit_exit()
> >   ext4: fix the error handling process in extents_kunit_init).
> >   ext4: fix possible null-ptr-deref in extents_kunit_exit()
> >   ext4: fix possible null-ptr-deref in mbt_kunit_exit()
> > 
> >  fs/ext4/Makefile       |   5 +-
> >  fs/ext4/ext4.h         |   5 ++
> >  fs/ext4/ext4_extents.h |  12 +++++
> >  fs/ext4/extents-test.c |  59 ++++++++++++++++--------
> >  fs/ext4/extents.c      |  38 ++++++++++++---
> >  fs/ext4/mballoc-test.c |  87 ++++++++++++++++++-----------------
> >  fs/ext4/mballoc.c      | 102 +++++++++++++++++++++++++++++++++++++++--
> >  fs/ext4/mballoc.h      |  30 ++++++++++++
> >  8 files changed, 268 insertions(+), 70 deletions(-)
> 
> Hi Ye,
> 
> Thanks for the fixes, seems like I completely forgot cleaning up
> resources in extents-test.c so thanks for taking that up. Sadly, my UML
> kunit runs didn't catch any of this :/
> 
> Although the series look good to me, I have a request, can you please
> resend the fixes in patch 4 - 7 separate from patch 1 2 3.  We need
> these fixes (specifically patch 4 and 5) to fix the breakage in
> linux-next [1], keeping them separate can help Ted just pickup the
> urgent fixes independent of patch 1,2,3.
> 
> Also, for patch 5, it fixes an issue that Ritesh fixed in his patche
> [2]. I think your patch is a better approach since all cleanup is
> handled via deactivate_super(). However, his commit message better
> describes the issue. While resending, can you include his commit message
> as well. (I've checked with him so feel free to reuse it).

Hey Ye, sorry for the confusion but you can ignore the above paragraph.
We still need Ritesh's patches along with yours. More details here [1]

That being said, I still feel the fixes here can go separately. I'll try
to priortize the review of patch 4 - 7 so thaat we can get them in shape
to be merged.

[1] https://lore.kernel.org/linux-ext4/abPh6GX0t22m628D@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com/

Regards,
ojaswin

> 
> Thanks again,
> Ojaswin
> 
> [1] https://lore.kernel.org/all/0d21783c-5299-4488-9708-def0b1a4dcbe@sirena.org.uk/
> [2] https://lore.kernel.org/linux-ext4/5bb9041471dab8ce870c191c19cbe4df57473be8.1772381213.git.ritesh.list@gmail.com/
> 
> > 
> > -- 
> > 2.34.1
> > 
