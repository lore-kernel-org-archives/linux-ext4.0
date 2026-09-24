Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804A0227EBC;
	Thu, 24 Sep 2026 07:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790235312; cv=none; b=A2LNks3GMkh8giBLnqn5xlMMj6c1W3QepfQ0Aux6NTwio1OlZdvwGZoJs2UCEbuHFsy4Nel+SoEmaobV4ku1/XbWIDViAlNG1E+OO2RKv0jNXolTrzGBJnbBkpKwNXq+ewVujvxlDkRCfqoDeeDIlcI5qOtJ/8u+jOOiN+sfBcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790235312; c=relaxed/simple;
	bh=Ys+QqykXQaa3Kkyg/JvbUcBlV0/c0WlVZ9xBRoconAA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ssegUx5G8IXnqd93SLS67aT1o+Jn41wvS3buHB6FXxY1GEQN3vnV4F8tDiStJ/U+2VSnADMD7c9uUvW4naqmrD4M7zYRisjsNag4RTMtop56o+hlWPpvQGrJxdAmp8Hmvp+LOmgEk4lES/5cXFHyqpMbUuqHdVIX33x/V17m1NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=S8rhj/tz; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="S8rhj/tz"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5bUBM1334102;
	Thu, 24 Sep 2026 07:34:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=QpJW40y9qqjMZNcpsgPAEJmz5QbmIX
	8BucE24vwbp5w=; b=S8rhj/tzd6viyTWpFPZBVchDpQhDNrfMnxoaEJWZgXY8aV
	EnSqE3vOeq6HYnir35q8OPpw1OsxnFXqez+TL2jNZaXCTbMccKevmgIdBCDI18of
	ELcXjYX1tcmlVTETolygcDYtEFBgbW6VXidF+MzAj7DS3KMysTD/n+vfYzKeg1vF
	yak8iVlCNzezjgHaOyx3w1Fmoo5R9oSxV8RtMjnx03Iz+5jNK/uF6lGaJdKa1ZZ+
	4WJ9Ec28TTs1+Q06RUJS6rs+2v7+2bXO0lCO1qnBzkTFkgA94gZ1XsoXoWGj12Mm
	JkLWU1GBtH1sIcQqKQv3Vnb10iBAhJ1Zff/0sdEw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gskgsfkhe-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 24 Sep 2026 07:34:53 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5lVn21501467;
	Thu, 24 Sep 2026 07:34:52 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gvbt2vgx3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 24 Sep 2026 07:34:52 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68O7YoXQ43778408
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Sep 2026 07:34:50 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 129F720043;
	Thu, 24 Sep 2026 07:34:50 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7D5E420040;
	Thu, 24 Sep 2026 07:34:47 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.210.215])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 24 Sep 2026 07:34:47 +0000 (GMT)
Date: Thu, 24 Sep 2026 13:04:44 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Ye Bin <yebin10@huawei.com>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] ext4: Fix sparse warning in extents kunit test when
 EXT4_KUNIT_TESTS=m
Message-ID: <arTSlPiTgSuUcav4@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260922135808.3371159-1-ojaswin@linux.ibm.com>
 <0d6aab78-ad58-457b-b880-03edb73a68eb@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d6aab78-ad58-457b-b880-03edb73a68eb@linux.alibaba.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=V/XoQuni c=1 sm=1 tr=0 ts=6ab4d29d cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=QyXUC8HyAAAA:8 a=SRrdq9N9AAAA:8 a=nhmY5jB8YhIchIyQf9oA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: wNbGZ7FXkyMFrieNgjTfXGrIvUUMIUTE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAzMCBTYWx0ZWRfX2RiIQuIoJs61
 /9SHrqO4km/oYSIrNHGZA1BebQtH8wDkv/3cpPWaWqIsJe2YvJZjqIstGUktiEb5KcjkM+D9+/E
 gKqF7IMeGGKn5lZTbxYgxgW+2VDkZn+b19bdNmoVSHMxRmESng3igCmZZty0Kb6mlptRNE2WK4z
 v7vIo/Wr2KVq0c+gvZOrcH6XUijDBpy38lS1Jkbc/PMGC4PtyT2JZmbnoyCGUK/QlV+39nTyF+E
 Xtop0GRndk9Xn4UmxSnYgcwuJVU2o4Oo9ePW8eZeqgb3xrdwDjHe1hss/AuVOI+D/ECn3Y4Kdo7
 DQO61EQra+btckiYAG7PLYqHGxY36vDmuBg0s20RDwPM9Vs2h1y39267ncnNps/7ebjlmgMKitr
 Q1O0yAaL/Dt4WP5ij4W8XyEk8eZ9D/DmloCHNazJyMWgZWc/ay0WeaV6mkmNnhFAXxc0XBTuCHt
 Ciy8Lt7gC7ycVCkQOqg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAzMCBTYWx0ZWRfX+hgyC4wY3LRI
 22NiWmhA9VKejJdcQz7x1eg8o8xdWQvwDpaf0kj28jSANEha7RfZwJYovRSVRKFJe5tzTVhCoXj
 Ya9PS8cO8lQHLy5EoE2oDqt61O80r40=
X-Proofpoint-GUID: BbAf_10AJW_LMYTct1hFDxmhnbg8D7IK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 malwarescore=0 clxscore=1015 phishscore=0
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240030

On Thu, Sep 24, 2026 at 02:57:50PM +0800, Baokun Li wrote:
> Hi Ojaswin,
> 
> On 2026/9/22 21:58, Ojaswin Mujoo wrote:
> > When kunit tests are compiled as modules, the extents kunit test emits
> > a sparse warning:
> 
> This is not module-specific, it also shows up with
> EXT4_KUNIT_TESTS=y, so maybe the "=m" can be dropped.
> 
> >>> fs/ext4/extents-test.c:59:3: sparse: sparse: symbol 'k_ctx' was not
> >    declared. Should it be static?
> >
> > Fix this by declaring it as static.
> >
> > Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/oe-kbuild-all/202609221900.Pgwrcp41-lkp@intel.com/
> 
> 
> Missing Signed-off-by, otherwise looks good to me.

Ahh idk how that got missed :) Thanks I'll fix it.

Regards,
ojaswin

> 
> Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
> 
> 
> > ---
> >  fs/ext4/extents-test.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
> > index bd7795a82607..9669b2197fca 100644
> > --- a/fs/ext4/extents-test.c
> > +++ b/fs/ext4/extents-test.c
> > @@ -48,7 +48,7 @@
> >  #define EXT_DATA_LBLK 10
> >  #define EXT_DATA_LEN 3
> >  
> > -struct kunit_ctx {
> > +static struct kunit_ctx {
> >  	/*
> >  	 * Ext4 inode which has only 1 unwrit extent
> >  	 */
> 
> 
