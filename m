From: Theodore Tso <tytso@mit.edu>
Subject: Re: EXT4 ENOSPC Bug
Date: Tue, 2 Dec 2008 23:37:12 -0500
Message-ID: <20081203043712.GJ20858@mit.edu>
References: <200811291418.24672.andres@anarazel.de> <200812021559.05103.andres@anarazel.de> <20081202164709.GC18162@mit.edu> <200812021847.35771.andres@anarazel.de> <20081202203315.GA20858@mit.edu> <4935D4C0.7050601@x2a.org> <4935D58B.4020002@x2a.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andres Freund <andres@anarazel.de>,
	Andreas Dilger <adilger@sun.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Jonathan Bastien-Filiatrault <joe@x2a.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:48609 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751148AbYLCEhV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Dec 2008 23:37:21 -0500
Content-Disposition: inline
In-Reply-To: <4935D58B.4020002@x2a.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 02, 2008 at 07:40:43PM -0500, Jonathan Bastien-Filiatrault wrote:
> Jonathan Bastien-Filiatrault wrote:
> > Theodore Tso wrote:
> > 
> >> Hmm...  really?  Was the error message ENOSPC, or something else?
> >>
> > I can confirm I get a ENOSPC on open/creat. Here is the relevant output
> > from strace touch test:
> > 
> (Sorry for replying to myself)
> 
> This happened while compiling a kernel with ccache enabled (with a
> relatively low hit rate for this specific build). Vuze was also opened,
> but with no active download.

Hmm... I build with ccache all the time.  I normally don't run a
bittorrent client, though.  What kernel version are you using?

Any chance you can apply the patch which I sent earlier in this
thread, trigger the debugging ioctl when it happens again?

Thanks,

		    	      	    	    - Ted
