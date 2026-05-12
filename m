Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A323529BDBF;
	Tue, 12 May 2026 02:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778551900; cv=none; b=I+TIQCWurUxO5yTr5OdiVDytWVaqPF8U5S7kHOC6vZBW+GoGZ3sbXg/smHzQKi153/aHCSBM7WuGGLK+DIDw65bVYs6uRzEC/3c9NFN03IuILhdhVMLWQ/idj8JzAD9jXCac5be78aQ4BFWuJ7ypqQHugtXpau+9P4hwoTK9FTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778551900; c=relaxed/simple;
	bh=y6yQ6HM0XyM5CHXUndby/A+KEehTP2dSwQ8ng2pGSwY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MHmVJ4Jpzf/DBzdl/wfxYaNkW03YGSoDyL+Ab3nGeJJIfnaD46zL8r+7p+47f0ij14vWNQx93uYDHxks5wCsLanE0GAE4zsVME5GzGGjIhqF5vGXjcvnR06/r/sch1QZyINQpQZ4aM8cUur8sOoxiEaJIh1r7+f0eowAYONAx9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=fl0nAvyJ; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="fl0nAvyJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=+Z8makgKmcfdp697EY64x32KShxUw//enrX43GpQF5E=;
	b=fl0nAvyJXKttn7RUqT4Vv92mVVO1eEQLlpOXBqk6dgmWnPYRJ12yRuEOpVdvut
	3NjK/PvNukHb/4On+1xnD3WHKOKFpRALDyXR6LWuq7F6RgQDhCUjtv3g4zeHQ2fB
	62S+9O5mWr52DTmajOxVq0Y7LdrUE06oFkIWcOkU8DaFw=
Received: from [192.168.56.102] (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wBH9+E2jAJqJL1qAw--.3266S2;
	Tue, 12 May 2026 10:11:03 +0800 (CST)
Message-ID: <f64bdace-15c0-43e6-98eb-12628cdfbf33@163.com>
Date: Tue, 12 May 2026 10:11:02 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 v4 2/3] ext4: use atomic operations for s_mb_stats
 accesses
To: sashiko@lists.linux.dev, libaokun@linux.alibaba.com,
 adilger.kernel@dilger.ca, tytso@mit.edu
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 adilger@dilger.ca, wangguanyu@vivo.com
References: <20260508093428.5814-3-liubaolin12138@163.com>
 <20260508200245.A703BC2BCC7@smtp.kernel.org>
Content-Language: en-US
From: liubaolin <liubaolin12138@163.com>
In-Reply-To: <20260508200245.A703BC2BCC7@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBH9+E2jAJqJL1qAw--.3266S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CFyfGrWUZrWrtry7XF4DCFg_yoW8uw1kpr
	s5Jay5KFsFvwn3C39rCFs5Gw4Fv342k347GrWayryjkFZ09r1vyryxKFy5ZFy5ArWDGF1I
	vF4kK34DC3y3uaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U3hL5UUUUU=
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbC6RdLFmoCjDeqIgAA34

Dear All,
    Sashiko AI reviewed the patch and provided two points. I will take 
these into consideration and submit a revised version for v5 as soon as 
possible.

Thanks,
Baolin

在 2026/5/9 04:02, sashiko-bot@kernel.org 写道:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] Architectural Anti-pattern: Using `atomic_t` for a simple configuration flag
> --
> 
> commit 4ef770887d49b5db285ae4848dba912e51abd333
> Author: Baolin Liu <liubaolin@kylinos.cn>
> ext4: use atomic operations for s_mb_stats accesses
> 
> This commit converts the s_mb_stats configuration flag in ext4 from an
> unsigned int to an atomic_t to fix data races between sysfs updates and
> mballoc reads.
> 
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 94283a991e5c4..4fb19fcb1f5f3 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
> [ ... ]
>> @@ -1622,7 +1622,7 @@ struct ext4_sb_info {
>>   	unsigned int s_mb_stream_request;
>>   	unsigned int s_mb_max_to_scan;
>>   	unsigned int s_mb_min_to_scan;
>> -	unsigned int s_mb_stats;
>> +	atomic_t s_mb_stats;
> 
> Since s_mb_stats is only loaded and stored concurrently without any
> read-modify-write operations (like atomic_inc), would it be better to retain
> the unsigned int type and use READ_ONCE() and WRITE_ONCE() instead? Using
> atomic_t for simple configuration flags can add unnecessary conceptual
> overhead.
> 
>> diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
>> index 923b375e017fa..fad2819f36319 100644
>> --- a/fs/ext4/sysfs.c
>> +++ b/fs/ext4/sysfs.c
> [ ... ]
>> @@ -540,6 +541,12 @@ static ssize_t ext4_generic_attr_store(struct ext4_attr *a,
>>   			return ret;
>>   		*((unsigned long *) ptr) = lt;
>>   		return len;
>> +	case attr_pointer_atomic:
>> +		ret = kstrtoint(skip_spaces(buf), 0, &i);
>> +		if (ret)
>> +			return ret;
>> +		atomic_set((atomic_t *)ptr, i);
>> +		return len;
>>   	}
>>   	return 0;
> 
> Does migrating from attr_pointer_ui (which uses kstrtouint) to
> attr_pointer_atomic unintentionally allow logically invalid negative
> values to be written to s_mb_stats, since kstrtoint accepts negative numbers?
> 

