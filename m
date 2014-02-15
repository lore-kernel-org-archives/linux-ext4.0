From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: kernel bug at fs/ext4/resize.c:409
Date: Sat, 15 Feb 2014 10:34:43 -0500
Message-ID: <20140215153443.GC7576@thunk.org>
References: <20140203182634.GA28811@shaniqua>
 <20140203185633.GA22856@thunk.org>
 <20140206210844.GA4335@helmut>
 <87sirnp2m3.fsf@openvz.org>
 <20140213145323.GA6296@helmut>
 <20140213211831.GA11480@thunk.org>
 <20140214201905.GA26292@helmut>
 <20140214234631.GC1748@thunk.org>
 <20140215031624.GI9176@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jon Bernard <jbernard@tuxion.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58326 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386AbaBOPeu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Feb 2014 10:34:50 -0500
Content-Disposition: inline
In-Reply-To: <20140215031624.GI9176@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 14, 2014 at 07:16:24PM -0800, Darrick J. Wong wrote:
> > 
> > Also, starting with e2fsprogs 1.42.10, there's another way you can
> 
> These three options (-rap) are available in 1.42.9.  Is there a particular
> reason not to use it before 1.42.10?

That was a typo, sorry.  I had intended to write 1.42.9, since 1.42.10
isn't out yet.

Checking to be sure, there are some coverity fixes for e2image that
are pending that aren't in 1.42.9 relating to e2image, but none of
them are super serious.  The worst of them is a printf type mismatch
when printing the final progress report.  This doesn't seem to cause a
problem on x86_64 architectures, but since it is a 64 vs 32 bit
mismatch, it could cause problems on 32 bit architectures.  I haven't
checked to see whether it causes a cosmetic failure, or a seg fault on
an i386 system, but if it is a seg fault, e2image would have completed
the file system copy at that point anyway.  In any case, this will be
fixed in the next release, and the fix is in the Debian package
already.


Thanks for adding this information to the ext4 wiki!

       	   	       		      	  - Ted
