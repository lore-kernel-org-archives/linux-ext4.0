Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD48A366802;
	Tue,  3 Feb 2026 05:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770096157; cv=none; b=dklDe5jBvgyH0DPP+RwVGewa0+81yaAzlZNiohPFMr3vAsMPc+O86prOVdGEIfEMsfXEENFt6+iGYvE5qEecfBJdNTjrcfjVUCEV9h1XF07i4wQdmvYTF9oNSl0Uyr04pv9yJpECBIWI3o+QMzSnEFPcaMuk5AdBmlHZpZp+5IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770096157; c=relaxed/simple;
	bh=C2HtuxEAJWvGiMLhVU4manacpCsGCzBGgNvwM3andlE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VrZt0P7/APnZeZIV/0c7TddU35fycCORjaqotApM/6BLbR6Be1NPjz801G1I7yxbMbq668QyyLWoFZyfgNIRng2DKkxR99igfdt6xsYHR9yD98Muthf3IzZR+x1ESZVOyomdujKktHeH7PLgMfsjujvnpwyZD+5TdRehBitv1tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=E3dh/QB7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E3dh/QB7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UG1GHC0dzmd0C7Ae/3CrFgZ7Ia2bmC6sKcZ0wwCpd3k=; b=E3dh/QB7dwEiS9iScY3eQU0KHT
	EsGr3O8HxHadS8sGX08b/sXUkoNCQuyLNsXyVuVfTv991q3c3wDqt4eQsYv+bGzeKvOQt3fY/gW9u
	bcg5os/N/LOHjikc6OtwJhFkGXSiPTB/rSEruLjvEe4pn8H4FafngKHAxihutzyHuNJKD+4bRjskB
	qp2BgmpBJfhEUA0uGmuoDW28yZa9uOYNLzF/kByOhdHYteVu14Y2rwK5EWvAN2L8Dnx77eKAfmf60
	KPir8KyRZuuxI2tWG+ZMuolBxRlJBAugM5iRUn+CmywB/cU+o/qmtWHDaY/UYOEEqtB3hMDg1nLZC
	0a5lDnRA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vn8s0-0000000662q-0lZ3;
	Tue, 03 Feb 2026 05:22:36 +0000
Date: Mon, 2 Feb 2026 21:22:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-ext4@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs/018: remove inline xattr recovery tests
Message-ID: <aYGGHMfca4gbB2vy@infradead.org>
References: <177005945267.2432878.7105483366958924034.stgit@frogsfrogsfrogs>
 <177005945298.2432878.17951687824065765554.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177005945298.2432878.17951687824065765554.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Feb 02, 2026 at 11:11:12AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we can do xattr updates in a single transaction (as opposed to
> using the attr intent machinery) if we keep the attr structure in short
> format, remove the attr intent item log recovery tests.

I have a bit of a hard time parsing this.  Currently with xfs/for-next
these fail, so removing them fixes it, which is probably what drove
this.

But looking through the patches I'm not sure why they actually are
failing - the updates are logged as part of the inode item, and
nothing in test_attr_replay seems to actually look at log specific
bits?

Only vaguely related, but should we ensure to always clear error
tags after the test runs to ensure they don't leak into other tests?

