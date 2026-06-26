Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C843ACF05
	for <linux-ext4@vger.kernel.org>; Fri, 26 Jun 2026 10:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782468647; cv=none; b=iTJybt5nyDtWiLrUouR5jyJeiHjpZUeQCmIcUuXAAEQ5fy/eUe1QUQDT87/u5l4d2RYD2qIlWRUvDSbppQUuGWOfI6SmRxkVIDnmUAKdq9xxIgsTPRZh3MRwJYb5nyFZQtojeNDLkl+eF1rjTddXytUngkxoEm40KXsFGyOymD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782468647; c=relaxed/simple;
	bh=In609y8wiB9Igiw93tYhKPDLXXbh2sIdVHslX2oPt2k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=raG2m5F3Jicn3Qbi2/g2kPmHxGDfmxR/o08og2hBwGV0+Gu0dVnT8LsRDpZ1pJKdrn9IUcm0mbEM9ZdSZH6fy8R4QrQyxQGdtbT+FVGMHWMuN7a6UOGb7UwEQrARpfSdu0H7MIRggx+wkLbMRWUriciqC+R7uhsmQt6Jwba2k+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ZMnPWRf9; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ZMnPWRf9"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782468641; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=3QLH0rG8v8LotA8W6RSWbfUmmujFyeY8tdl4kIuYy/g=;
	b=ZMnPWRf91Aw9bnvohkruvwBR+4Wo2MHP4hgo+mpUGGRJZh0z6BVn4yMkiYAfjOXZxrBI/l65xo+uds6Ewte1fd7iw/W+5F5TIBkUmPo9A3fcHkF41RFdAJXdjhkod2NtHdj/HtRrscmZuKeo9KoAYoxSYSwNnaIeohwF2/fAfpo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R531e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X5eZcwl_1782468631;
Received: from 30.221.129.204(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X5eZcwl_1782468631 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 26 Jun 2026 18:10:41 +0800
Message-ID: <a5ab0b56-85c0-40cf-8610-9bd044dcbd55@linux.alibaba.com>
Date: Fri, 26 Jun 2026 18:10:31 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/9] ext4: improve EXT4_GET_BLOCKS_CACHED_NOWAIT
 handling in ext4_map_blocks
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: tytso@mit.edu, sashiko-reviews@lists.linux.dev,
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
 Zhang Yi <yi.zhang@huawei.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
References: <20260626083518.1064517-1-libaokun@linux.alibaba.com>
 <20260626083518.1064517-7-libaokun@linux.alibaba.com>
 <20260626085003.BD4BC1F000E9@smtp.kernel.org>
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260626085003.BD4BC1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2026/6/26 16:50, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
>
> New issues:
> - [High] Encountering an invalid block during EXT4_GET_BLOCKS_CACHED_NOWAIT causes ext4_error_inode() to block while in RCU-walk mode.
>
> Pre-existing issues:
> - [High] check_block_validity() is bypassed for unwritten extents because EXT4_MAP_MAPPED is not set, leaving the filesystem vulnerable to arbitrary block reads.
> --
>
> commit 16a7856d68391995dd0a737adac6e20b3e6ddb76
> Author: Baokun Li <libaokun@linux.alibaba.com>
>
> ext4: improve EXT4_GET_BLOCKS_CACHED_NOWAIT handling in ext4_map_blocks
>
> When EXT4_GET_BLOCKS_CACHED_NOWAIT is set and the extent status cache hits,
> ext4_map_blocks() returns immediately without running check_block_validity().
> This allows malicious extents from crafted filesystem images to bypass
> validation if they have been cached by a previous blocking read.
>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index a60ecf0bebd04..2479f8d93ec8b 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -759,8 +759,9 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>>  			BUG();
>>  		}
>>  
>> +		/* Skip blocking operations and jump to extent validation. */
>>  		if (flags & EXT4_GET_BLOCKS_CACHED_NOWAIT)
>> -			return retval;
>> +			goto found;
> [Severity: High]
> Can jumping to the extent validation cause a scheduling while atomic BUG?
>
> If a crafted filesystem provides a malicious extent that is successfully cached,
> a subsequent path walk in RCU mode will call ext4_getblk() with
> EXT4_GET_BLOCKS_CACHED_NOWAIT.
>
> Jumping to found executes check_block_validity(). If the extent is malicious,
> this calls ext4_error_inode(), which can block:
>
> check_block_validity()
>   __check_block_validity()
>     ext4_error_inode()
>       ext4_handle_error()
>         ext4_commit_super()
>           wait_on_buffer()
>
> Since RCU-walk mode holds rcu_read_lock(), will blocking in wait_on_buffer()
> cause a crash?

Ah~ not doing check_block_validity() now will directly use potentially
abnormal extents, but doing check_block_validity() might sleep in atomic
context. It seems that validation before inserting into the es tree is the
thorough solution.

> [Severity: High]
> This isn't a bug introduced by this patch, but does the extent validation
> actually check unwritten extents?
>
> When looking up an unwritten extent in the ES cache, the flags are set to
> EXT4_MAP_UNWRITTEN but omit EXT4_MAP_MAPPED:
>
> ext4_map_blocks() {
>     ...
>     map->m_flags |= ext4_es_is_written(&es) ?
>                     EXT4_MAP_MAPPED : EXT4_MAP_UNWRITTEN;
>     ...
> }
>
> At the found label, check_block_validity() is only called if EXT4_MAP_MAPPED
> is set:
>
> found:
>     if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
>         ret = check_block_validity(inode, map);
>         ...
>
> Since unwritten extents skip check_block_validity(), could an attacker craft
> a filesystem with an unwritten extent in a directory pointing to critical
> metadata, forcing ext4_getblk() to read those blocks and leak their contents?
>
This is a false positive:

1. Symlinks cannot have unwritten extents. ext4 only creates
   unwritten extents via fallocate for regular files; symlink
   data is always fully written at creation time.

2. Reading unwritten extents does not leak stale data.

3. Writing to unwritten extents triggers re-validation. The
   unwritten-to-written conversion re-maps through the full
   ext4_map_blocks() path (without CACHED_NOWAIT), which runs
   check_block_validity() before any user data reaches the
   extent.

