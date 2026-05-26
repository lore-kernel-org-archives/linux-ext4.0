Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381A4401A32;
	Tue, 26 May 2026 17:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779815039; cv=none; b=iveASnt7AQ2ROeMiUNP7yxKgfK2/XdR/EyE9PqWb2JxW8Z/cSLw7od7JCdGE8zTb+0dv4QKoa68zCkDbJXN5n/KzLERv5xnfMf5k3W/HharstutpdSnj2qfnyFkJOAmQ2D5+Z8biJQxM2G2EgruhKR3POhwWxuO4EykVXwTH0y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779815039; c=relaxed/simple;
	bh=Jheo9sZwyglxXrHT5oNoxYP0A2kQfaIGUecuWZZQ2pM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=udOJumeffG/yxPHm5v03AS4HeRmPf9VYhxCwSeIipgiflGaDRRPrvjvLARVygBXyi5Ao/p/XtAX7UFBArDfaHOSnoFRFw4cVFEXFpIeXHKqEn6bNmw3HrMy94VonXJfz1UgsA1OJE/xl4RQXjXlLCFTbQH0GV0ctbbr+afhFLvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=I9r7u1n3; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="I9r7u1n3"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64QAj7XS1701412;
	Tue, 26 May 2026 17:03:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=VF6XnHZ8wl7wdURjPuSNpgQh9iiY5J
	AZ1sN/2BaOZKA=; b=I9r7u1n3dKNrJEwc0algpoOJ95UCIyauo4fNiHJdHpCpg+
	Ie/MovKS9N9V/BseUgjXVH5RyHaAOex/XumJre089CVUzVn34Q+3+Pr+poYJsYuo
	gOAmSgTx4m53sz/6AVdwuf3ZLkG/Q6opnZgnbFsqQY4eUnVLDqaLF0pmdF6T4z1a
	kVsJUdc2GKTP66Aou9822U4Pq7657y9pgoH0w/oe+QV5nCJufliKQ5zR1arNhl0I
	hXDCbITCPSz/cbAEfI0mBOw1yCI0ih7jJK2QvibVPOQ1DDcWwIdM1euw53QOWk7Y
	+w6nBXpuoyPmEz/gSzNPBPUJ9Y3InEeobCVm5vfQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eb4s2dawe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 May 2026 17:03:31 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64QGd7fn026899;
	Tue, 26 May 2026 17:03:30 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ebs8ya3g4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 May 2026 17:03:30 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64QH3Sej42074496
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 May 2026 17:03:28 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 675632004F;
	Tue, 26 May 2026 17:03:28 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8319B20040;
	Tue, 26 May 2026 17:03:24 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.18.153])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 26 May 2026 17:03:24 +0000 (GMT)
Date: Tue, 26 May 2026 22:32:48 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com,
        yukuai@fnnas.com
Subject: Re: [PATCH] jbd2: update outdated comment for
 jbd2_journal_try_to_free_buffers()
Message-ID: <ahXSOMykmefnvO_Y@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260522030540.3896201-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522030540.3896201-1-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: aJcv1VbXSaueCVXGKLHrdZ1DOypcTEGN
X-Authority-Analysis: v=2.4 cv=Sq2gLvO0 c=1 sm=1 tr=0 ts=6a15d263 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=i0EeH86SAAAA:8
 a=VnNF1IyMAAAA:8 a=y4ZKDCiFNaCdIKpVWjoA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI2MDE0NCBTYWx0ZWRfXxef/7z914hVS
 6IlxkMWm+6783yvPxds7RN4S8gyzOC8xJHpLNn2VdnfM6d+WDD7E0QopNLTiQghfPX/Q4bwrh4Z
 QB5oZF1r0orMv6+UYQ2nUdiXde6zsxLxWkuZgYHfRjjJ+XkKAoyyR3ecZjvHCheji0mlsyuHZGm
 kPNQpUd25i1G9cx35+dPksWqSk4Evee4+bwLPTzhqPqUp9uQJ/Be7DYPbeLhQacUEEtZYAMyKAp
 k1GJyojfSCdtK54shqwigK1yq3G9v5if7T4xNF91ccF2yde77P3zadsuOQ1EWf3/jAB5yHKZyHs
 GFPbntPQfOEmwqqrcIZREN7nmeo3DJuS88qQWs0fdyagTBP+I2+WyiVWPVnorINAjo6gmnP6eEa
 naAvBVp/jZWz+W+dxBjG5ESDpo8OhiGc0TlQiqfZp/AV/dVNLLVrtGM9BKnsMZmHZ6NHeN5TPgE
 vaKELcjBJl5MH+wA+Sw==
X-Proofpoint-ORIG-GUID: EiS6nBpNd3kwhq5lj0O2I8-5k7SO75gq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-26_04,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 phishscore=0 impostorscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605260144

On Fri, May 22, 2026 at 11:05:40AM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> jbd2_journal_try_to_free_buffers() currently only tries to remove
> checkpointed data buffers from the checkpoint list for data=journal
> mode, and bails out if any buffer is still attached to a transaction.
> For data=ordered and writeback modes, data buffers never have
> journal_heads, so the function degenerates to a plain
> try_to_free_buffers() call.
> 
> Besides, The release of metadata buffers has been delegated to the jbd2
> journal shrinker in commit 4ba3fcdde7e3 ("jbd2,ext4: add a shrinker to
> release checkpointed buffers"). jbd2_journal_try_to_free_buffers() is
> not used for handling metadata buffers now.
> 
> However, the comment above the function still references
> jbd2_journal_dirty_data(), __jbd2_journal_unfile_buffer(), t_datalist,
> BKL, and BUF_CLEAN, all of which were removed in commit 87c89c232c8f
> ("jbd2: Remove data=ordered mode support using jbd buffer heads").
> 
> Replace it with a description of what the function actually does now.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good Zhang, feel free to add:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin
