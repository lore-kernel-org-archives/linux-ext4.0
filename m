Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8935821CC71
	for <linux-ext4@vger.kernel.org>; Wed,  9 Sep 2026 02:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788922641; cv=none; b=lafIUWbcuiDjCopAiZVuk4snyv24p+oTXA7xtf4mQO6ndwZ+wwLHJEHWf01yXu6Siz69msf0OdeJRya/Nq3J9wuRuLVSqm/hXmZ2xPqtlwc1QV1IqobDcBBWdwp4DSnCZ4heKAeAAxQWUwryLQMfmJH0S1b7O/ITyYLWtIkHx5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788922641; c=relaxed/simple;
	bh=SDIsZtWXAlpFzILuh4rrvFEddSS0AaxR+df4jaCKOdk=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=icI88+T0cPxaOwF+EpN7y0K9mEdM1MqZWuPRL/a0S8lvyjFmudbzjyMdMEHzWmHlOLA7T7gb8w70YA/X8AcoQiTwl+PBS0pQc7dC1rzkHBUFiskgu3bMJFf+Og62jYGI+aQj8rlgm+AO728YX1UIVk0IpsHcQ/C7DkUP5Iasfpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=vvTWOtbG; arc=none smtp.client-ip=162.62.57.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="vvTWOtbG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1788922621; bh=SK7Zy5Qw4XjZBwFeGJmEvTkajeIHlycVZ7XHhHgKjkc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=vvTWOtbGW/fW+KLXmE0LjWqvD9ayDJXQmt8kbvM2o8O7CE6sIlIDbj80VGtHDExln
	 qp1/bfLRlgNj3sbemBRDyf0XM8h/IiL28q6wlj1c9OCJ9pGwQhXWv0JVxyBpmiW2s0
	 Ivg7gVsjh9P6DwGtN87Z5WCIlPLrZ1id9KwqYrH0=
Received: from DESKTOP-AT5F202.localdomain ([183.242.132.32])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id E3A2C828; Wed, 09 Sep 2026 10:56:58 +0800
X-QQ-mid: xmsmtpt1788922618teyvk177w
Message-ID: <tencent_6DA35D78D35066882AE3C8AA6949D04B5606@qq.com>
X-QQ-XMAILINFO: Mp62enUr7azuBx5JDR3/T7eP5y2rnbrQUHhVzvBJGKvkeaILWzRGgBwVPWaDiB
	 ClAwTcKI1QJvtuZRag91Seo73QWsdQ2ejFg2zpvrq5msrVUwlEimoMdtMlyc3B3+5kitsvb5VBMF
	 efgJ7PSq5M4+693Qz4g6n/Tl/udj5m0aM8atVtm6xqHS/necDq4uiAeTgDiK0GZgPXBTpAr0RsNg
	 0pUBDxRh91ee/TMUzRQhtiNfM54WN/nx78excxik3WT/qdu3djIvkvvyKxAhsQBBjgazRK7/Rrcl
	 5CESox7C79yprGpql7IBhz3GWj1/M9wKWH571/8xk+L7KYJFlBmFujV4L3mOS8WQJ1yoNbbCQGOi
	 JWZ0bsUcELIs4Csn7huxHojcyx9WWoGF4J3A/8PPYMPydtknSlxpBEQpj0+2ced6rL9R16JT1Jl/
	 UmA5/1utb4hfcBq/lJmIuGlF8cch0kbTTLJjNcjmBPHhNlSLgIJzkTnXHEcraLZr6O772udemyfc
	 gC8ICqQZAgfI3B7VmMhdPb80ofSJOajkfGjZAnez4kENqbR8RfjzgN7sTqN0a/BylvAxnxAYNt4F
	 3VetPalwNgm6eNt63XF+24HpH2NFuDJ1F+79x+gXiux1Njc5Bjc2z8xiJz19D8oX9ZUQiG2HQVMk
	 2EAMW8ISQByJYFlvBvKmH42IfzdAIImLGUMQ5Vj6epVc/VM7raK/PQnPvrezLuKMJybqvBL9OTR1
	 KfWEoJ0fHriOfCqfa1Uo4TQQl3oj2CYp3mjyW6ir+CoGEK2Q4hsCYO2N0uGZC/Kusr5zr0W8UsVj
	 kNJEUzok1Md8cNiC89eVAFCfOv9Vb3dWQUUAuLaY3EhF3yIhIugdGPFKjSIroNt0A5CnOIXY4bqj
	 5uj7jY/7VUMNaMpwXw22AVhKcr5VaEccQr6rGzljxjz4eR6FNxwRsIwGWJG8luousQcEOCrf512M
	 xv/wUT5IfuR8YOKCGKGMDlcwivZDKUGKQvb31ti6BRxhpctlyrY7GAKBIr/MLstnN+VApF+RxAdm
	 OkXR/34kbvFBypCZdc05DceyCOvJvSh2Gi//bRiWFTTp/f98V7OfzX3bm1Pw3Q11lnmoDPwA==
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
Date: Wed, 9 Sep 2026 10:56:57 +0800
From: shuo chen <1289151713@qq.com>
To: sashiko-reviews@lists.linux.dev
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4:Fix the initial value of not_found in
 ext4_destroy_inline_data_nolock
X-OQ-MSGID: <aqDK-T5tyQOQ77kL@DESKTOP-AT5F202.localdomain>
References: <tencent_CD1AF9C3A7875C42F2187B57D74A1C5EE609@qq.com>
 <20260909012443.0E7A01F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260909012443.0E7A01F00A3A@smtp.kernel.org>

On Wed, Sep 09, 2026 at 01:24:42AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> 
> Pre-existing issues:
> - [Critical] The patch initializes `is.s.not_found` to `-ENODATA` but fails to check this value before unconditionally deleting the inline data xattr, leading to a catastrophic size_t underflow and KASAN out-of-bounds write (kernel panic).
> --
> 
> commit af434a75deba4ee29e45b41767340323974fc530
> Author: shuo chen <1289151713@qq.com>
> 
> ext4:Fix the initial value of not_found in ext4_destroy_inline_data_nolock
> 
> If a file has EXT4_INODE_INLINE_DATA set but lacks the EXT4_STATE_XATTR
> flag, ext4_xattr_ibody_find() will exit early without modifying
> is.s.not_found. This may cause ext4_xattr_ibody_set() to behave
> incorrectly.
> 
> > diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> > index caa51473207d7..4f02e7e9f5a30 100644
> > --- a/fs/ext4/inline.c
> > +++ b/fs/ext4/inline.c
> > @@ -405,7 +405,7 @@ static int ext4_destroy_inline_data_nolock(handle_t *handle,
> >  {
> >  	struct ext4_inode_info *ei = EXT4_I(inode);
> >  	struct ext4_xattr_ibody_find is = {
> > -		.s = { .not_found = 0, },
> > +		.s = { .not_found = -ENODATA, },
> 
> [Severity: Critical]
> This is a pre-existing issue, but does this patch fully resolve the problem?
> 
> While is.s.not_found is now correctly initialized to -ENODATA,
> ext4_destroy_inline_data_nolock() still unconditionally calls
> ext4_xattr_ibody_inline_set() without checking if is.s.not_found indicates
> the attribute is missing.
> 
> When ext4_xattr_ibody_find() returns 0 and leaves not_found as -ENODATA,
> this leads to a deletion operation (i.value == NULL) in
> ext4_xattr_set_entry() on a non-existent entry.
> 
> Because the deletion path in ext4_xattr_set_entry() ignores s->not_found:
> 
> fs/ext4/xattr.c:ext4_xattr_set_entry() {
> 	...
> 	if (!i->value) {
> 		/* Remove old name. */
> 		size_t size = EXT4_XATTR_LEN(name_len);
> 
> 		last = ENTRY((void *)last - size);
> 		memmove(here, (void *)here + size,
> 			(void *)last - (void *)here + sizeof(__u32));
> 		memset(last, 0, size);
> 	}
> 	...
> }
> 
> Executing this when the entry doesn't exist causes an integer underflow in the
> memmove() length parameter, which leads to an out-of-bounds write and kernel
> panic.
> 
> Should ext4_destroy_inline_data_nolock() explicitly check is.s.not_found
> and skip ext4_xattr_ibody_inline_set() when it is -ENODATA?
Got it. I will add checks and  send v2.
> 
> >  	};
> >  	struct ext4_xattr_info i = {
> >  		.name_index = EXT4_XATTR_INDEX_SYSTEM,
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/tencent_CD1AF9C3A7875C42F2187B57D74A1C5EE609@qq.com?part=1

