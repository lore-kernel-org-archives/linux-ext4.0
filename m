From: Theodore Tso <tytso@mit.edu>
Subject: Re: duplicate entries on ext3 when using readdir/readdir64
Date: Thu, 14 Aug 2008 10:52:29 -0400
Message-ID: <20080814145229.GA8256@mit.edu>
References: <1217583820.12454.20.camel@kannnix.a2x.lan.at> <20080801121658.GG8736@mit.edu> <1217933631.14552.45.camel@kannnix.a2x.lan.at> <20080806140722.GA14109@mit.edu> <170fa0d20808131421j3e4955dcra611509f1a094547@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thomas Trauner <tt@it-austria.net>, linux-ext4@vger.kernel.org,
	ext3-users <ext3-users@redhat.com>
To: Mike Snitzer <snitzer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:34213 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750738AbYHNOwf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Aug 2008 10:52:35 -0400
Content-Disposition: inline
In-Reply-To: <170fa0d20808131421j3e4955dcra611509f1a094547@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 13, 2008 at 05:21:20PM -0400, Mike Snitzer wrote:
> 
> The attached patch has served my employer (IBRIX) well for 2.5 years.
> It was only recently, when I re-raised this issue internally based on
> this thread, that a co-worker recalled the fix.
> 

I can confirm that this patch fixes things; I also have this patch
ported to ext4.  I need a Signed-off-by before I can push this to
Linus, though.

							- Ted
