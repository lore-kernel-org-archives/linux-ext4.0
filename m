From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [PATCH] Make non-journal fsync work properly.
Date: Tue, 08 Sep 2009 15:39:51 -0700
Message-ID: <1252449591.15572.5.camel@bobble.smo.corp.google.com>
References: <1252119300.23871.7.camel@bobble.smo.corp.google.com>
	 <20090908050614.GA10477@mit.edu>
	 <1252424465.17646.7.camel@bobble.smo.corp.google.com>
	 <20090908220504.GS22901@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:44149 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbZIHWj4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Sep 2009 18:39:56 -0400
In-Reply-To: <20090908220504.GS22901@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2009-09-08 at 18:05 -0400, Theodore Tso wrote:
> On Tue, Sep 08, 2009 at 08:41:05AM -0700, Frank Mayhar wrote:
> > I needed to doublecheck before answering but I think I've covered that
> > angle.  Specifically, in ext4_write_inode the patch only calls
> > ext4_do_update_inode() if s_journal is NULL, otherwise it takes the
> > current path.
> > 
> > So I think your concern is covered by the current patch.  Can you take
> > another look and let me know if you agree?  Thanks.
> 
> It wasn't obvious from reading the diff, but after I applied the patch
> and looked more closely, you're right.  I'm still worried though that
> the code is a bit fragile.  At the very *least* the restriction that
> ext4_do_update_inode's do_sync flag should only be called when there
> is no journal needs to be explicitly documented.  Possibly we should
> have a BUG() check to enforce this restriction; although a comment
> before ext4_do_update_inode() is probably enough.

I agree that the code as-is is a bit fragile.  Commentary is good but it
would probably be better to enforce the journal/no journal distinction
in ext4_do_update_inode() itself.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

