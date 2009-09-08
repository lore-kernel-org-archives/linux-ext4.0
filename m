From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Make non-journal fsync work properly.
Date: Tue, 8 Sep 2009 18:05:04 -0400
Message-ID: <20090908220504.GS22901@mit.edu>
References: <1252119300.23871.7.camel@bobble.smo.corp.google.com> <20090908050614.GA10477@mit.edu> <1252424465.17646.7.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:49193 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbZIHWFH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Sep 2009 18:05:07 -0400
Content-Disposition: inline
In-Reply-To: <1252424465.17646.7.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 08, 2009 at 08:41:05AM -0700, Frank Mayhar wrote:
> I needed to doublecheck before answering but I think I've covered that
> angle.  Specifically, in ext4_write_inode the patch only calls
> ext4_do_update_inode() if s_journal is NULL, otherwise it takes the
> current path.
> 
> So I think your concern is covered by the current patch.  Can you take
> another look and let me know if you agree?  Thanks.

It wasn't obvious from reading the diff, but after I applied the patch
and looked more closely, you're right.  I'm still worried though that
the code is a bit fragile.  At the very *least* the restriction that
ext4_do_update_inode's do_sync flag should only be called when there
is no journal needs to be explicitly documented.  Possibly we should
have a BUG() check to enforce this restriction; although a comment
before ext4_do_update_inode() is probably enough.

							- Ted


					
