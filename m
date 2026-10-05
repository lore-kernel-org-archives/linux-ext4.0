Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD48E48640B
	for <linux-ext4@vger.kernel.org>; Mon,  5 Oct 2026 14:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791209005; cv=none; b=VMSKGiSbG48eMeHrhoiHQDBXh/g8PmBow+7rbccdNip/mFtHmu8fT1ztgBCKg1VHTvlPWBaDRULs/viBMt9iaxB/HWj/7RA6P+fBKeO9bGzZS5X4K49OI/GJ0TSL0VykizI/Hd1UDANMUXFmdt7C5/Bz0tSviMql3Zeqr9RMd6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791209005; c=relaxed/simple;
	bh=Y0BFTkA47iyFJ29RfA9FIn0I7Rr/kvLIQWeKr2f47KQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t3tUY4gZj3N2Gilp/URIIEL8cT/6LO+fFKe7VnbJjX2wh/oG/Ro1KfvqyrltCpn7CNE2GyQn8jrWDto0AVsqUY8321CRCkqQgtjjKh083NJL+mIxl2irNZ9O88/9DJqPTA7wcNGwQAg3sBN8ERFsr1wP6kfsizLSw5FIoAfFNdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=V6LSENu8; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="V6LSENu8"
Received: from macsyma.thunk.org ([151.240.45.38])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 695E1pXg006784
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 5 Oct 2026 10:01:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1791208920; bh=Upl7F91amjUFqp9wyYmz9ODrIhZOAhPMAxoyRitl3L0=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=V6LSENu82/5QHJEpjIQKsDLNWAZfXCMl7QKTnJluY+fal63ihQbkpYeXXhLxn3A6M
	 W2cR9ekZVVHr/2qSqUztc47IiTgmEycOidY9Nq1YSiAIIGGOOqCvaWQ5WPyL9nsvRD
	 1n0R0Z3LoU0MCg0F4jLyUNYX+FzTtsBd0jaoEealqrDQiNxMpRJnxRZVhp9QrACWcP
	 0M6szUmqTf52z+bHbn5jlAgjpDq1G6HbseDDXC6KTCCLwSaW06SagzuDoA1UTrDZ19
	 7TyOuVpsOZwnQSXRfYxKk2WXelHmVZ+W5ogB1/UPVOZNvCgfkEV7xrv7ZlgFf86aHw
	 PkjbY6mtUUPMA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 4019D1F15D36; Mon,  5 Oct 2026 10:01:50 -0400 (EDT)
Date: Mon, 5 Oct 2026 10:01:50 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
        ritesh.list@gmail.com, djwong@kernel.org, hch@infradead.org,
        yi.zhang@huawei.com, yizhang089@gmail.com, chengzhihao1@huawei.com,
        yangerkun@huawei.com, wangkefeng.wang@huawei.com,
        yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com
Subject: Re: [PATCH v6 11/31] ext4: implement buffered read path using iomap
Message-ID: <asOtpKyvNQOahh5X@mit.edu>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-12-yi.zhang@huaweicloud.com>
 <asNrmCSW8UjpyfRv@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asNrmCSW8UjpyfRv@mit.edu>

On Mon, Oct 05, 2026 at 05:23:31AM -0500, Theodore Tso wrote:
> I tried running "git am" on your patch series, and after resolving a
> patch conflict manually, I ran a build check to make sure things were
> still building, and I ran into a couple of issues that caused the
> build to fail:

Never mind; this was caused bby building on too old of a kernel base.
When I applied this on a newer kernel, the problem went away.  Sorry
for the noise!

						- Ted
