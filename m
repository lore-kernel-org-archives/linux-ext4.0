From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsprogs-interim scm tree?
Date: Tue, 20 Nov 2007 13:45:22 -0500
Message-ID: <20071120184522.GF13125@thunk.org>
References: <alpine.DEB.0.99999.0711200128130.7426@sheep.housecafe.de> <20071120031127.GB13125@thunk.org> <14319.62.180.231.196.1195554243.squirrel@housecafe.dyndns.org> <20071120140420.GC13125@thunk.org> <4742F5A9.3070301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christian Kujau <lists@nerdbynature.de>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34595 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbXKTSpm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Nov 2007 13:45:42 -0500
Content-Disposition: inline
In-Reply-To: <4742F5A9.3070301@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 20, 2007 at 08:56:41AM -0600, Eric Sandeen wrote:
> Theodore Tso wrote:
> > On Tue, Nov 20, 2007 at 11:24:03AM +0100, Christian Kujau wrote:
> >>> Note that the userspace code still needs a lot of work.
> >>> It's for this reason that I haven't been recommending people use it for
> >>> production systems just yet.
> >> Understood. But the more ppl testing your stuff the better, right?
> > 
> > Oh, absolutely.  I just don't think it's fair to encourage people to
> > use something that might cause them to risk their data unless they are
> > going into it with their eyes wide open.
> 
> Please do report any problems you find, though.  Ted has said that the
> sourceforge bugtracker is the right place to do this for now.

BTW, when reporting a bugs against the git tree, please include the
branch and the git ID (i.e., that which is reported by git-describe),
so there is no question which version you were running at the time.
The git ID won't be helpful if you have your own local commits against
the tree, but it can be useful if you are reporting a bug against the
"pu" branch and it has since been rewound as patches get rebased and
revised.

						- Ted
