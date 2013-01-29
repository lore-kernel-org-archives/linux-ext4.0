From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] ext4: remove useless assignment in dx_probe()
Date: Mon, 28 Jan 2013 21:37:29 -0500
Message-ID: <20130129023729.GI7003@thunk.org>
References: <1358496074-6228-1-git-send-email-yan@linux.vnet.ibm.com>
 <1358496074-6228-3-git-send-email-yan@linux.vnet.ibm.com>
 <20130129012150.GB4754@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Guo Chao <yan@linux.vnet.ibm.com>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45975 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab3A2Chc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2013 21:37:32 -0500
Content-Disposition: inline
In-Reply-To: <20130129012150.GB4754@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 28, 2013 at 05:21:50PM -0800, Darrick J. Wong wrote:
> 
> The 'at' variable seems to be used (in a if(0)'d code block) to
> check the results of the binary search against a slow linear search.
> Perhaps we should get rid of the if(0) hunk about 30 lines up?  The
> 'at' variable itself could go too, since it seems to be an alias of
> "p - 1" and frame->at.

What I'd suggest doing (if someone is interested in doing the cleanup)
is moving the code into an inline function which is normally #ifdef'ed
to be an empty function, but which could be enabled if we want enable
the debugging cross check.  This is what we've done in other parts of
the ext4 code base, and by moving the debugging code so it's not
inline with the rest of the function, it should make it more readable.

						- Ted
