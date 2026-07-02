Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A399834CFC6;
	Thu,  2 Jul 2026 05:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782971245; cv=none; b=KnFBs2LfwThgjQ9kGyiJP9qwiu934xCG+/QYaYQ5BmI57swZSZKPgMY557Wh6T+h8mmu3Gx1MZnzaVSl5KuW5lzmSUs4YIuz12Oyav0HhRfZ+XiCM8SaMsIsd95t96RxcG0FAwcVh1/YrBtPASDnHk4ZcApZAX50hYZAVX8FNQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782971245; c=relaxed/simple;
	bh=u58r3CefMbAywJbaVku/oZhOab/Wjy2zxF+O+Ztw3lI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rqKg+n6BFrTcDdUST/gYMcxIQYAovH+UwnFwgwRbt+IIcWakTKA12L2esXWxinoIFQA2+Ug78a6U42CmmEFmZOs30S2wwCESon5QgBQFvmQtJ/ThbeeNY2CmivG8LThmZ6DvPTh2bUKYP4bMl1FXDh1zjUUU9iJZW/7gCgJE7o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWZ5/4fd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWZ5/4fd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7C21F000E9;
	Thu,  2 Jul 2026 05:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782971244;
	bh=sXso+4GBnuKXjYgPtf84y9cD9NZXvUOFXFxPwbxDSJQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=sWZ5/4fda5pFsq8jQYD188mc73tARPLECCMdEd4amk+BG4YwjPUCtaJRdvTp+Afz7
	 e9Ek8a/aQ2Qfm6wZoL6Nn78DawaCZzQhjPIQUcJ8rc4uLzd66/5f5/jHjzCk7DfzCo
	 TNMx3FUBxOd7RfRNU9AR94cNC9qo8fs8rkaSuGik=
Date: Thu, 2 Jul 2026 07:47:34 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Wang Jun <1742789905@qq.com>, tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, libaokun1@huawei.com, 25125332@bjtu.edu.cn,
	Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: Re: [PATCH] ext4: get rid of ppath in get_ext_path()
Message-ID: <2026070210-catty-grape-2568@gregkh>
References: <tencent_C982B0201FE8F041BD5B4FC1ED7D646A740A@qq.com>
 <2026062643-tamer-limes-a320@gregkh>
 <rrsgndgpxyrmu6okb43u6wkdaibbidlbyqgugeeijd2b44sf4y@6lzmm4v4xvdp>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rrsgndgpxyrmu6okb43u6wkdaibbidlbyqgugeeijd2b44sf4y@6lzmm4v4xvdp>

On Thu, Jul 02, 2026 at 09:48:33AM +0800, Jiayuan Chen wrote:
> Hi Greg,
> 
> Any update here ?

What is "here"?  There is no context in this email :(

> We rebased the 6.6 stable one week ago and also found the same regression.

What regression?  Again, no context :(

confused,

greg k-h
