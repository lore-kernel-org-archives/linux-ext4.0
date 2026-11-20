Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795205506;
	b=JDAePIe8ePK+xhbGK9LsDg++5Xk9pEgmhttW/kcxUGEKUz0GVEddN/0OZWGldwvWbvcP
	 2nKK7LVXSExdDwQtfZsSLGCceCkWVpykBjRWZ8t05c2c2dTQdi4kMzIh3Ty+7L0gCyi3a
	 jRZ3PmUGDuwti1jAZ9DXJrpbwnaIvvbTR5yvT99tMhpT74JRwmBnBaOqN7MiLydg+kwlL
	 AqOM72C8/GgjqzMpoXWwApMuF0HEYDgR0jL8VxQpKBQkTjiLdUsWo2gpciOj6VMNPhWHv
	 lsb6vshddP2JGVYnjqoMyWAaxB2Q1gZ9vnVkW8hFdM/9U9W+wo4AH8+DWkX60bLha2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795205506;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=tSD+v5qtJvl1jtYKfGZE0/A9pPZfPt3HE1Ga1u1oj98=;
	b=GhKRpKrzl3DjaTmnu+7p/Ai8sJ5jIGbd7rgFEKSNrB97D5+5jqjXVc9uMlA9GcpGh9LX
	 ERqWSqh4faRbFiQqCQfaqEyotcEIetZ3Jm0i7VSn0D3yRpBg5imr+g1i1lndox6dU6wSn
	 49MRBCrYCW3ZfhZgZBvOg40rHCWsXvUiJI8ec0OmMuzQN2NSPPCC1avkSpH4xLD4KSiYc
	 vOhjVgLTcFJ7h2bYqiht7qAtqpJmtRQ9PG+yPi5tSSYAb/ZgQa73hdkzAr5qkVs8dOTkY
	 +DzZRtY9TyJ93akKDxG73IJm4ETK4RmwFNCAuF2EUZSLtmS2p4WHQxkZkZo8ho3XWKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aT5+jo3k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B922606A6DF
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2026 20:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aT5+jo3k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF821F000C4;
	Fri, 20 Nov 2026 20:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795205506;
	bh=tSD+v5qtJvl1jtYKfGZE0/A9pPZfPt3HE1Ga1u1oj98=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aT5+jo3kkI/RnoMADuI6SYbdGmzwNLFFbSLKmWFftUdoN+VegCdD2tmlE2F3Zny+d
	 5hocedOUvNOKVr84WbY04nTy0DgkUCbUzOFNjxbqzXF6MUTiRWf58oGrpx5i2y3PYm
	 yJPJEnEvSTvqca3fpxhygR7O533gYuCMldpUmM7QxgNzhyBbOSSEonq7S9g8JcD3Eu
	 aRYY2/Y+3jzeBrB9tLemZo24n8TtfxT1PKqvS4MXZjOfolw8kC8FVUG2g2gFTpNkmr
	 NtjbnVGYD3QbNJZeZB0BLHSj8RRSarE0gZZVlZLYQH+mr3JB4uOhydoTyOm5kpLmF+
	 MxspkXwFUHRKQ==
Message-ID: <sashiko-outbox-226008@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 2/5] mm/huge_memory: fix filemap_release_folio()
 interaction with GUP dirty
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pedro Falcato" <pfalcato@suse.de>, "David Hildenbrand" <david@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Zi Yan" <ziy@nvidia.com>,
 =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>, "Jan
 Kara" <jack@suse.cz>, "Lorenzo Stoakes" <ljs@kernel.org>, "John Hubbard" <jhubbard@nvidia.com>, "Peter
 Xu" <peterx@redhat.com>, "Johannes Weiner" <hannes@cmpxchg.org>
Cc: linux-ext4@vger.kernel.org, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, linux-mm@kvack.org, "Kairui Song" <kasong@tencent.com>, "Qi
 Zheng" <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Axel
 Rasmussen" <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei
 Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Michal
 Hocko" <mhocko@kernel.org>, tytso@mit.edu, "Chuck Lever" <cel@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, "Anna Schumaker" <anna@kernel.org>
In-Reply-To: <20261119-gup-dirty-what-v1-2-236d69f25c24@suse.de>
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
 <20261119-gup-dirty-what-v1-2-236d69f25c24@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 20:11:43 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/huge_memory: Fixes trailer cites d824ec2a1546 instead of
  6a3edd293956
--

commit 30321b8e2452fd3a099b0078bb5c7a8478e790ce
Author: Pedro Falcato <pfalcato@suse.de>

> mm/huge_memory: fix filemap_release_folio() interaction with GUP dirty
>
> filemap_release_folio() can only be called safely on:
>  - folios that are unmapped and
>  - folios are not dirty and
>  - folios that don't have elevated refcounts
>
> Anything else can plausibly be pinned for DMA/writing, which interacts
> very poorly with ->release_folio().
>
> Fix it by adding a filemap_may_release_folio() check, plus move unmap_fol=
io()
> outside the i_mmap_read_lock(). unmap_folio() does not need the
> i_mmap_read_lock, since the folio is locked anyway.
>
> Reported-by: David Hildenbrand <david@kernel.org>
> Cc: stable@vger.kernel.org
> Fixes: d824ec2a1546 ("mm: do not reclaim private data from pinned page")
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

[Severity: Low]
d824ec2a1546 ("mm: do not reclaim private data from pinned page") only
modified shrink_folio_list() in mm/vmscan.c, whereas the
filemap_release_folio() call in the THP split path was added by
6a3edd293956 ("mm: release private data before split THP").  Should the
Fixes tag be:

  Fixes: 6a3edd293956 ("mm: release private data before split THP")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119-gup-dirty-=
what-v1-0-236d69f25c24@suse.de?part=3D2
