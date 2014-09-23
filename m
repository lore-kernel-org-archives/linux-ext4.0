From: "George Spelvin" <linux@horizon.com>
Subject: Re: [RFC] mke2fs -E hash_alg=siphash: any interest?
Date: 23 Sep 2014 19:00:23 -0400
Message-ID: <20140923230023.19419.qmail@ns.horizon.com>
References: <24F09699-B86B-4F73-8D93-1650B2BFC483@dilger.ca>
Cc: linux-ext4@vger.kernel.org, linux@horizon.com
To: adilger@dilger.ca, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:31988 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757065AbaIWXAY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2014 19:00:24 -0400
In-Reply-To: <24F09699-B86B-4F73-8D93-1650B2BFC483@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Now that the patches are available, it makes sense to run some
> directory-intensive benchmark to see whether the improved hash
> function actually shows improved performance.  The hash may be
> somewhat faster, but since this is only hashing the filename and
> not KB/MB of data, it isn't clear whether this is going to improve
> observable performance of directory operations.

That's basically my current task, and why my v1 is kind of a draft
just to introduce the idea and flush out any comments on my choice of
identifier names and stuff like that.

Personally, I just like the cleanliness of using a primitive designed for
the purpose, but I benchmarked it to ensure it wouldn't be any *slower*.

> I'm not sure what a suitable benchmark for this is, however.  It
> needs to be doing filename lookups to exercise the hashing, but
> in the workloads that I can think of there is always a lot more
> work after the name is looked up (e.g. open(), stat(), etc) on
> the filename.  Some possibilities include "ls -l" or "mv A/* B/".
> It may be the only way to see the difference is via oprofile.

It's worse than that.  The dcache has an great hit rate, and you have to
force misses.  But if you actually hit the disk a lot, that will dwarf
hashing performance into unmeasurability.

So it requires a very cleverly designed benchmark to highlight it.

> It also isn't clear whether the strength of siphash is significantly
> better than "halfmd4", which is already cryptographically-strong.
> Since the filename hash is also a function of the filesystem-unique
> s_hash_seed, mounting an "attack" on a directory needs to be specific
> to a particular filesystem, and isn't portable to other filesystems.

There are two definitions of "stronger":

1) The unknowable truth, and
2) It has been subjected to a lot of analysis and appears to hold up well.

By criterion 2, SipHash *is* significantly stronger: it's presented at
crypto conferences, been studied, and is widely used.

halfmd4 a very ad-hoc primitive that I don't think anyone's looked at
seriously.

It's not obviously terrible, and it's possible that halfmd4 is more work
to break, but we won't know until someone with cryptanalytic skill takes
a swing at it.
