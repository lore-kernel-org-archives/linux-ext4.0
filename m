Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D5C357A25
	for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2026 06:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158115; cv=none; b=KEbeVDnjR659DRvrbTvTTqiVRFwTnw52uQ2I/TK3wTZnLiHE89QU8CqMMN+JD97cXOGzy/U6in7+DFGJHaw/iyQYnfXa5H1aIYGS4JLOfhqSC2Axn8Mij2a/ikS5Ai06vi2OMh9Rd9UKyocvB4XBsK+IBm+hr8wyuUtjcoK6b/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158115; c=relaxed/simple;
	bh=IXx4Y7dXA3GvLFQrNKzZm2XFS1dlrXtZhK3rbsyotYU=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b80scFcBpCMKWgSe4NVwA3sTVi9f1pmRP874RQplySmTBKJ4MUSgGTHcAHOaSMKLgebDWljpAqF33udYVt40GE5RFwB39nd+YvGspiRtPdhYK1md/4PQ3uUh+TliWnihsPZfjAzIrOw5NYsSjjNTfEABEPwTGeVe1hEbFYpDSWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=EKP+0ISX; arc=none smtp.client-ip=162.62.57.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="EKP+0ISX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1788158101; bh=Yw0CCCrbuCRVyeIgXOLbfQYWLNsk4nYhvK9+RSWx7p4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EKP+0ISXgfDnPsPKRIHgRO238A0sPuJkQcjLurhiIX8uOzY5TwddF2RzjFwUosl+E
	 0VRJzDsRdVYuFH67iiLzDyWTXgwAGwFYYJhKs4wYm7/UjGfubulTGN/EDjM7s1ZgBX
	 tu1xc8vbbK130/O1aqLy+Onq/x542WvRQahbS5jI=
Received: from DESKTOP-AT5F202.localdomain ([183.242.132.32])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 8BA9D466; Mon, 31 Aug 2026 14:34:58 +0800
X-QQ-mid: xmsmtpt1788158098tp7jrshev
Message-ID: <tencent_8756434A305EF41A89C387860E424A199709@qq.com>
X-QQ-XMAILINFO: NuZcuqAyFajVpku28UFTELjRBqmKH83+VXiEgNq+fCffOHaeHYO85XTwq9Qfb/
	 wSjcbpqbg6/mM3sboIAaGosf7s1smwUgmp9PAGLkwa70P9sWfoujVtHgMVTPnmTj2OaScTYI7kYF
	 RdolfjhiX7hZh050d/jtml72XrATK1JdV4hVpTV9hqJOi0TD/Lg+uuPFBpZt6hCQzFhdsxWKr2xE
	 TXCpO8uHxucEPhK9rjv/5gArykl5QCLFzEkN6UE+Wx9olCszbZxpSkyWBP91X2GqdUvXzJVwMqwO
	 PY9G5guyq24BuqMm12uJhReMKjGsF+R91ROTxXSm1/v/W63zjSwJNgAWFbXmIdoRx+tItrm3xzeI
	 ZOslz7Vwt09U7xFEj1RmNoIr06sfor09BcfBOSLvzSuxr35N+xFwSGms26WjM1x5dFmPVxuL+pDZ
	 49LbXVZwnibEhccEGgHi/e1btGKnyrkc+li8l8coL2+yP77zlfAb0UZPCTrYTqZTMMAcOHXZhRDS
	 Xwv3h21U1Uov6BNiEasImf7QuVC5Qru1Oq9Ge6b0O5Ww9Pt2Er6DbicG0f67XK6gVT0VS2GbMeAK
	 cXMpde+DCIrDUAe2cHV7MBGc/SRY7jbQ1SfLRYxcLmQBk92RLHa6Fv7iLmsK+FZukK/bqX6OyyWC
	 O4R+ffS7WVh+WZxoIAyAEPY7QyHPU0M++KuC7F0s25D/4IImniuRKA19w1kkILmZ+2VQy38si2cu
	 ybN8kHE3lTk7CNbND5TBeTF3cIvxGFgeYswEpcEQQ5EQlPInfJU50IeAcEslVXrykHMnVOIkOa2m
	 1DcJEewsF/ohX6o9A9JhCJ9HCIoOqEy0i19TXa3jree3dQD7mwDAWghQprQ3jc2fAkOiGYZW774v
	 7kko0wxOhZhUBGEVqp7fnrTmkbSrdTBtgIxqZ9kth0nBeLdO7A5Ok0rcA2Zj1N1+ONFh9JW8+YS6
	 sP59FtUU4qFuqLVScIM0IJLGPaas/xHOvnZLICkcrH+BKhVTe3XFcUca508p/S18sjQfw/inqhUu
	 RlHPEbVUWPEbXSC6KASXSlhpuShcmR0SW/GDM/hizT5Qc3Z2G6xar44e1oQffEyHofAeH3NQ==
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
Date: Mon, 31 Aug 2026 14:34:58 +0800
From: shuo chen <1289151713@qq.com>
To: sashiko-reviews@lists.linux.dev
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v4] ext4: rewrite ext4_convert_inline_data_nolock to make
 it safer
X-OQ-MSGID: <apUgknX191x5FE-n@DESKTOP-AT5F202.localdomain>
References: <tencent_DBADB12BBC6D88300488F16E75A384FAE505@qq.com>
 <tencent_54332AAC969648BF78341E85930FE984D80A@qq.com>
 <20260831023455.02F981F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831023455.02F981F000E9@smtp.kernel.org>

On Mon, Aug 31, 2026 at 02:34:54AM +0000, sashiko-bot@kernel.org wrote:
> [Severity: High]
> Does this error path leak a reference to is.iloc.bh?
> 
> If kmalloc() for xattr_buf fails, the code jumps to the error label which does
> not call brelse(is.iloc.bh). Since ext4_get_inode_loc() pins a reference
> on is.iloc.bh, could this result in a permanent buffer head reference leak?
Got it.
> 
> [Severity: High]
> Does hardcoding the extent length to 1 leak extra allocated blocks?
> 
> In ext4_convert_inline_data_nolock(), ext4_mb_new_blocks() may return a
> larger extent due to bigalloc or normalization, passing the total allocated
> blocks as len:
> 
> fs/ext4/inline.c:ext4_convert_inline_data_nolock() {
> 	...
> 	newblock = ext4_mb_new_blocks(handle, &ar, &error);
> 	if (error < 0)
> 		goto out;
> 	allocated_block = EXT4_C2B(sbi, ar.len);
> 	...
> 		error = ext4_set_inline_data_block(handle, inode,
> 				newblock, allocated_block, bh);
> 	...
> }
> 
> If multiple blocks were allocated, the remaining blocks might be permanently
> leaked since they are marked as used but not mapped to the file.
The remaining blocks are stored in i_prealloc_node.
> 
> [Severity: Critical]
> Is it possible this overwrites the error code from ext4_ext_insert_extent()?
> 
> If ext4_ext_insert_extent() fails with an error other than -EDQUOT or
> -ENOSPC, execution falls through to the ext4_xattr_ibody_find() call, which
> could succeed (returning 0) and overwrite the failure. This would cause the
> function to proceed to the success path, clearing EXT4_INODE_INLINE_DATA
> without actually inserting the extent, potentially leading to data loss and
> a block leak.
Got it.
> 
> [Severity: Critical]
> Does this recovery path miss a call to ext4_mark_iloc_dirty()?
> 
> The code restores the inline data into raw_inode->i_block and clears the
> EXT4_INODE_EXTENTS flag, but doesn't mark the inode dirty. Since
> ext4_ext_tree_init() previously dirtied the inode, it might be written to
> disk with an invalid checksum and the EXT4_EXTENTS_FL flag still set in
> raw_inode->i_flags, which could cause metadata corruption.
Got it.
I'll fix these issues and send v5.

