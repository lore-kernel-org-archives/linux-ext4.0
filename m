Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159DC54763;
	Wed, 28 Jan 2026 03:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769570557; cv=none; b=PtSZwNw6I75D/8EPC46lDY11b6MAjH3j0ip3yxgMZ2oUyTeW9sgnkLn0Z3cS1PttQUuhn3AXY3kpc3WMMguHZuBTfauqy09bKXgHNMnJ6QmMMT1cRuW8JOlchID8HALgxL06BMSCvACjdjiAdpsbMzY59bv5PvOgpCcQJ0TyXso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769570557; c=relaxed/simple;
	bh=hO7Dvp+n2fT8USiyWHCLLJZmQ5uqUDuWImmkAnQEdLg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gOGP/ROkeKPmONFfdf3Yguv0XIOZi1slD8GtKlKjEaogDawS6SqRWSBgsM/8vT8G8xEq3fFF+6JHpHHvbTdw07mcTHSS46Z7jUwkzY2FMX3hbjyjqNN5GyrJvd3TI/YEcRubjfvAKtudjf0l8DjPcB4AgTuk7WBSxMVYSdJBlIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GVoeY+wZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GVoeY+wZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305E8C4CEF1;
	Wed, 28 Jan 2026 03:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769570556;
	bh=hO7Dvp+n2fT8USiyWHCLLJZmQ5uqUDuWImmkAnQEdLg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GVoeY+wZx5buXBTIHSfGxUGQ57DrOaBRKk5U5A/3h9N3bozABH3DFmg7tGDTgOWXw
	 8pOK+jle1pHoNNdSngnSz79EnorWBVoK6MUWSACqVy6ko4d52R0r+wZV7trXYk6oGr
	 0tCJEH+MjaMQfWnMRpkSDQs5UBbaCv7/TXS1i9GYb4dVjHBTEAT7aHvgVCbaikQibv
	 rbWHYIIBbH1JSEqLPkGm9OzuvkCKXHUmqSWwyY7bTLmDhrYTHiTNqyA6bU5sfS2NlY
	 fB0DubjlJnjMafKhG51XCPpwFeVgmjXE8o8FQ03pRK/N+dEF22Vk5OOrn/DLTUWHuj
	 bVPe2pm4VAhKw==
Date: Tue, 27 Jan 2026 19:22:03 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, fsverity@lists.linux.dev
Subject: Re: [PATCH 09/16] fsverity: constify the vi pointer in
 fsverity_verification_context
Message-ID: <20260128032203.GA2718@sol>
References: <20260126045212.1381843-1-hch@lst.de>
 <20260126045212.1381843-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126045212.1381843-10-hch@lst.de>

On Mon, Jan 26, 2026 at 05:50:55AM +0100, Christoph Hellwig wrote:
> struct fsverity_info contains information that is only read in the
> verification path.  Apply the const qualifier to match various explicitly
> passed arguments.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/verity/verify.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)

Did you consider that fsverity_info::hash_block_verified is written to?
It's a pointer to an array, so the 'const' doesn't apply to its
contents.  But logically it's still part of the fsverity information.

- Eric
