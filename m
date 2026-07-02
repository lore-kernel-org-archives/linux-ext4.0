Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3FC4C6F18;
	Thu,  2 Jul 2026 14:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783001546; cv=none; b=Egz90OZUu7alF1cNEUgKkIfQrUQrUJYUeDGKsTjv3eSwSzia8GJcqEwrQJEYmjXf6rUhOa3e8l0HVedVsb5+iyslkuWC5fyjG1NCc/TlWOiUPR+S7DL4EQgsf7X3zAk7gGk64JbEqNuw02c52AP2FmYb6qhuVO3T716t/DcRdpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783001546; c=relaxed/simple;
	bh=jPYYO3NVbYfP6Y+4papL2kzNg02s7hCZaO+i5E61E6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ypdd7qdZZK695vBw9VqApy9KIqbTDlTnZNKJNgrY+MG6mHd4PLWjSznlLdy1kTYD9W1eLEnW9rD7DbBZlujo72s+z0gecG7pa7xvIUdjm0yQjwoCkQ4X5C0tuWtXxOyppmC0Sc57p5g3Lzuqh6Jbc4TSxmXo11ijqpI7y8kMLdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=BMEE6ZwT; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ZW+s8XPk; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="BMEE6ZwT";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ZW+s8XPk"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 5ED80EC016F;
	Thu,  2 Jul 2026 10:12:23 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 02 Jul 2026 10:12:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1783001543; x=1783087943; bh=coSbwYrOpB
	B3901brZO/NXQPPPNwXDuYtBnjvYTPt4U=; b=BMEE6ZwT1ro8WwTgpeK8cNni0M
	jrNJXd5BAsf5xAp0KDKWec+on0jbgj7sbbqmDTxykCyJlUQwd9IGDhmjrnn6GwzB
	kOIolsqzNjBpgcxKpYE/U378TUk3Hm2G7GOmgwpDQPsrdNCtdF/jZn+M0PRSZAN3
	PKDS9r44inxN3M5F2naA4UxZL7h92qVmu1Hz7v55HNhpYCQ3gWQDTrukfesmcPnT
	d4GTXPU5uKzLwXuDKqfXLp4Wyxbo6VYysvpYlRO7jb+NWuSfCHkAuBhIsH+q0i3z
	lu6cLrIqiPklCyHcjDiMDgtskIUHkCUMnofXrji/qsawIYsx7BWFPttfXISA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1783001543; x=1783087943; bh=coSbwYrOpBB3901brZO/NXQPPPNwXDuYtBn
	jvYTPt4U=; b=ZW+s8XPkJ/wir8VWHYAEgbMYD4W2zGF78InKg7Zi1Q2hZ9OznJ0
	q2sl8p7Opj4BRlqs8H6QYi+nQqLIxHvVrHiMf924r30BJI2qxsFwdrkunZUimjnl
	xe53rCkrPEHYDYt6Jjub5YgHHvY1TkW0w/tqDItMGQUHFRfK/kjD40f8fAVQA0Q9
	c/h1zXdhbh540m2j/eF7AS3EaCrHIMVnEMLRLHaEVmNnJov+8MmMbXsmI1hJIJd7
	B0Vdv3SUpok+XGxuPj4HWmPrdcnVd+DM4rCS7Vmzl5XtzY1+kr0xOq3sm+54a7M4
	yK+Sm6ZDqb2P7RdvP/zJjndHkSpWHfxGZyA==
X-ME-Sender: <xms:xXFGauJvSszhvSQiYsgaiRrTPZK1L-k8_BpUPqbhalOsIr7NGjqHzw>
    <xme:xXFGasfyTNHc_w_SQmswqcilQAtNiPRSKHg0p98aEkmHXBRvWHByjvwks96OeEneC
    -E-xNWRfQwuj5IWZeKkV5-2s5BjjilebiG7ipDaVzBmLN9p8g>
X-ME-Received: <xmr:xXFGarZ_jrf2inIKgIGBiYLt0tgSiDF2SHo9PRI3N_ZuBURiPqF9qLbNsQG7pbGYRrid6f-DIs0ALMBoZwW55O8obQ>
X-ME-Proxy-Cause: dmFkZTET+D/tjVZsAcZ0DzRnd0uXFo6ya+rePbfHDXdxJfIDVXdZz/1Q3G6rMJ4DdTSFwv
    LSMaMQHg0ZJdBTCAs/cukC4O43oaWVhvvx1jkH/k033eAZgGet+tjvDgaq8FDV0rBAMAFq
    4WwLuTABhNE3DWHglRsHpkFkej3W17cflI5tbM1G0lwhoIqQSGwXURyftQzYesYQmJmLGi
    r+W6i7AwsiR6sLPWixIU9vVR05LVRGX0hNmVYw38b4bl5v6Vx6fiAyp4dGBtRMKJjwRaNA
    ivR/kUKIqe997JUx60vQj8e0REBtHSGrLmKJt7PHUNCrhYFLGLzql461WuRJYg5+/XN6tZ
    UF3Q8dF06YzF9sHEWU4fANkFhgj3+baMKlKXH2FviGBjJdTy85y+KHtM7fHH7W21UqX3TO
    j8hY7pxBEwwrG60lPwEvrlItcjYI75r+3/+PHQK1BHiHqGtCVYehhYSQQudwuZusAmlrPW
    OJDbJCxKRZ6mHZHjVB+XPtswxY+WVMD+ne0ZiTK7kkFigviZ9hoX2JUT3hmXOgNydfp3ja
    qeFVQzrTgKJ0Jeh8eFMlzKFd42ko4/rVJr10Tz2+rAzVp/z06QerjrD4ch9njAmTaw8oix
    eosXg5jLfVSR+7VrKhuE/neU/imUE/m7pXrY1lTu8CdQ8vA5ccKQSdlbR6uw
X-ME-Proxy: <xmx:xXFGaiBd6bXUFoZ-uYMuol-bXTUMGAyWWM3GJqbc5-yg0JPZk6Mslg>
    <xmx:xXFGauJtUM2ndUEewjel0BJvJZk-cOE0IFzLDdGj1i9REm0hSy085A>
    <xmx:xXFGapq6EV2jPzn79MJcuHVGxlvJBdH7RoXzmH6_WEMrKsMw0_rpAg>
    <xmx:xXFGanN2POZ0RSCvMSaK6ipgOhvBm5UC872MJjY7TViQAH4G8-AXpg>
    <xmx:x3FGap__ycv1UwttUjS7jJA5W-hEckD-y2Mut1wDEHNAjMbPTZue-pJQ>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 2 Jul 2026 10:12:20 -0400 (EDT)
Date: Thu, 2 Jul 2026 16:12:32 +0200
From: Greg KH <greg@kroah.com>
To: Wang Jun <1742789905@qq.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	libaokun1@huawei.com, 25125332@bjtu.edu.cn, Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: Re: [PATCH] ext4: get rid of ppath in get_ext_path()
Message-ID: <2026070211-stuffed-riding-d38d@gregkh>
References: <tencent_C982B0201FE8F041BD5B4FC1ED7D646A740A@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_C982B0201FE8F041BD5B4FC1ED7D646A740A@qq.com>

On Fri, Jun 26, 2026 at 01:17:21PM +0800, Wang Jun wrote:
> [ Upstream commit 6b854d552711aa33f59eda334e6d94a00d8825bb ]
> 
> The use of path and ppath is now very confusing, so to make the code more
> readable, pass path between functions uniformly, and get rid of ppath.
> 
> After getting rid of ppath in get_ext_path(), its caller may pass an error
> pointer to ext4_free_ext_path(), so it needs to teach ext4_free_ext_path()
> and ext4_ext_drop_refs() to skip the error pointer. No functional changes.
> 
> Without this fix, ext4_ext_insert_extent() returning ERR_PTR(-ENOSPC) in
> ext4_ext_map_blocks() triggers a kernel Oops, observed via SyzKing
> fuzzing on v6.6.142:
> 
>   BUG: unable to handle page fault for address: ffffffffffffffec
>   R15: ffffffffffffffe4  (= ERR_PTR(-ENOSPC))
>   RIP: ext4_ext_drop_refs+0x...->ext4_free_ext_path+0x...->
>        ext4_ext_map_blocks+0x509/0x53a0
> 
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Wang Jun <1742789905@qq.com>
> ---
>  fs/ext4/extents.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

The commit here does not match the upstream commit at all, and is not
documented as such, so obviously you don't want us to take it :)

thanks,

greg k-h
