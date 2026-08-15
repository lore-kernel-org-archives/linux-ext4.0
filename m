Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991C71E7660
	for <linux-ext4@vger.kernel.org>; Sat, 15 Aug 2026 02:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786761227; cv=none; b=YDOTRagnP6lQ2PXsSaB+oEe0lqq66nAmuK9eKZNRWfOpl3kk4H61zTr4sTOroN3Lzm5zGjmQY54kreoDTU+EEf6Ty+fo5YeIRAMjcrDwAtRDneE/u64rf1vsfrkp8lpifGffLay6cWA2i5O4KdYTNTvb4GZK9jbpINHnNmo59jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786761227; c=relaxed/simple;
	bh=iV4XDfJX+CFZbdszmcTiGj00Tjyby5tA1Vo+celIx7w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H73/r4a02tOBH2pe0IK3wzvxllnX2HoYMyHg8z2dJYYhPcPWDpMM5KzVYOGddHU3ql9pGjYz/R5lh9rFMGkBmi/8rPr8r5lJ5Q8CyEL4RqDXEt8DdKW0Lv5A1p67CJgV7WbgLW9jpAlsw5d+m06XUYs4MOi7PEdno8xv0tfCrWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n9KEReoz; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n9KEReoz"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-381c51fde6bso2027253a91.2
        for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 19:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786761225; x=1787366025; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x0Z8mCo+puk0a6hzRC+iz3VlA602gbMFooVLucdUKS8=;
        b=n9KEReozDy4ZiHq9EjXvN2TvS3hZ0ZRHcX3ytr8A1pezW355rtK+nt5yJUiX8AGnfm
         jguWhmuhABtURWqel55Rrpzzc96ImaHRs3RnRn4sCwIXwhu4Iz+wLAcJiZk89uVIwPLG
         HIPanVcrdQQD5G3OSh4SVZzWnuBqJNR2PleFgF0EFXQ3XBKhKIjGa8+5VKGu9tu0CxqT
         kBY6HRdMwnbKplf5jS3AumfGYvghgaX1ZECl/u7wMPjl9Dv84UKkIcDxhSRrNWoXQXKk
         H3W/vfdRPffSusgA7OW8fWAwxDy1hNqFhyQ1CVPGY82lq0z5T4Dg3aKFUPHiDjUsjTeS
         cMwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786761225; x=1787366025;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x0Z8mCo+puk0a6hzRC+iz3VlA602gbMFooVLucdUKS8=;
        b=feUXM6BCPeMS4oaMTmJR4uONRENbLxsYNGfEeXz7awEgsZsh+MA9UkToe9VzoX4l44
         lV1MquIaMTg6kWZZHG/dmOTgaNdsPIRwWdgqsYdPqK9z2y8wq+hLjRiT4kpdrz/fwAzw
         ELql5/yaJ5PJqq1GAs243czAi2d6m9dd0JW2SecSTPZKIwUgBgfsTq7PSPDx5KxRC00n
         wfHHIbgdVKPZA3/GD9gr4KtDASMVnkDn7MvTa07W5t434HuDtdpTWVAKsfmWdwqGA+v+
         Ye5w959LCrbxVl5rbDGLArnEqMpoS0jeYNFC5f3FLpE1O7HowU24RQcFgRzLkHpwjjmX
         L50A==
X-Gm-Message-State: AOJu0YzjW4HcGy2hvXOu+mTjT6AmJMukoLlOr4vNmGTINWt6EN8yBE+m
	zQNX5w8aeBmUwNp6ll57W6XyUZiEriUOtjrer5/6U74uqs/GUjboAaLxBnR2BQ==
X-Gm-Gg: AR+sD13T9PGjL9leImsiTfoaPwTToeIFEp8GNfT1zgECrPIyI0QI3JQPBymjIznRx/3
	iJ1XjWWNa05GP9TQSBcIul4+oKUY2/Qv2fojCTI6g73suIqQlElKIVB4NuXYnCBdQsUdGdLWpiv
	qFfk7tje8BZzE2KRdeyCNsChjmIAhmXRVZHQOxnq1vouaxvp153L/Am7lF0KDrYgK8T2nbUMBd3
	ptaotIOkTQMITKSWqOOu3xm0Bsn5+dM5xKHqQY7k/8kEbSlphJPggtEQojnCDDWD3iCQv/ogaGR
	wJ2f9RHDjeQqfS66io1ZHIUAm7/1PXEyhH5J/xIjNqBlyd7qXUAB6z5VtgL2fpbG7STOIgsAr5a
	6wVun+9e/wBGyY+WQKGXmfhaWBZh91//0ZU+nV89i/9d7M4Mf9LAmsLBcmUd5Wi+e2Z26IOs5l5
	F+XIgXK9qDz0Kd/NkrWz/BsHpFgmqLZeFYsGhsT+9PfsShtIXbOmfyuCQqEaRHTy0u1fUFBP0qR
	NSMPx8R
X-Received: by 2002:a17:90a:e18d:b0:380:7688:fbe9 with SMTP id 98e67ed59e1d1-3933b764d23mr12272119a91.8.1786761224820;
        Fri, 14 Aug 2026 19:33:44 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-394ea9723casm4714661a91.2.2026.08.14.19.33.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Aug 2026 19:33:44 -0700 (PDT)
Message-ID: <3ba86c4d-ddc2-4716-bb4c-feb4b68bb6bd@gmail.com>
Date: Sat, 15 Aug 2026 10:33:17 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next v5 03/32] ext4: simplify error handling in
 ext4_setattr()
To: sashiko-reviews@lists.linux.dev, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-4-yi.zhang@huaweicloud.com>
 <20260814101229.9F5201F000E9@smtp.kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <20260814101229.9F5201F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/2026 6:12 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Critical] The patch incorrectly routes non-fatal errors from `posix_acl_chmod()` (and `ext4_truncate()`) to `ext4_std_error()`, triggering a spurious filesystem corruption response (DoS).
> --
> 
> --- Patch [3]: [PATCH -next v5 03/32] ext4: simplify error handling in ext4_setattr() ---
> commit f94f03ca7ff7f314c8faf61276a2cc51f78e4ce7
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4: simplify error handling in ext4_setattr()
> 
> Refactor the error handling in ext4_setattr() to propagate errors using
> the existing error variable and jump to the common 'err_out' label. This
> removes the need for the redundant rc variable and unreachable checks.
> 
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 8654006a57eff..76bf0e944ebee 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
> [ ... ]
>> @@ -6244,15 +6244,19 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>>   		}
>>   
>>   		filemap_invalidate_unlock(inode->i_mapping);
>> +		if (error)
>> +			goto err_out;
>>   	}
>>   
>> -	if (!error) {
>> -		if (inc_ivers)
>> -			inode_inc_iversion(inode);
>> -		setattr_copy(idmap, inode, attr);
>> -		mark_inode_dirty(inode);
>> -	}
>> +	if (inc_ivers)
>> +		inode_inc_iversion(inode);
>> +	setattr_copy(idmap, inode, attr);
>> +	mark_inode_dirty(inode);
>>   
>> +	if (ia_valid & ATTR_MODE)
>> +		error = posix_acl_chmod(idmap, dentry, inode->i_mode);
>> +
>> +err_out:
>>   	/*
>>   	 * If the call to ext4_truncate failed to get a transaction handle at
>>   	 * all, we need to clean up the in-core orphan list manually.
>> @@ -6260,14 +6264,8 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>>   	if (orphan && inode->i_nlink)
>>   		ext4_orphan_del(NULL, inode);
>>   
>> -	if (!error && (ia_valid & ATTR_MODE))
>> -		rc = posix_acl_chmod(idmap, dentry, inode->i_mode);
>> -
>> -err_out:
>> -	if  (error)
>> +	if (error)
>>   		ext4_std_error(inode->i_sb, error);
> 
> [Severity: Critical]
> Does this code now incorrectly route non-fatal errors from posix_acl_chmod()
> (and ext4_truncate()) to ext4_std_error()?
> 
> Passing a non-fatal error code like -ENOSPC or -EDQUOT to ext4_std_error()
> can cause it to treat the condition as a critical filesystem metadata
> corruption, aborting the journal and remounting read-only (or panicking).
> 
> For example, if an unprivileged user exhausts their quota or filesystem
> space, and then executes chmod on a file with a POSIX ACL,
> posix_acl_chmod() attempts to update the ACL, calling ext4_set_acl(), which
> may return -EDQUOT or -ENOSPC. This error is now assigned to the error
> variable and falls through to the err_out label, triggering
> ext4_std_error() and causing a potential local Denial of Service (DoS).

Yeah, if an inode shares its xattrs with another one, updating ACLs
will allocate new space and can return ENOSPC when we're low on space.
I'll drop this patch in the next spin. For later, maybe we can add a
helper similar to ext4_error_is_fatal() to filter ENOSPC, ENOMEM, and
EDQUOT, and only call ext4_std_error() for the real fatal ones. We've
got similar checks in extent.c, so we could probably generalize that
and share the logic.

Thanks,
Yi.

> 
>> -	if (!error)
>> -		error = rc;
>>   	return error;
>>   }
>>
> 

