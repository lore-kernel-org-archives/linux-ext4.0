Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91852ECD3A;
	Tue, 24 Mar 2026 13:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774358242; cv=none; b=aorZ/sK4uJBUA7Rf4Z1uvz1rIkkLp1AaHecgyqc+9/oaD3gPPLsqAlRXnE8IFv0+8huSUsmYWamgE71UhXTbAf3DAQFlJlcvL+FExlXr+bevrDowgCxRyeDJz2QVAPpGCU9tyzuMz97IyS/+U237qGbecKrKmnrB/jHlc78pXLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774358242; c=relaxed/simple;
	bh=lqaMRZ91pT74ndkwoEb0c3rlcHmDC5LsqtFmQEmUIsU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b+7MRb+zBU/AxfQVu9qLQ1HH46WItpyvcb8mjXP3/aLBafIE3LrrJEWudytgXJJ34JQuzVvXqVJ5uEP5OzUXxi38ySzsAo0UJCYZS9LaeDqZ9lWqsHqeoHqYH1wuW4jNkwq862b7atRljZli/edIxg+lAy9etbGvgqYeGd3ArRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=c4MIb9Qk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c4MIb9Qk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2r2P0EuXUIpFebfcqs+V2aJI6SFcZOJexfLphbr7J9s=; b=c4MIb9Qk/bHbiz4wX6m2X6msJr
	oxY4CmAVyhXkZn2ex8skBdsVMy6D9fHjgZGKyDoZhixt+T6XNn4ZuCPCY4RodYRopRi6Up8Cx35gV
	ksmFcaJu7gz5f0Zgd6McYixFQc6T++IH/jHp7rATGG9fJIvVL2R0Ml80Ry/Y9cVKqRRPn+WPAajUZ
	tMFv8tbnZ1kC0DTmK9CGA9Nv4WNohsUA/HrMyF5rNQ353MYz7h1fSM0R0/niBS53UuVp3u5Y5um0p
	XYJpneQzDASBCOWBAFFFIOjxNfzgzXTm9A5xbpwlXZxSZ2biNZcmoO1+TLZNvnb6KcU/M2lMHEjqU
	U7uzKpsg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w51dE-00000001WkF-24HP;
	Tue, 24 Mar 2026 13:17:16 +0000
Date: Tue, 24 Mar 2026 06:17:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 12/41] fs: Drop sync_mapping_buffers() from
 __generic_file_fsync()
Message-ID: <acKO3NRw852FdGUO@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-53-jack@suse.cz>
 <acIjxUzWFstarlwv@infradead.org>
 <ezdm6d34jqdrcohk7o6wycxvvlgtf6aqenwx5ffr3plfagdbzi@gibz7xwr6yhr>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ezdm6d34jqdrcohk7o6wycxvvlgtf6aqenwx5ffr3plfagdbzi@gibz7xwr6yhr>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 24, 2026 at 01:34:57PM +0100, Jan Kara wrote:
> I'm fine with simple_fsync() name for the helper with the trivial behavior
> of writing out the mapping and the inode. Code wise this will look somewhat
> different given what you've suggested for the last patch.

Yeah, the pitfalls of going sequentially through the series :)

But sketching this out I'm not even sure all this makes sense any more.
Maybe instad of the allback we should just have a helper for checking the
inode state like:

static inline bool inode_need_fsync(struct inode *inode, bool datasync)
{
	enum inode_state_flags_enum state = inode_state_read_once(inode);

	if (!(state & I_DIRTY_ALL))
                return false;
        if (datasync && !(state & I_DIRTY_DATASYNC))
                retun false;
	return true;
}

and otherwise just open code the calls int the two implementations
without any callbacks, as it feels cleaner to avoid the entanglement.

This helper might also be useful for other fs-specific implementations
later on.

