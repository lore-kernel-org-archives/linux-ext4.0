From: Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Mon, 29 Sep 2008 14:13:40 -0700
Message-ID: <20080929211340.GF4563@wotan.suse.de>
References: <1221331767-16870-1-git-send-email-tytso@mit.edu> <2EC8176B-0AFA-4B36-A2F5-E51753A576A5@cam.ac.uk> <20080913212903.GF26128@mit.edu> <20080914134859.GB21746@infradead.org> <20080914175810.GB13074@mit.edu> <20080915144948.GB16491@infradead.org> <20080915175305.GS4563@wotan.suse.de> <20080916213106.GA10562@mit.edu> <20080920164759.GY27404@josefsipek.net> <20080929010720.GH8711@mit.edu>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Anton Altaparmakov <aia21@cam.ac.uk>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linuxfoundation.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:57171 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbYI2VNn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Sep 2008 17:13:43 -0400
Content-Disposition: inline
In-Reply-To: <20080929010720.GH8711@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 28, 2008 at 09:07:20PM -0400, Theodore Tso wrote:
> Do you have time to update the fiemap patchset so we can hopefully
> come to consensus and get this pushed to Linus in time for the
> upcoming merge window?

I can probably do this early next week. If that's not soon enough, I won't
be offended if you or someone else does the update. I agree, it seems like
we're pretty close to consensus.


> If not, I can take over for you and take over the care and feeding of
> this patchset so it can get pushed to Linus ASAP; I think we are
> pretty close to consensus on this interface, and I'd rather that we
> not lose momentum.

Why not let this sit in -mm for a cycle? I know how that sounds, considering
how long it's taken everyone to decide what color to paint the bicycle shed,
but at the least it'd give other file systems a chance to write their own
support patches. There's also the benefit of a little extra time for
ext4/ocfs2 to debug their own support patches. Do we lose any momentum if
the patches are 'complete' and in -mm with a target for 2.6.29?
	--Mark

--
Mark Fasheh
