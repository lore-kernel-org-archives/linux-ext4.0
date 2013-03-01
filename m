From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL URGENT] ext4 regression fix for 3.9
Date: Thu, 28 Feb 2013 23:00:39 -0500
Message-ID: <20130301040039.GA4452@thunk.org>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	"gnehzuil.liu" <gnehzuil.liu@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>,
	Borislav Petkov <bp@alien8.de>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50691 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab3CAEAz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Feb 2013 23:00:55 -0500
Content-Disposition: inline
In-Reply-To: <20130301033005.GA7081@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 28, 2013 at 10:30:05PM -0500, Dave Jones wrote:
> 
> This has fixed the problem I reported, but I notice now that my
> desktop is really sluggish. perf top shows it's almost constantly
> spinning in ext4_es_reclaim_extents_count
> 
> Any ideas ?

ext4_es_reclaim_extents_count() is getting called out of the slab
shrinker.  It's getting called too often when there is significant
memory pressure.  We can optimize this so we're not calculating it all
the time.

						- Ted
