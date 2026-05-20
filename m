Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97923BD644;
	Wed, 20 May 2026 09:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779269694; cv=none; b=hs9hN9xSuhShlaKUnlkQec/MGyKVCVex4LkPkFWwWDVNFL2gSk1Kqmt0TcRadnVtfCvxd9YvZ8GXUHz06PoygN09BDefjjKol+GlmmNCTiPQhd7PPk6na9YkF53OJ+tGbNHrVuNsDEEhYyC2zH2Aaip4MLeX9JYIrk/EPBqtpn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779269694; c=relaxed/simple;
	bh=J08RMay1xI/XMVf3oOOgHWGiTGclpQIfUmmQYmqCjYk=;
	h=Message-ID:Date:From:MIME-Version:To:CC:Subject:References:
	 In-Reply-To:Content-Type; b=FaqyAqx1arlBJOgtNFEfSQzy76hw7UjEk9aeQcBWuugKp0s3xsQjv7AGaV+0RGl8lhJty3PxTq26EfUGbnU+IIWbsxnuqVMEaUL2/NPrGJXaPHOQwFDGPUqEUZjjTW+FSPZzAh/nWa4t9/2Am00ocJTNCd7CwEPV3bPeGqapHbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=ke4kJ+Iq; arc=none smtp.client-ip=117.135.210.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="ke4kJ+Iq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Message-ID:Date:From:MIME-Version:To:Subject:
	Content-Type; bh=Jf76jY7UFR/LVocsCCEE7SGxCvnr8uVaYNOlgn9VrOo=;
	b=ke4kJ+Iq5GD5h9tYuzk8FqL/CFrBz9xZ9ddLZUrR4GJEdwqoYdotHAvJpnNKq6
	Qzq4qOfQ8CeYB9hUvi3+W2MI9sr9DS9H0ykgaLi3ND0X75WhaL7yQ/WeCIa0uqhj
	O5nOsOuJNZebbzWNPBJssEatJwZFHxr2uOvF/szqYfsvU=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCkvCgDHT4L6fw1q3cghFA--.15812S2;
	Wed, 20 May 2026 17:33:46 +0800 (CST)
Message-ID: <6A0D8003.1050709@126.com>
Date: Wed, 20 May 2026 17:33:55 +0800
From: Hongling Zeng <zhongling0719@126.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
To: Zhang Yi <yi.zhang@huaweicloud.com>, 
 Hongling Zeng <zenghongling@kylinos.cn>,
 tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
 jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
 neil@brown.name, brauner@kernel.org, jlayton@kernel.org
CC: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix ERR_PTR(0) in ext4_mkdir()
References: <20260520074634.53656-1-zenghongling@kylinos.cn> <889382e7-69cc-4797-bf9a-3eada00bf1b3@huaweicloud.com>
In-Reply-To: <889382e7-69cc-4797-bf9a-3eada00bf1b3@huaweicloud.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCkvCgDHT4L6fw1q3cghFA--.15812S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJr4DJFy7Cr48JF1DZr18Zrb_yoW8GrykpF
	s5G3Wvk3yFg348CFsakr45Xw1rZw1Sgr48Wryagwn8AF9xWr1FqFZIqF4Uu3WrAr4UGw4Y
	yF4UKry5uFW3CaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jjksgUUUUU=
X-CM-SenderInfo: x2kr0wpolqwiqxrzqiyswou0bp/xtbBrxv7zGoNf-urLwAA3k

   Hi ,

   Good point! I've been systematically fixing this across filesystems.
   Several fixes have already been merged (9p, jfs, orangefs,cachefiles....)

   Still working on a few more filesystems.

   Thanks for the suggestion!

   Best regards,
   Hongling

在 2026年05月20日 17:19, Zhang Yi 写道:
> On 5/20/2026 3:46 PM, Hongling Zeng wrote:
>> When mkdir succeeds, ext4_mkdir() returns ERR_PTR(0) which is incorrect.
>> It should return NULL instead for success and ERR_PTR() only with
>> negative error codes for failure.
> This point is indeed very easy to overlook. However, why not modify
> other file systems as well? Commit 88d5baf69082 made changes not only
> to ext4.
>
> Thanks,
> Yi.
>
>> Fixes: 88d5baf69082 ("Change inode_operations.mkdir to return struct dentry *")
>> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
>> ---
>>   fs/ext4/namei.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
>> index 4a47fbd8dd30..8cadaeb15b2b 100644
>> --- a/fs/ext4/namei.c
>> +++ b/fs/ext4/namei.c
>> @@ -3054,7 +3054,7 @@ static struct dentry *ext4_mkdir(struct mnt_idmap *idmap, struct inode *dir,
>>   out_retry:
>>   	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
>>   		goto retry;
>> -	return ERR_PTR(err);
>> +	return err ? ERR_PTR(err) : NULL;
>>   }
>>   
>>   /*

