Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9166248032C
	for <linux-ext4@vger.kernel.org>; Fri,  5 Jun 2026 07:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780646130; cv=none; b=X039yqdiBpNujdCOaHOqImQxFu7ql7pnDPlklLSLiL7xkd7TnqXbeA8BR63+daltvveTkV9vPuuIBjXj925VCYrzHBCx8zKTYTnuJP7ltOuUzRAJFwcHSKysHh51kizfmnWurKX3M9men028mjg2NAgGGVRe2WFjvFF8MbbfVe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780646130; c=relaxed/simple;
	bh=vzE9hWosgeWvwB76jStSWNnAVZ6FpemK28/nQda855k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IJpiwAsxZY0Jy+pTm57Hsm/dZLQBEFf7i1I3sY4uNaHVQzRPhWiI+L2Fu6oJfXFmnkrxOxOLYxIlaPVdJnUfBnW0TOgEBo8bBLu2bZ0lgc7vsaW42Qjmdca6pGnaCczCF4AWmNk4+BjnOcG0P4Fa3rbl9Vm5EvLyDqovVkvhviQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=yLlMcJ91; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="yLlMcJ91"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780646120; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=v0MJzfrab+O8JNPIGQ1YiBX0dP4CoNDO+ph8nJ25wQ8=;
	b=yLlMcJ91YdmeP7zLptR+XsJ95EWNtxDZpt7mzL12zZedY1VaowSdP+NQ5AZFpNT2fNkj2hWgT6nBwZlT3Zxy0Ss9xb3VAoXnUfOw2VLKVJHnBRgD3HsBJjnk57rPGYvsHa1BnUrD6/aFIN5jrz2HBwGIq19/LwdO7/sfFh1Vk8w=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R461e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X4CbzrJ_1780646119;
Received: from 30.15.203.183(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X4CbzrJ_1780646119 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 05 Jun 2026 15:55:19 +0800
Message-ID: <643ed5ed-5781-48e4-8742-bed0c86b1e9c@linux.alibaba.com>
Date: Fri, 5 Jun 2026 15:55:18 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 10/17] ext4: use fast incremental CRC update in
 ext4_free_inode()
To: Theodore Tso <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, sashiko@lists.linux.dev
References: <20260508121539.4174601-11-libaokun@linux.alibaba.com>
 <20260508233305.EB600C2BCB0@smtp.kernel.org>
 <h3n7jlfhyna64dn5o76qxcspnhxdddcs6crpxftmy7gnl7b3sx@jenszfpcsnit>
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <h3n7jlfhyna64dn5o76qxcspnhxdddcs6crpxftmy7gnl7b3sx@jenszfpcsnit>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/6/3 22:17, Theodore Tso wrote:
> On Fri, May 08, 2026 at 11:33:05PM +0000, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
>> - [High] ext4_inode_bitmap_csum_set_fast() corrupts the inode bitmap checksum if EXT4_INODES_PER_GROUP(sb) is not a multiple of 8.
>>
>>> -	ext4_inode_bitmap_csum_set(sb, gdp, bitmap_bh);
>>> +	ext4_inode_bitmap_csum_set_fast(sb, gdp, bit);
>> Can this corrupt the inode bitmap checksum if EXT4_INODES_PER_GROUP(sb) is not
>> a multiple of 8?
>>
>> In ext4_inode_bitmap_csum_set(), the CRC32c checksum is computed over exactly
>> EXT4_INODES_PER_GROUP(sb) >> 3 bytes. If s_inodes_per_group is not a multiple
>> of 8, any trailing fractional bits are strictly excluded from the checksum
>> calculation.
>>
>> Because ext4_fill_super() does not enforce that s_inodes_per_group is a
>> multiple of 8, a crafted filesystem can have an unaligned s_inodes_per_group.
> The reason why ext4_fill_super() doesn't enforce that
> s_inodes_per_group is a multiple of 8 was that a long time ago, back
> when Android was allergic to GPLv2 in userspace, they implemented
> their own version of mke2fs (and didn't run fsck on the file system,
> sigh).  Their MIT licensed version of make_ext4fs would occasionally
> make file systems that were not a multiple of 8, and this ran afoul of
> e2fsck[1] if someone actually tried to repair a corrupted Android user
> data file system (as opposed to just wiping the flash and starting
> from scratch).
>
> [1] https://sourceforge.net/p/e2fsprogs/bugs/292/
>
> This was fixed long ago (over a decade ago), and so at this point, I'm
> pretty sure any such mobile handsets are in the landfill, so we
> probably should fix this by adding a check in ext4_fill_super() and a
> corresponding check in e2fsck.
>
> 					- Ted

Hi Ted,

Thank you for your information and suggestions.

I will send two fix patches to synchronize the checks in mke2fs
with ext4_fill_super and e2fsck.


Thanks,
Baokun

