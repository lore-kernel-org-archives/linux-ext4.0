Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F9038F623
	for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2026 10:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773396467; cv=none; b=Fzousjf3hEPTE0Bib3/lmkdCY3OfMC8hfsZSrafX6fzYg+iQLMG0cHXBed2cAAPxovenjKbRoG8ccFIHX0jJpe9Pi+E6SjP7MkSzlQEvqYn2xocWSa4I8J7CVnRjHe17EfsHohvOIHKa/XjRL0VTSBfM1Tanxyo17HXbvQFyU/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773396467; c=relaxed/simple;
	bh=2w25CDHM9PDEt3tYNivGwH1gjLzIRT5YEMQU0FWtUsk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ffZEiTcSZw5/XLrrO+hLKAA1mBecZldRiOsKwoPtpWrIzpew20QaCIP5B6DHeV3SvAKzW74z6+bZEQsXsQ8RrTQ2qSGVyx3rhK7ts0RekZAFk87j4DTdP3X2FbAqzeNQW0hZYgPCbj4Qp7v+5xUm1LKSmaR6KJNwhpCcnOE5fy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=m5XXyP6B; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="m5XXyP6B"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62D5FCdK2259751;
	Fri, 13 Mar 2026 10:07:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Aogr81/kce7bNcoC9AoSK8plahwjrA
	a7VB4Vr5WmXNI=; b=m5XXyP6BcICKyFhxYRpD01rDbAEBOmJrzuAc786Zkka15F
	kaeGwvaIEZWrjdsXOuleeax3Nqs7Vw0UsVHxrk0KF9kA3vapHoLJ+PNX7T/J8ahg
	TgVcC4fbOgnWgUxjYLf7mimoLLF10gfE94Telqz7IEMjX7IPJAqBJvVhKln14VRv
	MmW0eqfakbo94rtvmngHS/nhOyWbVc3XPW5MHYJqZHd0m39qz/1yWu9eloZjT8UF
	/xzHKXDRiYT7FOwceVJetcNxd5zwqWEQOF+uctTa/re1b4RXiyqHDB88TMzi7+uL
	adsqSkKJuXCMgSHXlJowoD8Nb1Z6BFEKuCPVpSQw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh92f68f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Mar 2026 10:07:43 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62D5alDH025678;
	Fri, 13 Mar 2026 10:07:42 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cuha8e56r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Mar 2026 10:07:42 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62DA7fDw30867764
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Mar 2026 10:07:41 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B2CE2006B;
	Fri, 13 Mar 2026 10:07:41 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3A1E82006C;
	Fri, 13 Mar 2026 10:07:40 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.23.11])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 13 Mar 2026 10:07:40 +0000 (GMT)
Date: Fri, 13 Mar 2026 15:37:36 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Mark Brown <broonie@kernel.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: kunit: extents-test: Fix percpu_counters list
 corruption
Message-ID: <abPh6GX0t22m628D@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <5bb9041471dab8ce870c191c19cbe4df57473be8.1772381213.git.ritesh.list@gmail.com>
 <f6d26b93-e21c-45bf-b377-1896010e59fe@sirena.org.uk>
 <abO6o3RFQM24dYK9@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abO6o3RFQM24dYK9@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: sQgU9aYysUEplMzgLvZ-P8ULq25hBNhO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEzMDA3OCBTYWx0ZWRfX7tK/VyS4jJZc
 DMHofyfq/4ukD+7N77Io0EGLXWOX1srNvGXTHjoWzLTRkD9AgeHbRZ+y1ojX6fUxa0mUXl6f3Z/
 q08lBQGJPoUtUZjPx05OJCvqe8OhzaK5re1FeLcL9lU6LXFYWbOZLCUDjakYptwOU3xkF0kPDrp
 FQ77Jhq+B/3ndHyVoZmVel6HQwh5kbdXFijXpx3yT3UzbThPjKlTxh0d60F/0sVEgDiBao/cs5N
 91mwLa/vll09WacOyCN5Wzm1n1v/tfQHeuM5w/m+phb/mqf3+YjdRYsAlJcnDSN+Wu64tTEsySe
 ZZbNXMyf5auXCLKCzz4O+BtmNFxVY7ZUWKVltvy0NNffjS27xu3d+NXLJhHrku6D1wHK+xzgmiK
 vaqw9AmLzTuWUV+7rNJKyR4Gs5vGhJJsbtRj0TSlqW+khMrSO1dYE3EqaN9wVroPT5oQDDLXiW1
 5VCnmN/I1cw1+7SUEvg==
X-Proofpoint-GUID: 8i-NmHLloIwiPDAGn66uYUapXU0brWtO
X-Authority-Analysis: v=2.4 cv=XNk9iAhE c=1 sm=1 tr=0 ts=69b3e1f0 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=AiHppB-aAAAA:8 a=nKqlpFztFCWwokx0LXwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-13_02,2026-03-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603130078

On Fri, Mar 13, 2026 at 12:50:03PM +0530, Ojaswin Mujoo wrote:
> On Thu, Mar 12, 2026 at 03:57:38PM +0000, Mark Brown wrote:
> > On Sun, Mar 01, 2026 at 09:44:26PM +0530, Ritesh Harjani (IBM) wrote:
> > > commit 82f80e2e3b23 ("ext4: add extent status cache support to kunit tests"),
> > > added ext4_es_register_shrinker() in extents_kunit_init() function but
> > > failed to add the unregister shrinker routine in extents_kunit_exit().
> > 
> > This is breaking KUnit in -next which is causing problems for other
> > trees, can we please get it merged promptly?  Discussion here:
> > 
> >    https://lore.kernel.org/r/abJe1PAf4JbwGGRI@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com
> 
> @Ted, the fixes here [1] supersede this patch. I've asked Ye Bin to post
> the fixes independent of other patches. Once we have those, we can get
> that merged and it should fix linux-next
> 
> [1] https://lore.kernel.org/linux-ext4/abO55xo3MDyJ-NEi@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com/
> 
> Regards,
> ojaswin

Hi Ted, upon discussing internally with Ritesh, I believe we still need
this patch and [1] doesn't fix the issue of linux-next, just hides it.

Basically I was assuming that the patch 5 of Ye's patch will handle
unregistering the shrinker via:

deactivate_super()
  ext4_kill_sb()
	  ...
	  generic_super_shutdown()
		sop->put_super()
		  ext4_put_super()
			  ext4_es_unregister_shrinker()
				kfree(sbi)

However I missed the fact that in extents_kunit_init() we never set
sb->s_op so ext4_put_super() is never called. In Ye's series, the issue
became hidden because the kfree(sbi) was never called anymore (memory
leak) causing slab to never return the corrupted page.

Hence this patch is needed for the immediate fix of linux-next. And then
we can look into merging Ye's fixes separately, once the review is
complete.

Sorry for the confusion.

Regards,
ojaswin

[1] https://lore.kernel.org/linux-ext4/20260312131253.366296-6-yebin@huaweicloud.com/
