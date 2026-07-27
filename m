Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD0638657E
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 20:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785183439; cv=none; b=ejhM8ZCSGpNXy8gxjrNCrim9iY9AGV/NhZnmJg1xLEZSqMxvbZ0z87XAPFD5VrEAAADXlWu/HnuWO/OVNL6/q+Kv6BsUAfJ72JLJJlLZ9SOM21I0Ezl28joRUnyTXwO/1m6EqqGOdknBmC2dfqaK3gS4uGQ0beVRXkB+qRLAMz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785183439; c=relaxed/simple;
	bh=EBEvmFvsJNkNE+f1ZxEk7AdKX3aIDmUvkj9A10Ky0zA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mHfguIMhbO2p82Jef7NjeF3UHZR/aMa/Cfq+IsRFCYJM3XNnK/sOUm6Ke76jdS6oO0t2eDYjMMNtLs5wkuGA/mN7shZVVukuWrkB0A8hBHVqfM23pqz6pM0u0rFT99G84V5RbKtzMOHyGxc93TONTaYbGHgloEQ0gJSmrimPCw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=l1YgNBbW; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="l1YgNBbW"
Received: from macsyma.thunk.org (pool-108-20-43-42.bstnma.fios.verizon.net [108.20.43.42])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66RKGxSN018799
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jul 2026 16:17:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1785183423; bh=lqwzHX2gaOLTWDJGE334KY7K4w7Twh++Kya4cibum+0=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=l1YgNBbW8w0IxQmJBr00eB0BEVAkI+sY1DpS6px7whAkxLAROPQYRE/3RBc8S+rAH
	 0HukZKmUQwy5fG4zcCCHknXjgfJ+w7mVQ0vEL6lfwdHs3/l6s/xbtw24WeTmsE92XQ
	 C1kgyDgm8XVZM53cRtd0GVHg1R+DYItwtVekQdgPglZHMXSwP38o4T900gq19aOk/h
	 zagMWPmHeQU4rBEMu7aXlNLQL4gqUBdUryEdk3yJ9fUwIJUpBsO9F6O5THmSLfnM3M
	 4JNxUbMOTsJ1SCJvW7hXWGjQTZwH5GScURLXc+ItcEZzFOq4czrlnKCmvo+SHLRUHH
	 1hYBnJ5WeyQaQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 6DD2BC42F8C; Mon, 27 Jul 2026 16:15:59 -0400 (EDT)
Date: Mon, 27 Jul 2026 16:15:59 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: rafad900 <rafad900@gmail.com>, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: convert pa_count from atomic_t to refcount_t
Message-ID: <amePTzFUaAEZ0cgl@mit.edu>
References: <20260720034441.3900050-1-rafad900@gmail.com>
 <2joyziupzemt5vjdvmnic3kcdckt6z5dht6vgusxsxrfbtthhn@uuiexxvvcclv>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="hw2meiq5p3tcmdce"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2joyziupzemt5vjdvmnic3kcdckt6z5dht6vgusxsxrfbtthhn@uuiexxvvcclv>


--hw2meiq5p3tcmdce
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 27, 2026 at 01:57:11PM -0500, Jan Kara wrote:
> 
> This is a bit problematic as for pa_count 0->1 transition is fine (as long
> as pa_deleted isn't set) so this conversion will trigger false warnings as
> the 0-day report shows.

For better or for worse, the lifetime rules of the ext4_prealloc_space
structure don't match those assumed by refcount.h.  Which is to say,
it's not a reference count the same way that say, struct inode's
i_links_count.

The whole *point* of the preallocation space is that we are holding
some blocks for use by an inode or by block group, because it's too
expensive to figure out that this set of blocks is available for
allocation.  So even though pa_count is zero, meaning that there isn't
an *active* allocation in process, under normal circumstances we want
to keep ext4_prealloc_space around and linked into its relevant linked
list.  This is why the pa_count 0->1 transition is OK, and it is _not_
an existing "use after free".

There's actually quite a lot of documentation in fs/ext4/mballoc.c,
but the comments don't really make this point clearly enough.  I think
that's because the assumption is that this high-level description of
what the goals of ext4_prealloc_space is assumed to be known by
everyone trying to modify that part of the block allocator.

But given that we are having more people trying to submit changes to
ext4 (in some cases, assisted by LLM's), it might be a good idea to
improve the documentation, both for the sake of the humans and the
LLM's that are trying to understand how things work.

Just for yucks, I asked an LLM to explain what a human might want to
need to know about how the ext4_prealloc_space sutrcture was used, and
it came up with this.  (See attached.)

I don't propose adding this directly to the beginning of
fs/ext4/mballoc.c, but we might want to see if there is some parts of
this that we do want to add.  (And to seeif what we currently have as
comments at the beginning of mballoc.c is accurate, since I don't
think anyone has reviewed it in a while.)

Cheers,

						- Ted

P.S.  Hi Rafa/Rafad, it appears that you are a relatively new Kernel
contributor; I see that the only other patch contribution from your
gmail account is was to attempt to address a jfs syzkaller issue.  If
you intend to contribute more ext4 changes, welcome!  It would be
great if you introduced yourself so we know a bit more about who you
are, and what name you would prefer to be known by.


--hw2meiq5p3tcmdce
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: attachment; filename="ext4_prealloc.md"
Content-Transfer-Encoding: 8bit

# `struct ext4_prealloc_space` allocation/deallocation and `pa_count` semantics

## `struct ext4_prealloc_space` — overview

Defined in `fs/ext4/mballoc.h:118`:

```c
struct ext4_prealloc_space {
	union {
		struct rb_node   inode_node;   /* for inode PA rbtree */
		struct list_head lg_list;      /* for lg PAs */
	} pa_node;
	struct list_head pa_group_list;
	union {
		struct list_head pa_tmp_list;
		struct rcu_head  pa_rcu;
	} u;
	spinlock_t   pa_lock;
	atomic_t     pa_count;
	unsigned     pa_deleted;
	ext4_fsblk_t pa_pstart;
	ext4_lblk_t  pa_lstart;
	ext4_grpblk_t pa_len;
	ext4_grpblk_t pa_free;
	unsigned short pa_type;   /* MB_INODE_PA or MB_GROUP_PA */
	union {
		rwlock_t   *inode_lock;
		spinlock_t *lg_lock;
	} pa_node_lock;
	struct inode *pa_inode;
};
```

A PA represents a chunk of physical blocks reserved ahead of an actual
write, so future allocations for the same file (inode PA) or the same
locality group of small files (group PA) can be satisfied without a full
search. Each live PA sits on three structures: `grp->bb_prealloc_list`
(per-group list, protected by the group lock), and either the inode's
`i_prealloc_node` rbtree (protected by `i_prealloc_lock`, for
`MB_INODE_PA`) or a locality group's hashed `lg_prealloc_list[]` (RCU
list, for `MB_GROUP_PA`).

## Allocation

- `ext4_mb_pa_alloc()` (mballoc.c:5716) — `kmem_cache_zalloc()`s the
  object from `ext4_pspace_cachep` and does `atomic_set(&pa->pa_count,
  1)`. This single reference represents the caller's (the allocation
  context `ac`'s) own hold on the PA — it isn't in any list yet.
- If the regular allocator succeeds and finds *more* space than
  requested, `ext4_mb_new_preallocation()` calls
  `ext4_mb_new_inode_pa()` or `ext4_mb_new_group_pa()`, which fill in
  `pa_pstart/pa_lstart/pa_len/pa_free`, mark `pa_type`, then link the PA
  into `grp->bb_prealloc_list` and into the inode rbtree (or leave it to
  be added to the lg hash later via `ext4_mb_add_n_trim()`). These
  linking steps do **not** touch `pa_count`.
- If no extra space was found, or an error occurs,
  `ext4_mb_pa_put_free()` (mballoc.c:5729) is used instead: it asserts
  (`WARN_ON`) that dropping the sole reference (`atomic_dec_and_test`)
  actually hits zero, then marks `pa_deleted = 1` and frees it via
  `ext4_mb_pa_free()` — since it was never linked anywhere, there's
  nothing to unlink.

## `pa_count` semantics

`pa_count` is a **reference count on "who is currently using this PA for
an in-flight allocation,"** not a count of pointers/links to the
struct. It answers: *is anyone actively consuming blocks from this PA
right now?*

- It starts at 1 when created (owned by the allocating `ac`).
- Every additional reader that wants to reuse the PA for a new
  allocation request bumps it first, under `pa->pa_lock` (or the
  rbtree/list lock protecting lookup):
  - `ext4_mb_use_preallocated()` → `atomic_inc(&tmp_pa->pa_count)`
    before calling `ext4_mb_use_inode_pa()` (inode PA lookup via rbtree,
    mballoc.c:4997).
  - `ext4_mb_check_group_pa()` (mballoc.c:4819) walks the lg hash list
    picking the closest group PA to the goal block, incrementing the
    candidate's count and decrementing the previous candidate's count as
    it walks (`atomic_inc`/`atomic_dec` pair) — pure "trial reference"
    bookkeeping while searching.
- `ext4_mb_put_pa()` (mballoc.c:5160) is the release path:
  `atomic_dec_and_test(&pa->pa_count)`. Only when this hits zero **and**
  `pa_free == 0` (all blocks in the PA have been consumed) does it
  actually delete/free the PA — unlink from `bb_prealloc_list`, unlink
  from the inode rbtree or lg list, mark `pa_deleted`, and free
  (immediately via `ext4_mb_pa_free()` for inode PAs since they're
  rbtree-protected by a rwlock that serializes with lookups; via
  `call_rcu()` for group PAs since lookups walk the lg list under RCU).
- If the decrement reaches zero but `pa_free != 0` (there are still
  unused blocks in the PA available for future requests), the PA is
  simply left alone/relinked — it's not consumed yet, just not currently
  in use by any allocator.

This is why `pa_count` is checked before discarding a PA for space
reclaim: `ext4_mb_discard_group_preallocations()`,
`ext4_discard_preallocations()`, and
`ext4_mb_discard_lg_preallocations()` all do `if
(atomic_read(&pa->pa_count)) { skip it }` — a nonzero count means some
other thread is mid-allocation against that PA (holds `pa_lock` briefly,
but the increment happens under the rbtree/list lock before the
discarding thread can grab `pa_group_list`/`inode rbtree`/lg-list
locks), so it's unsafe to rip blocks out from under it. This is a real
(if narrow) race window explicitly called out in the "possible race"
comments (e.g. mballoc.c:5195-5205 and the block-history comment at
5003-5030): a PA's `pa_free` can only reach 0 while `i_data_sem` is held
for that inode, and once it hits 0 the same call chain
(`ext4_mb_new_blocks → ext4_mb_release_context → ext4_mb_put_pa`)
immediately removes it, so no other thread ever observes a
zero-`pa_free`, still-linked PA in the tree.

The invariant enforced by `BUG_ON(atomic_read(&pa->pa_count))` in
`ext4_mb_pa_free()` (mballoc.c:5143) is absolute: nothing may free a
`ext4_prealloc_space` while any reference is outstanding.

## Deallocation paths

Two flavors of actual teardown, both requiring `pa_deleted == 1` first
(set once, guarded so double-delete warns rather than corrupting state —
`ext4_mb_mark_pa_deleted()`):

1. **Consumed exactly** (`ext4_mb_put_pa`): the last user of a
   fully-drained PA (`pa_free == 0`) tears it down inline — no blocks
   need to be freed back to the bitmap because they were all
   legitimately allocated.
2. **Discarded with leftover blocks** (`ext4_mb_release_inode_pa` /
   `ext4_mb_release_group_pa`, called from
   `ext4_mb_discard_group_preallocations()`,
   `ext4_discard_preallocations()` (per-inode, e.g. on truncate/evict),
   and `ext4_mb_discard_lg_preallocations()` (trimming an overlong lg
   hash bucket)): these walk the still-reserved-but-unused bit range and
   call `mb_free_blocks()` to actually release it back to the
   buddy/bitmap, accounting into `sbi->s_mb_discarded`, before the PA
   struct itself is freed.

In both flavors, the struct's memory is only released via
`ext4_mb_pa_free()` (or the RCU-deferred `ext4_mb_pa_callback()` for
group PAs, since they're looked up under `rcu_read_lock()`), and only
after confirming `pa_count == 0` and `pa_deleted == 1`.

## Inode PA vs. group PA: how the two types differ

`pa_type` (`MB_INODE_PA` vs `MB_GROUP_PA`) isn't just a label — the two
kinds have distinct owners, distinct container structures, distinct
sizing/shrink behavior, and distinct discard triggers. The choice
between them is made once per allocation request, in
`ext4_mb_group_or_file()` (mballoc.c:5831):

- If the request isn't a data allocation, or `EXT4_MB_HINT_GOAL_ONLY` is
  set, no preallocation of either kind happens.
- Otherwise the function computes `inode_pa_eligible` (false only for a
  closed, non-open-for-write file whose size already matches — no point
  prealloc'ing past EOF for a file nobody will extend) and
  `group_pa_eligible` (false if `s_mb_group_prealloc` is disabled, or if
  the request is "large" — bigger than `s_mb_stream_request` — since
  dumping a large file's blocks into a shared per-CPU locality-group
  pool would fragment it for everyone else).
- If group allocation isn't eligible, the request falls back to inode
  preallocation (`EXT4_MB_STREAM_ALLOC`) or no preallocation at all.
- If group allocation *is* eligible, the context grabs a per-CPU `struct
  ext4_locality_group` (`raw_cpu_ptr(sbi->s_locality_groups)`) and locks
  `lg->lg_mutex` for the duration of the allocation, serializing all
  allocation/discard activity against that CPU's locality group.

### Inode preallocation (`MB_INODE_PA`)

**Purpose:** speeds up sequential writes to a single file by reserving
trailing blocks past what was actually requested, so the next
`ext4_map_blocks()` call for the same inode finds physically contiguous
space without a fresh search.

**Ownership/container:** exactly one inode owns it. It's threaded onto
`ei->i_prealloc_node`, an rbtree keyed by `pa_lstart` (logical block),
protected by `ei->i_prealloc_lock` (a rwlock — readers use `read_lock()`
in `ext4_mb_use_preallocated()`, writers use `write_lock()` to
insert/erase). It's also linked into `grp->bb_prealloc_list` for the
physical group it lives in, and `ei->i_prealloc_active` is incremented
on creation / decremented in `ext4_mb_mark_pa_deleted()`.

**Creation (`ext4_mb_new_inode_pa()`, mballoc.c:5251):** called only
when the block allocator found *more* contiguous space (`ac_b_ex`) than
the caller actually asked for (`ac_o_ex`) — `BUG_ON(ac_o_ex.fe_len >=
ac_b_ex.fe_len)`. The extra logic (the `adjust_bex` block) decides where
within the goal window to anchor `pa_lstart` so the original request's
logical range is still covered, since the found extent may be smaller
than the full normalized goal. `pa_free` is initialized to the whole
`pa_len` and then immediately reduced by `ext4_mb_use_inode_pa()`, which
consumes just the sub-range needed for *this* request (so a freshly
created inode PA typically already has `pa_free < pa_len` by the time
it's inserted into the rbtree).

**Subsequent reuse:** later allocation requests for the same inode
(typically the next sequential write) hit `ext4_mb_use_preallocated()`,
which does a rbtree walk (Steps 1-4 in that function) to find the PA
whose logical range is adjacent to/overlapping the new request's logical
start, skipping any PA already marked `pa_deleted` by a racing
discard. On a hit it does `atomic_inc(&pa_count)` then
`ext4_mb_use_inode_pa()`, which trims `pa_free` by however much of the
PA this request consumes. Because inode PAs are per-file and non-shared
across processes, in practice contention is only against a
truncate/evict of the same file or an ENOSPC-driven discard.

**Freeing:**
- Normal exhaustion: once `pa_free` reaches 0, the next
  `ext4_mb_put_pa()` on it deletes and frees it inline — no leftover
  blocks, nothing to return to the bitmap.
- Explicit discard on `ext4_discard_preallocations()` (called from
  truncate, `ext4_evict_inode()`, etc.): walks the whole rbtree under
  `write_lock(&ei->i_prealloc_lock)`, and for every PA with `pa_count ==
  0` marks it deleted and moves it to a local list (a PA still in use —
  `pa_count != 0` — triggers a `WARN_ON` and a retry loop, since nothing
  should be actively allocating from a file while it's being
  truncated/evicted). The collected PAs are then unlinked from
  `bb_prealloc_list`, have their still-unused blocks returned to the
  bitmap/buddy via `ext4_mb_release_inode_pa()`, and freed with
  `ext4_mb_pa_free()`.
- ENOSPC-driven discard (`ext4_mb_discard_group_preallocations()`,
  per-group): treats inode and group PAs uniformly at the
  `bb_prealloc_list` level, but unlinks inode PAs from the rbtree
  (`rb_erase`) rather than an RCU list, and frees them immediately (not
  RCU-deferred), matching the rwlock-based (not RCU-based) protection of
  the rbtree.

### Group preallocation (`MB_GROUP_PA`)

**Purpose:** batches small, unrelated files' allocations from the same
CPU into shared, moderately-sized chunks, so many small files opened
concurrently on one CPU don't each trigger a full buddy search — instead
they carve slices out of one shared reservation.

**Ownership/container:** not tied to one inode (`pa_inode = NULL`);
owned by a per-CPU `struct ext4_locality_group`. It's linked into
`lg->lg_prealloc_list[order]` — a hash table of `PREALLOC_TB_SIZE` (10)
RCU list buckets, indexed by `fls(pa_free) - 1` (i.e. buckets group PAs
by approximate remaining free size) — plus the same
`grp->bb_prealloc_list` per-group list that inode PAs use. The `lg_list`
is RCU-protected (`list_for_each_entry_rcu`, `list_add_tail_rcu`,
`list_del_rcu`) since lookups (`ext4_mb_use_preallocated()`'s
`try_group_pa` path, `ext4_mb_check_group_pa()`) happen under
`rcu_read_lock()` rather than the rwlock inode PAs use.

**Creation (`ext4_mb_new_group_pa()`, mballoc.c:5352):** same
precondition as inode PA (found more than requested), but `pa_lstart` is
set equal to `pa_pstart` (group PAs have no meaningful "logical"
position of their own — they're just a floating pool of physical blocks)
and it's linked only into `grp->bb_prealloc_list` at creation time;
insertion into the lg hash table is deferred to
`ext4_mb_release_context()` after the current request's consumption is
known.

**Subsequent reuse — the key difference from inode PA:** rather than trimming a sub-range out of the middle of the PA the way `ext4_mb_use_inode_pa()` does, `ext4_mb_use_group_pa()` (mballoc.c:4791) always takes blocks off the *front*. It deliberately does **not** correct `pa_pstart`/`pa_len`/`pa_free` at use time (comment: avoids a race with a concurrently-loading buddy bitmap); that correction happens afterward, in `ext4_mb_release_context()`:
```c
pa->pa_pstart += EXT4_C2B(sbi, ac->ac_b_ex.fe_len);
pa->pa_lstart += EXT4_C2B(sbi, ac->ac_b_ex.fe_len);
pa->pa_free   -= ac->ac_b_ex.fe_len;
pa->pa_len    -= ac->ac_b_ex.fe_len;
```
So a group PA's `pa_pstart` literally slides forward every time a chunk
is carved off the front — it behaves like a bump allocator over a fixed
physical range, unlike an inode PA whose `pa_pstart`/`pa_lstart` are
fixed for its whole life and whose *interior* free sub-ranges get
consumed. After shrinking, if `pa_free` is still nonzero the PA is
re-hashed: removed from its current `lg_prealloc_list[order]` bucket and
re-added via `ext4_mb_add_n_trim()`, since its shrunken `pa_free` may
now belong in a different `fls()` order bucket.

**List trimming (`ext4_mb_add_n_trim()`, mballoc.c:6019):** when
re-inserting a group PA into its bucket, the function also counts how
many entries are in that bucket; if it exceeds 8,
`ext4_mb_discard_lg_preallocations()` is invoked to prune it back down
to 5, discarding the least-recently-useful (by walk order) non-busy
(`pa_count == 0`), non-deleted entries. This is a size-bounded eviction
unique to group PAs — inode PAs have no analogous cap because there's
naturally at most a handful of live PAs per inode.

**Freeing:**
- Normal exhaustion: same as inode PA — `pa_free` hits 0 and the last
  `ext4_mb_put_pa()` deletes it inline. Since `pa_type == MB_GROUP_PA`,
  unlinking uses `list_del_rcu(&pa->pa_node.lg_list)` and the struct is
  freed via `call_rcu(&pa->u.pa_rcu, ext4_mb_pa_callback)` rather than
  immediately — readers may still be mid-traversal of the RCU list.
- List-size trimming (`ext4_mb_discard_lg_preallocations()`): triggered
  proactively (not by ENOSPC) whenever a bucket grows past 8 entries, as
  described above. Leftover blocks are returned to the bitmap/buddy via
  `ext4_mb_release_group_pa()` (a simple single-range
  `mb_free_blocks()`, unlike the inode path's `mb_find_next_zero_bit()`
  scan, because a group PA's unused region is always one contiguous
  trailing range, never a punctured interior).
- ENOSPC-driven discard (`ext4_mb_discard_group_preallocations()`):
  identical group-list logic as for inode PAs, except unlinking is
  `list_del_rcu()` from the lg hash bucket instead of `rb_erase()`, and
  freeing is RCU-deferred.

### Summary of the asymmetry

| | Inode PA | Group PA |
|---|---|---|
| Owner | one inode | per-CPU locality group |
| Container | `i_prealloc_node` rbtree (rwlock) | `lg_prealloc_list[order]` hash of RCU lists |
| `pa_lstart` meaning | real logical file offset | mirrors `pa_pstart`, no real meaning |
| Consumption pattern | interior sub-range per use | always trims from the front (bump-allocator) |
| Correction timing | immediate, in `ext4_mb_use_inode_pa()` | deferred to `ext4_mb_release_context()` |
| Size-bounded eviction | none (bounded by file count) | yes — `ext4_mb_add_n_trim()` caps buckets at 8 |
| Free on empty | immediate `ext4_mb_pa_free()` | RCU-deferred `call_rcu()` |
| Discard trigger(s) | truncate/evict (`ext4_discard_preallocations`), ENOSPC | bucket overflow (`ext4_mb_discard_lg_preallocations`), ENOSPC |

Both types, however, share the same `pa_count` discipline described
above: nothing may unlink or free either kind while `pa_count > 0`, and
`pa_free == 0` is what distinguishes "quietly retire on last put" from
"actively discard and return blocks."

## `ext4_mb_new_preallocation()` — the dispatch point

```c
static void ext4_mb_new_preallocation(struct ext4_allocation_context *ac)
{
	if (ac->ac_flags & EXT4_MB_HINT_GROUP_ALLOC)
		ext4_mb_new_group_pa(ac);
	else
		ext4_mb_new_inode_pa(ac);
}
```

This is the single call site (invoked from `ext4_mb_use_best_found()`,
mballoc.c:2282, right after the regular allocator settles on `ac_b_ex`)
that turns "we found a good extent" into "we created a PA object for
future reuse." It doesn't decide *whether* to preallocate — that
decision was already made earlier by `ext4_mb_group_or_file()`, which
set `EXT4_MB_HINT_GROUP_ALLOC` in `ac_flags` (or left it unset, or set
`EXT4_MB_HINT_NOPREALLOC` which routes around this call entirely — see
`ext4_mb_use_best_found()`). `ext4_mb_new_preallocation()` is purely a
two-way switch on that already-decided flag, dispatching to whichever of
`ext4_mb_new_inode_pa()` / `ext4_mb_new_group_pa()` matches. Both
callees share the same precondition (`ac_o_ex.fe_len < ac_b_ex.fe_len` —
the allocator over-shot the request) and both expect `ac->ac_pa` to
already point at a freshly `ext4_mb_pa_alloc()`'d object (allocated
earlier in `ext4_mb_new_blocks()` before the search even ran, at
mballoc.c:6306, so it's ready the moment the allocator finds a hit).

## `ext4_mb_discard_preallocations_should_retry()` — deciding whether an ENOSPC-looking failure is real

When `ext4_mb_regular_allocator()` fails to find a suitable extent
(`ac->ac_status != AC_STATUS_FOUND`), `ext4_mb_new_blocks()`'s retry
loop doesn't immediately give up with `-ENOSPC`. Preallocations can be
holding blocks reserved-but-unused, which the bitmap/buddy structures
see as "in use" even though nobody will ever consume them (e.g. an inode
PA nobody will finish writing to, or a group PA sitting idle in an lg
bucket) — so a real "disk full" and a "full of dead-weight
preallocation" look identical to the allocator. This function
(mballoc.c:6133), called at the `repeat:` label (mballoc.c:6338-6340),
is what tells the caller whether it's worth clearing that dead weight
out and trying again, up to 3 times (`retries < 3`):

```c
static bool ext4_mb_discard_preallocations_should_retry(struct super_block *sb,
			struct ext4_allocation_context *ac, u64 *seq)
{
	int freed;
	u64 seq_retry = 0;
	bool ret = false;

	freed = ext4_mb_discard_preallocations(sb, ac->ac_o_ex.fe_len);
	if (freed) {
		ret = true;
		goto out_dbg;
	}
	seq_retry = ext4_get_discard_pa_seq_sum();
	if (!(ac->ac_flags & EXT4_MB_STRICT_CHECK) || seq_retry != *seq) {
		ac->ac_flags |= EXT4_MB_STRICT_CHECK;
		*seq = seq_retry;
		ret = true;
	}

out_dbg:
	return ret;
}
```

It works in two tiers:

1. **Try to actually free something.** It calls
   `ext4_mb_discard_preallocations(sb, ac->ac_o_ex.fe_len)`
   (mballoc.c:6106), which loops
   `ext4_mb_discard_group_preallocations()` over every group in the
   filesystem (or until `needed` clusters have been freed) tearing down
   any PA with `pa_count == 0` and returning its leftover `pa_free`
   blocks to the bitmap. If this frees any blocks at all (`freed != 0`),
   that's a strong signal the retry is worth it — return `true`
   immediately without even checking the sequence counter.

2. **If nothing was freed, use the `discard_pa_seq` counter to detect a
   race rather than genuine exhaustion.** The comment block at
   mballoc.c:435-452 explains the scheme: every CPU keeps a percpu
   `discard_pa_seq` counter that's bumped whenever blocks are marked
   used/freed (`mb_mark_used()`/`mb_free_blocks()`) or whenever a PA is
   discarded. `ext4_mb_new_blocks()` samples *its own* CPU's counter
   once up front (`seq = this_cpu_read(discard_pa_seq)` at
   mballoc.c:6301) as a cheap fast-path check. If the
   retry-should-happen function finds `freed == 0` on this call, it
   falls back to `ext4_get_discard_pa_seq_sum()`, which sums the counter
   across *all* CPUs — a more expensive, globally-accurate view. If that
   global sum has moved since the sample was taken (`seq_retry !=
   *seq`), it means some other CPU concurrently allocated, freed, or
   discarded blocks/PAs while this allocation was in flight — i.e., the
   group's apparent fullness may already be stale, so it's worth
   retrying even though this thread's own discard pass found
   nothing. The `EXT4_MB_STRICT_CHECK` flag is a one-shot escalation:
   the first time this branch is taken it's set on `ac_flags` and the
   retry is granted unconditionally; on a *second* consecutive miss with
   the flag already set, the retry is only granted if the global
   sequence value actually changed since the last check (`seq_retry !=
   *seq`) — otherwise the loop concludes the fullness is real and
   returns `false`, letting `-ENOSPC` propagate. `EXT4_MB_STRICT_CHECK`
   also has a side effect back in group scanning:
   `ext4_mb_good_group_nolock()` (mballoc.c:2777) takes the group's
   spinlock instead of reading `grp->bb_free` unlocked when the flag is
   set, trading the fast-path's tolerance for stale/racy free-count
   reads for a consistent view — appropriate once the allocator is in
   this "am I really out of space" retry regime rather than the common
   case.

In short: `ext4_mb_new_blocks()` treats an allocation failure as
potentially caused by live-but-idle preallocations rather than true
exhaustion, and this function is the policy that decides, cheaply at
first (did discarding free anything?) and then via a global
race-detection heuristic (did *anything* change filesystem-wide?),
whether another pass over the groups is worth attempting before
surfacing `-ENOSPC` to the caller.

--hw2meiq5p3tcmdce--
