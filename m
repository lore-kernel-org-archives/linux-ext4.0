Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792459560;
	b=KPp6oITygh0lk4XNX/gkco3KtJt/BkCs8X4QqzivGqzNOM53kSNAo8Myqh0+k37JyYhP
	 d03tUJ7xHZ/8qw8PQXlsQkKP3Ti5ohXPa3bJ7JOzSv2q06G2U0AKSLfJnIC/YZ+nxMz/9
	 QL9HSl8jFH7X/A5BlWq+IGsXE6pFG1chVzgW6Z7/ekuCJ7e9aXyI1lyxKKzFa7ntZepyL
	 6NPBcdNEgPH6/G2IaaqDTqXwabkpF3BepwTFFhk33r7ahikl3BlDN3TumlED5I2D5K+Mt
	 UBHYa84AgQWg0ZZ6xA9AQg4kP9Xu/y3JmS1KvvO//hhNyW+PrW41du1mDRtwgnpMNKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792459560;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=wSX0ou4En0Loje0VMQSvyBs2WArXvoHO0E4dlLLOqxo=;
	b=ZrENNHtsb/taqmD3HA69+UmlZhw214UdOiiloUaiRpVcr1KkcHyVxoFKHNvZHl0EmiEu
	 2aaMWu25TjcJM217QI/cbIMiTY5cHEbTzTzfjdnSbaFhKKhaW4oL6Si0zs7FQuda0vA4t
	 pnn+DoZQ8b3NvYnwkQcU6xBEXJfRamw0gOBRJY76CW0xWiY42SqR+mdF27xY2IJKPDWh6
	 rqRFPCrpGjzq1o4UKn/z9c/9QzwkeKohaHCPH6CFOgK/I2VJyB5eNdBb3LjJ+WZfnke9J
	 ANnF5lhOEq2ciHqmD7uaE37BFbHRqJC4LFGsLHY5ce3n5fyL4UTCoDGMIo6yXXHOjGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kJgC9DX8;
	arc=none smtp.remote-ip=91.218.175.24
Received: from mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A125A606A319
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2026 01:25:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A125A606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kJgC9DX8
X-Envelope-To: linux-ext4@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=6cxA+5Cap6YuVVh878URw7RVJb0ynDru1vwbXqf/Zcg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792459556; v=1; x=1793064356;
 b=kJgC9DX84QK9wuR5Pel/YZV605dqtEWagrLtqqcNdNDFdv+SQb6r0hEc7VETykvPRQs6Tgm1
 NP41AwvhRdbJfDiwfhiOLco3eTbp2gSrNFZtHvPVReRWBngGlagCUJ74Ohrya4EX1V73CrEslYt
 VbA6sx2pY3pF+cCxIUUfjQXk=
X-Envelope-To: linux-ext4@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 83bbbd00093168ec;
	Tue, 20 Oct 2026 01:25:56 +0000
X-Mizu-Trace-ID: 83bbbd00093168ec
X-Migadu-Flow: FLOW_OUT
Date: Mon, 19 Oct 2026 18:25:51 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+54f6a8926b40a171f2c8@syzkaller.appspotmail.com>, 
	david@kernel.org, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, rakie.kim@sk.com, 
	syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	linux-ext4@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, Barry Song <baohua@kernel.org>, 
	Theodore Ts'o <tytso@mit.edu>, jack@suse.com
Subject: Re: [syzbot] [mm?] WARNING in shrink_one
Message-ID: <atbC0ml_mctTyEP0@linux.dev>
References: <6ad67231.a20cb897.960b0.0042.GAE@google.com>
 <20261019164638.c33e70eaefbee802eefb4716@linux-foundation.org>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019164638.c33e70eaefbee802eefb4716@linux-foundation.org>

+Jan Kara

On Mon, Oct 19, 2026 at 04:46:38PM -0700, Andrew Morton wrote:
> On Mon, 19 Oct 2026 12:40:33 -0700 syzbot <syzbot+54f6a8926b40a171f2c8@syzkaller.appspotmail.com> wrote:
> 
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    a0ff06b3a7bd Merge tag 'firewire-fixes-7.3-final' of git:/..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=12cdb20d580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=44ac479246d4559b
> > dashboard link: https://syzkaller.appspot.com/bug?extid=54f6a8926b40a171f2c8
> > compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> > userspace arch: i386
> > 
> > Unfortunately, I don't have any reproducer for this issue yet.
> > 
> > Downloadable assets:
> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-a0ff06b3.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/3f4bcbceb92e/vmlinux-a0ff06b3.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/bf4df8252e54/bzImage-a0ff06b3.xz
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+54f6a8926b40a171f2c8@syzkaller.appspotmail.com
> > 
> > ------------[ cut here ]------------
> > current->flags & PF_MEMALLOC
> > WARNING: mm/page_alloc.c:4816 at __alloc_pages_slowpath mm/page_alloc.c:4816 [inline], CPU#3: syz-executor/5706
> > WARNING: mm/page_alloc.c:4816 at __alloc_frozen_pages_noprof+0x1eac/0x3300 mm/page_alloc.c:5449, CPU#3: syz-executor/5706
> 
> Thanks.  The stack trace is missing important bits for some reason, but
> it appears to be ext4 disagreeing with page reclaim.
> 
> __alloc_pages_slowpath():
> 	if (unlikely(nofail)) {
> 		/*
> 		 * We don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
> 		 * otherwise, we may result in lockup.
> 		 */
> 		WARN_ON_ONCE(!can_direct_reclaim);
> 		/*
> 		 * PF_MEMALLOC request from this context is rather bizarre
> 		 * because we cannot reclaim anything and only can loop waiting
> 		 * for somebody to do a work for us.
> 		 */
> -->>		WARN_ON_ONCE(current->flags & PF_MEMALLOC);
> 	}
> 
> The electrical think machine said:
> 
> 
> filemap_fault()
>   -> direct reclaim
>      -> shrink_slab()
>         -> super_cache_scan()
>            -> prune_icache_sb()
>               -> evict()
>                  -> ext4_evict_inode()
>                     -> ext4_clear_inode()
>                        -> ext4_discard_preallocations()
>                           -> ext4_mb_load_buddy_gfp(
>                                GFP_NOFS | __GFP_NOFAIL)
>                              -> __filemap_get_folio()
>                                 -> page allocator
>                                    -> WARN_ON(PF_MEMALLOC)
> 
> 
> The task enters direct reclaim after a filemap allocation failure. 
> Reclaim calls shrink_slab(), which evicts an ext4 inode via
> super_cache_scan() and prune_icache_sb().  The eviction path eventually
> calls ext4_discard_preallocations(), which explicitly does:
> 
>     err = ext4_mb_load_buddy_gfp(sb, group, &e4b,
>                                  GFP_NOFS | __GFP_NOFAIL);
> 
> If the buddy-cache folio isn't resident, ext4_mb_load_buddy_gfp()
> allocates one through __filemap_get_folio().  This reaches
> __alloc_pages_slowpath() with __GFP_NOFAIL while PF_MEMALLOC is set,
> triggering the warning.
> 
> Simply removing __GFP_NOFAIL doesn't look safe.  The preallocations
> have already been detached from the inode's tree, and failure to load
> the buddy information can prevent their space from being released
> correctly.
> 
> It seems that ext4 needs a way to complete this mandatory cleanup
> without performing a NOFAIL allocation from the slab-shrinker context. 
> Perhaps the preallocation cleanup could be restructured so that it
> doesn't require allocating buddy-cache folios during reclaim?
> 
> The syzbot report is at:
> https://syzkaller.appspot.com/bug?extid=54f6a8926b40a171f2c8

Jan already has a series which will fix these kind of issues:
http://lore.kernel.org/20261009133253.20102-1-jack@suse.cz
