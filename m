Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF14033F8A2
	for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2026 09:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787043728; cv=none; b=iWKdKd4NEunBNcnqpAReitNCefWrwF6TcIqLyHP6OO2pgQJPDnnGO6vUnpKo1TgurZx3dlmdyPTfi2Bh1KN5NzI4s0fNRnkkX+7zlIeKmIh9l59PGF1F6yjbw/ki7p7lIS22QkjxhQrXiq+KaZhyTb/SzEh0pXX1nXT7ST3dLn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787043728; c=relaxed/simple;
	bh=DR7Rw2o9mHCiOkvzX1QUQaQZCPVzoeEFnipzwH8zYEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QmV8Soppn5CHcf5jI1xOn6i6fUpbngAlW3QdUHDueZH4JU3rPFfDu86e8HR2dsnNB7NG9eD27Xf1+0RiELqgSkZ/2mvN4nnyHECWV1tChOI2o8rugrazStYcDGtI6h4viDCgJmphPf9JNWEp0AkkcxnfzovIApMPEHDb47LhO5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dEGGQR60; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dEGGQR60"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HM1ntI2669356;
	Tue, 18 Aug 2026 09:01:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=UYWbkfD8YPMQep1UiFmxBC75qqg665
	QuzGGRmusp/fM=; b=dEGGQR60hzSwJxttcVsRZdf9CqAwuhpUiu6aewnOdePLOY
	/9Yqa3W98Qxjkn45gQ0CXLT7vb46ZogPsWUdNi4Dxi0QGwjwA7fJFNogXRk9UxC1
	JJ0Wi3KbxAqvZGaDboekQg5fvZ9YXVt6W/pbqoX388c1c/yNzOMpfFtW+MrrBbpS
	8rsb71QV5S9zwTP3TFVSbXoV6mPk/YJ3rWqkOarf1o26pv9BS0aGQ+L7KC+GwKcP
	yhiOsGqyVlXe43jFaqVBLp6DbuERz5KhKVNgWs6OsCBYL9KZsEBuW6k3+C2xXqb9
	ObXIMeDhzRJUJnjyEgBeu/uzXByDFjRd/gLVjhBQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2frt6nvk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 09:01:47 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67I8uMGJ019188;
	Tue, 18 Aug 2026 09:01:46 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g354ya3g1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 09:01:46 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67I91ie115859976
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Aug 2026 09:01:44 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C1F3D2004B;
	Tue, 18 Aug 2026 09:01:44 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5794A20043;
	Tue, 18 Aug 2026 09:01:43 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.123.13.2])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 18 Aug 2026 09:01:43 +0000 (GMT)
Date: Tue, 18 Aug 2026 14:31:40 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        Baokun Li <libaokun@linux.alibaba.com>, Zhang Yi <yi.zhang@huawei.com>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: Re: [PATCH 0/3] ext4: Fix credit estimates for extent tree
 modifications
Message-ID: <aoQfdB0TJRi6acy5@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260805153202.29814-1-jack@suse.cz>
 <178632560650.1021605.3694902133748235095.b4-ty@b4>
 <an66zNiouBCgpS9M@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <aoOYvl2tsk1o6TR9@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoOYvl2tsk1o6TR9@mit.edu>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=OfaoyBTY c=1 sm=1 tr=0 ts=6a841f7c cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=EWHbFpkc5AXs8ooYSwEA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE4MDA2NiBTYWx0ZWRfX+dbuk5Krs597
 TJxMlIw7Te1301w2OL1ZUuYnJt4dweFjM91NVBGok+ysRsLw3SfY2pBZxAK3FBVDcBGO/DpwRo3
 EymMIC0dWLMUdtEMvMYtmkAJx+VtHpA=
X-Proofpoint-GUID: HKSBqbt7YnzFAEeHk0T0GTyGPUk3mMzC
X-Proofpoint-ORIG-GUID: 7fV3J7O8hg5X9wm1GMMq0ejWMHv_VqEv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE4MDA2NiBTYWx0ZWRfX+JluxiKs25Ic
 usRwvI8VlQJCqujUDs6z8XghH0AlWQVfyOiFSO8TOuHloYbm7ZHlyRyl8L2xp/yE70JjgHbGV+H
 zv/dvYkvv8PthJDjp3vbTC1Bea/omuU+Wyu2iC91Z9dk0yVCZsMcuHm2UuNthOP5vsJiWcio+df
 DRrnbO8fjNfrK8HdajSVpPVHsKFxG64EmPJqrHrbRFoENfKMCe09qTWS9fVjWiippEJIKypb7/F
 luXe3mCKH1EQa4UAO1yqy3Q2NdZakRjDY2yMpttTOwD3mP7rXs0riEQsRwpYg3532BqeH8mIKLx
 pCtwVwryae4SOB6kelRufP2HRFo16BLryOkZDuvmrauhoGZ4CpE+DOl5ns1wWmyxovklffh4O3r
 t4qKpjSeErG3qIppjRxAop1KxBd+2MY5p/YEi4v84OVFfe0c3ZqLSE98ejPoKGJwhNjEvVRcISA
 XYEap+Mj8XTB6axbwtw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_04,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 phishscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608180066

On Mon, Aug 17, 2026 at 07:31:46PM -0400, Theodore Tso wrote:
> On Fri, Aug 14, 2026 at 12:21:30PM -0500, Ojaswin Mujoo wrote:
> > 
> > I just noticed that the RVBs were not picked in your ext4/dev branch. I
> > think they got missed somehow.
> 
> Hmm, I see them on the dev branch:
> 
>    https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/log/?h=dev

Hi Ted, 

I don't see the Reviewed-by tags here as well.

Regards,
ojaswin

> 
> and they are on today's linux-next branch.
> 
> 						- Ted
