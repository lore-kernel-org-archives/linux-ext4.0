Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D4A248881;
	Tue, 15 Sep 2026 07:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789457723; cv=none; b=okD9G9XHGDgJXau8PVbpObR2yE5HbWg5rZ0KFjuO0hF3XERFtswR50/h2jy1kwOHPD7DkMUyRhx4nZ9pCaSAeY2gE5W6B/M4rxYR6ttiGyhcQNPVdqSOuArdBI7wtikXf38/5h580z2jGfVlSByDYDB6cah56SuRaUjEAO/1AgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789457723; c=relaxed/simple;
	bh=HKRtLYYt8Toe4P03Ofg4HMYivWkaKC32Te+XVYJYQYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fNbq4R9448911LH4uaJSS6OOxheQu/oqtEoGpyrMa0sChNDmguLt3/W5/914TwCsmtVI4VBw5pVRWkpB0Fanmm6Xbrrd0qUSL18U4AlO4aiKaJ5yOtD/ZJHk6W7zIO/csOpZVYDZbmE3sxIY2HsDdtTgcz+QIEu3iJgDjSu+Jrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MSN6bD0T; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MSN6bD0T"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68F71qss4192863;
	Tue, 15 Sep 2026 07:34:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=PWgvjmXGp2Zm7s53A3DZQaedkDL7MS
	jIBZBtGkdgJOg=; b=MSN6bD0TeHYr9Zb80Zs23fo7S3EgpRzjhgVS87iWaT5PLC
	FrOGZ1NV+gldILCi2r6kaJxXG0m5iFZQQLnSHs2v0pz/+cQRJ2e7ps4wYSFwCgUa
	6XyV10niZBy/7QnMxs7cp0HBH7AuUu41/3lt7v3m/Ug0syEUf9bMkcdgrurtH+2A
	mYBIcYTsBwP0e1wtNMX0sNT/lh1gMWYfX6JlJw2V+vROa8Z0sWVT9DlukWOeWVjv
	BlNiqZ0pgpA/0uI0pN0vL1WvBexE6Ags5mqZ+fJmtHjz0Be6i0P3jc43T2Vo8Vz8
	WNbUVvle6lrrjGD78rMnlae6VEqYyX8n39x9tIsw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmv5hnwtr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 07:34:57 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68F6ZIek3523888;
	Tue, 15 Sep 2026 07:34:57 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gpyxs8c0c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 07:34:57 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68F7YtWq44761590
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Sep 2026 07:34:55 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F03EF2004B;
	Tue, 15 Sep 2026 07:34:54 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8C0FA20043;
	Tue, 15 Sep 2026 07:34:50 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.20.92])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 15 Sep 2026 07:34:50 +0000 (GMT)
Date: Tue, 15 Sep 2026 13:04:47 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>, Christoph Hellwig <hch@lst.de>,
        John Garry <john.g.garry@oracle.com>, linux-block@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] ext4: never fall back to buffered I/O for atomic
 direct writes
Message-ID: <aqj1F2drbqLEVmSm@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260909-ext4-atomic-no-fallback-v1-1-5a6b9539c002@columbia.edu>
 <vgxva24firqq6eqt2wyovm6uqh356nvrsb35exzxtnxftspy3w@gb7uiv4gwets>
 <03907742-fc59-4d31-b12d-760a67e163a6@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03907742-fc59-4d31-b12d-760a67e163a6@columbia.edu>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDEwNyBTYWx0ZWRfX0G1yeIMmher3
 jvPnybfjQOmrDpsyuEquUHn5fjGkozsuJfHbisP2wBF7mgFvm17R+cGsQ9fmA1GNjaBf1tMdct6
 J8WZLxZULR/aQAolvZ61B/8DSkoXxph4WeuAXJ4zjMowGvn9pm+u5sbma6r4sXB4RR6r3Pn21SX
 ce7CwPdqZhh9f8zTolEUFdpnJHZ53+IpzAU4TrW8h9H3yMo+B5KlgSOPKid6X52UbFle9PzavVF
 7DHDvHwyZBsHwtIk4U/ESi/SE7ERrl+HeKQTqehietp8HX1ajGSBaFhtygiF7jQUFnJhhY27aCl
 fVKFbfxUy28A6DLH4f68NSoLbYKpv95ovmAiGPOg97vRYKM35YsKEDodpdVhe/qGtOnfJeI1U/2
 1u/E3RhTdPltXj3kJiIPxCnn4HgTbIg7nOIGsMsskuz4+ZrGfSLB1ZElOry13VSpnXe8gHuuog3
 w+Y1F9mKVxI1okzv4vQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDEwNyBTYWx0ZWRfX1HkQq7qg7Thi
 ErKfONHwuiTQ14oorDmqplJi4r0V+6f6T6ZzuyRC/5GQBAOZzsaQ2yjj6G61GCzOOkUiRlWAuuJ
 Hwmb7fhw4kvVCp2G/Yc17OBVyKaQVqY=
X-Authority-Analysis: v=2.4 cv=Zsx4uN7G c=1 sm=1 tr=0 ts=6aa8f522 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=c92rfblmAAAA:8
 a=5l271pzm8Fzoa8UtYScA:9 a=CjuIK1q_8ugA:10 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-ORIG-GUID: NB7Z35pS9rB9-1mJTKFnv-8zwlU-8umW
X-Proofpoint-GUID: VPZJfKRNAEsVdKqDOfb8IRICzyjqB3j_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_02,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 clxscore=1011 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 adultscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150107

On Sun, Sep 13, 2026 at 07:18:37PM -0400, Tal Zussman wrote:
> On 9/10/26 6:58 AM, Jan Kara wrote:
> > I agree your patch makes things better but I have a question: are short
> > writes (even 0) allowed for atomic writes? I don't think so as far as my
> > understanding of atomic writes goes (and based on what I could find in the
> > code). But after your change we'd just return short write (including ret ==
> > 0) now which doesn't look ideal and also doesn't match your "so any future
> > bug yields an error rather than a torn write with a WARN()" description. So
> > as a futureproofing I'd maybe suggest just:
> > 
> > 	if (WARN_ON_ONCE(iocb->ki_flags & IOCB_ATOMIC && ret >= 0 &&
> > 			 iov_iter_count(from)))
> > 		ret = -EIO; /* or maybe -ENOPROTOOPT??? */
> > 
> > before the fallback to buffered IO as a more robust solution.
> > 
> 
> Short writes shouldn't be allowed, so this is definitely better in terms of
> future-proofing. I'll do this with EIO but with the if (WARN_ON_ONCE())
> inside the existing ret and iov_iter_count() check to avoid duplicating the
> checks.

Hi Tal, Jan,

AFAICR the WARN_ON was mostly precautionary as we ensure in the dio path
that a during submission we ensure a write will not tear else we return
an error. Sure we can go with Jan's suggestion but  I think either ways,
if we hit that WARN_ON at that point we have already torn the write so
it is actually a BUG in the sense that we have not honored the
RWF_ATOMIC contract, but hopefully that will not happen.

> 
> It looks like Sashiko also found a pre-existing issue where an atomic request
> can be done non-atomically [1]. I'll see if I can reproduce it and add a fix
> as a second patch in v2.

Looking at Sashiko's comment, it does seem like a valid issue. A simple
test would be to create an inode with inline data after mounting with -o
inline_data which should force ext4_should_use_dio() to return false.

Return,
ojaswin

> 
> Thanks,
> Tal


> 
> [1] https://sashiko.dev/#/patchset/20260909-ext4-atomic-no-fallback-v1-1-5a6b9539c002%40columbia.edu?part=1
> 
> 
