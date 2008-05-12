From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4dev build failure on mips: "empty_zero_page" undefined
Date: Mon, 12 May 2008 13:35:38 -0400
Message-ID: <20080512173537.GG7029@mit.edu>
References: <20080512130604.GA15008@deprecation.cyrius.com> <90edad820805120654n50f7a00cm3c7b4a4f9346d5ea@mail.gmail.com> <20080512143426.GB7029@mit.edu> <20080512145836.GE15866@deprecation.cyrius.com> <90edad820805120814l7ee3f5d3h7f9939854bccf0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Martin Michlmayr <tbm@cyrius.com>, linux-mips@linux-mips.org,
	linux-ext4@vger.kernel.org
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:45086 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753996AbYELRfw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 May 2008 13:35:52 -0400
Content-Disposition: inline
In-Reply-To: <90edad820805120814l7ee3f5d3h7f9939854bccf0@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 12, 2008 at 07:14:23PM +0400, Dmitri Vorobiev wrote:
> 
> It was April 29th 2008 when commit
> 093a088b76352e0a6fdca84eb78b3aa65fbe6dd1 where the ext4_ext_zeroout()
> routine was introduced (it is this routine that makes use of the
> ZERO_PAGE macro expanding to an expression that contains a reference
> to the empty_zero_page global symbol). After this commit, the patches
> similar to the one found in this thread were made for several
> architectures. Apparently, MIPS has been overlooked.
> 

Yeah, I guess no one is currently doing test builds of linux-next on
the mips architecture.  It's likely Stephen Rothwell doesn't have
access to one.

(The patch itself has been around for a while, both in the -mm tree,
the ext4 patches, and in Linux-next.)

						- Ted
