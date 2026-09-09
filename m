Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D92D3DC4C6
	for <linux-ext4@vger.kernel.org>; Wed,  9 Sep 2026 09:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788946083; cv=none; b=V7C5c+mww5zA28vOWtTY112UAUC34mjiF8K9UUQ63hKN5SRqWiJw/lsgRz8WdbaTCQefnvk5iYtyURMokOIb/kp9W6BE08OpBVRDrLhGeMdd3YTedXq6MGmm+YAEHXAOAsZHO/80NODjIcgaJ/aWUvsR6lqOkwtlUVl7sNzVR84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788946083; c=relaxed/simple;
	bh=AYJGsZ8o7WlZaiF91/EzqEc+cyr0BaFZD9Xmzk9seYE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UC1DHFAkQJ2us0GSdVeYnyWMHlrBCssZQoGgu9bdKsZx2B6u9u1C4kZYXBdg+CVhTw97C2J2Dbh7LtSJQpZhCRwjhkaRp07K/Hz5zYNwgSo/S5HPkklqugxlVD5Rcd27Y2/GRRH45lsEuat8qSpb0SEmWscRNplaEQcY8C230iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D0R8B8J2; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D0R8B8J2"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8534d507f59so5969072b3a.0
        for <linux-ext4@vger.kernel.org>; Wed, 09 Sep 2026 02:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788946070; x=1789550870; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PgNAyP9Im00dlDthcLYZPnLpvWkQDHZkuU3va3Gh0tM=;
        b=D0R8B8J2nT10uKqNvnji95pEjX+rTC9ecYOW0i9Um6ffNAzVnvFiEJASiVZyjSVnP+
         uifE2VI6hYRQdTEOE9ej4EIsTKbF4QZx6mwn3UMiPZFbzGGfjRvDnspl+aSzxpMIfpQw
         Yas+LJ6VdddYlVeCrcIzmp3XS7KMs6MugewraGhCn/8COBAYR8JT13sg+lv35TTNwC/w
         nBZ6pSBgcG9s7kYLUZp+qWX5+nFauwSRWq9omcMjfWrTLBLU/i76jWLFo7fwfIp7iCAm
         O5/3B8fcjeQKEOQ7OJXqKHwhlJZ4lznM08Dv5aCVRAH8ZkkWF07MIjNB3qtHPAy6CEqs
         mcbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788946070; x=1789550870;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PgNAyP9Im00dlDthcLYZPnLpvWkQDHZkuU3va3Gh0tM=;
        b=UqZ7O+y+iSHg+GCvcId1Pq6wNIBAuAuUlDGXJIqucocwEEG+DotaYTI6BZKFbtXG/+
         rtJ6swnXmRu6PhK1NFX1papUtWCq8DS/GPtp8m1HXGfgJWurKIEt5PBSK7u7lN067o3m
         2l4Yo5Ymnon8vnGwWOTC0LbvkcF2ebzK2tzlbmvFCypdc9MD3iUouakrpfzALWmaJSWl
         4jZq2Z1TzMauHyL7z30R01bQvRgioB3pdHY032dE+93QhhAYmj2yBe7cQA1o09vCPUWt
         wdLW/n1mR9DdOseswivBFhD4JnFMsxCpflavQYCle9t6dQkzFW3EUH1FZ/Dsf2HQsdtU
         dPgw==
X-Gm-Message-State: AFuF++n42uiFJnm41g/bo4FHxs9F6x+LyP+hZ2dtW+Aavo4L5ha5Rxsh
	YYuxBherRSVXE07N4kd2gNBwaIRwCbyQYdqSzBaj52D3Qocd3hj/I6bV
X-Gm-Gg: AYBFou2p1GMtQh6TiBW1lMqZ8OinXWg+bOk7wDY/WkwIQzlnml/12pAb2pz2j+UTGoz
	t1CL33jjviJSFzINmDlf7Ldl6wxYY8XPExrgCkJc7LSbJ5YasdLkftImk6pyHC9gfcUxQTlmVVz
	QYqrZMmnwRKFymtdoLxe4HyfWkLGrlSr1zz4C8Owsjtea0GXTwX4b3XTUjrwxhiz91MUz4heGtA
	6HWlDFPYPXfg9kkFFhGx4QDFcpI20zIqNlISUeEq4MITgKIo3ats4ZFXQYAICgweXIXS3xOgqOd
	/rsrjTko7/QFgyq37woKXuQlOnv4l2AzLixmuapVYYH8Gag5iMW23s5aEnzP4dmL4IfIoBNYo7R
	EjZGLUjXnmniBCZZFAquLqIpIAGIuZKcH6qjSxxerVmnUyM9D7YhgwtGxBWZKa2DoaZmtIObuXj
	HQIbGMq5k9UJqlPuUwhG2hKgBBjiEhoEKlOG0SKTgQgt3k9rAaYq1OiQgHCoFSNf2i/S8fPTZDo
	mMgsp4AkqFkT76bV7g4c2fFn0+tIQ==
X-Received: by 2002:a05:6a21:497:b0:3d3:ae0f:526a with SMTP id adf61e73a8af0-3da3a152bbamr55331470637.22.1788946070066;
        Wed, 09 Sep 2026 02:27:50 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc455488faesm6683552a12.27.2026.09.09.02.27.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 02:27:49 -0700 (PDT)
Message-ID: <a1a84ad5-d58a-4d15-a3ca-e78c5922f4ce@gmail.com>
Date: Wed, 9 Sep 2026 17:27:27 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 05/31] ext4: recheck extent status tree before block
 allocation
To: sashiko-reviews@lists.linux.dev
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
 Zhang Yi <yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-6-yi.zhang@huaweicloud.com>
 <20260903130218.DA3BC1F000E9@smtp.kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <20260903130218.DA3BC1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/3/2026 9:02 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Unbounded retry loop in `ext4_map_blocks` can lead to livelock.
> --
> 
> commit 084efaf4a2100728f08798dc518e2664e9b89954
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4: recheck extent status tree before block allocation
> 
> This commit adds a sequence number recheck of the extent status tree
> before block allocation in ext4_map_blocks(). The goal is to ensure a
> racing truncate does not trim the extent between lookup and write lock
> acquisition, which could lead to quota leaks. If the sequence number
> has changed, the lookup is retried.
> 
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index d703e95a6f62d..fb4834608fd89 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -734,6 +734,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>>   	else
>>   		ext4_check_map_extents_env(inode);
>>   
>> +create_retry:
>>   	/* Lookup extent status tree firstly */
>>   	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, &map->m_seq)) {
>>   		if (ext4_es_is_written(&es) || ext4_es_is_unwritten(&es)) {
> 
> [ ... ]
> 
>> @@ -820,6 +823,19 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>>   	 * with create == 1 flag.
>>   	 */
>>   	down_write(&EXT4_I(inode)->i_data_sem);
>> +
>> +	/*
>> +	 * Check the validity of the mapping found via the extent status
>> +	 * tree or the disk query. A racing truncate may have changed the
>> +	 * extent, since writeback does not hold i_rwsem or the folio locks
>> +	 * covering the full extent.
>> +	 */
>> +	if (map->m_seq != READ_ONCE(EXT4_I(inode)->i_es_seq)) {
>> +		up_write(&EXT4_I(inode)->i_data_sem);
>> +		map->m_flags = 0;
>> +		map->m_len = orig_mlen;
>> +		goto create_retry;
> 
> [Severity: High]
> Could this goto statement in ext4_map_blocks() lead to an unbounded retry
> loop causing a livelock?
> 
> If an unprivileged user triggers a file writeback concurrently with a
> tight loop of operations modifying the extent tree (such as truncate
> or fallocate), the i_es_seq sequence number will continuously update.
> 
> Since there is no retry counter or a pessimistic locking fallback
> (like performing the lookup entirely under the write lock after some
> attempts), it appears the writeback thread could be starved indefinitely
> here in fs/ext4/inode.c, spinning at 100% CPU.
> 
> Does this need an upper bound on retries or a fallback mechanism to
> prevent system stalls?

The retry here mirrors the existing write_ops->iomap_valid() +
IOMAP_F_STALE mechanism in iomap, which also rechecks the sequence
number and retries without any upper bound, and has not shown livelock
problems in practice.

A retry only happens when i_es_seq has actually changed, which requires
another thread to hold i_data_sem in write mode, so each retry implies
real lock contention, and the writer yields on the rwsem slowpath rather
than spinning.

So I don't think an explicit retry bound is needed here.

Thanks,
Yi.

> 
>> +	}
>>   	retval = ext4_map_create_blocks(handle, inode, map, flags);
>>   	up_write((&EXT4_I(inode)->i_data_sem));
> 

