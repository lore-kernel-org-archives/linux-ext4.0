Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E8C35CB9D
	for <linux-ext4@vger.kernel.org>; Wed, 21 Jan 2026 05:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768974844; cv=none; b=sPmiHgpO/XF0CyUYRJwNd+5ixz+hYkcEYPb8sPmFgXST9CnBtJFbvpLJgzfGSYA6pthMG6Ikz7KZBBGDTbX2B6CkuCpd1A7ou0JArIT1jVp1bouHOQFZqo3bNJF+9Ay4vAaO31Tp/+faCaxkpTP8vnea68TQ650IYI2k1P8TBp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768974844; c=relaxed/simple;
	bh=KVTlQL9DAgGj1HFB2+HpOMvC307KwbFM3VsUbjVMb9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sdaifMTlUJjKE+ttww58yal2v1+HAnJO+guudsQ58SgrI4JHf9ujtAft0wCu/ecYPtGA6TRpo1ExEzG912FxJpjLFnA13EUFNUyU2F4uuDDk87wdm+UWeohhBPz91Ob7ISvXbx0aScQupcLXumDLN1pzED2+jZ5eEvyxQOI4D94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CEsIawAP; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CEsIawAP"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60KNjwpN020636;
	Wed, 21 Jan 2026 05:53:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=4Vo9h1kV7+MF9dHm711Ah4XVUfrHbQ
	edWbPdtj3XAuY=; b=CEsIawAPZovuAPT57OaNO6WEVt2ndLA5celtGlr00Gi4Vk
	dB4jy/Td53lyOMtcNmIpL9t6T5P8hHENj62TwTChFnuTGQR7tjmqdDIf315lm+qA
	Q4f1tPWYqH1m/bbyBv75jUPWZA7Zw6hiu6RvzTUhzwW9UQctqY7JYzPWmktnkCLC
	/ovPW/IZ9XNTMqwE0sQYZUchLVEbnklDvMpPWkCn0LJ4yL6MA9smIj3rkse3f9j3
	MvWWe0k0tt7m0hWi9/05yhuhKxb811mDeqEzJuCwxSONy+kvd3krmojRtWfoQlnZ
	iAtCs9z4RWmWsgwYjoH2Lx/K3GTFxcKnGMAqEMew==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4br0ufhe49-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Jan 2026 05:53:55 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60L3OpnX027220;
	Wed, 21 Jan 2026 05:53:54 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4brnrn25sc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Jan 2026 05:53:54 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60L5rqMQ15270184
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 05:53:52 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BFCDB2004B;
	Wed, 21 Jan 2026 05:53:52 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A064F20040;
	Wed, 21 Jan 2026 05:53:51 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.24.21])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 21 Jan 2026 05:53:51 +0000 (GMT)
Date: Wed, 21 Jan 2026 11:23:49 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: kernel test robot <lkp@intel.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Subject: Re: [tytso-ext4:dev] BUILD SUCCESS WITH WARNING
 1375189be5a60de4c0966f9e1dc5b34f056ec04d
Message-ID: <aXBp7RygGbDNsCQd@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <202601210011.UEP6VwCi-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202601210011.UEP6VwCi-lkp@intel.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6YwDG_7QXzQ9X4CsbiVLUd8EG-nFcceI
X-Proofpoint-ORIG-GUID: 6YwDG_7QXzQ9X4CsbiVLUd8EG-nFcceI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDA0NiBTYWx0ZWRfX3HG5qqaxPuMU
 9kra6Tbvu0WbDHL17Ccqdx5v+l8m0PpsCzbRlhLi9rZ6wk1PoeK+tMYs9Cjm8RNACXDRvyddq9v
 6bwwabDoDZun+Ta0Nm9e3b2bfU6DOu4juL5UpfikDBJ+bf1JhgSmV/3bUblMyOR01eARJiHlZHB
 mmjGDxhTT7wk+KBLHS++TdrkIHMDDZndZsYWRzfYvrOig/U1zTBr6qiVYG92szk3GFUzMmW73Sc
 DjJWF62kZ6GG4bOB785r4Uey7c8sra9VvLQgXJLxXDFsQsVMzQPBfBKYOWMKQqxvqxx02R/PaUi
 IQRZhB1tvwaBHWuYuTiAOkcPzJCt4UJGF+OG5jv+rQ5ehZiyNQvUL9zUcLblnY3OwTNTI2xyNCH
 w1/g3vrcJJOY7nTcNWPMyJwPLfXphA1n2x/LlLNksFgu7wjb4q/75wR62yv8rVC08/4jM2DVgOr
 ybVZiadBHvTEYOw4rgg==
X-Authority-Analysis: v=2.4 cv=bopBxUai c=1 sm=1 tr=0 ts=697069f3 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=RJle-kQt5ayhJ5grlNQA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_01,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0 impostorscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2601210046

On Wed, Jan 21, 2026 at 12:29:17AM +0800, kernel test robot wrote:
> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
> branch HEAD: 1375189be5a60de4c0966f9e1dc5b34f056ec04d  ext4: allow zeroout when doing written to unwritten split
> 
> Warning (recently discovered and may have been fixed):
> 
>     fs/ext4/extents-test.c:48:9: warning: 'EX_DATA_LEN' redefined

Ahh so arch/s390/include/asm/asm-extable.h also defines EX_DATA_LEN :)

Ted, shall I change the naming to EXT_DATA_LEN and resend? 

Regards,
ojaswin

> 
> Warning ids grouped by kconfigs:
> 
> recent_errors
> `-- s390-allyesconfig
>     `-- fs-ext4-extents-test.c:warning:EX_DATA_LEN-redefined
> 
> elapsed time: 724m
> 
> configs tested: 193
> configs skipped: 3
> 
