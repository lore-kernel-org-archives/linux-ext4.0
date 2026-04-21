Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD53367F39;
	Tue, 21 Apr 2026 06:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776751969; cv=none; b=jg+1yOw+rDRkeObBny57y/0Ems4Jybo3F0IIHYT0OTlffIWxoGR3Wi1nzRGAELxZxlpgDrIh6zcgFnMLr679xa9fio4OIURiQxSzzfYY9v0cN4w7oQvF3ybCfNfEEhsE+sl7Vt6NttaksDbFehpW++idL1ub6r6v08oR+59TJ7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776751969; c=relaxed/simple;
	bh=dXGR4v+2o/YKrFf+jF/qqIixZQXValpfQkWm1UuYbDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eQsYrzJeZS/Sd/Gfh/hBHQQCWq21euZ68MZeqBjET22Zy4RDXzdaNzBbI0g91kwtcXiu2Q7fudMoRsTagZLGkAk+4wpjfNlUkHN1t6kqy8JwDewzPElXOUC0qH3htyoIMFCRPr9NtTRl1uy6m612KbcUB+sE0HcwAxkj2nC1rrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KrBiGxA7; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KrBiGxA7"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63KJgZtQ1650656;
	Tue, 21 Apr 2026 06:12:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=y0fNHb
	9NBCvx5ZoAR1OqaJNPiksiOGSiAcg7mibchxI=; b=KrBiGxA7x8YlBZmxWL/Gwc
	c7u9N86sFpuHbnuvqe5NnzxpMXGZ9iQvoDUu9rQ48ywvBgx62Z6gGKINmSoRmCMp
	AcRgmAVFWDSqpYPTcQX0kywT6WybELMly9BLgQybUuKOlwCXTSosgTOBSZ7M2hQl
	1XnrU7lEyXUiXfCMceQyMjanaEzZ3WuUuE7ZW9FlQUetqNK9YiEoH/FNgzLHI8JP
	AP+y7sYALO0JfvDT/3WROmS9tWyL5vqzIbhnHdKqfNuelS6+mteKqmxfYHiuF/xg
	QGXREvDA1Y6VfV45zzKNBL+Y9ZzAKvyTX/S5dG2xPVuxxo+itCAFqpvUnfLzfqdw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dm2k52wvg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Apr 2026 06:12:32 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63L65gvm009430;
	Tue, 21 Apr 2026 06:12:31 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dmmnvqq6y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Apr 2026 06:12:31 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63L6CTvt53019110
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 06:12:29 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9ED0F2004E;
	Tue, 21 Apr 2026 06:12:29 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9F43720040;
	Tue, 21 Apr 2026 06:12:27 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.123.13.2])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 21 Apr 2026 06:12:27 +0000 (GMT)
Date: Tue, 21 Apr 2026 11:42:25 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: liubaolin <liubaolin12138@163.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Andreas Dilger <adilger@dilger.ca>, tytso@mit.edu, wangguanyu@vivo.com,
        yi.zhang@huaweicloud.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Baolin Liu <liubaolin@kylinos.cn>
Subject: Re: [PATCH v2 v2 2/2] ext4: allow clearing mballoc stats through
 mb_stats
Message-ID: <aecVCWGL3bUFFiBd@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260419063436.17999-1-liubaolin12138@163.com>
 <20260419063436.17999-3-liubaolin12138@163.com>
 <aeXt_qg1SprB9Gu_@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <4A904858-8611-42BC-B1BD-9679F284F8EE@dilger.ca>
 <7bq1t1zg.ritesh.list@gmail.com>
 <9a2d25d3-219f-481c-afb8-083c8b9417c1@163.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9a2d25d3-219f-481c-afb8-083c8b9417c1@163.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: PoH4z0V9dq326EsreHHf9t30iLQNYj59
X-Proofpoint-ORIG-GUID: OJRbTE29wtwBgHZCvAH4eroJsYLA68LB
X-Authority-Analysis: v=2.4 cv=VP7tWdPX c=1 sm=1 tr=0 ts=69e71551 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=RPJ6JBhKAAAA:8
 a=VnNF1IyMAAAA:8 a=hMtx4rf_crx3AzEWpUQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=fa_un-3J20JGBB2Tu-mn:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDA1NCBTYWx0ZWRfX0hFRx9WjBEqt
 O58D4UhNgi6RxMD9LCr7b+ajzH1YXmHQQLH1+uzhUncWcN+kqj69ncZMPWQdYAgSoe7zuv99Ejk
 N11LwVdMghm7gZw+VZ6j0G8cNutD2hpTfCa5vSWA6jkCq/TY/7jmw3TKdzG6TEOn8m1t9hVZBAq
 S9AWN7PbEyciz3+QCGkBQ2TgYICzou4jbImArxE5YHRuRJTz2269fETzFbEs47BfiJ1LtVx/t7E
 RIRVHh665dPnu1Q/n7P/C2A5gHX7aUBmyxDOF3WRw4noYbKqCRjbYtj5O3p1nflqV20uz58plWP
 R8R/24KKfwf+bDGZdgLYTLNiBzpNXQo7XuJtgcH2usmYem+aNgh9x3VNgNQWqcsogqeb2nYEKdO
 QMDBIMunorst6ZFQEe0f8/7dAYrk5EexbAPZNX9rmhnaXMQw3EE6cm2w3Ah1XNCGPHuFsC6hbGB
 hkp1Zgjn6f/vE+DP4WQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_01,2026-04-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604210054

On Tue, Apr 21, 2026 at 01:22:31PM +0800, liubaolin wrote:
> Dear all,
>    I noticed the discussion about where to document the ext4 proc parameter
> mb_stats.
>    I ran:
>      git grep -n "/proc/fs/ext4" Documentation/
>    and found that ext4 proc parameters are currently documented in both
>    Documentation/admin-guide/ext4.rst and
> Documentation/filesystems/proc.rst.
> 
>    To be consistent with the existing documentation, I am thinking about
> documenting mb_stats in both places.
>    If there are no objections, I will send a v3 shortly.
>    Compared with v2,the v3 patch will add the mb_stats documentation to both
> ext4.rst and proc.rst.

Yes this makes sense to me. Feel free to retain the Reviewed-by since this is
just a documentation change.

Thanks,
Ojaswin

> 
>    Regards,
>    Baolin
> 
> 
> 
> 在 2026/4/21 11:40, Ritesh Harjani (IBM) 写道:
> > Andreas Dilger <adilger@dilger.ca> writes:
> > 
> > > On Apr 20, 2026, at 03:12, Ojaswin Mujoo <ojaswin@linux.ibm.com> wrote:
> > > > 
> > > > On Sun, Apr 19, 2026 at 02:34:36PM +0800, Baolin Liu wrote:
> > > > > From: Baolin Liu <liubaolin@kylinos.cn>
> > > > > 
> > > > > Make /proc/fs/ext4/<dev>/mb_stats writable and clear the runtime
> > > > > mballoc statistics when 0 is written.
> > > > > 
> > > > > Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
> > > > > ---
> > > > Hi Baolin, thanks for the changes.
> > > > 
> > > > Seems like userspace doesn't have any way to know that writing 0 will
> > > > clear the that. Well, I guess if you are looking at this file you are
> > > > anyways debugging kernel code so that should be fine
> > > 
> > > That could be documented in Documentation/filesystems/ext4/allocators.rst,
> > > or better would be to add a new file that covers mballoc in more detail.
> > > 
> > 
> > I started looking for ext4's control knobs for sys-admins in kernel
> > Documentation where we should ideally document this, and I see those
> > are declared here..
> > 
> > Documentation/admin-guide/ext4.rst
> > Documentation/ABI/testing/sysfs-fs-ext4.rst
> > 
> > Looking at this and the relevant code, I see all /proc/ entries in ext4
> > are all readable and sysfs entries for ext4 are mostly the control knobs
> > which are declared in above admin guide.
> > 
> > But now this patch adds a control knob to /proc/fs/ext4/<dev>/mb_stats,
> > to clear the stats :).
> > 
> > I guess we could have simply documented a new control knob value (e.g.
> > "2") for clearing the stats via /sys/fs/ext4/<dev>/mb_stats itself or
> > maybe even having mb_stats_clear file in sysfs wasn't bad either... But
> > either ways, clearing the stats via the same procfs mb_stats file is not
> > totally bad and I don't have a strong preference.
> > 
> > 
> > For documenting this, we can add mb_stats entry under /proc section in
> > Documentation/admin-guide/ext4.rst and document this change. Something
> > like -
> > 
> >    mb_stats
> >          reports runtime statistics from multiblock allocator (mballoc),
> >          including allocation request counts, groups scanned,
> >          per-criteria scan hits (cr_p2_aligned, cr_goal_fast,
> >          cr_best_avail, cr_goal_slow, cr_any_free), groups / extents
> >          scanned, goal hits, buddy bitmap generations, and preallocation
> >          usage etc.
> >          Writing 0 to this procfs file resets all counters to zero.
> > 
> > 
> > -ritesh
> 
