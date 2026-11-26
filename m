Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.135.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795659929;
	b=5SzX2JdkFqt/diJmmalXhbJWb3vJMuffiE7YWj7Pt8hQ7cB67M0h6R9mbrzWo9YB856w
	 ukoCy2YJ4ZsZzMDLjlFxzX7p+xzGG373ZRM/QXAu2ht+auaelb4X49a4VyUz/m1R231UZ
	 tkVaRVQyHdGQZr//hcJFsgNE8KHV++0QAsQTZvHfZtHz2yNu14G+OvqeTykCGrEgFGuFu
	 Y9VrS9zoMcoafvv5sn6chsinPpfMVRNZKXHFzNE7b3M6hgcGlc82CnylsEA+OMBd5WNyA
	 TdVIMey+8AFiIyyA2RWYxe1UATaBjeAl/34Sy8Dq5eNvfb0qlIm/x88YyyMFx32Wicw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795659929;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=bq5K8Z87IavuvaaKNiqMth7LGJ8zdX5mtp1Bwcp67Uc=;
	b=AYsuFo86koqZUNaXl/MvjNGY4dR3RFeUvcyF8iBaWR2igGF67woqnXTgYsAXdGXhW6uw
	 4aG7QAvltGtjNzveO14Yvgz4go6+3L0Rn3S2ipSAqHJc5TDHQnW2FtyhLqtL3+xwGoCG6
	 ABfGx6zD8vkWKbt0Iuslqd7QgdWVRSiJ7BC5wtCYJP/H8FXKmr9XaamIlXbIEymTUBgjQ
	 Gu4j1PmqUGNt5Y4OzRTJ++f9J0g5gE2EPRs+YFcyL/50mk08mK7xia1cmUVD/3c094uYx
	 hbGk16FseEDd2BWMJ8/fGX2+lgxLCBviyFdaWFZoNCCjJ+4I8uZF2IKnmrsaVPuS7gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=azAUGPgc;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=Ki+KHe6M;
	arc=none smtp.remote-ip=148.163.135.74
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98473606A31E
	for <linux-ext4@vger.kernel.org>; Thu, 26 Nov 2026 02:25:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98473606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=azAUGPgc;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=Ki+KHe6M
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQ1XDBX1794644
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 21:25:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=bq5K
	8Z87IavuvaaKNiqMth7LGJ8zdX5mtp1Bwcp67Uc=; b=azAUGPgcRU1jSI5UcEdk
	lX/Oam7hV0qSGuaoRoZ76iTO+yUv1p2TSRxSWqw/GV116U6mifykV1LTK1RDVF4I
	iKOPSY3PSz8vfny7Ha9obUkbMW6zmIsYItSxjLycctsWrDJ2rP2Qa4yaT+QQ9KqU
	+4dz298p9gibceQ5lCgFjd5gQzpe1qreD1yq7bVWWajVHsF3DL8u2w+MyeG6JCax
	6uARcxrpY97cBRd9pD/9MBjtHydvImyxeSEwdpM3USUiXBCQARMKKoJ4GgI1FvmR
	xUwASOZFEFsMGQAO+s7arILwa8QlmuqSFhjk/ZCiUMSZ1ZhwWwfuQrgDVwgAtLqi
	3w==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j68hh1191-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 21:25:22 -0500 (EST)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93f1f2fafeaso728674185a.2
        for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 18:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1795659921; x=1796264721; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bq5K8Z87IavuvaaKNiqMth7LGJ8zdX5mtp1Bwcp67Uc=;
        b=Ki+KHe6MDEgfProqRIGk0un22f7ITJdGDVR8RFLPbBwg0ny1Bmym8YPhpeZ5n8UlJd
         uG7LtT0XBxXgDmmNj5VuE8pkpIlTsmrOYMww30ypNhH3jQGBmDe/EyrlIGJ7jfYGlEL4
         7qYCGuERLyRh2UNAj2kvUeVApVok7C9JRl8404UQg3FXcsPs+CyLH4KFqOWFLRL3Ll7q
         ARh/AYUGKeJJuaXrpWt34OkALRiyTeYrlsd84E/N4Fe1r6aiLKwda5YULwMZWtlFQtI/
         bCN5U4LkQ4Tf7erCDpoVEO1+B3yiqWYQ7ntypEgKTJuWN2IyZs1VtR/yv8W48b1FM+wm
         eTqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795659921; x=1796264721;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bq5K8Z87IavuvaaKNiqMth7LGJ8zdX5mtp1Bwcp67Uc=;
        b=B+nN98wMxhsmbPFqkbNfVVFZl5KjMRj/6lRcdTeuRoenf3sQ60C5Dp209w76wThwSt
         Tp4Dcye4pHrzn9oo0uz0ttXfF4M9qjLVbkJQWaIQMN/45oxfP/ptAceSU2tTE7cICUX9
         NI+Kuet7lmFnfBdKjSpWLBlCV+2v7Xgxkw2k12FCPedOHmFfc4pqS5gtBZEzWzlIuE/n
         ZC/xgWcNL2sxBdeefaoGMu9YkDTlInTQeMCstos2MElfc7Tv2gcuHUGuI2uIu6PMPI0m
         PuyqItoLjPvv254s2+NUGMRxC2cRAh5E3vwslP6Z4i0ALw8nHPY+MZgvpwY6IInhdQC8
         N9EA==
X-Forwarded-Encrypted: i=1; AL+hErGbWxsSeLKG6ucv6EcH+5sTwEfCmcqG5pq79eSgGS/ZChbbA5dh2fMgcEhaqJ7FsTUPEJNAK6KCshko@vger.kernel.org
X-Gm-Message-State: APuU4Z+vxmL2C0c3Ey6KIs/qTTSz/jPjrKIpP/T4BbfWCvf9/GwAbSa0
	G/Ogji10D3RpkLojIlS468h7MeuYWvvw1xUQ9nue3FhVNkWZWDpwXf41FOK0BFGcwnn21HynE9I
	MmJ7fc0NmJXY1mT3YOwsvFIsTeorPxBsVuP+gdaOaRMqU1o4h/8hihtsir/w=
X-Gm-Gg: AZFdTZfwnZVMktW7GBXlBnyBVdAIbklLQD93cC7zo8BBF8CI/ZcQeDX6q5JHXBk21ST
	D+B7ggJ1mvC/wwIucJI51cZXitok4xT6v0CyHubegw7mdfhcKH4s+05Pi2FyRcL42Ap4xq5h8sD
	1UkIbtc1PF00U/UQ3okI+iR0V0dbLwyMmTL/jvXKiQXljFbQateYvEo0AVqcfBqlYeuARAF3r4z
	gMMnrmF1GW/nAStTR7v0x+LqSRxa4X4mIff7L+1cCfIF3h694S0KFtyTkZVJy4pFFDTGiJeyWj1
	d0hxBUnCfKDib1vQ2/ZwZawnxgUk20gJDzf4yTkD4YeEbLeO2hB74FfyYRHbqOfCiERgG+NtiFP
	DRFAJrILcTfARE2CgMWi80UiDpPi7BUG0FkYZOKwr1FN1i17uQS9lNi0wt5sFG5mCEryFnsWhd7
	QatPjaWfn+fsyk2tZl6BYCB9l+zUhhm7Y=
X-Received: by 2002:a05:620a:1b8c:b0:949:7920:9d09 with SMTP id af79cd13be357-949ba99fdd3mr3499403985a.35.1795659921396;
        Wed, 25 Nov 2026 18:25:21 -0800 (PST)
X-Received: by 2002:a05:620a:1b8c:b0:949:7920:9d09 with SMTP id af79cd13be357-949ba99fdd3mr3499401185a.35.1795659920987;
        Wed, 25 Nov 2026 18:25:20 -0800 (PST)
Received: from localhost.localdomain (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb34ae74sm1452063385a.8.2026.11.25.18.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 18:25:20 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.linux.dev,
        Pedro Falcato <pfalcato@suse.de>, John Hubbard <jhubbard@nvidia.com>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Zi Yan <ziy@nvidia.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Peter Xu <peterx@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-ext4@vger.kernel.org,
        linux-nfs@vger.kernel.org, "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>,
        Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Baoquan He <baoquan.he@linux.dev>, Michal Hocko <mhocko@kernel.org>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] mm: GUP dirty + ->release_folio() fixes
Date: Wed, 25 Nov 2026 21:24:18 -0500
Message-Id: <20261126022418.3620783-1-tz2294@columbia.edu>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <d088452f-1118-4a06-bc16-1942e523e0fc@kernel.org>
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de> <4f096d70-6f94-4148-8f47-242b8551e5f9@nvidia.com> <awWNyDZT2SVu2Zp9@pedro-suse.tail5790ac.ts.net> <55114986-0ba1-4a80-8498-bf674d64e01b@kernel.org> <away88BuU8ibcTA5@infradead.org> <d088452f-1118-4a06-bc16-1942e523e0fc@kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=fuRJ914f c=1 sm=1 tr=0 ts=6b079892 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=VwQbUJbxAAAA:8 a=X-ZpGw2H3ZcMOUJhEmsA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI2MDAwOCBTYWx0ZWRfX3njPl2sbkxLS
 vIN8lFXB1YYXnHlgQ+3hAl1QOhR9T0Goz+8ZOUupYs+anMTtYwAh/1CUVWRVs5jIENYPCnGMVQJ
 gyrBAk9vGGPir9gOsbylbLdD49Qgbm+wnqGnbKfxjRqrTLi3ML/Qh3fjr9Ak9p6PSKV6AxoDjei
 akUcXUNZs7xJ1POAOr6fMKR0YqpbLDPvvuHTpZy7cFzN/joDF3EbBhFYseDSfq3L/MUVcpwe2Pl
 HaxdYwBoUdTEOo4dbBFZGdHo1qQ5VrIh14fiq3ZdNeflAOGTWLV+FLlJJ39kzyHsByj9dBgm7Wy
 0VtjikkDOBxZMYyZMsXFCi5fB4idGNkAVqdwZsF7Tdndb/EK3lSaoh/g3yqdfCNwokzCb55D8PY
 BXrSd54LcDT1vs5EB1ELNUhXLNUPTzYw+H0E+JinbdKxyfH5Hk72K6TXrKpcBQ0EHGRBEWJ1sC8
 U04j5fCazuxHNAmJqRA==
X-Proofpoint-ORIG-GUID: 2CkJ5uadU0GyuZTD0TERo-Hfq72oHvtF
X-Proofpoint-GUID: 2CkJ5uadU0GyuZTD0TERo-Hfq72oHvtF
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI2MDAwOCBTYWx0ZWRfX99zwTqQzfck/
 7q+pTagQifTVlp5uqBImBaKtFDE36fOTzLzH0Oc4hH12lllcajAmbvhuxKM3VbAEChM/0D7cjgS
 a2yMuW5jXdRfH+wl27hIEgWlUy/oq3lvGmdhpGETzFZbVC7dvzTO
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11977
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=10 suspectscore=0 bulkscore=10 malwarescore=0
 impostorscore=10 adultscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611260008

+CC Miklos

On 11/25/26 5:19 AM, David Hildenbrand (Arm) wrote:
> On 11/25/26 11:05, Christoph Hellwig wrote:
>> On Wed, Nov 25, 2026 at 10:50:42AM +0100, David Hildenbrand (Arm) wrote:
>>> 1) We fix all such cases now where unprivileged users can trigger this,
>>>    converting to FOLL_PIN.
>>
>> We need to, if not for this series then for all the other outstanding
>> issues with GUP writes.
>
> Cool, and I agree (that's why I placed it at 1).
>
> But who is "we"? Because I recall that "we" wanted to do that a while ago.
>
> (I won't be "we" ;) Pedro, can you take a look? I'm afraid the fuse thing might
> be the harder nut to crack)

Coincidentally, I sent out a patch to convert fuse_copy_fill() to use
iov_iter_extract_pages() a few days ago in order to remove its usage of
set_page_dirty_lock() and address a different race. I think it should
address the fuse side of this issue as well.

https://lore.kernel.org/all/20261120-fuse-copy-fill-pin-v1-1-72a0d888f140@columbia.edu/

Thanks,
Tal
