Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793716677;
	b=XnKSjMwBpmSoMBcjMMOA2eUvIrm7R3gNBdOSmB21AImn60brXcPWHxQctpVbbvZxFT8u
	 2qIhjjFr1OxC9ORbaqexqmcRhCxxOAB5QJVFl4mpgiTePYXoYPhWKaWOPemrKqK3a1lLT
	 aJA+dSSr6uJObcNhefG4IKuGu26n9W4wM+MieVtTsiEx3L6BOAxgobl6BOGl00Y338Atf
	 Xlchfc0mPuoVICNyL12XDMZNrIHdkEES3lDMjUUb9mgmkLLbD0XKCqoPjh3uIu3v7frr/
	 j8K2xWbed3WEJKxdcWWQi8i78/pSt+b0QbIvhmklbgAtOU7xo1gdgD8AV1VI9MXRIgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793716677;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=NxXQnExQXfshQ6IhKFYzYhFdWlPk06ylz8zruXk9mVk=;
	b=miK8AYzyhELvCAt7t/shJYpenbLJuD430oL+c0bd8AeEpE7ILj2AXrQd7x5xZgp2OphX
	 sWOtkIdWE1z7y//aLoHP3O4Gu5njzcd258ZyvuCFhSc/aSrcN8z4lstAdmpGq1ihXmI1h
	 AuCWCKbJ+84Q/qceuzxaS8WeYx4AvQ0bWXf4Pg8WRcPO7EWv7ezGL5kp6936gRHJMHNfP
	 qJz+DHT6UMUMG0NM97Lfk+scg18pTR3Ubk4VzGfagZh5eWCRPAwRndUDlih7lgaLXTPHI
	 2Sc3uLMop3stDzJ1MnVXqMmc0osodvuWeXtVaUr2X/ASW4wzj+ajykgsy2zTgHA2aqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b="Z/9BIgVB";
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A71606D805
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 14:37:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5A71606D805
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Z/9BIgVB
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NxXQnExQXfshQ6IhKFYzYhFdWlPk06ylz8zruXk9mVk=; b=Z/9BIgVB17v68SVRX/Pd3IUYhq
	8jvyYu41U96+/dSFevmEg45cxDFwOMNYplbVTgg/n/+ApAtSsCSmlJOdBVEE/fc5e8un1KAuqNHQi
	wBYvS/JTH1I0wQJF5KqUMepm4y+fe9j4DX1eduWfuJvmyJd6gEaPhX0rNnUJMdcvvGGEGxDXwmqWS
	N1Cz73hOJ3TvUJGKG5YZ4dWkwmLkzncqDZLZUrJRquQUARarrMpuAIcC1ECmwV/Tqnh0y+icicY5o
	pdqH7nlBBjjalhq8oxvKiZ7QU3uCpb7Z8ZChHSQYWVv0g3CGaTOQaHRAl5tjO+pG5PkX4sW7Iot4U
	0TmiVdlw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOFe7-00000002jsP-1xTC;
	Tue, 03 Nov 2026 14:37:55 +0000
Date: Tue, 3 Nov 2026 06:37:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	adilger.kernel@dilger.ca, ablagodarenko@thelustrecollective.com
Subject: Re: [PATCH v13 00/11] Data in direntry (dirdata) feature
Message-ID: <aunxw4vjchztwQLG@infradead.org>
References: <20261029122413.230409-1-ablagodarenko@thelustrecollective.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029122413.230409-1-ablagodarenko@thelustrecollective.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

I ended up here through the xfstests patches, because this looks like
a really weird feature.  Unix directory entries aren't really standalone
objects.  Why do you want to add more data for them and hugely
complicate the ext4 code?

There is this snipplet:

> The first user of this feature is LUFID (Locally Unique File ID), an
> identifier that must survive rename and be accessible from directory
> readdir without an inode lookup.

Which doesn't really explain anything.  And unless things changes in
the last year, lustre used:

 a) a kernel client making use of the file systems
 b) used a heavily patched ext4 for that anyway

So why should upstream carry this stuff for something that is a
perpetually out of tree kernel consumer with a really odd architecture?

