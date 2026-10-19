Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792453600;
	b=0Cq/l6/KredEYSESMubNQxnjg9ZxkYnitMs3OSnaCzKKvYdab/I54RLM2WHWIFi+yAIy
	 /a5HFWgQWLRldNNYWJS9OBUSptbxiks4PCDoh740CZPjtlk1jOmWjouN57IPnzNKCeVI+
	 p3ca1tPD5dpHy2lWBYFFTAEeYzyRrV8xms4n0Q14ZJC6ZSREWir5c/AxPXhkTUPFjOKLo
	 5/tb/OzPlYpkzq25hOs1pwXAzp6/URNDFEGNk0uANYRKYda0bIiYorOfh8rb2M6Jt0bma
	 gSR/yHihGmkmLaY01Ta3zLQ7BO4N3T7thLGopCwoLKy8XDU3u//zxUcVDC8VvT96Eeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792453600;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=lnbJ/fWoD11/g9szFmuzDGasP/1e2AgpJzFnEjFUq1Y=;
	b=W+skSF1UiWmnJM53UwWSS7wQ0Dt2BRjaoFtuvri0KvYQiAHHsjCe2qo79G5Yb0ICK6eE
	 SLQXL6ec428jTZCVqr+YZ5hSY5Y6ovh8hWzVSgu3y1NbhHyHUq4BgUU58QLybswk3BtoF
	 gSitRVl3mDmTp7P7Y1aj/u10WVSRC4SUKGdHjLgu/w8ShxNh8WwwFNZ5QEpjmIQ/AlnoE
	 6LoqI04IOPCO7e/zXByR7wTUmjmnfcqFNMSX2Huxkc6sYjG2K7K9UdsqLjXqz/rf8aqVG
	 7c8smfrztI5f3LrQcFdWOesdGf4/bZkmfzeMXI8/8Ox1rok2SnRhQzcPz/Y4GK0fz3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Xz2PyeQW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3028C606A319;
	Mon, 19 Oct 2026 23:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Xz2PyeQW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EED61F000C4;
	Mon, 19 Oct 2026 23:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792453599;
	bh=lnbJ/fWoD11/g9szFmuzDGasP/1e2AgpJzFnEjFUq1Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Xz2PyeQWC71Jdv+LVHPfpQH3SZFM38V7OqQRR6Rn+L0Or9GHlKTA9epcwDawRBhIW
	 o6Xjx+ug/q8y2FztLjpwhbc6LgdWxI5Xjwh7kTUZxVKLQRo3/YAl9XTCM+8srtVkkj
	 lzuNM0WK2JrER1UjAq1N6orohUxovMraATbR+YcY=
Date: Mon, 19 Oct 2026 16:46:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+54f6a8926b40a171f2c8@syzkaller.appspotmail.com>
Cc: david@kernel.org, gourry@gourry.net, joshua.hahnjy@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, rakie.kim@sk.com,
 syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, linux-ext4@vger.kernel.org, Vlastimil Babka
 <vbabka@suse.cz>, Barry Song <baohua@kernel.org>, Theodore Ts'o
 <tytso@mit.edu>
Subject: Re: [syzbot] [mm?] WARNING in shrink_one
Message-Id: <20261019164638.c33e70eaefbee802eefb4716@linux-foundation.org>
In-Reply-To: <6ad67231.a20cb897.960b0.0042.GAE@google.com>
References: <6ad67231.a20cb897.960b0.0042.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 19 Oct 2026 12:40:33 -0700 syzbot <syzbot+54f6a8926b40a171f2c8@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    a0ff06b3a7bd Merge tag 'firewire-fixes-7.3-final' of git:/..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=12cdb20d580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=44ac479246d4559b
> dashboard link: https://syzkaller.appspot.com/bug?extid=54f6a8926b40a171f2c8
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> userspace arch: i386
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-a0ff06b3.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/3f4bcbceb92e/vmlinux-a0ff06b3.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/bf4df8252e54/bzImage-a0ff06b3.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+54f6a8926b40a171f2c8@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> current->flags & PF_MEMALLOC
> WARNING: mm/page_alloc.c:4816 at __alloc_pages_slowpath mm/page_alloc.c:4816 [inline], CPU#3: syz-executor/5706
> WARNING: mm/page_alloc.c:4816 at __alloc_frozen_pages_noprof+0x1eac/0x3300 mm/page_alloc.c:5449, CPU#3: syz-executor/5706

Thanks.  The stack trace is missing important bits for some reason, but
it appears to be ext4 disagreeing with page reclaim.

__alloc_pages_slowpath():
	if (unlikely(nofail)) {
		/*
		 * We don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
		 * otherwise, we may result in lockup.
		 */
		WARN_ON_ONCE(!can_direct_reclaim);
		/*
		 * PF_MEMALLOC request from this context is rather bizarre
		 * because we cannot reclaim anything and only can loop waiting
		 * for somebody to do a work for us.
		 */
-->>		WARN_ON_ONCE(current->flags & PF_MEMALLOC);
	}

The electrical think machine said:


filemap_fault()
  -> direct reclaim
     -> shrink_slab()
        -> super_cache_scan()
           -> prune_icache_sb()
              -> evict()
                 -> ext4_evict_inode()
                    -> ext4_clear_inode()
                       -> ext4_discard_preallocations()
                          -> ext4_mb_load_buddy_gfp(
                               GFP_NOFS | __GFP_NOFAIL)
                             -> __filemap_get_folio()
                                -> page allocator
                                   -> WARN_ON(PF_MEMALLOC)


The task enters direct reclaim after a filemap allocation failure. 
Reclaim calls shrink_slab(), which evicts an ext4 inode via
super_cache_scan() and prune_icache_sb().  The eviction path eventually
calls ext4_discard_preallocations(), which explicitly does:

    err = ext4_mb_load_buddy_gfp(sb, group, &e4b,
                                 GFP_NOFS | __GFP_NOFAIL);

If the buddy-cache folio isn't resident, ext4_mb_load_buddy_gfp()
allocates one through __filemap_get_folio().  This reaches
__alloc_pages_slowpath() with __GFP_NOFAIL while PF_MEMALLOC is set,
triggering the warning.

Simply removing __GFP_NOFAIL doesn't look safe.  The preallocations
have already been detached from the inode's tree, and failure to load
the buddy information can prevent their space from being released
correctly.

It seems that ext4 needs a way to complete this mandatory cleanup
without performing a NOFAIL allocation from the slab-shrinker context. 
Perhaps the preallocation cleanup could be restructured so that it
doesn't require allocating buddy-cache folios during reclaim?

The syzbot report is at:
https://syzkaller.appspot.com/bug?extid=54f6a8926b40a171f2c8

