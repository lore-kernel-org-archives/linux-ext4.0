From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 00/22] ext4 encryption patches
Date: Tue, 7 Apr 2015 23:07:48 -0400
Message-ID: <20150408030748.GC21171@thunk.org>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu>
 <20150406222800.62bf4cc3@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jaegeuk@kernel.org, mhalcrow@google.com
To: Jonathan Corbet <corbet@lwn.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55740 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbbDHDHv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Apr 2015 23:07:51 -0400
Content-Disposition: inline
In-Reply-To: <20150406222800.62bf4cc3@lwn.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 06, 2015 at 10:28:00PM +0200, Jonathan Corbet wrote:
> On Thu,  2 Apr 2015 18:10:37 -0400
> Theodore Ts'o <tytso@mit.edu> wrote:
> 
> > There is a design document here.  It should hopefully be mostly up to
> > date, but there are a few things that we might end up changing (for
> > example, just using CTS all the time for protecting directory file
> > names).
> > 
> > https://docs.google.com/document/d/1IsyQ9DU1gA6NUqS0jF4ni_NTvv-b0HfCkRk47Zkd7W0
> 
> I just tried to take a look at this, but it tells me that I don't have
> permission to do so.  Presumably that's not what was intended?

Sorry, wrong URL.  It should have been:

https://docs.google.com/document/d/1ft26lUQyuSpiu6VleP70_npaWdRfXFoNnB8JYnykNTg

And Andreas has pointed out there are a few places where it may be
slightly out of date.  So it's good for checking the general idea, but
some of the details may not be quite right.  In particular, we are now
using CTS (Ciphertext Stealing) mode for directory entries, instead of
the weird thing described in the design doc.

							- Ted
							
