From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Sun, 28 Sep 2008 21:07:20 -0400
Message-ID: <20080929010720.GH8711@mit.edu>
References: <E1Kea9F-0004L5-Ds@closure.thunk.org> <1221331767-16870-1-git-send-email-tytso@mit.edu> <2EC8176B-0AFA-4B36-A2F5-E51753A576A5@cam.ac.uk> <20080913212903.GF26128@mit.edu> <20080914134859.GB21746@infradead.org> <20080914175810.GB13074@mit.edu> <20080915144948.GB16491@infradead.org> <20080915175305.GS4563@wotan.suse.de> <20080916213106.GA10562@mit.edu> <20080920164759.GY27404@josefsipek.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Mark Fasheh <mfasheh@suse.com>,
	Christoph Hellwig <hch@infradead.org>,
	Anton Altaparmakov <aia21@cam.ac.uk>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linuxfoun
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:38113 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751684AbYI2BHo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 28 Sep 2008 21:07:44 -0400
Content-Disposition: inline
In-Reply-To: <20080920164759.GY27404@josefsipek.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mark,

Do you have time to update the fiemap patchset so we can hopefully
come to consensus and get this pushed to Linus in time for the
upcoming merge window?

If not, I can take over for you and take over the care and feeding of
this patchset so it can get pushed to Linus ASAP; I think we are
pretty close to consensus on this interface, and I'd rather that we
not lose momentum.

						- Ted
