Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00193E9C05
	for <linux-ext4@vger.kernel.org>; Mon, 14 Sep 2026 08:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789375160; cv=none; b=m9CGwngfRWGb4+waHHAz6/3uy6yOyqq0ogqLm7ZGK6yzyMXEz1HJdrxVanXOGI7L998YkSm+4v4ZnEohqJGTUSQdW4P+rYWAdS4osat+qZrKi4DkXqFYwlxdgq3Zpelkcf+WjjkGpjxqJiNDq6qXCiVS3uz9lO5G2BO52KP12zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789375160; c=relaxed/simple;
	bh=T/NQlj4KEFbvcTcKeRCSLdv1JT6NuTOoCJ9yjBSuhIs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iPc2hd/B132Te+0346JtLYK9p2qRfsikO6jleJ7xwVIBnvjO/XIMnY5wCLyR8v0SCHtrqE/6l9voZZnmPjGs+9G4DCasjsyeUF6SjxQTGkxHT+RdH+c9nrJGKa0aGzDPKscpOu7jybKdix/Lyiq5I7T2yWSfpnVA6RnFIrnqJmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dtodcvjV; arc=none smtp.client-ip=74.125.228.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dtodcvjV"
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-85469b35611so805668b3a.0
        for <linux-ext4@vger.kernel.org>; Mon, 14 Sep 2026 01:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789375157; x=1789979957; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eGBrkoHMIJFGZ2LVPMmbnKr8Js6OWQm/jH/GzpXmdy4=;
        b=dtodcvjVj/RTQOcBWiLBNtqfBGu9r2iyrZLH51owOmTnhfGZFwM7EyrCRvYhRAyEig
         hDJBx4ixHHxKWnPvqdxyvdC7OcYJc5mKbJsseX3HtDLkfw1uwtFfvSXsTXaRgMzUFhUO
         nToyDwQpvApYYiR2J06GrfmI9nMP9f3CurJ9JAYRhQ7pQes8AGcSvB4D4ZuaGYA00+mF
         fIre2T++lZ5H5qi3CPJPLNxUq6pmcnz7vmb9lBzS6606YcLQgdeAt0SmS6FxKJWfkAeC
         SbqVNv7grRU9IIUmJMQBe/acjL7ahzCBu7e5ZvRrrEZ8DEHtvtHljO9EnZOvAfPHnNSF
         /bxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789375157; x=1789979957;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eGBrkoHMIJFGZ2LVPMmbnKr8Js6OWQm/jH/GzpXmdy4=;
        b=ryI491+C4AAWa9E4lSRGH1eSY5nTQIGiLMjsYbEfyr0dxCcyc4G02uzkxfhs6HU493
         wfv4XZRe7wXAcWI6fUmy03kueXMstHd49t/XgvWZIXHggft2DpEqfCjb25CykubGyAN+
         AUph7Y0FAzLTpA57CWTac8MNZhNIKL4LjngWRfhZAdhWKIG29CRaL8GCurShBby9qiz9
         weLP2Ia3RE4opaxgjORMlfZMCoL4zNd3JkCzhJjfGXEMCcf9ipEucUZsI2Qda4tzTrx0
         tPy2FB0gO72cID+r0nb64QdaYzFzR8Ydzk2tzj0LKuuZsdpEHg8Ip+1oz5Jq7L8ycXnq
         t80Q==
X-Gm-Message-State: AFuF++kZqHCMNgnClhAqvnEf/HMVjcSYlG8As6y1xFxCqSPHDsCmVejX
	ZGZhBypKAwYzG0sY7/OojyxSlBLavvJK6Ir3iOWff5LXfYXUhsJqmlkn
X-Gm-Gg: AYBFou1ujJvCBncNP/9toVs5VBDP8AqovtmLIaPr5TTx5Hnx7BlmAa7aO80kqduWvXT
	ECmU1V5+LJGX8MhBb2REkTFZkarQjmWsyxhchRyz8qz0cCrWsq/fE8yFqnoKI2bc6ZN28aoRoc+
	CdcEEsRC/szaZX140PI9ExIlFVOgwpsKSWGkSB2ntzi/ccTYtexpPl9aufYryBwsY4m9XrdNUpg
	JoSp3HKkrvJIooDWqJ2qOdewbn02W6e3QWra6ygVohqxMIM/EdMX3rZpaPzc3uy0tn3VUPPE0HV
	aqZGM1XpJr8hI2IOJhAqaM4yQn8QWG+iJ9uV3WpKFwpNBSyAuIXS1u6xW6N1PmSAvfOkMph8MqE
	5kDsPrVuB1CrnUvLV4/coCgKN3xekINHkiaaKTS3zYivLUJEHR6aWy6okAdx5S6F+6JhY4EV6Lp
	tLiek8i9aVt26Yk9h5+3gW2rFbj4NHBTO963YeGx37aLlkZCLR/dUrCe0rWaD8EpH03LHJvSFYM
	BWBnRbo9/kvSh6liL4=
X-Received: by 2002:a05:6a00:950b:b0:846:de21:3da4 with SMTP id d2e1a72fcca58-86f82a5f333mr3496436b3a.3.1789375157194;
        Mon, 14 Sep 2026 01:39:17 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b29bb8f28sm4294932b3a.40.2026.09.14.01.39.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 01:39:16 -0700 (PDT)
Message-ID: <3b84eec4-82c3-409b-a5bc-5a68a8aaa9b8@gmail.com>
Date: Mon, 14 Sep 2026 16:38:27 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 30/31] ext4: partially enable iomap for the buffered
 I/O path of regular files
To: sashiko-reviews@lists.linux.dev, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903124017.2325538-2-yi.zhang@huaweicloud.com>
 <20260903140457.8A92D1F00A3A@smtp.kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <20260903140457.8A92D1F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/3/2026 10:04 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Concurrent buffered reads during dynamic transition of the journal data flag cause type confusion on folio->private, leading to memory corruption.
> --

This is a false positive. Buffered reads do take invalidate_lock.
filemap_create_folio() and filemap_update_page() acquire
filemap_invalidate_lock_shared() before installing the folio and calling
->read_folio(). Readahead and page faults do the same.

Thanks,
Yi.

> 
> commit a5650f621dac34bfe427e11f706ab1c16d533afc
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4: partially enable iomap for the buffered I/O path of regular files
> 
> This commit introduces ext4_enable_buffered_iomap() to determine whether a
> regular file inode should use the iomap buffered I/O path. It also modifies
> ext4_change_inode_journal_flag() to dynamically toggle the buffered I/O
> path and address_space operations on an active inode when the per-inode
> data journal flag is changed.
> 
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
> [ ... ]
>> @@ -7598,9 +7695,10 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
>>   	 * the inode's in-core data-journaling state flag now.
>>   	 */
>>   
>> -	if (val)
>> +	if (val) {
>>   		ext4_set_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
>> -	else {
>> +		ext4_disable_buffered_iomap(inode);
>> +	} else {
>>   		err = jbd2_journal_flush(journal, 0);
>>   		if (err < 0) {
>>   			jbd2_journal_unlock_updates(journal);
>> @@ -7609,6 +7707,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
>>   			return err;
>>   		}
>>   		ext4_clear_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
>> +		ext4_enable_buffered_iomap(inode);
>>   	}
>>   	ext4_set_aops(inode);
> 
> [Severity: High]
> Can this lead to memory corruption due to a type confusion on folio->private?
> 
> When toggling the journal data flag on an active file,
> ext4_change_inode_journal_flag() truncates the page cache, but then blocks
> on jbd2_journal_lock_updates(journal).
> 
> During this blocking window, a concurrent thread could perform a buffered
> read on the same file. Because ext4_file_read_iter() calls
> generic_file_read_iter(), which handles buffered reads without acquiring
> the inode lock or invalidate_lock, the concurrent read can instantiate new
> folios into the page cache using the old address space operations (for
> example, attaching a buffer_head structure to folio->private).
> 
> When jbd2_journal_lock_updates() returns, this thread will proceed to
> switch the operations via ext4_set_aops(inode).
> 
> Will subsequent operations on those concurrently populated folios invoke the
> new iomap operations, misinterpreting the buffer_head pointer in
> folio->private as an iomap_folio_state pointer?
> 

