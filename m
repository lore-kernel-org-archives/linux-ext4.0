From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Subject: Re: [PATCH 0/6] ext[24]: MBCache rewrite
Date: Sat, 12 Dec 2015 00:57:01 +0100
Message-ID: <CAHpGcMKvyBqouqaq7zhCrxDCjW3vq_GE_wfoDyK00=ppPeYWzQ@mail.gmail.com>
References: <1449683858-28936-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Laurent GUERBY <laurent@guerby.net>,
	Andreas Dilger <adilger@dilger.ca>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:33396 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbbLKX5D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Dec 2015 18:57:03 -0500
Received: by mail-wm0-f53.google.com with SMTP id c201so93031122wme.0
        for <linux-ext4@vger.kernel.org>; Fri, 11 Dec 2015 15:57:02 -0800 (PST)
In-Reply-To: <1449683858-28936-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan,

2015-12-09 18:57 GMT+01:00 Jan Kara <jack@suse.cz>:
> Hello,
>
> inspired by recent reports [1] of problems with mbcache I had a look into what
> we could to improve it. I found the current code rather overengineered
> (counting with single entry being in several indices, having homegrown
> implementation of rw semaphore, ...).
>
> After some thinking I've decided to just reimplement mbcache instead of
> improving the original code in small steps since the fundamental changes in
> locking and layout would be actually harder to review in small steps than in
> one big chunk and overall the new mbcache is actually pretty simple piece of
> code (~450 lines).
>
> The result of rewrite is smaller code (almost half the original size), smaller
> cache entries (7 longs instead of 13), and better performance (see below
> for details).

I agree that mbcache has scalability problems worth fixing; you may
also be right about replacing instead of fixing it.

I would prefer an actual replacement over adding mbcache2 though: the
two existing users will be converted immediately; there is no point in
keeping the old version around. For that, can the current mbcache be
converted to the API of the new one in a separate patch first (alloc +
insert vs. create, get + release/free vs. delete_block)?

The corner cases that mbcache has problems with are:

(1) Many files with the same xattrs: Right now, an xattr block can be
shared among at most EXT[24]_XATTR_REFCOUNT_MAX = 2^10 inodes. If 2^20
inodes are cached, they will have at least 2^10 xattr blocks, all of
which will end up in the same hash chain. An xattr block should be
removed from the mbcache once it has reached its maximum refcount, but
if I haven't overlooked something, this doesn't happen right now.
Fixing that should be relatively easy.

(2) Very many files with unique xattrs. We might be able to come up
with a reasonable heuristic or tweaking knob for detecting this case;
if not, we could at least use a resizable hash table to keep the hash
chains reasonably short.

Thanks,
Andreas
