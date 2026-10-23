Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792723020;
	b=ktS6Fu3epYW2fi2UgKh2zSwPcXYmzWiiYHylwrXCIDyrmrBFoEWFcQQWsHKpuhMBJIYx
	 eRBZQm4vAkLmaN3R7pmCwmzb4KzDVXKXlfpKMMZTap4I2zslVNDb3IAHG8MxNtxqxN/Vh
	 TxYj2VOtSJLoiCwtim7+TLhf+Y5yryJIF9BrpJg+LMQMSyEktoTVopah/bIpDuVFmFUeU
	 sJMLRz7Srif4lNLLe5irwKZZTfaDg52/ZBT2h/iWux4k9mu4grPfOafx0QKvaqh2H/IUF
	 Pgz6hCm5F4WLWZ5uw7ShWbVI2oogYy40Lb/xGp6krajgu0skQy6tpG6lx+u8TKG7QSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792723020;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=K9kCZlBhGW9iOnZqPmtFcaDJpbNWZk4Nf14VO+3kDTk=;
	b=gsMDO5o4hbs/YuWv7uYRBeOCycC3E1EHi/p92bN4otpRW33fepbOy/NV/hjKP5gITJZz
	 Jgtt8VU747Uoh4iDvQBWNoHJCM6Y85bk8ocNEF10D6Z1cRX5ZIYr0aoyq2MnH501OCgOY
	 ikicufzylrFN5Xp0ORojQIvr8uKMSowHwz6RmsFajxfBV3S5NYvD6DOUmob0NBb/Qi2DD
	 CqFIh5SAdUTUBSb4LYglJu9HvvpFNTy/CL37TgYNTLK0fgIoXWsDXx+KIVcjLknJckb0r
	 48MJLHeLepAoOFRZFWWiIvRVAreePP1bIuw9zJNWdDT7G5KmEmrJsz0e4dgdrdfTnFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=none smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.112
Received: from dggmsgout12.his.huawei.com (dggmsgout12.his.huawei.com [124.71.93.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35BB606A319
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 02:36:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F35BB606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggmsgout12.his.huawei.com (SkyGuard) with ESMTP id 4j9nGP4MZcz1xs4
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 10:36:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5F4BF40561
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 10:36:49 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgB3tfRAyNpqIGruBQ--.13037S3;
	Fri, 23 Oct 2026 10:36:49 +0800 (CST)
Message-ID: <afcf8af1-2f77-4408-b11f-538ca692bf90@huaweicloud.com>
Date: Fri, 23 Oct 2026 10:36:48 +0800
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
Subject: Re: [PATCH 0/6] ext4: fix buffered writeback error handling
To: Theodore Tso <tytso@mit.edu>
Cc: Julian Sun <sunjunchao@bytedance.com>, linux-ext4@vger.kernel.org,
 adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, riteshh@linux.ibm.com
References: <20261022145241.2950379-1-sunjunchao@bytedance.com>
 <atoySP5ez1SwWh0X@mit.edu>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <atoySP5ez1SwWh0X@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgB3tfRAyNpqIGruBQ--.13037S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tryfuFW7uFy5uw4fCw1rWFg_yoW8GF1fpr
	Z8Kr4UKr97Jw1fAr95Z34rJr4Fyan3Kw15uF4YqrW5Za13W3WaqFW0kF4rZFya9rnxWF12
	vFnYq34rurn0vrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IUbmii3UUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 10/23/2026 12:05 AM, Theodore Tso wrote:
> On Thu, Oct 22, 2026 at 10:52:35PM -0500, Julian Sun wrote:
>> This series fixes error handling in ext4 buffered writeback. It prevents
>> stale data exposure when mapping or io_end_vec allocation fails, reports
>> unwritten conversion errors to fsync(), and preserves concurrent io_end
>> flag updates.
> 
> Hi Julian,
> 
> Thanks for this series.  However, we have just landed a significant
> change to the ext4 writeback to add support for fs/iomap's buffered
> I/O.  It is currently not enabled by default, since there are a number
> of features and mount options that aren't yet supported by the
> buffered_iomap codepath.  (Thanks to Zhang Yi at Huawei for his work!)

I'm glad to hear that the buffered_iomap codepath is going to be
upstreamed. I'd also like to thank Jan and Ojaswin for their careful
review and valuable suggestions, as well as everyone who has
contributed to this conversion in areas such as iomap and mm.

I will continue to put in effort going forward, and I hope to make
buffered_iomap the default path soon.

Cheers,
Yi.

> 
> I'd really appreciate it if you could rebase your patches on top of
> the dev branch for the ext4 git tree (I've sent a pull request to
> Linus so this should be in v7.4-rc1), and determine whether any of
> these concerns are also applicable for the buffered_iomap codepath.
> 
> Many thanks,
> 
> 						- Ted
> 

