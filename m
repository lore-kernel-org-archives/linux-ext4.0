Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC387313525;
	Wed,  4 Feb 2026 19:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770232189; cv=none; b=d5hOdeTohZK2bu7rbcPVg8PCFWZYg4E9bP+HNtD96sqnGh1xGplaM87FC2FRamlGieVTqghBEB2NnB+hpWvpbzbjjW3JDB+Q3ZD5JZYPVKfDXfGPzjMoGEDl/fOBPxQQ2gl4hOaAsEUYRj/RqmsxOpjGfs5+c3V5TPU2ozgtdyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770232189; c=relaxed/simple;
	bh=LxYVdStt8e5rjD317rCKqxQ1KptEiReTeRXJ7tUogNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TupIvWXuwY85BbEU1iB8wUJobvrEm2zNk0Vj/icuZjiRWalY/IBuMTv56GVe+q9g5o2KQ/QiX3Mm6GcWaDKYFAFLogNxmE27mu2jiduC8O01MKtAyPAECr5WkN1YBaJkMki4giw7aheemYUxMqyfVk7nRg3I7LRAh55nMaNaO6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JuPJrE7G; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JuPJrE7G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qDygt9b0t7ZzLBEATOD7cMQIy8qvNtTnpogBxkpI+zY=; b=JuPJrE7G8oGQ8Uf9ZVQGZNBVEI
	EIja7uvXDVHUSIGY47Rm7dVgq1nOJ0haG5lS163RX8BHcbpp4xab1LR4wzrMmKA5mbhkPmZnUMkpF
	ZX2qIgWJ7iOtgCQx4CLQ23IUvesIGpxEZQwyO54sER8+lbWXgZTXgvBOiOYo32AiL/+RUugUtQtFr
	OeeEUIWW1eT8hQgoYawQEqz9NHzELcEeDsC+g9ZDE1dGCUFfrObhlZlzM8qd9zibmSWaci3sXAlci
	rZH5E1UkngseT5Q0NgcZBzXIGm+ZHykd444E68L8YxTNLVEhOtFmg5sxhZaeCOxSNKSpFc/874NVX
	kQ/0IjQA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vniFx-00000002V0z-2vYj;
	Wed, 04 Feb 2026 19:09:41 +0000
Date: Wed, 4 Feb 2026 19:09:41 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	fsverity@lists.linux.dev
Subject: Re: fsverity speedup and memory usage optimization v5
Message-ID: <aYOZdUTrvIjq82AE@casper.infradead.org>
References: <20260202060754.270269-1-hch@lst.de>
 <20260202211423.GB4838@quark>
 <aYNdmk1EE5etfUYE@casper.infradead.org>
 <20260204190218.GA2193@sol>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204190218.GA2193@sol>

On Wed, Feb 04, 2026 at 11:02:18AM -0800, Eric Biggers wrote:
> Aligning to the opening bracket is the usual style as agreed on by the
> kernel community.

Says who?  I've been part of the kernel community since 1997.  I've
never heard of such a thing.

> It's 2026.  We generally shouldn't be formatting code manually.  We have
> better things to do.

I agree!  Stop changing it unnecessarily.

> If you're going to insist on ad-hoc formatting of argument lists, you'll
> need to be more specific about where and how you want it to be done.  It

Two tabs.  That's it.


