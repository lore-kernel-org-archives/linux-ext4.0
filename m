From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH]ext4: Add checks whether two inodes are different
Date: Tue, 29 Sep 2009 10:49:14 -0400
Message-ID: <20090929144914.GD24383@mit.edu>
References: <4ABC7FC5.5070803@rs.jp.nec.com> <20090925103453.GR10562@webber.adilger.int> <20090928200000.GA22733@mit.edu> <4AC198AF.1070600@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51772 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbZI2OtQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Sep 2009 10:49:16 -0400
Content-Disposition: inline
In-Reply-To: <4AC198AF.1070600@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 29, 2009 at 02:18:39PM +0900, Akira Fujita wrote:
> I thought the argument check (orig and donor inodes are different)
> should be done in mext_check_arguments()

Sometimes separating things into multiple functions can actually make
things harder to understand, since it means you have to jump all over
the file to follow what a particular function is doing.  Sometimes
having a function which is nested deeply in a loop can be made easier
to understand by separating it out into a separate function which is
called once.

Part of the reason why mext_check_arguments() is so huge is because of
all of the ext4_debug() statements.  It's not clear to me they really
all need to be there.  I'd also use EBUSY if the file is a swap file,
so it's easier for the userspace code to understand what is going on
in that case.  For the other many cases where EINVAL is returned,
hopefully that's obvious enough for userspace to figure out without
having to resort to looking to the system debug logs.

       	  	    	       	   	  	- Ted
