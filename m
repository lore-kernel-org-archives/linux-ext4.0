Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795828138;
	b=l8quPXFHq4qM8y8AnKWWGAqaORNpY2N6FQq6VXJLuJdsW13DLT9d6+CWOp6/GscNM6cX
	 GrUmAr9he+nXNDL83bj+6dZKOpN0x6VlW8b8O3vcsDuLs7nSTPevls/avTRdoIoLhKeST
	 byS0AqPAcFcPgetw31URlOVZpnOOFeVeLNIJ11OEA3217q6QVJ2filPI4Npk2SV5mf9JL
	 ewIrj1IF0+wWJRQ6rs+ga1fru60it/ZM/siuLsD1tM2DaJP0m/SZp4Mix9DS2bXCdpCbZ
	 W67vGRDSzqvh+mK4PeYBS7U+Rp0QIazGNaMPdCc5xBGUx1DcB4gyaWpxWptVLO024Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795828138;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=bmzb2klBetVMKm+jeI0J25mw8bATel70nHjfOTu/sK8=;
	b=vsTlF80Ja2Sn4wD3ryAh426BUzwOyuNin3uvT92XIVCWEETXt+q10ZchyBlPhBT55bM3
	 qdx/lmSNuZBuQDlbkY2grHlT53PX+VJKVlJ7L2Z8Xg8z2jeAhv+jlTXQBzWLPzwQk9P9a
	 m10Xx+QVaDVkZAalikCrHL5GTumb0FZQHW+4uQ3am3L/wCLjYS3DvI/Z0nyo9uWbRfKfo
	 vcvde1Zg+x/lF0xEyvyRrs1/g6y4dKiZdrG5KOg/V2eXcGEYGIxBVTxn6KCFe/tBjOx2d
	 GKnkqd0FMrsKC0fFTDIQRHWt+ljFnDvvf3Wwebm564A0Jxlg2/uIbc8Pebyz/vppFSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.99
Received: from dggmsgout11.his.huawei.com (dggmsgout11.his.huawei.com [124.71.93.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DD8606A31C;
	Sat, 28 Nov 2026 01:08:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3DD8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggmsgout11.his.huawei.com (SkyGuard) with ESMTP id 4jbscC2MFwz1c0XP;
	Sat, 28 Nov 2026 09:08:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id EDD4A40573;
	Sat, 28 Nov 2026 09:08:52 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCXzeyiKQprH4NRGA--.24636S3;
	Sat, 28 Nov 2026 09:08:52 +0800 (CST)
Message-ID: <99ddd05c-7e38-4f8a-bd9e-fe87d1d959af@huaweicloud.com>
Date: Sat, 28 Nov 2026 09:08:50 +0800
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] ext4: silent data loss when a split at I/O
 completion gets ENOSPC
To: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 guolingxing <guolingxing@tju.edu.cn>, Josef Bacik <josef@toxicpanda.com>,
 Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, regressions@lists.linux.dev
References: <d400205a-0d3d-4ec3-a916-6c0a085841b4@linux.dev>
 <d8ac3185-44c8-41e7-9cbf-3d1baa27f272@huaweicloud.com>
 <20261117-jf-ext4-enospc-reply-zhangyi-v9-b19eeb966ad0@linux.dev>
 <10712329-a587-496d-babf-620ebfd0e60e@huaweicloud.com>
 <20261118-jf-ext4-enospc-reply-zhangyi-v13-3886a3248c32@linux.dev>
 <9be1cb3e-4417-4609-bc0d-67dcfa24aa10@huaweicloud.com>
 <20261127-jf-ext4-enospc-reply-zhangyi-r4-3-59ba31e6e023@linux.dev>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20261127-jf-ext4-enospc-reply-zhangyi-r4-3-59ba31e6e023@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgCXzeyiKQprH4NRGA--.24636S3
X-Coremail-Antispam: 1UD129KBjvdXoW7Xr4fZFyDJF1fXw1fWw4Uurg_yoWkXFc_uF
	sFgrZFyrWDZF18G34xKFW3XrWYgFZYqFy8X3yrGa4fXr95ZFykCFyUXwn5Zas7KF45Ar9I
	gwnFqF4xAF9IvjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbxkYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	7KsUUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 11/28/2026 1:45 AM, Jose Fernandez (Anthropic) wrote:
> On Tue, Nov 24, 2026 Zhang Yi wrote:
>> My idea is to make this a real reservation of currently allocatable
>> clusters rather than just a counter check. We can subtract
>> sbi->s_mb_free_pending from free_clusters in ext4_has_free_clusters().
> 
> This makes sense to me.
> 
>> However, the probability of returning ENOSPC for pure append writes
>> increases by about 10%.
> 
> Our agents tried a close variant of it on mainline, with an exception
> for EXT4_MB_USE_RESERVED. The reproducer lost 0 of 72 files instead of
> 32 of 72. But write() got ENOSPC on 54 of 540 delalloc files, against
> none without it, with the filesystem at most about half full. The
> writers ran as root. Is your 10% before or after
> ext4_should_retry_alloc() gives up? Ours is after.

Yes, my test results match yours. Writes to preallocated files no longer
lose data or return ENOSPC, while the probability of delalloc writes
returning ENOSPC after ext4_should_retry_alloc() gives up increases from
0 to about 10%.

Thanks,
Yi.

> 
> We can test the patch once it is posted.
> 
> - Jose

