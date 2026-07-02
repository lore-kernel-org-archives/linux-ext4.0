Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48442C11F9;
	Thu,  2 Jul 2026 01:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782956929; cv=none; b=QVcLZnKhsLhrLdhtx6p5mK2Ksnv7K0lc57my4h6ANu/2ohm69JCPIhxpXpTOeMhpDhAGo36sQyH+nKYsWVzjiARfTAcDnTSX4lm86VLHaqr7dopJ+iMvkmjGoOQSr1rXXvLnWlDgEbeA5j0P1kMDrXao9Qh1es9cUPjO+Lk0Bd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782956929; c=relaxed/simple;
	bh=OsgpoD5P4cFTiwjAqPW62HDOaq7/Xu8Dn4rKycuJ0fM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uHff6V5SEF1+Ds+Gp7QCJ0dX7xbLj40YxcRwJbenD6nr3e6wkHZgsbGOARD1qRHiU00OTxOCKeu0c5n/ihe0brjGU63ca7X7bIVwgcfti1Cw9/TYX7hBv7fMm0fYIE+xilnj4GdxgvOnIAnv2wYEiW1w+oKdUnH4VZWxD5qtbXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jd+8qkoy; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jd+8qkoy"
Date: Thu, 2 Jul 2026 09:48:33 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782956924;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OsgpoD5P4cFTiwjAqPW62HDOaq7/Xu8Dn4rKycuJ0fM=;
	b=jd+8qkoyMpMPcw5KtF2o3aAaYORsMyJ1VxSjbgTogPwrt+X2it6p59J71sgczzr67Nn+h2
	D5qluvUfemIyAR8QgFLCT+ZOQdGPcq4NpG80+ZhA0OEhcNkiJ7S1HE70OPRRhActsVkmWG
	Mo+HE28vouMP6jQL5pB4WTlHp3Cm9FE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Wang Jun <1742789905@qq.com>, tytso@mit.edu, adilger.kernel@dilger.ca, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	libaokun1@huawei.com, 25125332@bjtu.edu.cn, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: Re: [PATCH] ext4: get rid of ppath in get_ext_path()
Message-ID: <rrsgndgpxyrmu6okb43u6wkdaibbidlbyqgugeeijd2b44sf4y@6lzmm4v4xvdp>
References: <tencent_C982B0201FE8F041BD5B4FC1ED7D646A740A@qq.com>
 <2026062643-tamer-limes-a320@gregkh>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026062643-tamer-limes-a320@gregkh>
X-Migadu-Flow: FLOW_OUT

Hi Greg,

Any update here ?

We rebased the 6.6 stable one week ago and also found the same regression.

Are we planning to use this patch or just revert the blamed series like 6.1 did ?
https://lore.kernel.org/all/20260408010208.746177-1-sashal@kernel.org/
