Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F30537F73A;
	Wed,  4 Mar 2026 13:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772631635; cv=none; b=J8aIHkPQ/wUn50nrtTCqKS/UxBcRQyzk4oV+ZauQA3sZAUFU6WRfw8zWlq+yqkEe/YV6+fQkTpQqE4Fqh6j+FgZ/HOnAEQgxkEa/3R6RDc2Et1cjv/2yES0IFdVb05MiejBdVNjs0azaf7jDqc+wF2RwQy9ns7xzHzi76MssCGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772631635; c=relaxed/simple;
	bh=Wgq3ARRdpO1Q0iJ5SGsrCWCaMeC2JHo6yO58UJf37NE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q4ldDuFsWGB8BOTNFgpVVOGMADjrGtVoSHIwMPK+3oHQl0EyVuwU8N9xRyi+r+OnEN+bcVtdB8W/6kjptydase5B8ey5BCzIQO0QXOPG62uTAHbnIMLSqB8v1bJ9TFialCgXbpW+CUWTgmUL1pcDIGxI0n8LE/X6bx/lU6GHaPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=teznPaF7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="teznPaF7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UpMjkqBNogxSPvE5B7hwtzwkc1kjwuxpixdO2LSAbyg=; b=teznPaF7Zol9XUlVmtkbdixlbj
	BGB56AhLKfWY9Cz+hlyK/SiVnKp62wmIciq1TfXQFK3eFHtabHDLKNQO0GqXac+YG8+R8BcmFAt8K
	cYAuvLkI/h0RYFbvWB03S5niI7jr1jteo6dXkwPe/R14U9EuFH+GJa45KPaMASqgAe98EAq0VK8Xi
	YyyYCH1nP6ks5seA8bZfAOTiODPxPZy/vA9q1sDq9Lr1OL9KaPoJwlI8OO9j9x33Z2lfM9YjsjoYr
	QiFjKMIvshsyvhmFha2IBILD2rNKcADZJIHENkohEcDKP4kwAxyx23jS2oLVsblAfaNcvNhAOhztq
	KNlz3OuQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxmSn-0000000HGUA-0qlh;
	Wed, 04 Mar 2026 13:40:33 +0000
Date: Wed, 4 Mar 2026 05:40:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 17/32] fs: Move metadata bhs tracking to a separate struct
Message-ID: <aag2URb_D0h--RKX@infradead.org>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-49-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303103406.4355-49-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 03, 2026 at 11:34:06AM +0100, Jan Kara wrote:
> +static void remove_assoc_queue(struct buffer_head *bh)
> +{
> +	struct address_space *mapping;
> +	struct mapping_metadata_bhs *mmb;
> +
> +	/*
> +	 * The locking dance is ugly here. We need to acquire lock
> +	 * protecting metadata bh list while possibly racing with bh
> +	 * being removed from the list or moved to a different one.  We
> +	 * use RCU to pin mapping_metadata_bhs in memory to
> +	 * opportunistically acquire the lock and then recheck the bh
> +	 * didn't move under us.
> +	 */

Should the buffer_head simply have a pointer to the metadata bh list,
as that would avoid all this and keep a lot of the references to the
list self-contained?

