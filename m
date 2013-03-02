From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL URGENT] ext4 regression fix for 3.9
Date: Sat, 2 Mar 2013 11:54:37 -0800
Message-ID: <CA+55aFxEfKTeGmX57R0s+2MaQwfgqvVnf+M3zkwNk0rN0j7Ksg@mail.gmail.com>
References: <20130227172256.GA236@x4>
	<7BFB2135-A1F0-4B6D-9962-16E75E5560F8@gmail.com>
	<20130227174553.GA224@x4>
	<CA+55aFwWA1jPEEQNx_5oJ6Ze=3yFb6=E9nraBfX-Ve=WjRkQMw@mail.gmail.com>
	<20130227184912.GA19624@thunk.org>
	<20130227185625.GA224@x4>
	<20130227191923.GA1121@redhat.com>
	<20130227192907.GB14253@thunk.org>
	<20130227201217.GD14253@thunk.org>
	<20130301033005.GA7081@redhat.com>
	<20130301040039.GA4452@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>, Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	"gnehzuil.liu" <gnehzuil.liu@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>,
	Borislav Petkov <bp@alien8.de>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ve0-f173.google.com ([209.85.128.173]:62072 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab3CBTyi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Mar 2013 14:54:38 -0500
In-Reply-To: <20130301040039.GA4452@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 28, 2013 at 8:00 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> ext4_es_reclaim_extents_count() is getting called out of the slab
> shrinker.  It's getting called too often when there is significant
> memory pressure.  We can optimize this so we're not calculating it all
> the time.

This needs to be fixed or reverted. I traced back some user
interaction problems to this same issue. It literally gets so bad that
the whole system is choppy, and a profile shows that a lot of time is
being spent in the spin-lock protecting these data structures. Called
from ext4_es_reclaim_extents_count, ext4_es_lru_add and
ext4_es_shrink.

We're talking very user-noticeable pauses, so it's not just the
spinlock, there's some real badness that comes in with it too.
Possibly related to other (sleeping) locks being held while the data
structures are then refilled or something.

                   Linus
