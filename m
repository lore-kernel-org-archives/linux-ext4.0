Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99EEF39A7F7
	for <linux-ext4@vger.kernel.org>; Tue, 24 Feb 2026 12:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771937926; cv=none; b=JXhO40HjDFwGy92cgRuu/0MYzin6dJNWLW7+SCTX88qRRioUZSF4iYA5t+Xtt3RY8kAijl7d7NYZHOfqsSrq4k8uCvR6/f+Wbum97j+UEqmF7olQ6xXJwawZ8uNQUR3in4sUH17AZhJUyPLRReT7grX689QZPKYvmNosDeF5bXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771937926; c=relaxed/simple;
	bh=DDw96xmoZbUt+zs0MoI3/CFecRPmq/Pl4/MVFM0h0dA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cGdL192ZkZvOq3mjVE18fFOa4oii6D0sI0pGoCt2Lig5kk1KcuFX8rQp5Q4btAbZO/5bCLufd3UI4cf/LsUGbMvAjARPfyhxysXdvj4aUe6U8kBaX+nnPJkK2xBJo1DBN+aQcrDRPEJ5eBK3YtwBKqwYVagpaSzPQPtcNCXlQh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ttQedrwE; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ttQedrwE"
Date: Tue, 24 Feb 2026 12:58:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771937923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u+wivhIr528+W6wLESqvbuF0C1RtOB8ByC0jlMyM6cc=;
	b=ttQedrwEbhqs8TPNzb9B3Y861TAKH54StDmEW8UqoxOWKwPfTGhRbkouy/LuWORW1iTAq6
	3iX6s7XAptUtrsVJdnqPjv+U6/FPE/E3+kZLl+JhKrSQgHWm2mr9VDj5jIgTonPhNqUJ6H
	dhUIkRCp0FElxpQjDjSRyKjLXG75it4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: miklos@szeredi.hu, joannelkoong@gmail.com, bpf@vger.kernel.org, 
	bernd@bsbernd.com, neal@gompa.dev, linux-fsdevel@vger.kernel.org, 
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH 29/33] fuse: support atomic writes with iomap
Message-ID: <ej24ajmh6ltfe37yiy6qzqko5p6y5eecixzybexgxs5oo45iuu@ufvfjxvppc3o>
References: <177188734044.3935739.1368557343243072212.stgit@frogsfrogsfrogs>
 <177188734865.3935739.5549380606123677673.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177188734865.3935739.5549380606123677673.stgit@frogsfrogsfrogs>
X-Migadu-Flow: FLOW_OUT

> +	}
> +
>  	/*
>  	 * Unaligned direct writes require zeroing of unwritten head and tail
>  	 * blocks.  Extending writes require zeroing of post-EOF tail blocks.
> @@ -1873,6 +1909,12 @@ static ssize_t fuse_iomap_buffered_write(struct kiocb *iocb,
>  	if (!iov_iter_count(from))
>  		return 0;
>  
> +	if (iocb->ki_flags & IOCB_ATOMIC) {
> +		ret = fuse_iomap_atomic_write_valid(iocb, from);
> +		if (ret)
> +			return ret;
> +	}
> +

I still haven't gone through the whole patch blizzard but I had a
general question here: we don't give ATOMIC guarantees to buffered IO,
so I am wondering how we give that here. For example, we might mix
atomic and non atomic buffered IO during writeback. Am I missing some
implementation detail that makes it possible here? I don't think we
should enable this for buffered IO.

-- 
Pankaj
