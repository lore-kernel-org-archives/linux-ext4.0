Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3133F0740
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2026 15:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779982643; cv=none; b=Z/LurEesj7ZsOu4NPi3dQ40XRbiSA2FydPqquVuiasN/ASUHfDQvLMsta53kpX74HjbV5hbvpfTGh0dLr6CH7PwACrHYygGfNTs+l+cqQB45yRMD2K1p75cywyAcDSjoXS758rWZfZf7SLB/Q11DmzuEC7lVxvUNblM+x4OoiUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779982643; c=relaxed/simple;
	bh=rqQCeHIszqLtzGD+9TIjivyuDDyH+4oIR9R8QJU8JUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tfWF32JlIPDq0rH52jrIr1nethb1lrHU7oQxZxw9ixKP9nDIAnN9Qw64Pj4v6BBwfkuHYqXHg+KID7/Wq4GHsSoGNPxcEhMbvUzAa8DnyhfJiE2amDDY3QdMlk07DTtZD3d9ftrb+Q8lH+veztWxipVg3uvW4UonSJcPxUDNhT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=aElPts2x; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="aElPts2x"
Received: from macsyma.thunk.org (c-73-9-28-129.hsd1.il.comcast.net [73.9.28.129])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 64SFb5U9005244
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 May 2026 11:37:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1779982631; bh=G+Cvh472mgio3qnzQivWQBkXaVPqCLOy9h74veY0hYo=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=aElPts2xYATFDcae3J0iz4wIMuY7ttQ1xKZEjcGAfAAXaxO8yQd/NgmwEREKBVh4p
	 G1N0dSQ8qWzVJRtmWRXMmZedIls9IpTTlrYTrg/B2zFMWlRiAsT4WWiDlgA/nmftl8
	 qxixSnKNRMMmpjTXNu8hs0k/81Wy/4CfffHo4JyJCdAz2HvHxqwYg+ikifiQLp2cJt
	 2OeOYtmKe1TdH8YHi9PPoP8ld7BEuIMMXO+DhOLiKiqUXOvY4HABXeDTuY8aI3+c0w
	 Cunc34kmoiX40up9vyHs5nRJt5/hbtvM0N/EGYVif52wiZKB/9WkMV+vknK4aM1xJo
	 b1HyUFk8NQjeQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 6453E6B6C83E; Thu, 28 May 2026 10:37:05 -0500 (CDT)
Date: Thu, 28 May 2026 10:37:05 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH 17/34] jbd2: Convert jbd2_write_superblock() to
 bh_submit()
Message-ID: <4w3twcxncvmld277cslrrn7r7f233fpw5wyis2rno5ec72y5tf@hhparb3t6ddx>
References: <20260525171931.4144395-1-willy@infradead.org>
 <20260525171931.4144395-18-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525171931.4144395-18-willy@infradead.org>

On Mon, May 25, 2026 at 06:19:10PM +0100, Matthew Wilcox (Oracle) wrote:
> Avoid an extra indirect function call by using bh_submit() instead of
> submit_bh().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: linux-ext4@vger.kernel.org

Acked-by: Theodore Ts'o <tytso@mit.edu>
