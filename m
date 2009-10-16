From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Bug 14354] Re: ext4 increased intolerance to unclean shutdown?
Date: Fri, 16 Oct 2009 09:06:38 -0400
Message-ID: <20091016130638.GA8196@mit.edu>
References: <f7848160910152128h96237b7ga103915082d6412b@mail.gmail.com> <20091016091558.GA10184@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Parag Warudkar <parag.lkml@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54436 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759613AbZJPOOI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Oct 2009 10:14:08 -0400
Content-Disposition: inline
In-Reply-To: <20091016091558.GA10184@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 16, 2009 at 05:15:58AM -0400, Theodore Tso wrote:
> These are three commits that seem most likely, but there are
> only 93 ext4-related commits, so doing a "git bisect start v2.6.31
> v2.6.32-rc5 -- fs/ext4 fs/jbd2" 

One correction.  The git bsect start usage is:

     git bisect start [<bad> [<good>...]] [--] [<paths>...]

So the correct git bisect start command should be:

     git bisect start v2.6.32-rc5 v2.6.31 -- fs/ext4 fs/jbd2

And similarly, "git bisect start v2.6.31 v2.6.31-rc3" should have been:

     git bisect start v2.6.31-rc3 v2.6.31

My apologies for any confusion.

						- Ted
