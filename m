Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0BA358369
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 14:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783003227; cv=none; b=EAz4mz+krlYmiQ1f6UJ1TvXbsth0hA5QT85nfKJ2pQyMmoczxFxb2xHYMjcME4KaMuVBPsTgC9QWrhWEuAiZWrLS3EoFODj8bP7ntWkoOrToLKXhImnbQi+1lLqANe6/+fPbkl9hHX+ZTxAG2Y4oj51vpH8FSxLQgKhAn7CWssY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783003227; c=relaxed/simple;
	bh=8SXQMwkQWak5JtAlo0/6+48IpTWeTNNenwJue0W4smw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bb7esVqUFroS1EOjv1So8pEp9AzH0QIKe3m7cOkZTaxNZFEpn/G62oDaAAJHdFvPSG5htM2YkcYrioMl/k4ChpSB3fTJbQTenxbvBoYqzT4p5dzelgxwQ9kfoQuGUE8kgO9qZdoeK0BOUL7HogAc2Z0Pc3II+DpvXsimKYMn2AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jvvQ1eSa; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jvvQ1eSa"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2c9bd2f8bf7so7745185ad.1
        for <linux-ext4@vger.kernel.org>; Thu, 02 Jul 2026 07:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783003224; x=1783608024; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bTU+3Q9UdlwatP5ZqPWog06rA34o9OKHK0DTOYICJmE=;
        b=jvvQ1eSaP5WXnf9K2SlFP/zgQ5nK9pQBGP2xSVHVQKyavmnIDkNOxIjr+/erdacXf4
         QVp+VIH6pysHmTckKTt5wpC3KHJzK0PkLfERp5dBK7pBQ0DdX6d+bpIz5P1CeDFJiB/m
         lfWntRXuh4FBL8YRYL0bW0emDpMhAEFe85+bsM2g2hIMY0myryofzvaudehbRl9H7Oiq
         B8WhFlucCXRklqjSGiyr4te55wovehnbt6UDgLa1GgM2FwjbEKGYa+lhR5NYCosVJqHh
         WlWcrIo/wfrqq2VXJhy/WY87FAJxDs6TCaNa4miB9YQrehtJnBWDtxFIsq9qhAbXlLNt
         /ScA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783003224; x=1783608024;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bTU+3Q9UdlwatP5ZqPWog06rA34o9OKHK0DTOYICJmE=;
        b=c0pqDqHwnncuCcicJngXRQjDYXb+fr4NktkKzv7LkAdfZUoEVzrP6aAnp/8O1s+PfK
         O7pI6uszENMefXPLLWky8cR+h/EIGWyXNHI/aRGflLMVKyVPCl0ofOA/Esd2QWIIoHrj
         Fyt5CKwwhJByBA5Q8twHS0NFBfM/tRIVAlWg9ekH6AbLnBRdE+62Z3lk1pZe+6ALTG94
         H+K9/c5U3OoOuiowqu8H03q0914xh8X5pvW6FAbYUAPro+w9Rn3uXP2/7nuaKFQyG4F4
         wuVtoBY6/txN3mlRTd+Ja0wGJlgEbe0FVySV6zh3Usn+mNVVNSLueJAl/DrqEasMdkp6
         hfFA==
X-Gm-Message-State: AOJu0Yx9cugzX+eHDIlk9KziHnTTZ7aj8f68HUUOxljVQmJu+B8cKq3Q
	WYdRtiJpUhfAKf0Ml6DkG9pYRX4FExe1leEIQNyLxj1hN5tSyhR5Hzu+
X-Gm-Gg: AfdE7clS9KskpHSuwqz/tWEjWj0aaRbX4uN/ZnaIno4kZ0+xHHnX5c11Vr1sW5LNJSt
	wVq8Gvdx1K7BUlT40jnLgj620kphSVJtvl5OcDvvdVWlJA16mRP+9VJf+dzCc0VOJ5VxSB70o4j
	u8LxsNrl2BMwYUViJ5lTqKXPnSI0TaGm1OPf53tXimebAvTNLQGDU2BcPzAQVp9KwmM6FzZgFja
	IOjO9kl14gQTdz7L+LtaG8IIoZwaS4xJ3tNCKv2GzlkOKiOxVDws+VpKGcdEErMXTQstHBXjYoz
	268j/iE0IlI2ifa7hAF6v17HnU2Ccir5yd//rq6KHSMKMg+TkW68XtuWrGQCiTZ1a96HHqL4ZSO
	vA5Z0AbdhyBfCS4hwONK0FLIbm22JWaaA64oG07E4cMda15TC+cFgD0z5I85+otYWDIDTh8iX0u
	zlSDYu2+D09wlmGj84xpCCy598ZgAQMd5Ao3NcyivEEEdkrkPS6iB6e8eR8IL2
X-Received: by 2002:a17:902:ccc2:b0:2ca:12aa:a390 with SMTP id d9443c01a7336-2caca49abbdmr2156365ad.0.1783003224398;
        Thu, 02 Jul 2026 07:40:24 -0700 (PDT)
Received: from ?IPV6:240e:390:e4a:af91:e858:9955:9be:dcd0? ([240e:390:e4a:af91:e858:9955:9be:dcd0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca9a8dadaasm14634105ad.14.2026.07.02.07.40.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2026 07:40:24 -0700 (PDT)
Message-ID: <a54c9df2-63e6-41ad-b32f-54d2f0356d5c@gmail.com>
Date: Thu, 2 Jul 2026 22:40:17 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] ext4: clarify return semantics of ext4_load_tail_bh()
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 yi.zhang@huawei.com, yi.zhang@huaweicloud.com, chengzhihao1@huawei.com,
 yangerkun@huawei.com
References: <20260701142009.1510104-1-yizhang089@gmail.com>
 <20260701142009.1510104-3-yizhang089@gmail.com>
 <qpxvjsdnq6jgigjnwzkxny6lms6gi6t4bq5l33rr2f6m6l4oum@5e6ayymrgcbd>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <qpxvjsdnq6jgigjnwzkxny6lms6gi6t4bq5l33rr2f6m6l4oum@5e6ayymrgcbd>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/2/2026 5:53 PM, Jan Kara wrote:
> On Wed 01-07-26 22:20:05, yizhang089@gmail.com wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> ext4_load_tail_bh() returns NULL for both holes and clean unwritten
>> buffers, but the conditions that lead to this are not obvious from the
>> code alone. Document this behavior to clarify the return value, so that
>> readers do not mistakenly assume that only holes result in a NULL
>> return.
>>
>> Also update the inline comment following the ext4_get_block() call to
>> reflect this: both holes and clean unwritten buffers fall through to the
>> "nothing to do" path.
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>> ---
>>   fs/ext4/inode.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index c2c2d6ac7f3d..0b31fa873743 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -4026,6 +4026,10 @@ void ext4_set_aops(struct inode *inode)
>>    * because it might have data in pagecache (eg, if called from ext4_zero_range,
>>    * ext4_punch_hole, etc) which needs to be properly zeroed out. Otherwise a
>>    * racing writeback can come later and flush the stale pagecache to disk.
>> + *
>> + * Return the loaded bh if it actually needs zeroing - in written, dirty
>> + * unwritten, or delalloc state. Return NULL if it's clean (i.e., a hole or
>> + * a clean unwritten block).
>>    */
> 
> Great that you're adding this comment because when I was reading previous
> patch, I've spent like 10 minutes trying to figure that out :). But as far
> as I'm reading the code, ext4_load_tail_bh() will return the unwritten bh
> even if it is clean - map_bh() in _ext4_get_block() will set
> buffer_mapped() even for unwritten extent. What am I missing? BTW, it also
> seems to be ext4_load_tail_bh() could attempt to ext4_read_bh_lock() on
> unwritten bh if things align wrongly...
> 
> 								Honza

Thank you for the review!

Please note the ext4_update_bh_state(bh, map.m_flags) call in
_ext4_get_block() — it restores the mapped flag back to unwritten. As a
result, the !buffer_mapped(bh) check will evaluate to true for a clean
unwritten block, the function will return NULL.

Thanks,
Yi.

> 
>>   static struct buffer_head *ext4_load_tail_bh(struct inode *inode, loff_t from)
>>   {
>> @@ -4065,7 +4069,7 @@ static struct buffer_head *ext4_load_tail_bh(struct inode *inode, loff_t from)
>>   	if (!buffer_mapped(bh)) {
>>   		BUFFER_TRACE(bh, "unmapped");
>>   		ext4_get_block(inode, iblock, bh, 0);
>> -		/* unmapped? It's a hole - nothing to do */
>> +		/* It's a hole or a clean unwritten block - nothing to do */
>>   		if (!buffer_mapped(bh)) {
>>   			BUFFER_TRACE(bh, "still unmapped");
>>   			goto unlock;
>> -- 
>> 2.53.0
>>

