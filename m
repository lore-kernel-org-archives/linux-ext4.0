Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.230.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795091981;
	b=dXTCNuTvCkHzgCc8Aiifo76ow8/4f02Dhsvcz04fAtqG2C7HAB82GgYwGxHEQopex0YR
	 HeQLqJypI4rca94++msbjJlmhvXbhfP3woYBAUNeZRuiiDoUTuBpN9LwazT/hR3ATl8nr
	 yVh5PjDjwm8mjR7OSC/Dui0OwfFDWz99PYhwKzLISbumAqUtUeBeIduY1CEIbYF8GWBiw
	 fmsx3qOihyjdlVUgI3Gb7hKRkmJrIhL+uiy/5QvYMmiVyMZZscIyseNt8Wqy64ms+1jYw
	 XkoRvMVqyMZkBZCv0CRv2fQQZ5iEdxOGEAguhOQTpLH+2Fn4OeGFQuBmu0NlaclY7gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795091981;
	h=DMARC-Filter:DKIM-Signature:Cc:Content-Type:In-Reply-To:To:Subject:
	 X-Lms-Return-Path:Date:X-Original-From:Content-Transfer-Encoding:
	 References:User-Agent:From:Message-Id:Mime-Version;
	bh=4W1OsMgDR03Yj+4i8xbunhvfo+tmgdJUAvqJYnYTpo0=;
	b=X1tlPM5k4dJBnDf7CVA4I6E6fTJ3aKtVT1+yJMZr/JbkamIkYTpXG9wV7WvFvHWuNb1L
	 hXNwCDEhQTnG4Mq7jELILb1PA6C6VB6Nbe/rGULT3Cz9EkL05nbz9Xd553AQoJXiwu2fL
	 ljosshnwKhJJ96NI94wQaoDNrkG1qmKMhpBKNHNmlOvbqbnpw9aYg5BOpyteL4LQNkdJy
	 299qR0XXdDohLAffRmNE2p3dFt2OX2CehAzqdosnmQ7AEG7OQiNoEVzbT+TEeC1hnhcug
	 DXd2Wzu28YfEMvawMAjtkW8eRzI3TtLPdaC8QfI+owFS4StE7UN2ayMTFFrsDC2j6eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=Il+Ee5Jz;
	arc=none smtp.remote-ip=209.127.230.112
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCBB606A33A
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 12:39:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BCCBB606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=Il+Ee5Jz
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1795091975; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=4W1OsMgDR03Yj+4i8xbunhvfo+tmgdJUAvqJYnYTpo0=;
 b=Il+Ee5JzHdIl0Rp4vRxOEELJcxqGShezZymRfl6nfe5LRTGw/WMW/VPJQlDoToFk1sAawQ
 uPkx0KYamjvBO18lQJtlAEofK6RUgBYAGxlZRLq1t85fur0s3Wt4y7gwDWgUjHcL1nBHKJ
 O7e+Hi7KMwxGg3ocEf6Cb33fIQuC45+6qyNokKjQ1f0PE5Szt0kc8HdYxyL7pY0T6FPxmL
 OLyIaepLtgsF3WvZymm2Nz22Iy5BPcxmGnrSaIhcGeLhEa+abiFZjZ7kM7PLRcHr4pW70/
 7X6yJ5F1AeC+WRNsA7GOatksCB1kFIf5v/Ps1w++i6eWSk/AuHDq9j3iOnS8rQ==
Cc: "Andreas Dilger" <adilger@dilger.ca>, <linux-ext4@vger.kernel.org>, 
	<libaokun@linux.alibaba.com>, <jack@suse.cz>, <ojaswin@linux.ibm.com>, 
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>, 
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <av5hDZzzrKNxmDBy@mit.edu>
To: "Theodore Tso" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: reject impossible group free cluster counts
X-Lms-Return-Path: <lba+26afeee05+6e72a3+vger.kernel.org+zhaogongyi@bytedance.com>
Date: Thu, 19 Nov 2026 20:39:14 +0800
X-Original-From: Zhao Gongyi <zhaogongyi@bytedance.com>
Content-Transfer-Encoding: 7bit
References: <20261102042428.65204-1-zhaogongyi@bytedance.com> <F238B62D-6BED-4D64-B099-B956B820BA44@dilger.ca> <2c1663e5-fac2-4346-ab2a-b35ae652373a@bytedance.com> <av5hDZzzrKNxmDBy@mit.edu>
User-Agent: Mozilla Thunderbird
From: "Zhao Gongyi" <zhaogongyi@bytedance.com>
Message-Id: <e71d2878-4647-4f3d-a390-c5fb900f4636@bytedance.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0

Hi Ted,

On 11/19/26 10:38 AM, Theodore Tso wrote:
> 
> Did you send out a rework of this patch series?  I don't see a v2
> version of this patch in my inbox.
> 

Yes, I sent the reworked v2 to linux-ext4 today as a two-patch series.

https://lore.kernel.org/r/20261119122601.85293-1-zhaogongyi@bytedance.com

Thanks,
Gongyi
