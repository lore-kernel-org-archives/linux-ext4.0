Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69361891A9;
	Wed,  4 Mar 2026 12:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772628540; cv=none; b=m5qrMnTbd5AQ03kJRUltf1PxfYsx2SF6vyq+RSPd6RcMULbvvEw6xdrdEc7Np/TYIIGtVX26D8NbJ40ocZw4kv7xAceVLmH6uHKCRHmOfA7U4cC6JdYWtcVysIY+AlTNQ7Np1QRAjgYzw9MKiGhGclhTCr1cmFvcAH/BlDky/ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772628540; c=relaxed/simple;
	bh=VZ1IQZ9wkbkriXYlTeVOKrSSDilZmIyjz5pgJIAWLf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ntqn5gMNlgTXpABHVYvoaGNGZs8Bzhq+xhx1mU14hkw2pFK/tW0Zpx3eoqd7V8HL49DBDJbyja5eSeEb9+PJdjpmDkjq3Yx+/uIsn9Dv0af0Ubxoi41X1VYF6tedMEzEgzkBn5nlaPRx3q5f0+qg007B2cxFghnAWE3e8s5F4hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ICg+Flg0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ICg+Flg0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D61C19423;
	Wed,  4 Mar 2026 12:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772628539;
	bh=VZ1IQZ9wkbkriXYlTeVOKrSSDilZmIyjz5pgJIAWLf4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ICg+Flg0GucrcK/Rp72ulJveVObDKbF74VwXPM1WlSI1LMqELjkUi6Z1yVFSvEdzx
	 sg4f3jMhAsjPe5+eS4uJwrFgCLC2x634qa7461r+1moEHf8kfuFszeph0AdcKmsKt1
	 YMDXm8+ua/G1ZldiSP/pvm7kJJ5+jdEmXmP4WjhB+BGHY1wWU2IemjZNp5ejFtDqX6
	 s2Oj6yA0YXmbBsB/pxBp3PhBqI5lTneSZBpJ+rUdDB0eqzmP+2sLWm8Ifx5AUBKSWg
	 VFnLzZ2Iex6vpQbWkYuo7BYDlnmJBzjw37/lgcK6OewxZWkKpJpOLSe+IP52ji6eXd
	 MSUewpqUQg7zA==
Date: Wed, 4 Mar 2026 13:48:53 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 18/32] fs: Provide operation for fetching
 mapping_metadata_bhs
Message-ID: <20260304-schalldicht-bushaltestelle-0ed92f03754a@brauner>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-50-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260303103406.4355-50-jack@suse.cz>

On Tue, Mar 03, 2026 at 11:34:07AM +0100, Jan Kara wrote:
> When we move mapping_metadata_bhs to fs-private part of an inode the
> generic code will need a way to get to this struct from general struct
> inode. Add inode operation for this similarly to operation for grabbing
> offset_ctx.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---

Yeah, it's a good enough trade-off, I think.
