Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0414944238E
	for <linux-ext4@vger.kernel.org>; Mon, 17 Aug 2026 15:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979435; cv=none; b=S16d70+EcTsiXhtubdLyEuin1Bs0e26EHjzNnY3nKAXxs14HQIyp7m04BHy4SqhkiHH6jX/bpcV15qQyex0loLcNkPDLcTaMgcTngc/PMM9kGoSybSUdimlrc+CFkpVHqwCOJffUIELKKfbLGm6vY6JZUwJs0mk1oKkDfSp6GY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979435; c=relaxed/simple;
	bh=KKCnlS1pxzvgbidLl0sV2t6qv6KLZ8DTzjyD8VyYYRc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HlE2VUv1RUY+Ot7FxXvJ3E3iGZu6ECoQ90M/d7fHRxrdqdw0uw5OWa/uL4EEaMPJuqZxp54S1wV9eeAYnH2Hut9RmsL3CN2qRfiEOK8kfw7Pnz5fxUP6Q3YVheK5ZC9RO/ogDCn3yaeqUpk1QOycYqBA+/0kCX5gGBCTXCJWuAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TOdPMqk9; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TOdPMqk9"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HCWDLu1442531;
	Mon, 17 Aug 2026 15:05:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=7QBFWxrMPbo2D2NhdJgIZ55SL4nghb
	uWHL3zYBBR3f0=; b=TOdPMqk9d+Yfr5kGFMq7lclfdsql0BK69sC47oSNWts21K
	ZS7bJnRGw7muJeXbycNF2BqeFlzd9iW9OMyXHbtl0uqIhn87Kt37VeFwEe7dcK8H
	d07c0WCJEEc3wDvx/R7Cf5D0UMP4YUYU6JDWDzCxHbQR4g/tD4DHBdCZ95bfQI7V
	3JeQSPxmEHkKE7xNi2eI9haEsI3s9hiIgk/rIMm+vAGCDVUv1BMUFEuWdxnD6nW/
	buKscmyiKYVTL5xDNQGApdF+e9WLABhG1akW1ybNqIx0uWXuEcdUFpaYzYzWsHvC
	MC1w/zIxnaj6LEvWUFy91DfQf41LP3oKel6w6j0A==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2frt2fwh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 15:05:09 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67HEuRgt026629;
	Mon, 17 Aug 2026 15:05:08 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g32epxntk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 15:05:08 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67HF57Sa48103834
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Aug 2026 15:05:07 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1B1DF2004B;
	Mon, 17 Aug 2026 15:05:07 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 59B4A20040;
	Mon, 17 Aug 2026 15:05:05 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.19.111])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 17 Aug 2026 15:05:05 +0000 (GMT)
Date: Mon, 17 Aug 2026 20:34:38 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Jan Kara <jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Baokun Li <libaokun@linux.alibaba.com>, Zhang Yi <yi.zhang@huawei.com>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: Re: [PATCH 3/3] ext4: Fix estimate extent index blocks in
 ext4_ext_index_trans_blocks()
Message-ID: <aoMjBjZly5eSiHBh@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260805153202.29814-1-jack@suse.cz>
 <20260805153605.166545-6-jack@suse.cz>
 <anV9QPd1RvK3qVUC@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <xjj4knbbdmielzi4yzifao6qj3nueeflj4hkaitstzw56cwort@l7eh3coy7czf>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xjj4knbbdmielzi4yzifao6qj3nueeflj4hkaitstzw56cwort@l7eh3coy7czf>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=OfaoyBTY c=1 sm=1 tr=0 ts=6a832326 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=iox4zFpeAAAA:8 a=PEwnRRkTZFf50BYqY3EA:9 a=CjuIK1q_8ugA:10
 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDExNSBTYWx0ZWRfXyrHv9wGvyUMY
 S1zrIpOl9N5VOIR2sWzf8JED8SqOF8Ey9q+nW2ZbiaWNogo34Qcosgp11IqKuPsuk6o1LMHvJA6
 M2pmZtN89k54bBciaNrfLLysFYI8XRU=
X-Proofpoint-GUID: qfsmAvuldP1UUblgme08Amr0Avi7nZZZ
X-Proofpoint-ORIG-GUID: BGJogC0nnVsHfdu9nIDvlu3LnqS15Q8G
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDExNSBTYWx0ZWRfX+3eBMnVoIZic
 HdwgZLO3NxDWnEuXZb1SYfhL4QKRdiMsYUW7S9pxraz1lzyx2jAQhnqsMbkfs/uLXBTQ+BOLPfu
 aQW3PNoZXLKjQYm9vAgWBTipQvMP+M8w5ZCJqvbgcdXruYB0H3u+8gw1Knx5hc7yhYHD7tdkY9r
 N8AylNr+GJwDXSibil2BOKIsQ7p2KqYq2jShgwxz8j2phYqiZCi4L7pBYIcV8pdU1TKIbs+jfsp
 e5SVGnMijE8RHH+G9oYf0ikYxjmIngA6/pA05IO3HE7BLXV6e8SerpqkPpLx1R4uKnWaF774C5S
 XgjofIMz3FBL7AoUD9H8sjjfiMng2zVCiAUQ53VHgeBii4TCWhhS22CUKfypamwkQ//u+3FK7qO
 Ubqcmpgq3sDk6ZG/s+Yj+ObDncNmufM+YVMq/tOt1GVxXYac0iRiIgkq+cLn+C3Isql4ii+Ovvd
 0FepDR4W0tt/BCI9Rjw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_01,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 phishscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170115

On Mon, Aug 17, 2026 at 01:39:09PM +0200, Jan Kara wrote:
> Hi!
> 
> On Fri 07-08-26 12:07:52, Ojaswin Mujoo wrote:
> > On Wed, Aug 05, 2026 at 05:35:49PM +0200, Jan Kara wrote:
> > > The estimate of the number of impacted extent tree index blocks could be
> > > one-too-low. If we modify say 2 extents, already two leaf index blocks
> > 
> > Its minor but just to be sure, by two "leaf index blocks" do you mean
> > the two leaf blocks that hold extents or the last index blocks which
> > hold pointers to leaf blocks?
> 
> I meant two leaf blocks that hold extents.
> 
> 								Honza

Yep, thanks for confirming. I think Ted has picked these up but FWIW:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin

> 
> > 
> > > could be impacted, not just one the current estimate counts with. Fix
> > > the estimate.
> > > 
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > ---
> > >  fs/ext4/extents.c | 14 +++++++++++---
> > >  1 file changed, 11 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > > index 44ab246a3176..713b2c098af5 100644
> > > --- a/fs/ext4/extents.c
> > > +++ b/fs/ext4/extents.c
> > > @@ -2427,9 +2427,17 @@ int ext4_ext_index_trans_blocks(struct inode *inode, int extents)
> > >  	 */
> > >  	if (extents <= 1)
> > >  		index = (EXT4_MAX_EXTENT_DEPTH * 2) + extents;
> > > -	else
> > > -		index = (EXT4_MAX_EXTENT_DEPTH * 3) +
> > > -			DIV_ROUND_UP(extents, ext4_ext_space_block(inode, 0));
> > > +	else {
> > > +		int ext_max = ext4_ext_space_block(inode, 0);
> > > +
> > > +		index = EXT4_MAX_EXTENT_DEPTH * 3;
> > > +		/*
> > > +		 * Modified extents need not start at the beginning of the
> > > +		 * leaf. Already two extents may need two leaf block
> > > +		 * modifications...
> > > +		 */
> > > +		index += DIV_ROUND_UP(extents + ext_max - 1, ext_max);
> > > +	}
> > >  
> > >  	return index;
> > >  }
> > > -- 
> > > 2.51.0
> > > 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
