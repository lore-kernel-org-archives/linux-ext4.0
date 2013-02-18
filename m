From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [BUG] xfstests #68 with data=journal hang against 3.8-rc7 and
 'dev' branch
Date: Mon, 18 Feb 2013 00:04:22 -0500
Message-ID: <20130218050422.GD10361@thunk.org>
References: <20130217172208.GB4059@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48711 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab3BRFEY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Feb 2013 00:04:24 -0500
Content-Disposition: inline
In-Reply-To: <20130217172208.GB4059@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 18, 2013 at 01:22:08AM +0800, Zheng Liu wrote:
> Hi all,
> 
> Xfstests #68 will hang with data=journal in 3.8-rc7 and 'dev' branch. I
> remember that there has a patch for ext4 to fix filesystem freeze bug
> but I am not sure whether it can fix this bug and it has been applied
> into 'dev' branch.  So I file this bug here.

Hmm.... I have never seen this test fail with my tests (although I'm
just using the dev branch; I have not tried merging in 3.8-rc7 into
the dev branch for any of my tests).

Is it failing for you reliably?

The commit which I think you are referring to fixed a bug where a user
was trying to freeze a file systme which was mounted over a FUSE
partition.  It's certainly in dev; it's not marked for inclusion for
the stable patch series since it's an optimization change, and it was
not intended to fix something which is inherently dangerous (and if it
works, it's purely by luck, since the FUSE userspace will get frozen
before the file system is necessarily done doing its journal freeze
operation; the change may have affected the timing so that the user
would get lucky, but it's a sheer chance thing, and there's no
guarantee the user will lose later).

					- Ted
