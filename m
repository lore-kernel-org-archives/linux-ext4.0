Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5502A3557F3;
	Tue,  2 Jun 2026 10:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780396704; cv=none; b=cdQo93vZZj1qI1iMub7L31XhZkInps5XnSA43qmn80j4auWGeWXBpohOy/VGY3VKutrgJr7vOS24x5wgcZ/FxSdgYBdxlBEjuDHSIS/ShtNb+fufrPeyZwVhMnYhR/dQS0k/KPmWQfPv4HVCGLDkMSu2gGkiCAboHWJoy1fu2ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780396704; c=relaxed/simple;
	bh=hQHI+gA7J3y66uC64+T7BlRqTy5AMPvzdZhG5+a1WAI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fvtNiqVJb4EurqJR9aUrhR13ChL68Rbsx1NSN4V2Fdvn2evKwD4EoFsOCAXNsfUjQ+lQG4aigAR7cq4fds9edM3hnRK8LRBQrsTgs6IKjKBbBEw8Y0nYRv6IcNSQQEpcbU+utwrxJ0J0n5dz3PUzsB2S8kWMjC6ThMbO0OtOWCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=P+fTbfdq; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="P+fTbfdq"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6526Omm42292567;
	Tue, 2 Jun 2026 10:38:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=sfpjhcaZa63OnPZOGzODUuDHJT6NFr
	/v3m4/jYPGifk=; b=P+fTbfdqFuUufwZL7khyA4ApySHD4ub4BrM1C+YOUiVSo8
	SYpoe4b5C9mk831TAJNnhvFn/he6NaU9dLg2kMeDs9ONJP9cENsF1EYBozEEOb+e
	2EPr3Rn1u8muwAPzy+plEjbq/ToKZKCdFjN6t3z4EE7oVhbM29vJ35KmM/C89mIt
	uPsuLdvY+0EDY/KT2FA04paZnpmxivcwukvW8s71NCU+/eWApHlgpCIi/thejxU7
	ht6/2gZVObxO4+EKfhYtAenXrH55BxQYDJGZL3jkj81Ebn0EFJFcln9UZy+TW3UD
	2Zm0zK/7z/8Ky/udeQGJQFt++ei7wi2gwleBreXA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4efqjq5cfc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jun 2026 10:38:22 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 652AOOaV011856;
	Tue, 2 Jun 2026 10:38:21 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ega7qaye4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jun 2026 10:38:21 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 652AcJZJ48169468
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 2 Jun 2026 10:38:19 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F47C20043;
	Tue,  2 Jun 2026 10:38:19 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 14F6E20040;
	Tue,  2 Jun 2026 10:38:18 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.123.13.2])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  2 Jun 2026 10:38:17 +0000 (GMT)
Date: Tue, 2 Jun 2026 16:08:15 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Disha Goel <disgoel@linux.ibm.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ritesh.list@gmail.com
Subject: Re: [PATCH] common/defrag: Skip defrag tests on DAX-enabled
 filesystems
Message-ID: <ah6yl1T9jnN0wH6d@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260602101418.55131-1-disgoel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602101418.55131-1-disgoel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 8TLNXbL_n6t--MMBS-2adwUGcgMjDBL3
X-Proofpoint-GUID: FeobQaZGfDkQf3zBLc1WGWgql0R5hxsr
X-Authority-Analysis: v=2.4 cv=bcVbluPB c=1 sm=1 tr=0 ts=6a1eb29e cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8
 a=f2d3xVgRKFj-nnJE2L0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDEwMCBTYWx0ZWRfX7omXT99wfXUt
 KR2VUSfzK/ZN7uh/VEZoFdp+oAV4pR9uFoFViAsgJDFCEG3V1pQN40aXKlqHhqSNVHjLtUY8NgL
 brFF+yXRQ0lSlnPsgNnCrcDJ3sNu++i0ZeIou4Go5um/ichqnynWAvinJW55dsnVO9Tq5JZsUN7
 jeSRWSdZm3IYnLlYejChG3TmZ9pB0uzt3+gwtg2/vCf9SZIcPIxmi/caEt4v8XAtebI46Pg8W+b
 wOzx//7gh8N+/xQD/9OzG40VbTpbChJ5Rgx1yh2RrVgyCEBH3NNXxMrMB+7XstcefwPT3MI5kjG
 09F4w1I2UrE7KgykP6ij0EWxU3va3vfvGJZFN8Qtqhi+BjuRPEik4shyzVbEAXENYsth2gdWGvx
 fVjxPdaOWaXGiuFG0Ln3fLlCNlJYWtmGZ6IryOFFzrJF8oFIzeFOXqjReS2YsL5UVtNSXzurQRr
 HGHI7u4idbbeChNaPgA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-02_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 adultscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606020100

On Tue, Jun 02, 2026 at 03:44:18PM +0530, Disha Goel wrote:
> Online defragmentation is not supported on DAX-enabled filesystems
> because DAX bypasses the page cache required for defrag operations.
> 
> Add check in _require_defrag() to skip tests when DAX is enabled,
> avoiding false failures on ext4/301-304, ext4/308 and generic/018.
> 
> Signed-off-by: Disha Goel <disgoel@linux.ibm.com>

Looks good Disha, feel free to add:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

One small comment:
> ---
>  common/defrag | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/common/defrag b/common/defrag
> index 055d0d0e..28db2f7a 100644
> --- a/common/defrag
> +++ b/common/defrag
> @@ -6,6 +6,10 @@
>  
>  _require_defrag()
>  {
> +    # Defragmentation is not supported on DAX-enabled filesystems

I think this comment is not needed as _notrun explains it already

> +    if echo "$MOUNT_OPTIONS" | grep -qw "dax"; then
> +        _notrun "Defragmentation not supported on DAX-enabled filesystem"
> +    fi
>      case "$FSTYP" in
>      xfs)
>          # xfs_fsr does preallocates, require "falloc"
> -- 
> 2.45.1
> 
