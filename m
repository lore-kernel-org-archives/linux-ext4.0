From: tytso@mit.edu
Subject: Re: [RFC] do you want jbd2 interface of ext3?
Date: Wed, 17 Feb 2010 14:16:29 -0500
Message-ID: <20100217191629.GE5337@thunk.org>
References: <20100216164123.b10b00e5.toshi.okajima@jp.fujitsu.com>
 <20100216185452.GE3153@quack.suse.cz>
 <4B7BAA70.9070605@jp.fujitsu.com>
 <20100217164933.GC5337@thunk.org>
 <87f94c371002171009i2a8ffe2aib43b82c1cf65104@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	Jan Kara <jack@suse.cz>, akpm@linux-foundation.org,
	adilger@sun.com, linux-ext4@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:55297 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090Ab0BQTQn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Feb 2010 14:16:43 -0500
Content-Disposition: inline
In-Reply-To: <87f94c371002171009i2a8ffe2aib43b82c1cf65104@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 17, 2010 at 01:09:30PM -0500, Greg Freemyer wrote:
> 
> Having little knowledge on my part, it sounds like it is time to open
> up jdb3 for leading edge development and turn jdb2 into the new stable
> platform and move jdb into legacy status.

There is no "leading edge" development currently planned (nor has
there been any for at least six months or so) for the journaling
block layer.

> If it really does only have one user at this time jdb is basically
> just legacy at this point anyway.

The one user is "ext3", and for a long time jbd has only been used by
ext3.  It's only recently that ocfs/ocfs2 started using jbd, and then
more recently they switch over to using jbd2.

I think people are fundamentally confused about the nature of jbd
versus ext3; jbd is a very fundamental part of ext3.  Heck, jbd was
originally written *for* ext3.  If jbd is "legacy", why not call ext3
"legacy"?  And what the heck does "legacy" mean, anyway?  If it means,
bug fixes only, that's the state of ext3 and jbd for the most part
anyway.

Yes, there have been a bunch of quota-related ext3 changes, but
they've been pretty much all been bug fixes, mainly because more
people are caring about quota now that people are much more seriously
thinking about using quota with as part of their virtualization
solution.  These bugs have been around in quota for a long time, but
since time sharing is so last century, for long time it wasn't getting
much attention.

     	      	       	       	      	      - Ted

