Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06CF324B33
	for <linux-ext4@vger.kernel.org>; Sat, 10 Oct 2026 08:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791619749; cv=none; b=mhjifOPmaKrKzdDamtmUuEtOANUR4DrJD5BvUtkM4C9xYciruyiD8ZA+EvBJ4rVEippKDsCh2Zh+p+Jj/S7e7uCI8VuMfpaqw/m/6HOg6v1dp1xPvnFT9q/82LFpK9VrKWpkvUmN4LJl/HPfKxqIWbnaD3Vrq58ZNoghFwBTU0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791619749; c=relaxed/simple;
	bh=VyXzyhxXix2J5dcURdpKFUag11U6FjtFgNekV8QQaic=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HPSIdFDTbZfJIEyeuav4khxBZJKhKWPNQT9Dos4bt+e6VvdQ1KdBSwlEz+zn3Dbkz564M+7eNMoS6VhcGhfwjq4BbSnvHR9gu0Gsa7FbUbvIsTP/qke5YnOaUpsB9eI+iPKdlPqvvFUOnlWyZcxFItuW4BHHtdMpBEMd09+TgAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Klr9aXbV; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Klr9aXbV"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3ab62a8250aso210040a91.1
        for <linux-ext4@vger.kernel.org>; Sat, 10 Oct 2026 01:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791619747; x=1792224547; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EPdE1haLXtYmkfSNpDltFBKmBYf3c6eC0Va7uh1cwWE=;
        b=Klr9aXbVe3vGAOO1P9/JdzkUp9Iu21no8AgrG0ucrLEYhkGCOQmlGOhftGCoVS015R
         3ICbdHiLYv5IEhkttFcdpkxyVV9ZGNiDMPKqw7nV/a3/ifVNClluRg84PHl/2WGDKrPs
         9rnJhDRJDlNlxFgQSCiLjmD+lMNCcDvsUsoKZTHqY/85pgrTF2DZJetS53U/mCYkLAYf
         qyDvuNvECudr7Djx1pGzO4aBMXVCKJKhwD9IsQ2nsVk0mMQJIZM2y0Qpg2ZAEi6L4Nk+
         TcSuwyFEwCZYbttK4CvNu1xxPEzrXCxBeNgyJXusrpsQGxaaMBSVyWKiposbt2TYax9G
         Es6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791619747; x=1792224547;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EPdE1haLXtYmkfSNpDltFBKmBYf3c6eC0Va7uh1cwWE=;
        b=DtRJzacam3Rkpe3SrD8KuxG/DGvwXJpXJa3CnGKa5yldCNwk9eMAuUYqvrlwRAl8Bf
         PnuAoRu/gRRefjUGHalfIMTQfBiT6NvSDW//1fJozWY9WWikj/wxh1s+C+4ndEa2afPo
         MSiO/EmhLS1P5du7MjiC4O8pvB3tnWJb+BMK5wqQma7R4uv7GMMkKef75CvyJ2Ng/92Y
         xPMBrbynoMbw40pNoYijBOug19KimD6LGqujEk1UURyNXldTLWuaDgzVuYKLIsu5gO5g
         6ilugbcNxl7do6iCl7NkefhTUh6uebQHR63/GMWqjjHKEo+edRreDoRxXtu32keG6CNg
         Wrkw==
X-Forwarded-Encrypted: i=1; AKwUvBzdhPDxY26HinJe/9i1dWguwS7nk+zfmiO6Lr5OInixjLrtyOYjqLFfXrVXCxhlowLegOK4BfF1DklB@vger.kernel.org
X-Gm-Message-State: AFq9FYJIb5I3EXiDafXyIsXJQthr/6UhXyCEaQwSLyzOFoARjtL0GqYM
	fS+tmWIIPI9586Hezn+jF+yMoWuTe5hIHg4JNg0zLeWNirVNVtTXmowL
X-Gm-Gg: AYBFou0fnkdlg3lraIuyS/b4ufeNasyV4aZz/bTIQYRmaTKT76GBmdfJvjGc4IFeeIa
	m4OdBLjmOJYSCmsdY/dH6HW0sc5XWsT9M0V4q9Ws9Li6P+kDwPpJo92jG2nu9pXT5SUN+guBsVH
	WGBneENxHxnbGTa92XhsCfoLPgI0xAeE5Fxg95MQUg6NRBEglO3s325mlMiVkvT3LcYEM7IJhmw
	Ft9JUv4IdMPFTspE2YuK2FbZoR5ledF3CyD4/6ZFC3E0nJjJ2cHmw6lnh5XM+lhn1bDlmTpoxuD
	Bx4Kv1ovtfmFMxFxg4X9+PnYxCGf7+FlSM5IeQC5z42WonZVGoi0CxIOxD8bJGX/7rchsZWxOjO
	BPAPdFNpkJDL3I+PnjUKDmHuG0B0AljoO7AI4vmzkgFIiUf891SOItoa0lHvdTFQjd73HY3YvR0
	zbvqG6HLABXU46lTlN6hU/AP2Ge8thur6uP5ePgSDEWaJlh1KsR7L96vhAaPZN5/B3uCi0p+rFM
	X9/pUR6ee2HzT08jZQ=
X-Received: by 2002:a17:90b:510a:b0:3a8:e2c:af52 with SMTP id 98e67ed59e1d1-3ab3a93eae8mr3361522a91.24.1791619746698;
        Sat, 10 Oct 2026 01:09:06 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab371c32cesm6887768a91.16.2026.10.10.01.09.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Oct 2026 01:09:06 -0700 (PDT)
Message-ID: <fe737cea-e80b-401e-b03e-d2eacf7b7fb3@gmail.com>
Date: Sat, 10 Oct 2026 16:09:01 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 30/31] ext4: partially enable iomap for the buffered
 I/O path of regular files
To: sashiko-reviews@lists.linux.dev, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103831.2978767-2-yi.zhang@huaweicloud.com>
 <sashiko-outbox-165384@kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <sashiko-outbox-165384@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/2026 7:33 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Critical] ext4: NULL pointer dereference in pagecache_write() during dynamic fsverity enablement
> --
> 
> commit 3391a6fc6c975d43c433b32dd18bae4da4784860
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4: partially enable iomap for the buffered I/O path of regular files
>      
> Introduce ext4_enable_buffered_iomap() to determine whether a regular file
> inode should use the iomap buffered I/O path. If unsupported features like
> fsverity are enabled at the superblock level, the inode silently falls back
> to the buffer_head path.
> 
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index c3a6f3dce3d86..a07ce368e6e82 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
> [ ... ]
>> @@ -6076,6 +6098,81 @@ static int check_igot_inode(struct inode *inode, ext4_iget_flags flags,
> [ ... ]
>> +void ext4_enable_buffered_iomap(struct inode *inode)
>> +{
>> +	struct super_block *sb = inode->i_sb;
>> +
>> +	if (!S_ISREG(inode->i_mode))
>> +		return;
>> +	if (ext4_test_inode_flag(inode, EXT4_INODE_EA_INODE))
>> +		return;
>> +
>> +	/* Unsupported Features */
>> +	if (ext4_has_feature_inline_data(sb))
>> +		return;
>> +	if (ext4_has_feature_verity(sb))
>> +		return;
> 
> [Severity: Critical]
> Does this logic handle dynamic fsverity enablement correctly?
> 
> If FS_IOC_ENABLE_VERITY is executed on a file where the verity feature was not
> initially set on the superblock, ext4_has_feature_verity(sb) will be false at
> inode initialization. This causes the inode to be assigned to the iomap
> buffered I/O path, setting mapping->a_ops = &ext4_iomap_aops.
> 
> When the user executes the ioctl, ext4_begin_enable_verity() does not check if
> the inode is using the iomap path. It proceeds to write the verity descriptor
> via ext4_write_verity_descriptor(), which calls pagecache_write().
> 
> fs/ext4/verity.c:pagecache_write() {
>      ...
>      res = aops->write_begin(NULL, mapping, pos, n, &folio, &fsdata);
>      ...
> }
> 
> Because pagecache_write() unconditionally dereferences aops->write_begin, and
> ext4_iomap_aops does not implement write_begin (it is NULL), can this lead to
> an immediate NULL pointer dereference?
> 
> Since this can be triggered by unprivileged users with write access via an
> ioctl, could this be exploited as a local Denial of Service?
> 

This is a false positive.  An inode is put on the buffered iomap path
only when the superblock does not have the verity feature, and that
feature is not allowed to be enabled at runtime.  It is a ro_compat
feature set by mkfs/tune2fs with the filesystem unmounted, and there is
no in-kernel setter for it.

More importantly, the only way to reach pagecache_write() from
ext4_begin_enable_verity() is FS_IOC_ENABLE_VERITY, and ext4's ioctl
handler gates it on the same ext4_has_feature_verity() check, so the
ioctl is rejected before ext4_begin_enable_verity() is ever called and
aops->write_begin() is never dereferenced.

Thanks,
Yi.
