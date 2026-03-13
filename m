Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A90282F04
	for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2026 07:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773386413; cv=none; b=T1TbB9v2/5rgHDvLl4/IRkKFxVJZEinFTrv8ljNtAjv8SJ9z4p5yr+KmFsqHGaPDEhkkz4Oukax9l8/ufcro9GFeI7D9FHb5pA5VpOflf+ZvqAmmt6SwBlfjN2a322aQkby1clSepR4STr1t1lcaNmI5x9aNo9iA5S/6MZ24YN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773386413; c=relaxed/simple;
	bh=28eVDL43RCjHZ8i01EHo033LIkP/6hYFRhGS9lrX7NY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tgkFpV8qk8pBHkre+o/Am9aWw0hh+IGxcDIve0TBXB6uwk/HhnTKBmFbgrGaaBsVw9qoSZvHAEW03h2bNwdM00671s2ryHowuyQS6KuK4mKE01KnwTKHQgxjSYjyEyBiM5+GrkJi1zbk7mbZvLYzDcxgraBKy+XzwWwG7ChUtJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DfQe890l; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DfQe890l"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62D6e3rc2923674;
	Fri, 13 Mar 2026 07:20:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=ocMoVLD/0KJK3C/7iy3pVBbFTlBPLb
	bXk8BFsvJaS1k=; b=DfQe890lPcfh+ARAuz4goiAqxGN/PwY6PtEq7X2ptHoIOz
	Zucc0p1VLxB9yRiPgNb/OmmBjP6rwzkBaolAiq9Iy1n1YmLTM1TV+Bj7rYHBnj7Y
	gH21ckgcIc6e95kb/K/vcAwucB4yCNuYOwaA4OWgLHXdCFvuMbFryk71w8NuYNCY
	1UYsCIDoDAsDtThGycQUesN81sOOakJYi+8H5zbijmqaPTk+Lz6I0IyAxJiVZKDD
	l08O/ywsgWYc9aH2Ii8sCAdxBgG001vIq88C/Ha9fqRfgeLlheWBp/U0XPMbEOub
	zCe4jHnUDvfI3OYIWG5ETqTfGpqtnEgkRl0HUabg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh94xmw9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Mar 2026 07:20:09 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62D4u7Ng025674;
	Fri, 13 Mar 2026 07:20:08 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cuha8dnc9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Mar 2026 07:20:08 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62D7K7qK59900278
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Mar 2026 07:20:07 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 04CDC20043;
	Fri, 13 Mar 2026 07:20:07 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F2F4020040;
	Fri, 13 Mar 2026 07:20:05 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.23.11])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 13 Mar 2026 07:20:05 +0000 (GMT)
Date: Fri, 13 Mar 2026 12:50:03 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Mark Brown <broonie@kernel.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: kunit: extents-test: Fix percpu_counters list
 corruption
Message-ID: <abO6o3RFQM24dYK9@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <5bb9041471dab8ce870c191c19cbe4df57473be8.1772381213.git.ritesh.list@gmail.com>
 <f6d26b93-e21c-45bf-b377-1896010e59fe@sirena.org.uk>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6d26b93-e21c-45bf-b377-1896010e59fe@sirena.org.uk>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=QKtlhwLL c=1 sm=1 tr=0 ts=69b3baaa cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=Ww9RJ0TEV2qCZfbB8mkA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEzMDA1NSBTYWx0ZWRfX9OChfjIXpKeM
 wbJngY89oTcFobGChYVGJFMESEELe8/I8OdLz3usLratMRc5+leWY1zU6WiFN//KwkCf/XxuZMS
 U8+APPclYSvKC8BFYwIY/HwgI9oTgn19oIO2mOob1uaV+vgFzSOSkYGxhg4JwpiYlD5Dh9CNknm
 rMMnvs1X++RHB992H5Bym5kfFgTVNdoQCmfQf2ROJy7xG4aWxMQHILiq7FwQ7gEvLmd29kfK8FG
 YlpDL5q8HA1rTRTQNce7wzwr0xwGE7k0ZqQHvyiAw8FrtHlkXA1HEhVPGDF5++SprI2JyH0c9vx
 PyOhxGp3gCdmCf9YigIvkIGK1afRfyzfD5NkIPObCUEjFj9HmP61pqIi43+kgdGM8XRXTnO6B6F
 yNw8vjos27heaauwXxUjvn7baZLofoDWFydZsQh1SMq38XoHVJGFl4fDLsrRGjJtrM/fHbe08sf
 MTDxsSpMGFcgvetR+rQ==
X-Proofpoint-ORIG-GUID: NU4NQh-0z8jHCE-tC9dkyR9BTj3hpomF
X-Proofpoint-GUID: 9ZNJPNxXhS08o9TN7ppSM_Sn-5rOO19y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-13_01,2026-03-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 adultscore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603130055

On Thu, Mar 12, 2026 at 03:57:38PM +0000, Mark Brown wrote:
> On Sun, Mar 01, 2026 at 09:44:26PM +0530, Ritesh Harjani (IBM) wrote:
> > commit 82f80e2e3b23 ("ext4: add extent status cache support to kunit tests"),
> > added ext4_es_register_shrinker() in extents_kunit_init() function but
> > failed to add the unregister shrinker routine in extents_kunit_exit().
> 
> This is breaking KUnit in -next which is causing problems for other
> trees, can we please get it merged promptly?  Discussion here:
> 
>    https://lore.kernel.org/r/abJe1PAf4JbwGGRI@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com

@Ted, the fixes here [1] supersede this patch. I've asked Ye Bin to post
the fixes independent of other patches. Once we have those, we can get
that merged and it should fix linux-next

[1] https://lore.kernel.org/linux-ext4/abO55xo3MDyJ-NEi@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com/

Regards,
ojaswin
