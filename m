Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70B83624C5;
	Wed, 15 Apr 2026 19:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776281235; cv=none; b=mNozs/qb7GUDoUJbCfdrPrIwcWQt5QoalVWYf9DVkVKm6ooQrf27VQas+SHl7sSgiEbT6oyllC4FY4I/Oy8na4/TTU31WeIC9RYpJOxBxnri5RoQlThcjXuvtyoWpr0NnGaUnZFrFnCSnHsdlmXjqzMpySF5zi+WDIIBuNEBqIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776281235; c=relaxed/simple;
	bh=Z3Qm2qGbMju+0Js4ijjp8rqnx80EzyxC7cBFc2dicfE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tZx1MuH2mGb2UzNzQNfbo8H+fJArY0xobxfFw7Ki8y7SDBXivg7RdAWqz3l07TWkgSvd9Bzk33GS8J6BX7PHOM/m7lC//LE/Ky4qFFiyqZsthJrwJQ224BG8rEZYRTl34A2C3pHTFy2tRC1oUBs0139IV1OH2zayFWXNlTR4f2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NTJkmXv9; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NTJkmXv9"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63FGSEjh2130606;
	Wed, 15 Apr 2026 19:27:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=pD2x7FXOAxiphqSY+v80d5AjwEMu7E
	DZZfNdxbrxpQg=; b=NTJkmXv9Gtbtbuld0aUR0LOeGkXec9oyRWqqcZDmil4oJR
	6cpOs80dzYfbuKDqWlWvqBVHBwb89pJOw5Bpkt4R0R7GYl94WMp0fo9z3efmeyuq
	/JhhUlJWglOXbjN0I7fcI9P0UX8cMYSroN9eUj9S9Aggb916OdwchrAwkfe7XZk9
	DJ+34ZTJtkjcSdKOYlZ5VKu2HWIMAnngWEi7FeS6C23zMsb8iYSK7tAqAyST7HHo
	G7/6Zc47MR6aHcy1DNjMcS55KDkU0ra2JweEK5IQ98hNPTiwKv316Yom903eBEf4
	0LbwLHyt0yzW4dGzKiPv5JXzPMsD0uxn2lQucXHQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89nhyk4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Apr 2026 19:27:07 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63FHQ0A5004180;
	Wed, 15 Apr 2026 19:27:05 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dg24kfngx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Apr 2026 19:27:05 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63FJR3G353543168
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 19:27:03 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C523D20043;
	Wed, 15 Apr 2026 19:27:03 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D1F3320040;
	Wed, 15 Apr 2026 19:27:01 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.25.126])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 15 Apr 2026 19:27:01 +0000 (GMT)
Date: Thu, 16 Apr 2026 00:56:58 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Baolin Liu <liubaolin12138@163.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, wangguanyu@vivo.com,
        Baolin Liu <liubaolin@kylinos.cn>
Subject: Re: [PATCH v1] ext4: add mb_stats_clear for mballoc statistics
Message-ID: <ad_mguIqaOT-pEmh@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260414100212.95209-1-liubaolin12138@163.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414100212.95209-1-liubaolin12138@163.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: ix5iUEyB-wPr_UgVJeh11OHM2xRKuNql
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE1MDE4MCBTYWx0ZWRfX8suWA81L5td0
 2zCNQo5IsIkOLhxo7ec7bnh6ysEelF4mtIcJ/YwxXSQlkGxuSVZVK2PNF7TJ2SN1yurU1USzKAl
 T7NNngczUKntqFBNGXIUVO15sVmSnvnOS1EskQlpxuZQdy8Xf+qqSUhSNgdTwzl3BlwRjBE6Cjr
 I8uvgnuuVhpIZv0144XPZn6TIxANTBmRSLinRd6L7kOAEl4lFioyxSLrhJbBZS77HWDp75L2UvQ
 j4YAbLVNK7b6hDbalTmas3E6Q1urlIOqA4iN0XTx3xi5a3hyCco8l67jNTOP9ACL3/dmVEjLX+6
 7BmWUwe2Jbra9j/UTQivtCfCIWXz4+c7Jm9WAUJNOLZbTWQw6G1uk8Kl5NytcuA6+OdQXxarZKn
 INpMn46PJRWIh4X68jv8BBslgdlYlpjSMpKR9KiXj02ISIGl6Ks+RYadThPSS+lBEjllUAbkcp+
 Uv0QPsEoOsGCs3U6Zcg==
X-Proofpoint-ORIG-GUID: XrqOsl1uQFRV9dDDYmaToKkNXeqqTSOp
X-Authority-Analysis: v=2.4 cv=FY4HAp+6 c=1 sm=1 tr=0 ts=69dfe68b cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=KrRLzkSUTx881rGj9LEA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-15_01,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 bulkscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1011 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604150180

On Tue, Apr 14, 2026 at 06:02:11PM +0800, Baolin Liu wrote:
> From: Baolin Liu <liubaolin@kylinos.cn>
> 
> Add a write-only mb_stats_clear sysfs knob to reset ext4 mballoc
> runtime statistics.This makes it easier to inspect allocator
> activity for a specific workload instead of using counters
> accumulated since mount.
> 
> Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>

The patch looks good to me Baolin. We just need to add documentation of
this to the Documentation/ABI/testing/sysfs-fs-ext4 file so that the
users know what it is and the fact that the only value we allow to write
is 1. 

Regards,
ojaswin

