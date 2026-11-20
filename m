Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795205509;
	b=NStaLsxGMBV9G8iNJ9q2FgyUKvTQd0/pALhJG/r/O3kfxnxl2HHGjmQWCbEYruHozfeW
	 4HbMuLWIE6mbnds2jwDxea46NQw8WHepl3gTVQ1MHX4CLBnTsY2a8cGAXgijxTDiXsFxl
	 V8rwTNcffOUOuWX5WrDVRsS0tsQxZkSOpUQ1ugs+X+Com0HIj5yVPHWhRnuExZmVlLWTc
	 pjPx/PXTZ1Ca7EbaL4qHph7a0u/iW+vF0kjyy8a3oalFzCSZYGDFY8o73JDPElN6rTDok
	 7XlIrjjTMAhJ3YYFPostqboiEC90lq1e7Yb/UB3+mkSE/vRuaj2Lpu+4oNJApe3BYXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795205509;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=nfsBEMGhx4Fh2PmnLWTGaQElHwcxVx4X18qdlNbyQXc=;
	b=mwBLqBrtXQNpXIInjIsiz55mVKvucEWtPjMSx//cMLOzqmlKn2+HztzvfkkR3+f4MBzE
	 /0mDxuu67ZF8t837c0pjqTCeFE0SFKMeldStpnyyvZk7espTyhHsZ61pGRkW1/mkEroPA
	 AeiM9ojkWKj4PX35KaNvnuPhIY9bgljVgYbGy3jerywlaklgTYBo11FtMUNP1F40IajoC
	 Nlq9sRnWDRcZ39RjD353cexy9VDeOor1WwPJQWfTdX03Lxwguoq92ODA9Zv47MXpIqjBP
	 TVGqYOhpvaFYBqOuXLQonYqL+iSzCBc/f2ZEObRcFq0PqMhXPoKxokh0jmNdR7He5dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dnbcJeQh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E59606A325
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2026 20:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dnbcJeQh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2941F000D0;
	Fri, 20 Nov 2026 20:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795205508;
	bh=nfsBEMGhx4Fh2PmnLWTGaQElHwcxVx4X18qdlNbyQXc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dnbcJeQhjxfEbyzCwV9BmpAElVPrFgze7maEBJWLQ4B/thu5K41q9ozrp6++J2hp7
	 D8AFv3iYurqXyzBRoDaBmFSMWRGepykcPPRhwtr7M7utJym/S3tz677Qwa7T+ICljp
	 cCjHa3y1EBtHQRfOOPTKnuNqGb9d5LcAfvHFEFohJjCCbQkhPgHYqaMdqRDKk/BIRK
	 nMePNg0hCfX4OyUZXVLg/JqGz84Jj7mwOE6SzQxOXAHCYIWl86J5WQMe4ZONsZ+0mI
	 3uMcjyYI/5GK7NejjMPVEkff+qf6WjWsFhIoqwUF5w+fX/5ilbfiwhbQExQNqYlrM6
	 xDOnHn9OeXBUg==
Message-ID: <sashiko-outbox-226011@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 5/5] mm/filemap: refuse releasing maybe_dma_pinned
 folios
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
In-Reply-To: <20261119-gup-dirty-what-v1-5-236d69f25c24@suse.de>
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
 <20261119-gup-dirty-what-v1-5-236d69f25c24@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 20:11:46 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] mm/filemap: filemap_release_folio() dma-pin check breaks
  folio_invalidate()
- [Medium] mm/filemap: VM_WARN_ON_FOLIO on mapped folio hit via
  mext_move_extent()
- [Medium] mm/filemap: VM_WARN_ON_FOLIO in filemap_release_folio()
  precedes needs_release
--

commit 38a290b76cc80ed81b7d5a26e8b50ef48dfba24c
Author: Pedro Falcato <pfalcato@suse.de>

mm/filemap: refuse releasing maybe_dma_pinned folios

This commit updates filemap_release_folio() to warn if the folio is mapped
and refuse to release filesystem metadata when folio_maybe_dma_pinned() is
true.

> diff --git a/mm/filemap.c b/mm/filemap.c
> index f9e34144c53c7..4fa75663b7f3e 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -4571,8 +4571,11 @@ bool filemap_release_folio(struct folio *folio, gf=
p_t gfp)
>  	struct address_space * const mapping =3D folio->mapping;
> =20
>  	BUG_ON(!folio_test_locked(folio));
> +	VM_WARN_ON_FOLIO(folio_mapped(folio), folio);

[Severity: Medium]
Can EXT4_IOC_MOVE_EXT hit this VM_WARN_ON_FOLIO() on a memory-mapped file?

In fs/ext4/move_extent.c, mext_move_extent() locks the origin and donor
folios and calls filemap_release_folio() on them without unmapping them
from user page tables or checking folio_mapped() first:

fs/ext4/move_extent.c:mext_move_extent() {
	...
	if (!filemap_release_folio(folio[0], 0) ||
	    !filemap_release_folio(folio[1], 0)) {
		ret =3D -EBUSY;
		goto unlock;
	}
	...
}

If either file is memory-mapped with resident PTEs in the moved range, an
unprivileged EXT4_IOC_MOVE_EXT ioctl triggers this warning when
CONFIG_DEBUG_VM is enabled.

>  	if (!folio_needs_release(folio))
>  		return true;

[Severity: Medium]
Should VM_WARN_ON_FOLIO(folio_mapped(folio), folio) come after the
!folio_needs_release(folio) check to match filemap_may_release_folio()?

filemap_may_release_folio() returns true when !folio_needs_release(folio)
before checking folio_mapped(folio):

mm/internal.h:filemap_may_release_folio() {
	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
	if (!folio_needs_release(folio))
		return true;

	/* There's no way to know whether these are write-mapped, so give up. */
	if (folio_mapped(folio))
		return false;
	...
}

Callers such as collapse_file() (which calls try_to_unmap() without
TTU_SYNC) and __folio_freeze_split_file() (which calls unmap_folio())
can leave a folio mapped if unmapping races with zap_pte_range(), then
rely on filemap_may_release_folio() to gate filemap_release_folio().
For a folio that does not need release, filemap_may_release_folio()
returns true and filemap_release_folio() then triggers
VM_WARN_ON_FOLIO(folio_mapped(folio), folio).

> +	if (folio_maybe_dma_pinned(folio))
> +		return false;
>  	if (folio_test_writeback(folio))
>  		return false;

[Severity: High]
Does refusing to release a DMA-pinned folio here break truncation via
folio_invalidate() and leak the folio and its buffer_heads?

During full-folio truncation, truncate_cleanup_folio() calls
folio_invalidate() before removing the folio from the page cache.
block_invalidate_folio() and gfs2_invalidate_folio() first discard all
buffers on the folio and then call filemap_release_folio(folio, 0) to
free the buffer_heads and clear PG_private.

If filemap_release_folio() returns false because the folio is DMA-pinned,
truncation still removes the folio from the page cache and sets
folio->mapping =3D NULL, leaving PG_private and the discarded buffer_heads
attached.  When the DMA pin holder later unpins the folio as dirty (for
example via unpin_user_pages_dirty_lock()), folio_mark_dirty() sees
folio_mapping(folio) =3D=3D NULL and calls noop_dirty_folio(), setting
PG_dirty on the orphaned folio while PG_private holds a reference.  When
shrink_folio_list() later scans this folio on the file LRU, it sees
folio_test_dirty(folio) and jumps to activate_locked before reaching the
orphaned buffer release path, and because folio->mapping is NULL nothing
can ever write it back or clear PG_dirty, permanently leaking the folio
and its buffer_heads on the file LRU.

On GFS2, gfs2_invalidate_folio() -> gfs2_discard() also leaves struct
gfs2_bufdata attached at bh->b_private to be freed by gfs2_release_folio();
once truncation clears folio->mapping, any later filemap_release_folio()
call sees mapping =3D=3D NULL and falls back to try_to_free_buffers() inste=
ad
of mapping->a_ops->release_folio, permanently leaking struct gfs2_bufdata
even if the folio was not dirtied.  In ext4's mpage_release_unused_pages(),
a failed delayed allocation calls block_invalidate_folio() and then
folio_clear_uptodate(folio), relying on filemap_release_folio() ->
try_to_free_buffers() -> folio_cancel_dirty() to clear PG_dirty, so
returning false leaves a pinned folio in the page cache with PG_dirty set
and PG_uptodate clear.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119-gup-dirty-=
what-v1-0-236d69f25c24@suse.de?part=3D5
