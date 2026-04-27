Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB35D213E89;
	Mon, 27 Apr 2026 01:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777253229; cv=none; b=TiS6bVkqQNCXvAtOm4TqSXFocSRqUluiq5AXYJ/Xi7WyXayTnyjejSayUQBJkJLJCNtJuokbpl//yXlONRhDrgWNC+bnXOQpVwXjxn/89Td9GDgw8QoFL/IvtZjnvDl1wXEZxDX7ndsbIg+tfXNLQFDTn03+qgHecIj5YRs07rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777253229; c=relaxed/simple;
	bh=/+D5e1zH00ifCSI14QDCMQDcqjKKt90kfvj8G4O5uIE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z4vxRlsHJoWAuUORXB9aDZ+PbplH6JToT6Z75fFssZA5WcBbcS8AbKQbeyG/tTwhIkO8D17ycEkfQm/iV4QaCmGZ/DzsQeSB/m9V2KwI/7F1JtmtMDiF7MEjzLqeL7jntsGTN9DUaheTRSXpKxrRbMRGH9Sz5al27nYc8cX4i0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=IySbcoCO; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="IySbcoCO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=4RMc/4m1b32/LbbLQKZyNjrfGuK6+y7cSp90Idj9Mvg=;
	b=IySbcoCOLNzC3f6f+xAYdNjdxZf9mOmtVOHxfPjX98gs2XleYhyGFPuR2GRmB1
	3KOHc1FyI1lqfgcvF7ES9ILzlIL/e5gHmZ5FKYJ4DeZDsyNytvQ5szlJKlpXTjqJ
	HhuxdC0q7WIiqsOgjaOZ5uepIeaWhsyk78cfq8zECDtS4=
Received: from [192.168.100.68] (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3fwC3uu5p7hgJCA--.15323S2;
	Mon, 27 Apr 2026 09:24:12 +0800 (CST)
Message-ID: <73c19bbf-dfb5-46d1-9f35-2475998b9b9d@163.com>
Date: Mon, 27 Apr 2026 09:24:04 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 v3 2/2] ext4: allow clearing mballoc stats through
 mb_stats
To: Theodore Tso <tytso@mit.edu>
Cc: libaokun@linux.alibaba.com, adilger.kernel@dilger.ca,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 wangguanyu@vivo.com, Baolin Liu <liubaolin@kylinos.cn>,
 Andreas Dilger <adilger@dilger.ca>
References: <20260422015026.7170-1-liubaolin12138@163.com>
 <20260422015026.7170-3-liubaolin12138@163.com>
 <20260423161947.GB68318@macsyma-wired.lan>
 <592456a9-ce45-4967-a7c4-4ed80e908bac@163.com>
 <20260424120702.GD11127@macsyma-wired.lan>
From: liubaolin <liubaolin12138@163.com>
In-Reply-To: <20260424120702.GD11127@macsyma-wired.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3fwC3uu5p7hgJCA--.15323S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uF4kXrWrtr15tFW7ArW7CFg_yoW8WFWkpr
	45A34a9Fs8Ja47Zwn7Aw4kJFyFq39rJ34xJrn3Z3y09a90qrna9FyIkrW5Xa4qyrWrua1r
	Zw4j9F98CayjvFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UOzV8UUUUU=
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbC6RzzvmnuuryJ5gAA3W

Dear Ted,
    Thank you and Baokun for your review and suggestions.
    I will incorporate your suggestions and submit the v4 patch as soon 
as possible.

Thanks,
Baolin

在 2026/4/24 20:07, Theodore Tso 写道:
> On Fri, Apr 24, 2026 at 04:09:31PM +0800, liubaolin wrote:
>>
>>     2. Do not delete the `/sys/fs/.../mb_stats` node for now; implement the
>> same write control logic.
>> 	* Write 0 to `/sys/fs/.../mb_stats` to disable statistics collection.
>> 	* Write 1 to `/sys/fs/.../mb_stats` to enable statistics collection.
>> 	* Write 2 to `/sys/fs/.../mb_stats` to clear statistics counters.
> 
> We could do that, but note that currently writing to
> /sys/fs/.../mb_stats just sets an unsigned integer in
> EXT4(sb)->s_mb_stats.  There is no ext4-specific function that runs
> when /sys/fs/.../mb_stats is updated.
> 
> So either you have to add some check in fs/ext4/mballoc.c which gets
> called every single time a block allocation happens --- and consider
> the race condition where two CPU's are checking s_mb_stats at the same
> time, and the desireability of adding a spinlock that would need to be
> taken every single time a block allocation happens ---- or you have
> add an ext4-specific function in fs/ext4/sysfs.c.
> 
>>     Compared to your suggestion, I recommend using the value 2 for the clear
>> operation because s_mb_stats is an unsigned int variable, and using -1
>> requires changing the variable type.
> 
> Well, since you have introduced an ext4-specific function which gets
> called when writing to the procfs file, that function can clear the
> statistics counter when -1 is written to the file --- and then set
> s_mbi_stats to 1.
> 
> Cheers,
> 
> 						- Ted

