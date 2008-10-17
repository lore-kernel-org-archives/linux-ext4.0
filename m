From: Mark Fasheh <mfasheh@suse.com>
Subject: Re: [Ocfs2-devel] [PATCH] [RFC] jbd2: Add buffer triggers
Date: Fri, 17 Oct 2008 10:11:21 -0700
Message-ID: <20081017171121.GB15154@wotan.suse.de>
References: <20080929012527.GI8711@mit.edu> <20081004000336.GE11442@mit.edu> <20081006213754.GA26632@mail.oracle.com> <20081006214251.GB26632@mail.oracle.com> <20081006233248.GA9337@mit.edu> <20081007010154.GE26632@mail.oracle.com> <20081008231752.GA5310@mail.oracle.com> <20081016174241.GH12962@mit.edu> <20081016194011.GA4748@mail.oracle.com> <20081017122840.GD21503@mit.edu>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ocfs2-devel@oss.oracle.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:44995 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbYJQRLX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Oct 2008 13:11:23 -0400
Content-Disposition: inline
In-Reply-To: <20081017122840.GD21503@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 17, 2008 at 08:28:40AM -0400, Theodore Tso wrote:
> Looks good to me.
> 
> Acked-by: "Theodore Ts'o" <tytso@mit.edu>

Excellet, thanks for the review.

> 
> Given that OCFS2 is going to be the first user of this patch, I guess
> it would make sense for you to push it to Linus in an ocfs2 branch?
> Or would you like me to send it to Linus?

I'll pick it up in ocfs2.git.

Thanks, Mark


--
Mark Fasheh
