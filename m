Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC00222590
	for <linux-ext4@vger.kernel.org>; Sat, 15 Aug 2026 07:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786780733; cv=none; b=l1y2hca9q0FWgPB2RbFjF1x3PFcQYlxANltdkPJYQ1af+eGfJw1hmrJ3NB3tChSF4+XcjWprTLG+OemvZcxL/u1IHyogeZYVH5dYGukgdPZVlgDyGQI7xiNYugHOqeCj5+x1Im0xtwBFBXNisUatM7aWYT+f79CUsPm9mYrryKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786780733; c=relaxed/simple;
	bh=jIEZZJ7p4KcOZsCVAV4ykuQfceRc8cLyKpOlaq3v5uA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NHI+oei6uEy4fHMteLjX1KhA0gVTPLrrxXM2fm9dc/P+NpDyhWon7RXYES+vFyzq3X5X1ZzUmB+beNHba0cvqMnnFXAss2jw1nP1/rZ+hsikAZL1De75f2IRLs2/z2KInjoFzebgGprJ9BVXyYnDv4+wVT4unEZbUu+hnDACFAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n6ZRi44o; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n6ZRi44o"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cacb8416a1so18054565ad.1
        for <linux-ext4@vger.kernel.org>; Sat, 15 Aug 2026 00:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786780732; x=1787385532; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rW377O/wYtB+aBJivfgYjxQSppkLexqA6V8YiPqrC3o=;
        b=n6ZRi44oUd3ses1g/ILdnmU9GRSf8oHK8Sw+0grqgid5tLPzqaxztwUIsaxM63MSLs
         h6xve7+wUmXTzdOBNimKWKrHtoeHaQ49OEP4CeU9BtCK2W3xnrIAMWXYEBcBXaY9pLWg
         6PGQvhfXvY50b9T0GoR2QYBEVteBWGQLqY0U5HVLG6ueg2ilmXuLxBZz7/JlGFWEWvO/
         fA7P0eSD1YvHW1AVxVNJrKAHC9YV7kC/genqOd6cLJXRoz9JOCIdHTrXU5Qidi4i++iD
         h5bjdUXcCI1i0Uh855J9TQsZPw7lJJYK6oSpuZ9NzIquk/nH7vH9yPH0X2HBxvMrmeFM
         7Nyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786780732; x=1787385532;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rW377O/wYtB+aBJivfgYjxQSppkLexqA6V8YiPqrC3o=;
        b=CaHv6XCZp+Cgs0lHy9ov+BsWxOgW8VOYRJoRxIwK4+uWgkxufDbqYyqzcrKH5KtWZy
         Xjm0HgfSo3ma5iNDS+gY1hbX5xB7wCrI+1Wh2GmMrELBJAcoP9sGTVwVSDxjJa5JNF/4
         mv/VcyFdxkXrGHTQNCuy62Jh2M3BdbkO8X8Qw/AZGTfESrT2Ys4FFGwJwcWM9D/qAENJ
         TAxpUCBvazyPK9FtsCDBA+EmDxXHEuBoSbd2pxo2Jd4l8yO+vnKotLwgGAf7Owus7ZcE
         JDKwtgRu3PN0miwFllNtpvhyIAt0pNUZ8Ww1FiYlRJwO0EBSHjXodz3Eu8T7bUtOSroF
         mWkw==
X-Gm-Message-State: AOJu0YwDhfo0JwTerOXZcscMfds7EYOOBPjullfyRDoKGbWwipNfzm76
	sPOaDNSX4WwRTzIGGqaqSidZo4iwbEZAEGnb2EIg5z0aJFCMtnwiGmjJoBnrstzqdfQ=
X-Gm-Gg: AR+sD11APJd/fVP7sTVnJEi8oYzUkLZNkr6XTJKvavBXG9lre7XMJk9eBe0ZTMhgFbq
	ztc17fZHsiuS67L3u9eaZZ1cuLbMJAwTqp1LQhiKFISLvixTOgMF+EqkLi4xbsAFnNV6skKcvao
	r/e5KcqAcoFfWjgNqwdtb3G2h9m/K2+TQ+EcNVDqi/dtaTc5bpKL51H9lS8/xr/dgLm9y5WbXwc
	8qpLzj96/5a3Y+CfKd4uAo3Xv8AZ9bxwOnli/CbCeKdmk6ODfuYBl0OgYvDP2QzxCt0JAuY+e88
	MQ3zjtpEphX6eyX+AbLKZq0S7EOMINttiCCDd2ORj18V33lHnPZA/jbHmcvYmLcT2rF1ZlHNK2x
	YLIPdJhTmS9CYPWPu2qMdSw40QdZSDyA2Sr2UC6IEfdSOzqHTgU3CG2MNEmoibw4ye/GUheUiab
	9490lIZv/PfsvVHaVg/D9adr7wqDfPQzj7kYjWOLY2bU4SP11BTgUTlhE7x22/rCVWhq2xmr/Z/
	VbDel0j
X-Received: by 2002:a17:90a:da8f:b0:380:21b7:e727 with SMTP id 98e67ed59e1d1-3933b95e327mr12617846a91.14.1786780731581;
        Sat, 15 Aug 2026 00:58:51 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-394ea99ab1dsm5385654a91.7.2026.08.15.00.58.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Aug 2026 00:58:51 -0700 (PDT)
Message-ID: <4b36f0e1-7e76-4567-895d-d3ba525535ae@gmail.com>
Date: Sat, 15 Aug 2026 15:58:23 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next v5 05/32] ext4: set EXT4_MAP_NEW flag for delayed
 allocated blocks
To: sashiko-reviews@lists.linux.dev, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-6-yi.zhang@huaweicloud.com>
 <20260814100816.4BBB31F00A3A@smtp.kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <20260814100816.4BBB31F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/2026 6:08 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] The newly introduced EXT4_MAP_NEW flag is completely ignored by its only caller, rendering the patch ineffective (dead code) and failing to resolve the underlying bug.
> --
> 
> --- Patch [5]: [PATCH -next v5 05/32] ext4: set EXT4_MAP_NEW flag for delayed allocated blocks ---
> commit f71e7357d8a5fa9c83f4d4fc004cfa3640d60291
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4: set EXT4_MAP_NEW flag for delayed allocated blocks
> 
> This commit sets the EXT4_MAP_NEW flag in ext4_da_map_blocks() to indicate
> when a new delayed allocation block has been inserted. This aims to allow
> callers to distinguish newly created delayed extents from existing ones.
> 
> Link: https://lore.kernel.org/linux-ext4/cc05c17d-163e-4251-b2c9-aa3a6f9555d7@huaweicloud.com/
> 
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 7601fe3618b1f..9dbece14ae569 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -1990,7 +1990,7 @@ static int ext4_da_map_blocks(struct inode *inode, struct ext4_map_blocks *map)
>>   		}
>>   	}
>>   
>> -	map->m_flags |= EXT4_MAP_DELAYED;
>> +	map->m_flags |= EXT4_MAP_DELAYED | EXT4_MAP_NEW;
> 
> [Severity: High]
> Does this code actually allow callers to use the newly added flag?
> 
> Looking at ext4_da_get_block_prep(), which calls ext4_da_map_blocks(),
> it unconditionally intercepts EXT4_MAP_DELAYED, sets BH_New, and returns
> early without checking EXT4_MAP_NEW:
> 
> fs/ext4/inode.c:ext4_da_get_block_prep() {
>      ...
> 	if (map.m_flags & EXT4_MAP_DELAYED) {
> 		map_bh(bh, inode->i_sb, invalid_block);
> 		set_buffer_new(bh);
> 		set_buffer_delay(bh);
> 		return 0;
> 	}
>      ...
> }
> 
> Because EXT4_MAP_DELAYED is always set alongside EXT4_MAP_NEW, this branch is
> always taken, and set_buffer_new(bh) is unconditionally called. The code never
> seems to evaluate map.m_flags & EXT4_MAP_NEW.
> 
> Is it possible this patch is incomplete and the underlying issue remains
> unfixed because the new flag is ignored?
> 

The 15th patch ("ext4: implement buffered write path using iomap")
will use this flag, so it's fine. I'll add a note in the commit message
as well, just to keep Sashiko from complaining again.

Thanks,
Yi.

>>   	retval = ext4_insert_delayed_blocks(inode, map->m_lblk, map->m_len);
>>   	if (!retval)
>>   		map->m_seq = READ_ONCE(EXT4_I(inode)->i_es_seq);
> 

