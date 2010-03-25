From: tytso@mit.edu
Subject: Re: [PATCH] ext4/super.c: Replace CONTIG_EXT{2,3}_FS by
 CONFIG_EXT{2,3}_FS
Date: Wed, 24 Mar 2010 21:59:46 -0400
Message-ID: <20100325015945.GK2159@thunk.org>
References: <2d0a357f1003240405x1178f0c6x188d30d1d311cb5@mail.gmail.com>
 <20100324161201.GG2159@thunk.org>
 <2d0a357f1003240957r21f869cft5685d2e214f47914@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: sedat.dilek@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55858 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab0CYCA1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Mar 2010 22:00:27 -0400
Content-Disposition: inline
In-Reply-To: <2d0a357f1003240957r21f869cft5685d2e214f47914@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 24, 2010 at 05:57:34PM +0100, Sedat Dilek wrote:
> Thanks for the fast fix - hope this goes soon into linus-tree.

So I hadn't sent the pull request to Linus, and when I was looking
over the patches, I realized that (a) the patch that broke the build
hadn't been pushed to Linus yet, and (b) I wanted to pull a patch from
the patch series since I didn't think it was appropriate at this point
in the release cycle.  So I ended up rewinding my for_linus branch,
and I'll be pushing something to Linus tonight.

Regards,

						- Ted
