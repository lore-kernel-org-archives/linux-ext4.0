Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B82218ACC
	for <linux-ext4@vger.kernel.org>; Tue,  3 Feb 2026 00:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770080381; cv=none; b=TJV7rVxkzsWIW5ldBveM5nwdQkW/cG465nylg1TObGRhG78ntJLEiT9ULIT0i9/i6AGEIliDiDk+wMHtfRaBbz6WzpOqspwhT5eZysOa072cYe1CxnEf2jDHhqkbeQnXtosLJjjBZNfjaerqtLpk9SPeGAZtwnHjKPaKgJ2QBIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770080381; c=relaxed/simple;
	bh=8248i/kYArgyaQTa2HABl7HpWtk+x6i4SNBHC7ecfvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tQy+N0MHDI8E+/0EohUlf2SZ4v9DKbrmAagiHImxMiv5GH2njyWRHaLwgOWb4Pq0aYdhX+7lMm6Y9WFCWjN5qNXF38P1/af02dvvIGG4dXGaIyzsonv4dB6tsLzynutsfNHwz5UcPvgUJ2UXEMSKtn+VZPdgKnnW81yCmJYQiAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=oymjkyAL; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="oymjkyAL"
Received: from macsyma.thunk.org (pool-173-48-123-50.bstnma.fios.verizon.net [173.48.123.50])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6130wZeK027056
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 2 Feb 2026 19:58:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1770080319; bh=aUyJiVznOTfQ6pPxpOeT0GU34DTIGGka4AHQzI4bQCY=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=oymjkyALcY2L6SOAuZbHGBaaZnFauHrclv6xQuVdOYpduatevDy6DEZzen76pSw5N
	 XSQfkThuW5BRzrU06IYhabSdIPWNjwnQq3+jhdRbr25SpUVdQmkk5lNGOzd/uO747K
	 5wJy84oHudJlo887rgejCF0q1QH5M51Hm5HrX5Qs3lHCepH4V3tn4Q2Mbopst+Bthx
	 0C+l4IQPlMxaV2LUrSt8VQhwr0E8xmYuMjg6fdD9CnZNtwd7fmd+npl3qZ/la1AxRO
	 KtkMvAXtqMqtkMjomn3aBlwVAqM9ZppQSr3aAmTcLg/UvUvgBZF6yKRoZrRsiGt2QT
	 gDbA0NuZCVYXw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id F2B815704A33; Mon,  2 Feb 2026 19:57:34 -0500 (EST)
Date: Mon, 2 Feb 2026 19:57:34 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Christoph Hellwig <hch@lst.de>
Cc: Eric Biggers <ebiggers@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        David Sterba <dsterba@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Chao Yu <chao@kernel.org>, Andrey Albershteyn <aalbersh@redhat.com>,
        Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, fsverity@lists.linux.dev
Subject: Re: [PATCH 03/11] ext4: move ->read_folio and ->readahead to
 readahead.c
Message-ID: <20260203005734.GB31420@macsyma.lan>
References: <20260202060754.270269-1-hch@lst.de>
 <20260202060754.270269-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202060754.270269-4-hch@lst.de>

On Mon, Feb 02, 2026 at 07:06:32AM +0100, Christoph Hellwig wrote:
> Keep all the read into pagecache code in a single file.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense to me.  Thanks,

Acked-by: Theodore Ts'o <tytso@mit.edu>

