Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5485E2DF134
	for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2026 14:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773410628; cv=none; b=Nqczy2bf+bAeedMeUgGrrCHfiYJUHEkhLpFTkQ/Go10pNyN/Cg1AvaDFp4QEs0//TMh443YVINx3RTh+ENyx0ZKp+Oxo/Nzu37lBF5QFDH6NRlrdCVReWldSak3S50TSfMgO62+wsL3vmBuYoGgyXjlA1RPMgggyh4CtSfHDuTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773410628; c=relaxed/simple;
	bh=6elx+WFyx5KzEd/a541NhYPzvf0Ndk0T4CKiZC8mpPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XgjEdCV6u2Lte5r666VWcLbjkGc+EgOluvFP/zOtwapJ9uCtG+GpybATwJLxocdKtCv3klHPBCWr1sK8mP4IDKpQN8SfWeDm4qB+Yn+xHZKj4ue7ysrRKjeyWBqdNyAemqzAYicLdKuqC/gA0tRK5rJixAABEzPFDRM4l79NYdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IwY6MxSz; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IwY6MxSz"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62D3U6nU1527560;
	Fri, 13 Mar 2026 14:03:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=hgCfHPJzlKejmmQE9FnOtkFCmnvYoC
	woHbuvuo+wG58=; b=IwY6MxSzJsLkCwUnNdZGmKvZYsmVQ8lixF63jOMawUHQ4g
	fbnAKK/jRDfwtlJ23tSm0okPqnwMU889Jka+NlPWZRDNLcfT2HfDVewOVLeUwQx3
	enUQy1VXM/7Jojhc9FOt6kPpmuZdXu/UEB+4eqK2VQ5PK9dNTJpf3Mb4zvVlMNvE
	tRdS81ki/gww2NGAsCwGl1SC8oJRuh09uUeUj24oCclDApJskeRjSz4Qz/ZeCz8L
	yIlaRFRxOzJpKVO8Fdm/6dH9vAuuHicVlMha7whYpmLYSv4AXo/CceMcIAIReeUa
	Q6IsGPFs+8pXU7lfU4gyWwJxTUErSiWEBHmfZI5g==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh98fte4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Mar 2026 14:03:25 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62DAKJAT018604;
	Fri, 13 Mar 2026 14:03:24 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cuha86ws9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Mar 2026 14:03:24 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62DE3MoM41222550
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Mar 2026 14:03:23 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CCA142004E;
	Fri, 13 Mar 2026 14:03:22 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 21F3F20043;
	Fri, 13 Mar 2026 14:03:21 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.23.11])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 13 Mar 2026 14:03:20 +0000 (GMT)
Date: Fri, 13 Mar 2026 19:33:18 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Ye Bin <yebin@huaweicloud.com>, tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, jack@suse.cz
Subject: Re: [PATCH -next 5/8] ext4: fix miss free super_block in
 extents_kunit_exit()
Message-ID: <abQZJiRBpeyLfFye@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260310130412.3156753-1-yebin@huaweicloud.com>
 <20260310130412.3156753-6-yebin@huaweicloud.com>
 <tsukszr0.ritesh.list@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tsukszr0.ritesh.list@gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=M+pA6iws c=1 sm=1 tr=0 ts=69b4192d cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=AiHppB-aAAAA:8 a=i0EeH86SAAAA:8 a=v_9cDC3c6U4_4HyAiZgA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: GsR5rnzE635frjOQPlAYMi4SpDG__wB2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEzMDExMiBTYWx0ZWRfX+1EQoSoVxE80
 7Y4LVgl48ov3BXEsvnMjScTUE5y0T83Kbje5Qmn2iXJlLH064vPlpg/rznUdg0MwRu1NjLNiY6E
 COgC2wUS4yKGbh3JdKR5KKAUzkWXPTnrd2ity35wHI2j0RZ2WS7fbIKzaJyZq2xXxXRRcSJOa22
 DAShmuTnmnTTKEZtE6qqKMIeTCVnvUXh/W3VVIPtLokN+wCId53fqw+pa+w9rrq/dur700RY/mR
 sZpRwMOkZgetQrv2G3Pu9kCt1xb8729Q1so0WdZ4khOEzZubbqBkaoGJOaFuim3GWK0SpEubT0Z
 M/bc1uGy7m14CySfWvlAaRbqhnzLpMTZdmk64SAiDrTDJFb4mG9vYdE+hrgaPtsYizQwx4lZzz7
 k9cEiQc066J25VTkMpUDNdERnbvsKYHMLk5bxn0OCfxYIGA9FiS7jnWm/dDr4WnHwz0PMNJ8TS2
 7Rowjejic1azE17LnJw==
X-Proofpoint-ORIG-GUID: yGFD4mJK86zO0fR4tjJxhF57Bpv-Trkg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-13_02,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603130112

On Fri, Mar 13, 2026 at 05:33:15PM +0530, Ritesh Harjani wrote:
> Ye Bin <yebin@huaweicloud.com> writes:
> 
> > From: Ye Bin <yebin10@huawei.com>
> >
> > There's issue as follows:
> > ODEBUG: free active (active state 0) object: ffff88812f2d68a0 object type: percpu_counter hint: 0x0
> >  <TASK>
> >  debug_check_no_obj_freed+0x3d9/0x4d0
> >  kfree+0x2bb/0x6c0
> >  extents_kunit_exit+0x65/0x90 [ext4_test]
> >  kunit_try_run_case_cleanup+0xbc/0x100 [kunit]
> >  kunit_generic_run_threadfn_adapter+0x89/0x100 [kunit]
> >  kthread+0x408/0x540
> >  ret_from_fork+0xa76/0xdf0
> >  ret_from_fork_asm+0x1a/0x30
> >
> > The above issue was caused because the super_block cleanup process
> > was not properly performed.
> > Therefore, deactivate_super() is called in extents_kunit_exit() to
> > cleanup the super_block.
> >
> > Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
> > Signed-off-by: Ye Bin <yebin10@huawei.com>
> > ---
> >  fs/ext4/extents-test.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
> > index 5a5016ea1ecc..70d84c0a18e2 100644
> > --- a/fs/ext4/extents-test.c
> > +++ b/fs/ext4/extents-test.c
> > @@ -144,7 +144,7 @@ static void extents_kunit_exit(struct kunit *test)
> >  {
> >  	struct ext4_sb_info *sbi = k_ctx.k_ei->vfs_inode.i_sb->s_fs_info;
> >  
> > -	kfree(sbi);
> > +	deactivate_super(sbi->s_sb);
> 
> This doesn't look correct. We don't have sbi->s_sb->s_op->put_super() registered, so
> kfree(sbi) never happens. Maybe it will be good to check with kmemleak
> too, that this could cause a memory leak.
> 
> I think we can do:
> 
>   ext4_es_unregister_shrinker(sbi); // already taken care in [1]
>   deactivate_super(sbi->s_sb)
>   kfree(sbi);

I checked in my setup and can see that we don't have sb->s_op
registered. 

  @@ -149,6 +150,8 @@ static void extents_kunit_exit(struct kunit *test)
  
   	sbi = k_ctx.k_ei->vfs_inode.i_sb->s_fs_info;
   	deactivate_super(sbi->s_sb);
  +	kunit_log(KERN_ALERT, test,
  +		  "sbi: %px sb->s_op: %pS", sbi, sbi->s_sb->s_op);
   	kfree(k_ctx.k_ei);
   	kfree(k_ctx.k_data);
   }

Output: 
  [   12.176807] sbi: ffff8881089cc000 sb->s_op: default_op.3+0x0/0x100

So we are using the default noop s_ops.

Regards,
ojaswin

> 
> [1]: https://lore.kernel.org/linux-ext4/5bb9041471dab8ce870c191c19cbe4df57473be8.1772381213.git.ritesh.list@gmail.com/
> 
> -ritesh
