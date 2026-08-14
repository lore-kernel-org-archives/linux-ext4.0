Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DE1395AD8
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 08:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786696823; cv=none; b=N8qPRUjoDsFq5XgWZc8e3vstUoG1FQuYlnuQIN8nTF492c59H11zGCE8O1369WoI640svrGvwkepL7aElL+X0L763Up+eOiK5C/KYb/5AFxgLuo7pUq6TwRuReUhrNQiyPvXtZxZv+NoU4HlTivCmMNmBKyKqrrM4GVFHb/6soU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786696823; c=relaxed/simple;
	bh=gl+nmfWZ4OUErkRQr8/TrijPExg1vxMsKvipjLGW4YU=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e83/ACBvN6EH9xgX68hBNm3MrmQ0Jl8fZiooRJt9P6qOE/yfuUO8kd61yyFntFB0UjlzEWd4QOEUTxm5KepL1CP2c294TZWxbQwhZsI+O3obqlJ6Re7rSOKOWEX2TxjUPP4RaeVFyFJW0c8WdCzu2X85uk95t6nSekkYtc9qzY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=PiNOirCX; arc=none smtp.client-ip=162.62.57.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="PiNOirCX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1786696806; bh=MdMgdFnXZNjb5tS48nmSp8lbhMdc1NtY/+YCQ5FrCxg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PiNOirCXR2fOBo0YkAkO6+NjaINs5waL9V17S7meukBa8V6geCVUIMmxXrOW5EJmX
	 96zFzKVDbYeAc0YBvNcIXKM3F3+YtXLIvNir2OKF1+muirRTpY5CsKjKa7BuCqHMYt
	 lLenCdfE1JOtPp3kdxq4DZMPHY3pwJPcnptaKPlU=
Received: from DESKTOP-AT5F202.localdomain ([183.242.244.64])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id A0318A16; Fri, 14 Aug 2026 16:40:03 +0800
X-QQ-mid: xmsmtpt1786696803t1n0usvzm
Message-ID: <tencent_9121249A3171F5A424EC25B7912A3C794805@qq.com>
X-QQ-XMAILINFO: OASTJNHpK0KvaMJftleY1AN96cKTBxbprBxBv/sHewJY5rKIBlBuEoauUr+otW
	 s3U/ynm8towUK7ZiunLf/GM453qICClkWXL2RnDeaZcmIyelqyJw4UqsCPRZFv4klX/0UzL81EXh
	 GlTcvNhJC0KNbaufN21SB88cN3ZubrAi6lEKOCkVpz8OPVywOxpGsOQGJtEwMlLtAsAyil3/glN6
	 EsNVDiYoyiGWpuUW7b6SXkqqAzXe9o1J+wGaeDJ9bVrQOFj7z/U4xjw8/dakDWrLX9RQgff/g0Ok
	 bQZp/yRu+mhVozYgqO+mgFPjehdGEIeNaTtRCFFDWnfJzeQSLAQ9PnkipTMoji8gpsjyhlIDFzp1
	 lFdsICja+8spwatqaJX7PhE2soqNw4WZ+Duz91Mh1tka+q5EemuxQ24JDnaxbTYrKh6Zwy0eJq9d
	 TzdOohS4HGxBcxNQUKXllaKNlUaOw3GMv4Ox46t+xE+LCTNGfDcjvj7isPSHLYMRFPsLPwLUNH2z
	 1rWE+WjWnQARbbQp1CLsdJgXe8UFVpCmK12VzWS25VirJdAKrgWkrCfFeJ2XznUth2fK8EgSJ1aO
	 5+ww1NChVfwoxDHdjISL0blLNs55X+DCWoJa9BHDkVn40Ihr6UbnpSbrcCCe0PkhOEHo1P50FiHm
	 KTrqkMAkTizZSm1aS1aoGicKNW72+JQanQ/JMFtzfADP532DGr7poIvtDvQD94speQsJhktdDjWI
	 jDVFi+niKT6XJAHwupSGpuCh0+R919S1BZWygKUSu6SVWvljPai5VpZJnTEnvLsLU5W/D8g5bA83
	 mqLjZKBeKTEILmnsxKwfgioLIqtqxNVmFWDDCT1gm7Vq5xp+765UZh/UnVJoGHXs98pGjwVj+9tv
	 O1GxT14Iq0SpVKwme7EwjntHxQF2EPBAUIJxC0fd/Ha8M3RVQlwwMHpte4g3lDfFFffyHJfHjYEu
	 ZhuRyr6RAZ453LkKFzW3AIYNidEf3V68lrVy92tU0RyWNt3JpSw9SefBJlYH62/TrfKZ3LgC+mem
	 Re+e4XbO9+NEPkNgElGJhkEzK2LlJTMZYUmBqoWr5u5BRMNUWptiTBJDDQtRc=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
Date: Fri, 14 Aug 2026 16:40:02 +0800
From: shuo chen <1289151713@qq.com>
To: Theodore Tso <tytso@mit.edu>
Cc: adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH] Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir
X-OQ-MSGID: <an7UYmbju_ovlFwM@DESKTOP-AT5F202.localdomain>
References: <tencent_321031C6B9D5D092C8978B46D9F0BBA18607@qq.com>
 <an5_shcksPF6uIaW@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an5_shcksPF6uIaW@mit.edu>

On Thu, Aug 13, 2026 at 11:31:03PM -0400, Theodore Tso wrote:
> On Thu, Aug 13, 2026 at 04:33:57PM -0500, pipishuo wrote:
> > After a failure in the route ext4_restore_inline_data ->
> > ext4_create_inline_data -> ext4_mark_iloc_dirty, the inode will still
> > be considered as having inline data.
> 
> How did you run across this?  Was this something that was actually
> happening?  If so, what was triggering the error?
> 
> Or was this something that was found via AI?
I didn't have a reproducer. I was reviewing the inline data error paths 
and noticed the interaction with ext4_readdir looked fragile
so I attempted to make it more robust.
> 
> I'm fairly sure this patch was created using AI.  This useless
> inclusion was a bit of a tip-off:
> 
> > +#include <asm-generic/errno-base.h>
It was automatically inserted by my editor's include suggestion feature,
and I missed it in review. That's entirely my fault.
> 
> As far as the fix is concerned, there's a much better way of
> implementing the functionality in ext4_restore_inline_data(), which is
> to just capture a copy of the inode (since the inline data is stored
> in the inode), and if we need to back out a failed conversion in
> ext4_convert_inline_data_nolock(), we can just copy the old contents
> of the inode back in place.
Because ext4_convert_inline_data_nolock() has already called
ext4_destroy_inline_data_nolock(), the inode is no longer in the inline
state. So we need ext4_create_inline_data() to rebuild the inline state.
> 
> We can also do the conversion in a much safer way, by allocating the
> data block first, and writing a copy of the data to the data block,
> and only if that is successful, do we update the extent tree or
> indirect block mapping in the inode.  Of course, this would require a
> rewrite of ext4_convert_inline_data_nolock(), but this would allow us
> to fix up the other aspects of the error handling which is not quite
> right. 
I agree with your direction. I'll take some time to study the code 
and work on a proper v2 that rewrites ext4_convert_inline_data_nolock()
following that model.
> 
> 						- Ted

