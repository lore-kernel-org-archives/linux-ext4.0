Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D51E33D4E1
	for <linux-ext4@vger.kernel.org>; Tue, 24 Feb 2026 21:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771967932; cv=none; b=VtC4JhHofbS3b+jyhuWwhx/zviYwbr0CNaYTcVnrfEnD64DG+cJ6v2bmy3mVjt2NwYPHWZpFVFhh3aatqKQ17rVnHbAjLkr8ASk+K3kOFmhHvbZH9bP9i23H/d1e1Qb5f67h3nwub8Go3/0M6JMet2SuC8ZCxm92UBjUa6KjVB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771967932; c=relaxed/simple;
	bh=AYDplU6K49/SVuAPo9/ReGyIIV5abEzbKrqhW6D4Kzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RBC3sgxTCq3A2tJ7zeetvbY0X5iSXOlN/Hd6Svqwu8+ZEwJXDwHmU8oEu+C4T28pb2jxFcdG102HjHZvNvAWbpoqCNGjEsh2eA1CLWgJNJymcPxN1MwGZXJLOtBK0qVPd4MxwN5gdFCaguAIwZ5wOd2s6zPvnJwxlSeRgR/SKoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cS43nh27; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cS43nh27"
Date: Tue, 24 Feb 2026 21:18:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771967918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e6wTWaWNIxwLv+18TjX9PEFxPO2yrUFIKp0jYJONcPI=;
	b=cS43nh27ThYnwu5hAnSeohAUUzQPZsv0vZvXypJ7CVo3us7EeHEKOs80WX6w838O4zhKsN
	f7mAgSFfimuw+wTziUoQv/r5bS01t2Upxgivuq4M3pVvPT8q1mOmVvwfSCvI2FRfdeDb2/
	V54OmBvyQQ5ZJWDOEmUGfTRw0nzoQ9g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: miklos@szeredi.hu, joannelkoong@gmail.com, bpf@vger.kernel.org, 
	bernd@bsbernd.com, neal@gompa.dev, linux-fsdevel@vger.kernel.org, 
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH 29/33] fuse: support atomic writes with iomap
Message-ID: <jabujke2yepqsgipfip3juvizdgkdgnuzzrluuex6yc3pjxch3@pldpsltux43n>
References: <177188734044.3935739.1368557343243072212.stgit@frogsfrogsfrogs>
 <177188734865.3935739.5549380606123677673.stgit@frogsfrogsfrogs>
 <ej24ajmh6ltfe37yiy6qzqko5p6y5eecixzybexgxs5oo45iuu@ufvfjxvppc3o>
 <20260224193005.GD13829@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224193005.GD13829@frogsfrogsfrogs>
X-Migadu-Flow: FLOW_OUT

> > 
> > I still haven't gone through the whole patch blizzard but I had a
> > general question here: we don't give ATOMIC guarantees to buffered IO,
> > so I am wondering how we give that here.
> 
> Oh, we don't.  generic_atomic_write_valid rejects !IOCB_DIRECT iocbs.

Ah, that is true. I was secretly hoping you added support for buffered
IO atomics ;)

> 
> > For example, we might mix
> > atomic and non atomic buffered IO during writeback. Am I missing some
> > implementation detail that makes it possible here? I don't think we
> > should enable this for buffered IO.
> 
> <nod> Now that y'all have an lsf thread on this, I agree that not
> supporting buffered writes in fuse-iomap should be more explicit.
> 
> 	if (iocb->ki_flags & IOCB_ATOMIC)
> 		return -EOPNOTSUPP;
> 

Yeah. This looks more explicit. Of course this change does not warrant a
new series as it is not changing anything functionally. If you plan to
send a new series anyway, then this could be folded in.

-- 
Pankaj
