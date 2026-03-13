Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E1D3659E0
	for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2026 07:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773386252; cv=none; b=Rf+J/drI/GcYtMfiIWIPjcN13uzUXg//GTCYCPXMeaIi4ZWNIDY8t0kUHYYyVIfKS/gsk3mizgwuuHidCYgHZg7vsgWc7sqSATH3938UwFHFMg8GvsdZt7Ob9UnzyN7CEOR7dc2CfI9CO+7CbzsbIZ6BD+y07qf8K65MCgwCZHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773386252; c=relaxed/simple;
	bh=SICePwOrNXW/zF5cipFNwpr9DLK8wYUvr2392hZ2v2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tcs/k9Xx6Ew48pgtujdGrsLRglck1ZyiWTRxVrwGKucFFmuMe4rwLT93hUBQD73E0X9GI8G05q9s83eHheN3EUPtDKIElslrp2cqeFrV5DXPmbaekBR9e+J6pb3Q7qIUDbzq35uJiwKErvhNNt36/rRHbnllZY9wbfziujVSqjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jlsHyLTD; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jlsHyLTD"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62D61uDW2302634;
	Fri, 13 Mar 2026 07:17:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=QnxAYzCwGsbjgDfLO93l0eUkCYgKkv
	apFoOkjw67+r8=; b=jlsHyLTD/1cZu9PbZzjqDGwBIgtmNQyaYixAafef1aHkyu
	axORHcLqW8Ygi8I1ttZLGyUeIBKqwB4o6RDk23FKFwS4M+Vzn6ZzJoX0lHJHuKau
	UKQtrmvmKeD7pppn1EgfPmOZ8XjVrAfhZpzBuIfsMBV1LQD5jjtFvudCdJNLm8UJ
	0GktM0oJ1rpTmkWwpTZvGoWcFngkY4w39DjuaqWYIjMRNRRe4n19lZQ4pGk1mI9/
	KShXvIIvQE5BiMWLgWnlWdBAwAkvpMMUluODtm3k0lFthRMRuhBrfGHcQ/rGWsZ2
	1dexB+UP2zu4d4RdptYryLnYq+KP3I59AqeCrc2A==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh95xb4d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Mar 2026 07:17:02 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62D5WaEU020771;
	Fri, 13 Mar 2026 07:17:01 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cuha9nnbn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Mar 2026 07:17:01 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62D7GxIh43450854
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Mar 2026 07:16:59 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7FD7C2004B;
	Fri, 13 Mar 2026 07:16:59 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2842F20040;
	Fri, 13 Mar 2026 07:16:58 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.23.11])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 13 Mar 2026 07:16:57 +0000 (GMT)
Date: Fri, 13 Mar 2026 12:46:55 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Ye Bin <yebin@huaweicloud.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        jack@suse.cz
Subject: Re: [PATCH -next 0/8] Fix some issues about ext4-test
Message-ID: <abO55xo3MDyJ-NEi@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260310130412.3156753-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310130412.3156753-1-yebin@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEzMDA1NSBTYWx0ZWRfXzPUsSjUaMM/e
 GT5pktCLDH6WIxL5LK3DNnKJ0KXPZTPJG0/2B6gE1dIwMQg6cwfD9f6g0hm6swaWMGgOTYISsUq
 egooB1nmbEd/fDt660DilNWOR3sshOY1wzuPuiPIFFLWykuZ8Rix+6LNlqI6m1s6VUBrhg9xZxO
 mOD8YFwpzYKiz2wzJP9C+PiszvLls2v4KQI7g0KwY5trNez9Mik519zN5WDCsDjSSDOKNraK9Rx
 jAc9qbhgAhvt5f5JQXYEF1pwXjurIgP8hA8ihwQ4y57+1C9zTpioNkmWTffQAoZsDPLG8t7lXNS
 JhHNDeu93Vr3ws+nvHPsRalRNkcLZvu3TmwA2kxedyfdvyNwZiOpY0oLPksgOvrDbTCEzm9eKBL
 0knH+vUThlo7eCzOVeitNTF6unxyq4ZgUrQYUJg/3JJCbZXgYZB0IFCX/KoEJM/kmPeWshgdN+4
 pChUs2itPtyZ8wYl12g==
X-Authority-Analysis: v=2.4 cv=FowIPmrq c=1 sm=1 tr=0 ts=69b3b9ee cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=qNABUOcEAAAA:8 a=pGLkceISAAAA:8 a=i0EeH86SAAAA:8 a=ZeLe3bWMkn-tXEy979YA:9
 a=CjuIK1q_8ugA:10 a=Ytm653ucTKQjCvbzLygB:22
X-Proofpoint-GUID: P16_s3XRiwmY7hV7F9xYjfKuWEE5iZ_6
X-Proofpoint-ORIG-GUID: P16_s3XRiwmY7hV7F9xYjfKuWEE5iZ_6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-13_01,2026-03-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 suspectscore=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603130055

On Tue, Mar 10, 2026 at 09:04:04PM +0800, Ye Bin wrote:
> From: Ye Bin <yebin10@huawei.com>
> 
> Patch [1]-[2]:
> Decoupled mballoc-test and extents-test from ext4. Patch [1] does not
> have any changes compared to the previously released version, so the
> reviewed-by is added.
> Patch [3-7]:
> Bugfix for extents-test.c.
> Patch [8]:
> Bugfix for mballoc-test.c.
> 
> Ye Bin (8):
>   ext4: fix mballoc-test.c is not compiled when EXT4_KUNIT_TESTS=M
>   ext4: introduce EXPORT_SYMBOL_FOR_EXT4_TEST() helper
>   ext4: fix extents-test.c is not compiled when EXT4_KUNIT_TESTS=M
>   ext4: fix miss unlock 'sb->s_umount' in extents_kunit_init()
>   ext4: fix miss free super_block in extents_kunit_exit()
>   ext4: fix the error handling process in extents_kunit_init).
>   ext4: fix possible null-ptr-deref in extents_kunit_exit()
>   ext4: fix possible null-ptr-deref in mbt_kunit_exit()
> 
>  fs/ext4/Makefile       |   5 +-
>  fs/ext4/ext4.h         |   5 ++
>  fs/ext4/ext4_extents.h |  12 +++++
>  fs/ext4/extents-test.c |  59 ++++++++++++++++--------
>  fs/ext4/extents.c      |  38 ++++++++++++---
>  fs/ext4/mballoc-test.c |  87 ++++++++++++++++++-----------------
>  fs/ext4/mballoc.c      | 102 +++++++++++++++++++++++++++++++++++++++--
>  fs/ext4/mballoc.h      |  30 ++++++++++++
>  8 files changed, 268 insertions(+), 70 deletions(-)

Hi Ye,

Thanks for the fixes, seems like I completely forgot cleaning up
resources in extents-test.c so thanks for taking that up. Sadly, my UML
kunit runs didn't catch any of this :/

Although the series look good to me, I have a request, can you please
resend the fixes in patch 4 - 7 separate from patch 1 2 3.  We need
these fixes (specifically patch 4 and 5) to fix the breakage in
linux-next [1], keeping them separate can help Ted just pickup the
urgent fixes independent of patch 1,2,3.

Also, for patch 5, it fixes an issue that Ritesh fixed in his patche
[2]. I think your patch is a better approach since all cleanup is
handled via deactivate_super(). However, his commit message better
describes the issue. While resending, can you include his commit message
as well. (I've checked with him so feel free to reuse it).

Thanks again,
Ojaswin

[1] https://lore.kernel.org/all/0d21783c-5299-4488-9708-def0b1a4dcbe@sirena.org.uk/
[2] https://lore.kernel.org/linux-ext4/5bb9041471dab8ce870c191c19cbe4df57473be8.1772381213.git.ritesh.list@gmail.com/

> 
> -- 
> 2.34.1
> 
