From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH v1 4/10] lib/siphash.c: New file
Date: 6 Dec 2014 18:32:00 -0500
Message-ID: <20141206233200.3175.qmail@ns.horizon.com>
References: <20140929191243.GN10150@birch.djwong.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: darrick.wong@oracle.com, linux@horizon.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:46485 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751203AbaLFXin (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 6 Dec 2014 18:38:43 -0500
In-Reply-To: <20140929191243.GN10150@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 229 2014 at 12:12:43 -0700, Darrick J. Wong wrote:
> Could you please make this part of crypto/ so that anyone who wants to
> improve upon the C implementation (Google suggests that SSE/AVX ports
> are possible) can do so easily?

Well, *that* was a rabbit hole.  It seems like an obviously good idea,
but let's just say that crypto/ is non-obvious.  (No, it didn't take me 2
months of work; I just got sidetracked a lot because it was discouraging.)
But now that my cleanup patches there are getting reviewed, I can answer.

Basically, to fit into the crypto layer would require a very different
implementation with a lot more overhead.  The code I proposed is optimized
for both size and performance in the single-contiguous-small-buffer case
that apples to file names.

There's are no separate init/update/final calls, no saving internal
state to memory, no handling of discontiguous input buffers, etc.

This is all because SipHash is designed to be *extremely* lightweight,
so the overhead of marshalling the input bytes is noticeable.

I could easily write a *separate* implementation for crypto/, and
it could share source code, but it wouldn't be the same object code.


> This would also make it so that ext4 only loads the algorithm when necessary.

Yes, but my Cunning Plan is to replace the MD5 use in net/core_secure_seq.c
with this, too.  And, after careful consultation with Ted, the one in
get_random_int, too.

With all the simplifying assumptions I mentioed above made specifically in
order to get it down to negligible size, the code is 454 bytes long with
-O2, 397 bytes with -Os.  Is that worth the overhead of a separate module?
