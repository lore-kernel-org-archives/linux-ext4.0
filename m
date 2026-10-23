Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792726840;
	b=V44MR2TPuLH5EFJESNgihmhprujMwnmq+JB6JQrRpFwEUSKwY9QszfptzGk+yTPWZbQD
	 cp9ArvxUDwNCsA9V3Ny9rNAR+3p9Pz99EtWfhlKfxlQLV6kNfxTCZVTOUyvbEfIJ2aheb
	 iZA9EHj5vAbTHdEp13B90eArVUdyRfVXE/9aUA1jBwEyYCtfMYcPfVgIzcS3nkdSUkRsr
	 wm4lCawHulKiaon47eX0f2PPCXnfSFLRq+NOESk+8uo57+51WYFGO3iA64dufITpNbz6T
	 CNMP6sc1/JEX1tZEqRAx7sTx6jdJqOuhH16k9Ve983b8507Wq3L6tvA2ww5XrcO4CxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792726840;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-TM-AS-GCONF:X-Proofpoint-Reinject:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=m3ikE1jC4iTxYTtmRyndWhyT9nMef7Uxze1zR2s0b+Y=;
	b=qXc6wLocF8RcL5t7Jk7CZTh6pJGCLq2iUkwsRzm1glanqfuXitan4xEzuw+Dxbme0Wj8
	 DpbK0QYHx/vwBonsZdmLWKbAA7AJY58ts5Ievp61G+hIU1VU32GRCuXKl7+t/r9kKrha2
	 3IxxfdeCRl5VjiZi1iLphzNfzjzBmScxqqQCZfmGPpPhvnQdGHb4C3kt9de0RURbw6UHq
	 YA+T1aR+x3znjf/z2DviMSTbA9c4a0J/ImEsUyxBZT6Pcwx9Vs/cBd8gRpNi6t7lMicXB
	 Mhy5FUfZbNgIAvwj3V6wZHhcZdGK6wFLU+B7LOdnletqjHkPaua3HfeYQFy0adIqDdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=k4Jm6+6i;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75F9606A319
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 03:40:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D75F9606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=k4Jm6+6i
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N1EHtI4011289;
	Fri, 23 Oct 2026 03:40:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=m3ikE1jC4iTxYTtmRyndWhyT9nMef7
	Uxze1zR2s0b+Y=; b=k4Jm6+6iAq8Al6v9btiX4plp//IruMYcxIlK/PRu5nFefg
	q2cDR8OsGfNy5/F3jMTFxsUBx3RLmFg63h401VwOieYB9XmPW5EdqT5OGRUHeW8M
	wvS5pnmlcWhBs+zzpafu+43eO/YxPpt+8N3vlnI5vmPDpRkLGVaLwOPHHCZa8YvU
	gV/dpIUOeduUJVYuuCc28xGw8GP9qlrR9eCy2wY2ODFCQAbgwDUiQqqEY/ad33LH
	W704PZ7ICRKFauxOkE/bvmq1LCH+X2G3EPQpCDJV1lAMFHXXV4z2S8sw15Ddqsda
	63rLDZQi64Et8cUuhsh0vYMYXAUnEq4c5PHTOsDQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hdw5bu4tm-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 03:40:17 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69N1Juko1368058;
	Fri, 23 Oct 2026 03:40:16 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hfj1x3ewu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 03:40:16 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69N3eFcj38469976
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Oct 2026 03:40:15 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0B15120043;
	Fri, 23 Oct 2026 03:40:15 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C051520040;
	Fri, 23 Oct 2026 03:40:12 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.17.104])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 23 Oct 2026 03:40:12 +0000 (GMT)
Date: Fri, 23 Oct 2026 09:13:17 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Theodore Tso <tytso@mit.edu>, Julian Sun <sunjunchao@bytedance.com>,
        linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        riteshh@linux.ibm.com
Subject: Re: [PATCH 0/6] ext4: fix buffered writeback error handling
Message-ID: <atrX1Y5GiTnYv3tQ@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20261022145241.2950379-1-sunjunchao@bytedance.com>
 <atoySP5ez1SwWh0X@mit.edu>
 <afcf8af1-2f77-4408-b11f-538ca692bf90@huaweicloud.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afcf8af1-2f77-4408-b11f-538ca692bf90@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: tTK20dSV7HLTt5ZzkOnaHqInVJQhrgJb
X-Proofpoint-ORIG-GUID: mKWIA6NcB53dstAue7PH9XzLVw2214Me
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAxMiBTYWx0ZWRfXwYeG5PBFrSZf
 +81LErLMT8PJd5L5hBasIn9hSLfCM64roE9Fjf4B1wCHzBZqeCsiDlu8KjrPq5zOzEnof29c6gP
 zKmvkDw6NkpHDqEYewxTvp0lvPnauPQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAxMiBTYWx0ZWRfX458rNL83I3Gs
 QfKPjVCqjQb2azVUKLAMvDWOg9ufKHCQxXatgSFmAzVgNZ89CBnAYl5/uSl78/RGJDf9zvFGRGp
 OytkRXD4msvtDcYlHP3Q5EtN/beswJD3sf5g1cMw+D3YYfaQsXPbR2jGfLJ4zVRtXKjRdcUml9U
 9JFsIvR6NoEcKBSV49ZynnjMg09Pbmgh0rKAgEBkYggFb0d3CqXT1fvSQxSU0W4kWCou1PPYe/q
 bnrL8dMtj/I8tAVq5mFHPjW7fPt5KAUGAf6F7ElzTrYje3ZVY5E3tukf1TS4IFD5069RQUusH9I
 8ljigQmCiCw6ecpVorkAjFAbQyfMIX856cVkZBmUcw4cqjflkyUsWLj2FsCZmbWvEXvTnRcfaqV
 Ko1puJ9AIqeKYSC7DkBldX0h6LlvWs0hQP5BKjNGl1/PqQpNmD2P8KpP3qjKd8QTVyrJkyG02tp
 KK4og4bWQg0j/Tqg0jg==
X-Authority-Analysis: v=2.4 cv=Gb2CDgXL c=1 sm=1 tr=0 ts=6adad722 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=K9rkECeryf17TUk1rBAA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 malwarescore=0 spamscore=0 phishscore=0
 clxscore=1011 bulkscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610230012

On Fri, Oct 23, 2026 at 10:36:48AM +0800, Zhang Yi wrote:
> On 10/23/2026 12:05 AM, Theodore Tso wrote:
> > On Thu, Oct 22, 2026 at 10:52:35PM -0500, Julian Sun wrote:
> >> This series fixes error handling in ext4 buffered writeback. It prevents
> >> stale data exposure when mapping or io_end_vec allocation fails, reports
> >> unwritten conversion errors to fsync(), and preserves concurrent io_end
> >> flag updates.
> > 
> > Hi Julian,
> > 
> > Thanks for this series.  However, we have just landed a significant
> > change to the ext4 writeback to add support for fs/iomap's buffered
> > I/O.  It is currently not enabled by default, since there are a number
> > of features and mount options that aren't yet supported by the
> > buffered_iomap codepath.  (Thanks to Zhang Yi at Huawei for his work!)
> 
> I'm glad to hear that the buffered_iomap codepath is going to be
> upstreamed. I'd also like to thank Jan and Ojaswin for their careful
> review and valuable suggestions, as well as everyone who has
> contributed to this conversion in areas such as iomap and mm.

Hi Yi, thanks for your consistent effort over multiple years! Glad to
see it finally merged :)

Regards,
ojaswin
> 
> I will continue to put in effort going forward, and I hope to make
> buffered_iomap the default path soon.
> 
> Cheers,
> Yi.
> 
> > 
> > I'd really appreciate it if you could rebase your patches on top of
> > the dev branch for the ext4 git tree (I've sent a pull request to
> > Linus so this should be in v7.4-rc1), and determine whether any of
> > these concerns are also applicable for the buffered_iomap codepath.
> > 
> > Many thanks,
> > 
> > 						- Ted
> > 
> 
