From: Theodore Tso <tytso@mit.edu>
Subject: Re: Oops with ext4 from 2.6.27-rc3
Date: Wed, 13 Aug 2008 17:04:08 -0400
Message-ID: <20080813210408.GC6142@mit.edu>
References: <47983.10.5.1.205.1218652098.squirrel@webmail.lugor.de> <20080813201004.GJ8232@mit.edu> <200808132255.10194.mail@eworm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christian Hesse <mail@eworm.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:45572 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751832AbYHMVEK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Aug 2008 17:04:10 -0400
Content-Disposition: inline
In-Reply-To: <200808132255.10194.mail@eworm.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 13, 2008 at 10:55:07PM +0200, Christian Hesse wrote:
> >
> > Can you reproduce the bug?
> 
> I can. ;)

Great!  I haven't been able to reproduce it myself, but I was using a
very quick test case on small toy filesystem.  My ext4 root filesystem
is 100% extent based files --- and this bug is only happening on
old-style files with indirect-block-style inodes.  And I'm trying to
get things done before leaving for a family reunion on Friday, so I
just don't have the time to set up a reproducer.

Can you verify whether or not my patch fixes things for you?

Thanks, regards,

							- Ted
