Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E241A0BD0
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 01:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786670871; cv=none; b=FubuzzwiioWCq+haQawq4uoP166YMORrL//VPAX9v5zj7+0DL5I753oaRSq9FlCBG17VJgdX9xq/W7DuhTgOksABoMN9fj/IoftpcjN4uIKKncXksNITB1rEGP3yXDMqMy8yCmn+f8QLO5a1ofFbb4/BJkiIqFvAcoKOCDPUWHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786670871; c=relaxed/simple;
	bh=re1ofY4SLgKxLAxXhI9BYqr9jXY8ist671nHBA3jxIY=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SBXxUhTPY/Txa4F9psbrAM7THQ97kp9OQVH8paSHVih73W9lVT3UV1DjQ3DTbbKa8p+Tfyj8YPdl7hHEhS77hbYfQp5JQfDr7heEQvI1ZlCxKyAYRx57oDWbzhLz2RytiFeGWBENf4weH7p6p7SuVLMgt4JKtluPlgCvDOdBqb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=kASfaSwU; arc=none smtp.client-ip=162.62.57.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="kASfaSwU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1786670863; bh=fMWJMIbuUGfrVNWK+RV8WFnGvWI+CSLj7XQpsHf4cMY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kASfaSwUBAtO6ouqK02TnjLJWCoO4mtKNSU5X5OdOsMZI06rrTdDmUByLe9xEwfI5
	 bvfAAantDQ8fJBOrmFeYVQcnKq9rS6IxOz7xRUgw4UvzMh6ODFvC0twrcn96onHTEj
	 n/h0pxEJSZxQma9lx+1/aIDTTqEWCSTHT6xksWC0=
Received: from DESKTOP-AT5F202.localdomain ([183.242.132.32])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 6E91B84A; Fri, 14 Aug 2026 09:27:41 +0800
X-QQ-mid: xmsmtpt1786670861to8jriz4i
Message-ID: <tencent_4EE770A921BB900D4682559792D797A04607@qq.com>
X-QQ-XMAILINFO: Mc9HrrINmkVjaaL6BOIpPQ4c0aGo0fAdGGktrNlMG4+xyygSnVg2kz4LRgMILp
	 DGKSOvUAe55pV3wHF1Sjk5oteTGA6GxAzuaGB+o+d8VqeeOI8MoYUjTGEkqk4MPbYNthzBLXPTK8
	 D5/KimOXMbduNURDFPE2SFmbTezoNmLwKzAhArDSV70eIQ8fmIln1tmKxRIYSoc+uoD+8WlF8Bfo
	 I/cTxhrL5NTC+mcyy4wKliLJPLLPWoPWksJhfiZAwgn7OAqcBRTQ5SlNFfddAQ14t5Mq6EhNpM3+
	 /zZb2aK30a0bccIz767u9kFEUGEvkmqvmb78eaauM9UreG+IcDm2cxQlOQveS4OTfCuRqTVYP6Pn
	 D2EeYv1vmbnRwpGm8GY23Nczwi3Tmgwq3yegQo+Jrvxq1fbqWkHlo+S5A3JcM61l00Nyu1SSsGmf
	 4oETpVWu4D9s/ehwG1g7HfUBM1g7vlCGa/tvZjweJ9csguFdG4dTUczgJZm52I9aclDZfCfCrn/Y
	 /nBXSgv1AlND0ynnNVDtHTbfvSHAjOlBGcaeq/0k0kvFQDDQnRICj+I4uSXooZ3ODJCQGS/rS3Q0
	 +slJOkmjIt/dxTZcxRaRdvBdqKU39W4z3ZJcZybXSPhOYgCsDSU9TfDjfgDe2iBiyOCHp3bmgkZy
	 bZPX/N9hTqRlEsUSWZfqu+3Mkrx1rw1OShdixXwlJdT/6yFbIxNk4b8E6WwS1LzaIbDRFk3+qW9h
	 VboVR43T6a40V8yefiabK6QS4lCcnR+OI14MVVgvlArlEvXWssWaf811x0iEoGDCOlUa4ixdA0Z9
	 lnmHiAf8Pyvc1+0ny/dgmAqYQc30PgFBFO8O4Is823e/Y5cFUOClG7aynbM73LbWz9Z9FQyNF19x
	 X4UpjW0A8vIGmBAGbRhBmup9NHooyuVu7d595hfH2uI+NXPamWxRCR+upSYvKTTltYcPgYgSRb+X
	 6kv5c3LOZx7yoTPQdNqNTYhBvH6HQFhtuvxa5XsdhFfj9LtpcfFtdbo5O3h1H7+oWPN8Nibm+PoK
	 JKly5xJw3vT0qycgVqwDLBs3ZUg2ySevl1FmAZAJOHlnTxtWQu4/BImJsvV3w=
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
Date: Fri, 14 Aug 2026 09:27:41 +0800
From: shuo chen <1289151713@qq.com>
To: sashiko-reviews@lists.linux.dev
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir
X-OQ-MSGID: <an5vDS7rxoKVKzC_@DESKTOP-AT5F202.localdomain>
References: <tencent_321031C6B9D5D092C8978B46D9F0BBA18607@qq.com>
 <20260813084928.3BF531F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260813084928.3BF531F000E9@smtp.kernel.org>

On Thu, Aug 13, 2026 at 08:49:27AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Returning `-EINVAL` from `ext4_readdir` on a corrupted or inconsistent directory state breaks userspace expectations and bypasses filesystem error handling.
> --
> 
> --- Patch [1]: [PATCH] Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir ---
> commit 419471105d79565b3d6563ce7e941b266526160b
> Author: pipishuo <1289151713@qq.com>
> 
> Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir
> 
> This commit adds a check for EXT4_STATE_MAY_INLINE_DATA in ext4_readdir to
> prevent reading incorrect inline data if the inode's inline state is
> inconsistent after a failure in ext4_restore_inline_data.
> 
> > diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> > index 8d7b81e6948e7..857cf02742c0c 100644
> > --- a/fs/ext4/dir.c
> > +++ b/fs/ext4/dir.c
> 
> [ ... ]
> 
> > @@ -160,6 +161,9 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
> >  	}
> >  
> >  	if (ext4_has_inline_data(inode)) {
> > +		if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
> > +			return -EINVAL;
> > +
> 
> [Severity: High]
> Does returning -EINVAL here break userspace expectations and bypass the
> standard filesystem corruption handling?
> 
> If an operation (like ext4_convert_inline_data_nolock) fails and leaves
> EXT4_INODE_INLINE_DATA set without EXT4_STATE_MAY_INLINE_DATA, this
> indicates an internally corrupted or inconsistent directory state.
> 
> By returning -EINVAL directly, this code bypasses the standard
> ext4_error_file() error handler, which prevents the filesystem from taking
> corrective action (such as remounting read-only).
> 
> Additionally, returning -EINVAL from a readdir (getdents64) operation is
> typically interpreted by userspace as a buffer size issue, which completely
> misleads tools like ls. Should this instead invoke EXT4_ERROR_FILE() and
> return -EFSCORRUPTED?
Thanks for the reviews. I'll address all the comments and send v2 soon.
> 
> >  		int has_inline_data = 1;
> >  		err = ext4_read_inline_dir(file, ctx,
> >  					   &has_inline_data);
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/tencent_321031C6B9D5D092C8978B46D9F0BBA18607@qq.com?part=1

