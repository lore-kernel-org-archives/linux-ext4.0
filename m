Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F83E31F98A;
	Tue, 24 Mar 2026 05:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774330941; cv=none; b=pEYZ1r6JZ41iHF3GuhBFUs1yYzOrHwAuXHsdGQDRqzJjUDzPa4YkRA+XLL66FBON8KjuZyB57KYZzJjw9KdO0d4qfLqTq6GIBMqi6UgveoyzhsYqb6EuCY+G7FYL6KV9u4T1ynYAQk5N8/a1Rwn+IdB204a21Iv9NoinMMwqksU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774330941; c=relaxed/simple;
	bh=kd5Yx63RdPdAIVJ1mo9COTFAo+UI8gbhO+yjJqCQspQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tLSIeJ7hKft0jIBA853ESSdKpzSJzsKePJlkeSdCG5XpBP+pi3XBHLAEPqQsaAMcV+nqSRD+41YJbOvqo7/g/WLdr8QfjPJ0m4pL/tlJjO7DJfSUEc1lIuFWH1Mbt02F3XMRY6eJrpDcRi2Nns+NPpQwc4KJYa158cxExa7kxtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ShZJIyBs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ShZJIyBs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gnGFQgv2BByGLzw1hq9qZga1CuZS+vQ8g5BMMQp3Me4=; b=ShZJIyBsPXklu8G8Q2+rirXnpz
	m9KHOWtXQviysvw1bU77BDdHs88FzgEmFKq6rJQKNyE6K07zB1zFlmXDr9uoNQqe1j9z3qewfntOe
	SiNtFmOmubhI/X5uf5wMClzwKnDdAVPYQfeJFAL8i681WEXEJ6Ge/kbNm/sIi8BhXVfs0IlqcMZgl
	iWkD6S2J9+7CRMttEN8ODM2cw4HwZ6qd9bMawbsWUC7AOBJ0hjAScvzE3LKhED1QRAEPqoh+HLmra
	19I4mUAVR7gsRhaa/0XPtpgK+TmJNyqPD9xkyiZdskMH8HLvcfUEyiiMCuLOVSjjrHHQW4tmPtXF8
	eiug5RSw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4uWw-00000000bSG-1SyC;
	Tue, 24 Mar 2026 05:42:18 +0000
Date: Mon, 23 Mar 2026 22:42:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 20/41] fs: Ignore inode metadata buffers in
 inode_lru_isolate()
Message-ID: <acIkOmat4Y_M2SUC@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-61-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-61-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Mar 20, 2026 at 02:41:15PM +0100, Jan Kara wrote:
> There are only a few filesystems that use generic tracking of inode
> metadata buffer heads. As such it is mostly pointless to verify such
> attached buffer heads during inode reclaim. Drop the handling from
> inode_lru_isolate().

But the code isn't just verifying (which to me implies debug code),
but doing actual work to remove the buffers.  This does look like a
behavior change to me, buf it is not due to previous patches or
because it was dead code, it would help greatly to explain that here.

