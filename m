From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Ocfs2-devel] [PATCH] [RFC] jbd2: Add buffer triggers
Date: Fri, 17 Oct 2008 08:28:40 -0400
Message-ID: <20081017122840.GD21503@mit.edu>
References: <20080917232629.GB20752@mail.oracle.com> <20080929012527.GI8711@mit.edu> <20081004000336.GE11442@mit.edu> <20081006213754.GA26632@mail.oracle.com> <20081006214251.GB26632@mail.oracle.com> <20081006233248.GA9337@mit.edu> <20081007010154.GE26632@mail.oracle.com> <20081008231752.GA5310@mail.oracle.com> <20081016174241.GH12962@mit.edu> <20081016194011.GA4748@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: ocfs2-devel@oss.oracle.com, linux-ext4@vger.kernel.org,
	mfasheh@suse.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:55686 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753436AbYJQM2n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Oct 2008 08:28:43 -0400
Content-Disposition: inline
In-Reply-To: <20081016194011.GA4748@mail.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 16, 2008 at 12:40:11PM -0700, Joel Becker wrote:
> 	Actually, I've had the fixed up patch for a week, tested even.
> You caught me this morning as I was rebasing against Linus.  Sorry I
> didn't send it out sooner.   The only difference from your version, that
> I can tell, is that I unconditionally call the commit trigger function -
> it handles checking for empty b_trigger, etc.
> 

Looks good to me.

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

Given that OCFS2 is going to be the first user of this patch, I guess
it would make sense for you to push it to Linus in an ocfs2 branch?
Or would you like me to send it to Linus?

							- Ted
