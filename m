Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D12D51E422
	for <linux-ext4@vger.kernel.org>; Tue, 13 Oct 2026 17:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791912986; cv=none; b=T1yHQMRWRiXHUnLWREyLIYAY+LHU1eM2ZjJj9ZA9GpY16ykzy/hzlOjhLvBbcN5vZHUSD0+Xf4mqiYRvu7NAePFYT+hXoun5tWbKoBqDa+95LDl4WVBs1OhIGM4cfeV/6viTJoNJYG3jdHmPqPuRFi4QSAldoGpqTVSNxRERRbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791912986; c=relaxed/simple;
	bh=Dj5dkMy90u8AZTnJJCjsiqTyzCoru/ESbIGWugvCt1E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IoX1KamuOnqi2K1MzSICQ5MiCaie4gyek4yo9oy9c3sn1AsbPAW4wh/GuRT1yxesbdTGn9E1vSavBdRG3MxGcvTAN2VctioGbWn6sLA+IeZDzlNfQz1vzF50YKq37YX8SlVE0xH5ekuiyq0T72ZufODcDeT4tlUzhzqsolGWfv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=oUFuMisZ; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=GTsZg0Zu; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="oUFuMisZ";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="GTsZg0Zu"
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69DGYFvM1158039
	for <linux-ext4@vger.kernel.org>; Tue, 13 Oct 2026 13:36:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=u1Ri
	8mJXPdKAGRkcGKBITz/hwC09NlNj7vX3FNyHoII=; b=oUFuMisZgL5jb2g3IUFa
	xyWCEGGvD7O2Xynt63Y2Xve3B8CjRupGpPqJ/OWx/bWve9CFyedTl4/LhrCOTc7L
	8eeFRCEJ8Gobz0dDRYFI5rv58ztENPO+Pg8B1ytmDaoffc4cs99w91W7CdFOT8bw
	AuxcjDc7kRjZ53Za7v+nQVfrKigLhb9FOSnUYxeGyoAdVSWzSjTjlZfQQGtGv1de
	A6il+vgtOck/VHgnlAJG0nFI7oa49w60KExN6HRJQif+Ne8CA33NcLpaAiced6LJ
	uqykVOtRqWfKINcyAt8UPYllYgRyubdk3uQmsIzkrY8uD2RaRZgK4F6oTPSvOw0+
	+g==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4h9qtrhc00-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 13 Oct 2026 13:36:18 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-53397b6e05aso71032561cf.1
        for <linux-ext4@vger.kernel.org>; Tue, 13 Oct 2026 10:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1791912977; x=1792517777; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u1Ri8mJXPdKAGRkcGKBITz/hwC09NlNj7vX3FNyHoII=;
        b=GTsZg0ZuJP49GLhD0WqVDzBe1LGyTl53LmWhIoVEH2tcynO0ez1AQH4FI4koREdhCc
         59hnYZrrkwqJWMU4GdZcwoZx8z7rHrAp50nZ5R6DNJ0NWBJu7Ix3mRUFBxAWWldY89jm
         5ZY9BzHT97FMol7pSBlHYsyvryaIHDz/psb6sEUf6QOJMaH6Ri34vFVSjrSsfFbKvlsT
         OWIRQOUH+RkzioutihObFlTURWJwNZNa1Nqdt8D6m/hdSQyQ4MRTwQDLyWIfROFNPAHd
         Duw9MI7rhEgasmYP18wAOGmgWC0vlP4S+cgivlj5xP7P1FGaTTWmp3brvoD82z/vsEqv
         4zvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791912977; x=1792517777;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u1Ri8mJXPdKAGRkcGKBITz/hwC09NlNj7vX3FNyHoII=;
        b=els2nP1WXnz4Wa/CcOAfDAjvhdgqc7vrlKrWx1KmHZYQ43yiQ9lvZPbWVzUdqWfMqh
         6TylczFgvcaDT2SaQA/afGJVR7F9aFfWxqhfzFMreTxMv2Rdyv8JIwEGVnTc3iLlSGjf
         l2cTU8B1EmTsld8WrhQtnedhaN9zKIV9K1NkHc1k7QFGO+SZEO7rl9XzZivZ76bwRrMr
         0Gs8ZJcjS4OTm4gMEOAtnlVi1Pt9Q9s5l7PT3WO8rA62gqtWk9nUYeKny57mLsrYiZI6
         r4WMJNdYdrTBCvM/pZdMtVnwf6i/5NYu1uFPYDjbayMqztrpq2GG5pLIFe3ZZGonksZv
         46dQ==
X-Forwarded-Encrypted: i=1; AKwUvBxumEb1p+nlKbDCE4WnzFrO/OH3ZjEfwDHSSDXDsm+3fbrheS+TCCsOyQVGRnoCKWaMRZnbYTqU75FD@vger.kernel.org
X-Gm-Message-State: AFq9FYIwgjWTBsOfaoS5IGcuvp/7i2qZh+e2tK6KY5H6n8DGNmPbfGub
	2MLK2Bt7WmxZ18sueN5F/4izZLdsWl+MmjoC9+UaEoP+UreZhk6KfYlWNVSGeeQ35FkLXlJD5qQ
	dUhAEZESSKX4wjtzY03WespGGU8n9hj2OKK2o8h7c/SncYnR6qxgx4s+33QE=
X-Gm-Gg: AYBFou0zLK5lOB/eTvZgX1xAHoAoo2hC9w6fHE8vO8XAQjc/W6+041ysXJ4RG11RYp2
	840IeT6LWbhxP5HXFXIeu/Q5UEYIf5AktxjLDeLSSvNf6r7xl6nsqGOxO0UGBxtz6QqhlTIIepS
	D71tb0bxrmq3bXm5TBsQFFjoza4UN95NDZyCXKBVaGXAKLHqVCI5HYfVxRCw79QEfhBmoPzA8/o
	KPccdAH3ia+FrRlJa0gNwFe2g5KacdyConLyS7Lg9pog9avdMmrLxV8i1kO3pz7dLBt1Me4f/jA
	o5fpTnH9Iyda3IZjZJEKeQ48QJefbbuSMhNDFGcogl164MKkVXNfj7lRo1QdENBOGAdkI2N+dID
	ZR6gtVp09byV232i5jYHQuCFvxt8XoNVhmEB4hlvgMJNmGg==
X-Received: by 2002:a05:622a:4d93:b0:534:b7d1:cd1c with SMTP id d75a77b69052e-5359f498f75mr233112601cf.8.1791912977264;
        Tue, 13 Oct 2026 10:36:17 -0700 (PDT)
X-Received: by 2002:a05:622a:4d93:b0:534:b7d1:cd1c with SMTP id d75a77b69052e-5359f498f75mr233112291cf.8.1791912976817;
        Tue, 13 Oct 2026 10:36:16 -0700 (PDT)
Received: from [10.207.9.0] (nat-128-59-177-43.net.columbia.edu. [128.59.177.43])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5359b731a6csm107012341cf.11.2026.10.13.10.36.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 10:36:16 -0700 (PDT)
Message-ID: <fcbf90fd-6de0-4652-b4e0-8946f1581c6c@columbia.edu>
Date: Tue, 13 Oct 2026 13:36:15 -0400
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: complete dropbehind writeback in task context
To: Christoph Hellwig <hch@lst.de>
Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>,
        Taotao Chen <chentaotao@didiglobal.com>,
        Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261012-ext4-dontcache-complete-in-task-v1-1-6ac801557041@columbia.edu>
 <20261013115926.GA2944@lst.de>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20261013115926.GA2944@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDA3MCBTYWx0ZWRfXxZuSOC+/UyOK
 wbs8P9tWnji9kVGUeZg/hbw+UycYGRdNCzuup3R9iywEBGCH4k0MsyJ8Yj5c4pt5MatBhwAiMkv
 PRzCDJuiyjBJ+hjosRQ0awW6CvvBvyz7nrlwb4CWc+/CDEz1IJhX/bURu+VZWy30qLNlNxJuEof
 H9/3i1/Jw4NRtL/sm6QVDJbHKPVuTvhdxtqVG7pjsrHhzEY+LXglOjfjjOVD+YfjGKgE1IkKxe/
 /Fe8tBO3ctwS3VbFVVBN7vAx1R9jhk/LETggmsc8q6I1Sp0bPZ6X/m6bZtB+XJN931rc/d+6dkb
 te7iFgGi+3tNE8i8EvB8H/N12T55kThtC4PqpgyadseXNty4vXyqSpPc387ytdw3qHubc0BIt9y
 TnQu5+w6fbpBlW2xiGuySTOGW+oh0h2iP0bhtWKB3bfP4jkb+8MzD5Zt0Q7L00LRSvVyayasWfb
 Rk5l9PMclPdumFfEAhg==
X-Authority-Analysis: v=2.4 cv=S5FMU4sP c=1 sm=1 tr=0 ts=6ace6c12 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=lXeS3XHMKYhu4Q0xF1pUDQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=zoHXe33pqz0Du4Moe64A:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-ORIG-GUID: x6qjiuA5yt-_-IsNMcynxK_uy2je9kwR
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDA3MCBTYWx0ZWRfX2tbrr6tdGnpO
 oQFjjXAKDb2Uj3fun53RYSlyTJibeqwbwQw9WP5HgtamIQkdP0aLilG0sQxzCMmNnsxz+iIe+lC
 RKAOkPj2ecDFO78sFce+vXitTMGvTXpaBJ+kf1rImjrTc3i56mvU
X-Proofpoint-GUID: x6qjiuA5yt-_-IsNMcynxK_uy2je9kwR
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11934
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 phishscore=0 clxscore=1015 lowpriorityscore=10 adultscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 suspectscore=0 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610130070

On 10/13/26 7:59 AM, Christoph Hellwig wrote:
> I wonder if we can add a test to xfstests using say the mincore command
> in xfs_io to check if the pages actually get dropped after a trivial
> RWF_DONTCACHE write to verify this behavior?
> 

Looks doable, I can take a stab at that in the next week or so.
