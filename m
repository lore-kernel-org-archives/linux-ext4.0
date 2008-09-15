From: Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Mon, 15 Sep 2008 10:53:05 -0700
Message-ID: <20080915175305.GS4563@wotan.suse.de>
References: <E1Kea9F-0004L5-Ds@closure.thunk.org> <1221331767-16870-1-git-send-email-tytso@mit.edu> <2EC8176B-0AFA-4B36-A2F5-E51753A576A5@cam.ac.uk> <20080913212903.GF26128@mit.edu> <20080914134859.GB21746@infradead.org> <20080914175810.GB13074@mit.edu> <20080915144948.GB16491@infradead.org>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@MIT.EDU>, Anton Altaparmakov <aia21@cam.ac.uk>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linuxfoundation.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:49106 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbYIORxJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Sep 2008 13:53:09 -0400
Content-Disposition: inline
In-Reply-To: <20080915144948.GB16491@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 15, 2008 at 10:49:48AM -0400, Christoph Hellwig wrote:
> I agree to you (or someone elses - don't remember anymore) suggestion
> to put in more padding so we can add fields later.  I strongly disagree
> putting in features now that we neither have a user, nor a usecase or
> testcase for.

So, how about another 64 bits of padding in struct fiemap_extent? That could
help cover future uses like compression, which might require another 64 bit
offset field - we only have 32 bits of reserved space there right now.
	--Mark

--
Mark Fasheh
