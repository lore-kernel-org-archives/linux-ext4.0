Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361CC33065D;
	Fri, 24 Apr 2026 08:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777018205; cv=none; b=LbmIfNCkElaY7xog+jahr3+HIi29RLwgnz9wf29F5/7SXaTll71S6JH657IeJvIDI6kP/NZcNaXSfe8uUtDuH4HNOh6SF/NajXDdZUGkJWs9hYv/iOgL1K/El4IsvkJZpKkxFMt8Mu/f6y44jgqLukOatGRhm6wkZeWLG2pn0kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777018205; c=relaxed/simple;
	bh=YhZ77naYPkIykKbUM1EdB2E1HQaTDGQdNdCuY1eUV8w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aGBD1v4GKDEKtO6UvR6GRkmqUraXqhU3k5mMb1uJ37+Vb/i0R2r3zMRb7qdwPSeqzNo/kxWAhjDOagCacPcAGY8i03MyCFW3ESm8GwMAXQ+Ctuu+dmjtRNYrbAkl9bBjM1A49F+CSsbAOf4K07e5sxLKF0TFZF8rhEgiLcfLaPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=AtI/W/xk; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="AtI/W/xk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=5eckPIJ6C7eQOtnjeDdoOds89DmFRbADXWxl90Vzlu8=;
	b=AtI/W/xk6jPK4IUSHYvZHl/pUbFAH/x1opppqvynxn3ft5Kcv9QnQj/yeIIsoK
	C13ZrxZNREfkH3bn13rG14wy+T7EQ1ddAmh2sLXm9KrnF77iLosFN7E5kHnaHucY
	0MpG8gG0foxGMCcBjgYwLLaID9lr8Y06TT/0F9ju5oKQE=
Received: from [192.168.56.68] (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD3n_A7JetpjOsEBg--.8545S2;
	Fri, 24 Apr 2026 16:09:36 +0800 (CST)
Message-ID: <592456a9-ce45-4967-a7c4-4ed80e908bac@163.com>
Date: Fri, 24 Apr 2026 16:09:31 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 v3 2/2] ext4: allow clearing mballoc stats through
 mb_stats
To: Theodore Tso <tytso@mit.edu>, libaokun@linux.alibaba.com
Cc: adilger.kernel@dilger.ca, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 yi.zhang@huawei.com, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, wangguanyu@vivo.com,
 Baolin Liu <liubaolin@kylinos.cn>, Andreas Dilger <adilger@dilger.ca>
References: <20260422015026.7170-1-liubaolin12138@163.com>
 <20260422015026.7170-3-liubaolin12138@163.com>
 <20260423161947.GB68318@macsyma-wired.lan>
From: liubaolin <liubaolin12138@163.com>
In-Reply-To: <20260423161947.GB68318@macsyma-wired.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3n_A7JetpjOsEBg--.8545S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZr1xZryfCFW7Gw13ur1Utrb_yoW5GFy7pF
	15X342vFn8Xa4Uur1xGF4kJr1Utr9xJ3y3JrnxG34a9F4DtryF9F1FkrW5tFnrKryvva1r
	Zr409F90yay2va7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UOzV8UUUUU=
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbC6QCueWnrJUAfigAA3M



在 2026/4/24 0:19, Theodore Tso 写道:
> On Wed, Apr 22, 2026 at 09:50:25AM +0800, Baolin Liu wrote:
>> From: Baolin Liu <liubaolin@kylinos.cn>
>>
>> Make /proc/fs/ext4/<dev>/mb_stats writable and clear the runtime
>> mballoc statistics when 0 is written.
> 
> At the moment to enable mb_stats the system administrator needs to
> write "1" to /sys/fs/ext4/<dev>/mb_stats, and writing "0" to the sysfs
> file will pauce the statistics colleciton (but not clear the
> statistics).  Adding a way to clear the statistics by writing to the
> procfs file might be confusing to users.
> 
> So.... as a suggestion, if you're adding to the ability to write to
> /proc/fs/.../mb_stats, what if we make things work by
> 
>     * Write 1 to /proc/fs/.../mb_stats to  enable statistics collection
>     * Write 0 to /proc/fs/.../mb_stats to  disable statistics collection
>     * Write -1 to /proc/fs/.../mb_stats to clear statistics counters
> 
> And then deprecate the /sys/fs/.../mb_stats variable (but we probably
> won't be able to remove it for at least a year or two).
> 
> 	       	       	  	    	- Ted
Dear Ted, Baokun,
    Thank you for your review and suggestions.
    Since you mentioned that /sys/fs/.../mb_stats cannot be deleted in 
the short term,
    I plan to modify and submit a v4 patch according to the following 
strategy.

    1. Change `/proc/fs/.../mb_stats` to read-write mode.
	* Read `/proc/fs/.../mb_stats` to show statistics counters.
	* Write 0 to `/proc/fs/.../mb_stats` to disable statistics collection.
	* Write 1 to `/proc/fs/.../mb_stats` to enable statistics collection.
	* Write 2 to `/proc/fs/.../mb_stats` to clear statistics counters.

    2. Do not delete the `/sys/fs/.../mb_stats` node for now; implement 
the same write control logic.
	* Write 0 to `/sys/fs/.../mb_stats` to disable statistics collection.
	* Write 1 to `/sys/fs/.../mb_stats` to enable statistics collection.
	* Write 2 to `/sys/fs/.../mb_stats` to clear statistics counters.

	Delete `/sys/fs/.../mb_stats` later when it is possible to delete it.

    3. Modify the relevant documentation for `mb_stats`.
	Documentation/ABI/testing/sysfs-fs-ext4
	Documentation/admin-guide/ext4.rst
	Documentation/filesystems/proc.rst

    Compared to your suggestion, I recommend using the value 2 for the 
clear operation because s_mb_stats is an unsigned int variable, and 
using -1 requires changing the variable type.
    I suggest avoiding changing the s_mb_stats variable type unless 
absolutely necessary.

    Do you think this modification is appropriate?
    If there are no problems, I will start modifying the code and submit 
the v4 patch as soon as possible.

