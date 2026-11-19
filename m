Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.230.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058837;
	b=5T573tRZvcurT+h0FmMeJiotC7leXMkf20fBpk9otxu+3JjH9TUPnFS664/MDgwC23zR
	 EvSJcvnh0FIWy5RdlOWXcx4LbrG+EQuERxcPLj6++IGyEG1nISniMOEZf/7SNh+M2NQxU
	 XNyRisSuujUcbysvjJ5SkV1t8cguOKWoA3uHwX3B4dSEpAPkw93iJrwi54i6IiQ/rif1u
	 rQBNuIZsWen3Q8e6ROIJ140fLCDSaZBt9I+5z2fWQSOsovLYdBouCnvO1i+2nk+6NW6T2
	 dwejWe3M/6j8JQ0b0jLCvBVoB9oPK+IgWn+BmxVI4J1z6bQP4nT6MUPi8bh1/8pUYWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058837;
	h=DMARC-Filter:DKIM-Signature:In-Reply-To:Date:X-Lms-Return-Path:
	 X-Original-From:Subject:User-Agent:Content-Type:
	 Content-Transfer-Encoding:To:Cc:From:Message-Id:Mime-Version:
	 References;
	bh=86v23/ZwHeuwYjgTIPISAtm9B3GSH5/zd26VuNwl3R0=;
	b=R7iuQnVCc0SP3oo+4AzU+X4fSL/1j676RPczfv5sVxrmGfqwULwvD8KY/Vq0ebzIHxOh
	 ers0ZWc4OdQg3C94AoxmUZH4kcKT/VK7PWU0UNlZPsfHbwpxBUTgkw/vt3ev9QOal+7Bt
	 adDzApPlBamoMGUhpTpCrzdVwFOnCFjq4nJI1/Xfo2v26hyaAiTGxfWTSci4HjApZu08s
	 i7GGChNhaqmeM6CbBk4vHZ7x+rgBc+eL6eeBgxSNAmE6jHMtrJs3iWFyjWk3lyVUThpdm
	 kJNj70Fb9d0Y9fj5L3e5RJEZxFzd2cOTPOy5YAlfy6SzYBAAkatUlhDCITMa8jColzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=XkbOPl6Y;
	arc=none smtp.remote-ip=209.127.230.111
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7353960A2603
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 03:27:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7353960A2603
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=XkbOPl6Y
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1795058830; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=86v23/ZwHeuwYjgTIPISAtm9B3GSH5/zd26VuNwl3R0=;
 b=XkbOPl6Y6VpBHEqk0tRl0hdjZ8buEoIJVsEXsJXOgfTVXs9/2EhHztaJMh325uAqZAUXEQ
 kghdFaG2awt0eSRrrpN9QecUPj4T3UPyV0oOsXvcsAMSacQuKvORGO81J1LGq00U0t5kc0
 JDGZIW0QeakO/k44mX/FKSVSy6QEDfVprljqezce7u4Ulfzn6PdCk9pNZ/e+CMScOSxtwr
 EFvH0p0mHg5zotjlJS0hWFODib5i/aEqEYrZQ+RfyUDM/WKi4bwscfNVMJE82TrDPFOgnf
 bAG2ce0Es/K8NO/yEata2LXId7w7QbN7OG3vy7CgvvL3TiwkMhmkCVTPC/ldAA==
In-Reply-To: <x2m3ypyugjn25myfovxs42jgctnctmz6iof77juya3464o3bbl@qlsx2mk4smhr>
Date: Thu, 19 Nov 2026 11:26:48 +0800
X-Lms-Return-Path: <lba+26afe6c8c+aa9d64+vger.kernel.org+zhaogongyi@bytedance.com>
X-Original-From: Zhao Gongyi <zhaogongyi@bytedance.com>
Subject: Re: [PATCH] ext4: use a stable source for the kmmpd thread name
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: "Jan Kara" <jack@suse.cz>
Cc: <tytso@mit.edu>, <linux-ext4@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <adilger.kernel@dilger.ca>, 
	<libaokun@linux.alibaba.com>, <ojaswin@linux.ibm.com>, 
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>
From: "Zhao Gongyi" <zhaogongyi@bytedance.com>
Message-Id: <da2b0a43-f916-485d-81b0-d97ab7245ca8@bytedance.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261114172523.5888-1-zhaogongyi@bytedance.com> <qz2gh5bbbyqjqfqclatkq34pgxnvbu3ey5kf3octnlykstzhx2@s65dxum2wdso> <da634961-1d13-4d21-b181-f366fd72e0d1@bytedance.com> <x2m3ypyugjn25myfovxs42jgctnctmz6iof77juya3464o3bbl@qlsx2mk4smhr>

Hi Jan,

On 11/18/26 7:15 PM, Jan Kara wrote:
> 
> Yes, sorry, but this isn't really something we care about. It is in
> principle very similar as corrupting memory through /dev/mem and the
> filesystem can crash in many different ways. When you are fuzzing, you
> should disable BLK_DEV_WRITE_MOUNTED config which will also disallow
> corruption like this.	

Thanks for the clarification. The write I traced went through the
mounted loop block device and modified the MMP buffer while ext4 was
using it.

I'll drop this patch and use CONFIG_BLK_DEV_WRITE_MOUNTED=n for future
filesystem fuzzing runs.


Gongyi
