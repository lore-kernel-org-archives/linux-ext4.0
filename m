Received: from out162-62-58-216.mail.qq.com (out162-62-58-216.mail.qq.com [162.62.58.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBAA385D9E
	for <linux-ext4@vger.kernel.org>; Fri,  4 Sep 2026 02:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788487646; cv=none; b=uU66doGx8dLlWJnxP0jvWbY1ZnqRGLoId/vmxEGdWox8OE9VI3A32rHmh8M5bv2t/bZpYkk04+XynUhlSoUYTdlUnaj70C9dOPcfo6kdrNzQKsIbWWRW5t4cJH5Fh9JY9btgCFkQPakIGYj2mJVmQY9vKphWfHlPungwv7CMsxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788487646; c=relaxed/simple;
	bh=/usv0M9ON4gEcbPXu04wspLUvbZ9ED7JzEdRTpfgqMY=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O/mGlwYrGmGYAhdKX1aoLcZe4roSllyC9ZRbd78sKIDWpnRNhDfiRCP8Ng9LpDezqVaRbljMyQoVaMHTt/uk7kt6usSjKv1OVRmfmtME58vTPQwhK4u3CgQwUoMwr7gDtmEiRdIos0T/BafWM9LCAPWe7gVwSCCYdyr7Y5QNDH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=qsL9SInf; arc=none smtp.client-ip=162.62.58.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="qsL9SInf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1788487633; bh=C8ycuz886UciVQ1/7YL6A1EfAASJCUtMC9jmmAELh5c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=qsL9SInfTxazViFXnyOwMyvXLFwnud1q2Yy25WFV3cz/kG4/cPFEVqYg9lEwdYP3/
	 pYVyOAzSDQEj9FZPMPTD1fCPM3uk2DPbJzME6llTRIdMDMomJZi/GYa7Cxtw6UrfRP
	 u0y6kE/7KJdLgVS20bQxqiIUWzkv32PNaDPuk9EQ=
Received: from DESKTOP-AT5F202.localdomain ([183.242.132.32])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 1821DA6F; Fri, 04 Sep 2026 10:06:02 +0800
X-QQ-mid: xmsmtpt1788487562ta5e8irxs
Message-ID: <tencent_C4778C64AB2025042F0F8DACE17843752108@qq.com>
X-QQ-XMAILINFO: NCkMfDbncK88D5FX62okEeIHIvOEXCqeMP4mg7GUuiX6gtWZyKQxhpP22St5z9
	 qjG0CgWaWVyjvj67DJnZSyzDBM8Y6Xd52+yW8ZZMxCPiA3nnDM3bHk7p+fi8uog+L5Ir+9oTyCPU
	 +n2zDLnJiPauVE3YrbJ9iLWmmNwC1MZPgNMRjMKYAXqqvZpsPovpIa256/+yEfs9uG6Rvdnc9RNA
	 7srPSRv3hN42Tntw8mGtWogDH4J79+zwW6aK/tPVEaLPmaVcgFEr6rzb2n6dl7dFElTQUA/336xf
	 pkVrXJglMVHvRTOfN1ItGFF6QExi4QW6fYYe2gWQgBWxP7pkSRHtBffhMnJNEySrVX+giJ7LZtDy
	 E+dUr51JdGUMZVayvP3o7SzHbfrHRNtDCao4e+8PS6Kpe5j+RkUuGUGQhi0OV6nU6r41zsCYVdGw
	 eWQz3l07xaQRtXva/u8YayS9wmyPpY+dcRKMbkEB2ogk65mZfyEPJi+gVwM1m3ZycWkcaoHIPUdg
	 B8LrPJzenDd+n7cU84OhvCVsxwkdSM3fkAyzFdBdu41uqMDyN9AzaPy0j8XDetnhp3ixWyYWXBdF
	 mJB+0oSM8GUqHMR9j0CXAYQf+v6uizqSJ+GlHjUAQku6o0/J5UAEUJNBizhgKftWrG8sryt2W/Zt
	 QG0HEgLc/9/U3kDS/yh6hK/9GxFMUnVcWrnEoR/h8qCR3zfXTrC6Q+GM9xhTKj9eEbnYX3kXhy56
	 FMMW7CRNtjQqoEmi1JEj4xttkrh+RISDMQSFirSbKYoJ3mJpzY2KzduaQATZD9LNQ+3XFS8NC3+F
	 l5///qT+maXXglJ/3Tv/anFyeyz9fhDf0rWwI88AMUv84qZCMOnB6lWg4TWsX/1O6tc2v+wN2qhK
	 UTyDD8jDc1bkIkxTu6uhvsI8ExhDMOium5jz0UQvqVE30+GZQXaVzRe4SWvV507L72velxbQERld
	 FbXNKBlwp48cCWvU3m0jCC/UGCTt//78KtXLTykaCfz9vgFrKmqnmWmfMOt28lrp+pTYGaYkHEDf
	 ywOCY99m1EjolBggn5kCl3feA6c/CuYpd9Psm3TkRhRhcAXiZE
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
Date: Fri, 4 Sep 2026 10:06:01 +0800
From: shuo chen <1289151713@qq.com>
To: sashiko-reviews@lists.linux.dev
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v6] ext4: rewrite ext4_convert_inline_data_nolock to make
 it safer
X-OQ-MSGID: <aponieVkWaPYQ8GZ@DESKTOP-AT5F202.localdomain>
References: <tencent_93CC3232AC6A9418BCE4372286770F91850A@qq.com>
 <tencent_3656CB4AA45EA01A8DC2B9865242BA18A709@qq.com>
 <20260904014637.BBEE01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904014637.BBEE01F000E9@smtp.kernel.org>

> [Severity: High]
> Does this hardcode the extent length to 1 block, potentially leaking blocks if 
> ext4_mb_new_blocks() allocates a larger contiguous extent?
> 
> In ext4_convert_inline_data_nolock(), the actual allocation size is captured
> as allocated_block = EXT4_C2B(sbi, ar.len). If the allocation request returns
> multiple blocks (for example, on a bigalloc filesystem), only the first block
> is added to the extent tree here. The remaining blocks appear to be neither
> mapped nor freed, which would leave them orphaned in the block bitmap.
This is a false positive. The remaining blocks are stored in i_prealloc_node, 
so they will not be leaked.
> 
> [Severity: High]
> Can this error path result in a permanent data block leak?
> 
> If ext4_ext_insert_extent() fails with an error like -ENOMEM or -EIO, the
> code jumps directly to the no_free label. This deliberately bypasses the
> ext4_free_blocks() call just above it. Because the calling function relies
> on ext4_set_inline_data_block() to free the newly allocated block on error,
> bypassing the free operation here appears to leave the blocks permanently
> marked as used in the filesystem.
If the error is neither EDQUOT nor ENOSPC,freeing blocks here could 
lead to a more severe error.See the patch 
"avoid infinite loops caused by residual data"


