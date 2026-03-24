Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F20332EC8;
	Tue, 24 Mar 2026 07:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774338753; cv=none; b=XjM+Z8Pz8cj/miDlGJUd4mLl9ykXguR21SJT4AD7/li3ZXwhirjQ3jN8q/L8CM5+bug+1GkpV0pGGe3XF+noOaxxSsmWxb8RjRkcS8Ywu0dVsf1g8YivccHoie+rRM6adad5YvyXjJ9Jb3fD/THGORysljtUIMfMj9pZNyoKWGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774338753; c=relaxed/simple;
	bh=GK2IYXY4fWED+zdWnR9Z0qZk6u43ugpNDiwX6DRQ9k0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EN99QACJPNY30DXAgVcYVSJug2eVsWlu6YJqDvN3rO7GLh3nRWwMhniPXGAuufMTwR6iIoyXwxQl+lov59iusun4ZF5hu+62Lvl53ZPNyishP5bHYQedx3AS/VJKySIjtBkoNVKMv+oHW5qgj/NeBWPvfRSwJ4zytMlr6XGpRoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qSs3X2uu; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qSs3X2uu"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62O31UXY3644267;
	Tue, 24 Mar 2026 07:52:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=HlT36rphlz9gK4CWzL5Cac89x7zgq/
	ZvBcLuzcsZ9QU=; b=qSs3X2uuRbkKbPOQLMXZC19izEPaFxjSVZ4JeUAAawF80k
	o5LcyDxKrmg+zci+xdy93PNKsbzIU48mS6rrfsmcQIOtXf8O1qk32cIyC2bzPjEU
	2/LzO9xG6ppp0/HMtoMpHfjxyu5urJpelmzDEDB4oitWhh5hHyMKEAyhppNUT8FL
	/Y+li98OG8DBcfnir2VnVJ3fuBBKGtWt/51pQ6AkG6dEP6CNs8TbM2+S8xfvtvew
	k1hGHHkEUPW6z5YDC6nNhdECBt0PNZ01F9OmVzcXILpdmr0QQ1SqJXEuZmiowosH
	qBV1tZDldCJt/wqQltH2haZ9iZxPrNIOUqsoKodA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1ky01tv8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Mar 2026 07:52:06 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62O3HIPf008722;
	Tue, 24 Mar 2026 07:52:06 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d26nngrt3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Mar 2026 07:52:05 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62O7q4kv29295094
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Mar 2026 07:52:04 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EABD920040;
	Tue, 24 Mar 2026 07:52:03 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D037A2004B;
	Tue, 24 Mar 2026 07:52:01 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.26.38])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 24 Mar 2026 07:52:01 +0000 (GMT)
Date: Tue, 24 Mar 2026 13:21:59 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: hongao <hongao@uniontech.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, yi.zhang@huawei.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+1ffa5d865557e51cb604@syzkaller.appspotmail.com
Subject: Re: [PATCH] ext4: skip split extent recovery on corruption
Message-ID: <acJCn4F6TTaegl4U@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <FA074540F4E30F27+20260323015752.60064-1-hongao@uniontech.com>
 <E4BAF530323E79C3+20260324014025.31601-1-hongao@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E4BAF530323E79C3+20260324014025.31601-1-hongao@uniontech.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI0MDA2MiBTYWx0ZWRfXyqux1ox4BKa9
 2KwFNv7OY56KvIyR0Mw8Kbx7n2VZErcgv01aBKWw3pI4M+AcwfwTCVg9VOJuwEPMYZ7ULZ9VLx7
 c4l4Tz7PByjCVPYOssdjGauCuDTrn6Oci5Km6zd7AgxZRo8zp2gWJMclzEZ7+ViMNMyqaJo+kP9
 31CipUvirLWL5pOOdfmLh2IyPjsbL/wW153CDNrtUaLRw184o6SCgIMyFcEBCEDkTbC1bgu21A4
 xrI2BNkH17fFYZiowhBBvR0csQMGqF55UrMByzinsVBDi1cSM67FwNGbTc1icdWETb7OtM4OxNs
 h5kzpKxeRbD7o0Y+8KAj56lwz3Ek7jBjnAioDHzxxxKRmp8fyQmcU5pf8k9VHCUzD/85fCmQAdE
 UteUHPygpXMRjj+kS0jrnNPUCWbAJR7DLcX9j3bHoaWi4kwEq35vxWV5bg7ko+1z2GK03gzsDNw
 oXapcThlWIJ88RDsumg==
X-Authority-Analysis: v=2.4 cv=JK42csKb c=1 sm=1 tr=0 ts=69c242a6 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=i0EeH86SAAAA:8
 a=VnNF1IyMAAAA:8 a=qiODnJNJ2US13fybofsA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: gInWFBDZqrD-kFbgguwmXIPulAvPsTJl
X-Proofpoint-GUID: gInWFBDZqrD-kFbgguwmXIPulAvPsTJl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-24_02,2026-03-23_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 adultscore=0
 spamscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603240062

On Tue, Mar 24, 2026 at 09:40:25AM +0800, hongao wrote:
> Hi Jan, Yi, Ojaswin,
> 
> Thank you for reviewing the patch.
> 
> I will send a v2 that moves the p_ext validation before
> ext4_ext_get_access(), as Yi suggested.
> 
> Also, thanks for the Reviewed-by tags:
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
> 
> Regarding Ojaswin's questions:
> 
> I do not have a local reproducer at the moment. My analysis was based on
> the syzbot report, the crash trace, and code inspection.
> 
> For the p_ext == NULL case, a successful ext4_find_extent() only means
> that we were able to walk the tree down to a leaf. It does not guarantee
> that the leaf still contains a valid extent entry for the target logical
> block.
> 
> path[depth].p_ext is derived from the extent entries stored in that leaf.
> If the leaf metadata is already corrupted, ext4_find_extent() may still
> return a non-error path, but p_ext can be NULL because there is no usable
> extent entry there anymore.
> 
> So in the corruption case, a valid path is not enough to continue the
> recovery path safely. Returning -EFSCORRUPTED is safer than
> dereferencing p_ext and crashing while trying to repair already-broken
> metadata.

Hmm so I looked a bit more and this path can lead to an empty extent:

ext4_ext_insert_extent():
  ...
	// Creates an empty leaf with p_ext == 0
	path = ext4_ext_create_new_leaf(handle, inode, mb_flags, gb_flags,
					path, newext);

  // Errors out
	err = ext4_ext_get_access(handle, inode, path + depth);
	if (err)
		goto errout;

Checking ext4_ext_get_access()

Seems like it can return EROFS when journal is aborted or EIO if journal
detected some IO errors on backing device. I guess we have already
handled these by exiting early in your patch, but sure having an extra
check wont hurt. 

Feel free to add:
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
Ojaswin

> 
> Thanks,
> Hongao
