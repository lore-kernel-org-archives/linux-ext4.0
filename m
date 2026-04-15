Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35273195E4;
	Wed, 15 Apr 2026 18:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776279219; cv=none; b=dH54lAdYun1PRsHWuH9t66vLvb8qHdlLgRpO2soD+aU4VKa4j+FR9YNQYv6kzleoPmlMAoiriwAPOf+KIOdvcxZhUQSlcAHfV047tsskoB5wvpScgPDZ+8BjUyITQ/x8Z7ofFhQImW+cgOrd2qKE0oGudofigbt0GcN25qYDcWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776279219; c=relaxed/simple;
	bh=BfHvhcRYRMXMyjgbXJd2OY1+7840Oyx8s5yp4e8AJTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=shEO6C6ZIWdKMN53hACo479EgiRM5xyyaIe3WaXCadW4Pukb8sH+QdZyRVITzmXcR9unZ5rLvWOoPjt6mEZyn4uH9qCDZIMY91md7GpkICTJGGPCzA/8u7Kgd6iE2Yz+fCSTmdlwBFT8ocUaSAHnjTZ+Uoypz6bgUe0uSMe0Xv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gYpWdniD; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gYpWdniD"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63FH8VFf1842719;
	Wed, 15 Apr 2026 18:53:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=h4OpAubd9q5e7B6uB56+ahT00foe/q
	dN8mEFhKjLCNE=; b=gYpWdniDGWhKzptNQkh7Tn6dlR7YwEX/0Fv3tw1fp0Mp+D
	DzA8IlTFXcEIhi4iBhi0FkC/fQZBEVjG9wrq6fGf1fYqrOSzx4IgwRIgrn8vJTrt
	iNxNXyHVFz98/IYXY7CpuQZtzu7cwF8juKjgrGltos8XGr5l1t6CXixUJ3KODY74
	5qIzzomfefd60W36rOS+HFRwPtdgvaqkO4tMF4y0r95kZT5PeXHNlhQs9ABSQFbS
	sz0jlfPcmRaxeSKfJhsLNH5DHiRtzTwq5P8BAu+lUx4Ec5qps8cjYOENzxYSknps
	C76CudaieB3cBRXIu69KgzmqvSnr2yPjb9PZ3Azw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89msr82-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Apr 2026 18:53:30 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63FGWFT6015621;
	Wed, 15 Apr 2026 18:53:29 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dg0msqrmu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Apr 2026 18:53:29 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63FIrRWf53543244
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 18:53:27 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 75D2220043;
	Wed, 15 Apr 2026 18:53:27 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EB9D220040;
	Wed, 15 Apr 2026 18:53:24 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.25.126])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 15 Apr 2026 18:53:24 +0000 (GMT)
Date: Thu, 16 Apr 2026 00:22:55 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Zorro Lang <zlang@redhat.com>,
        fstests@vger.kernel.org, fdmanana@suse.com, ritesh.list@gmail.com,
        naohiro.aota@wdc.com, wqu@suse.com, Disha Goel <disgoel@linux.ibm.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 4/6] generic/765: Ignore mkfs warning
Message-ID: <ad_b2utxJPG1Sc0M@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1775802601.git.ojaswin@linux.ibm.com>
 <afee4fedcc9b3685df0e05800d82b88d27f977f8.1775802601.git.ojaswin@linux.ibm.com>
 <20260410165435.GU6212@frogsfrogsfrogs>
 <advRgjl1tG4PMc6V@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <adyxi7156VAbL-G1@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <20260413162120.GV6212@frogsfrogsfrogs>
 <20260413204215.GA5461@macsyma-wired.lan>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413204215.GA5461@macsyma-wired.lan>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE1MDE3NSBTYWx0ZWRfX++/ljNaxRJz7
 WNRLniE1JFS1qRLN0NqO/BnJOjWEV6sApMH63qu4eVVJhLY5sZ204Gq+4nURoHzP8PsM5nDM193
 8RU3DhVyvYna+SEpPRHjzMFemTDiqgjVwSk4HPBJPhvkPGPTpNM9olO8ISSYQ7ND8QqNI+6MWiE
 xFUAB3riNsjW4Iyz/Ugl8TfiyC/q3UFWb5/pByBbE4O6mb16tDWre+Kuy2wiKCnNDV70E2tUZsP
 vN/4E0QtGlAQGUfVs9No201KWkp5e3A7Lp+4lNUfZNuiZwMiU5tZOalD2uEFwJreiOdzJ4FCoay
 VE+yqGuJtZqCoqOpe1R6njO98BJU2A3QiY4eE+ts2TZKw4F75hxc6KE8gedKb2eP1Atu/Fc1Zu/
 3XqXM6nOd4IjEMWUOQWhXw/f117zbK1fYQ4ZjQIgktvsfRc0rweIyPq1nJS3QSr+8VrjgeWKY+T
 aGo+toae3sGLdm9tejw==
X-Authority-Analysis: v=2.4 cv=eJ4jSnp1 c=1 sm=1 tr=0 ts=69dfdeaa cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=66D-73G8LnB4jtNC3wMA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: FAMMwvCd3pJ_QqljpiaUgoGKtuIBZMov
X-Proofpoint-ORIG-GUID: plDz-XMIJxM4rI7fkQEcwMY8q8R7ic8V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-15_01,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 suspectscore=0 spamscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604150175

On Mon, Apr 13, 2026 at 04:42:15PM -0400, Theodore Tso wrote:
> > > > > > The output can get corrupted with warnings like below because clustersize
> > > > > > more than 16xbs is experimental:
> > > > > > 
> > > > > > + 16 times the block size is considered experimental
> > > > > > 
> > > > > > Hence pipe these to seqres.full to avoid false negatives.
> 
> You could also suppress the warnings using the -q option, for example:
> 
> mke2fs -Fq -t ext4 -O bigalloc,quota -b 4096 -C 131072 /tmp/foo.img 4G
> 
> > > Futher, mke2fs has multiple instances where we print warnings to stderr,
> > > should we go and fix all of them as well?
> > 
> > "stderr" meaning "standard error", I'd say that errors are anything that
> > prohibits the format from completing, and only errors should go there.
> 
> Sure, I'll accept those changes.  But adding -q will allow the test to
> pass using older versions of e2fsprogs, while still allowing stderr to
> go out the expected output.

Okay cool, I'll send the patches.

thanks,
ojaswin

> 
> 					- Ted
