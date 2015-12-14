From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Subject: Re: [PATCH 0/6] ext[24]: MBCache rewrite
Date: Mon, 14 Dec 2015 23:47:31 +0100
Message-ID: <CAHpGcMLo2ScBw4E6x4ZVd+o5VX5toL0SqAH04Jb+ucnm5C84hA@mail.gmail.com>
References: <1449683858-28936-1-git-send-email-jack@suse.cz>
	<CAHpGcMKvyBqouqaq7zhCrxDCjW3vq_GE_wfoDyK00=ppPeYWzQ@mail.gmail.com>
	<20151214211410.GP8474@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Laurent GUERBY <laurent@guerby.net>,
	Andreas Dilger <adilger@dilger.ca>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:35564 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbbLNWrd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Dec 2015 17:47:33 -0500
Received: by mail-wm0-f44.google.com with SMTP id p66so66422150wmp.0
        for <linux-ext4@vger.kernel.org>; Mon, 14 Dec 2015 14:47:32 -0800 (PST)
In-Reply-To: <20151214211410.GP8474@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan,

2015-12-14 22:14 GMT+01:00 Jan Kara <jack@suse.cz>:
>> (1) Many files with the same xattrs: Right now, an xattr block can be
>> shared among at most EXT[24]_XATTR_REFCOUNT_MAX = 2^10 inodes. If 2^20
>
> Do you know why there's this limit BTW? The on-disk format can support upto
> 2^32 references...

the idea behind that is to limit the damage that a single bad block can cause.

>> inodes are cached, they will have at least 2^10 xattr blocks, all of
>> which will end up in the same hash chain. An xattr block should be
>> removed from the mbcache once it has reached its maximum refcount, but
>> if I haven't overlooked something, this doesn't happen right now.
>> Fixing that should be relatively easy.
>
> Yeah, that sounds like a good optimization. I'll try that.
>
>> (2) Very many files with unique xattrs. We might be able to come up
>> with a reasonable heuristic or tweaking knob for detecting this case;
>> if not, we could at least use a resizable hash table to keep the hash
>> chains reasonably short.
>
> So far we limit number of entries in the cache which keeps hash chains
> short as well. Using resizable hash table and letting the system balance
> number of cached entries just by shrinker is certainly possible however I'm
> not sure whether the complexity is really worth it.
>
> Regarding detection of unique xattrs: We could certainly detect trashing
> of mbcache relatively easily. The difficult part if how to detect when to
> enable it again because the workload can change. I'm thinking about some
> backoff mechanism like caching only each k-th entry asked to be inserted
> (starting with k = 1) and doubling k if we don't reach some low-watermark
> cache hit ratio in some number of cache lookups, reducing k to half if
> we reach high-watermark cache hit ratio.

Such a heuristic would probably start in the same state after each
reboot, so frequent reboots would lead to bad performance. Something
as dumb as a configurable list of unsharable xattr names would allow
to tune things without such problems and without adding much
complexity.

No matter what we end up doing here, mostly-unique xattrs on separate
blocks will always lead to bad performance compared to in-inode
xattrs. Some wasted memory for the mbcache is not the main problem
here.

Thanks,
Andreas
