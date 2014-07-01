From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Generated files in e2fsprogs git repo
Date: Mon, 30 Jun 2014 21:02:50 -0400
Message-ID: <20140701010250.GA23932@thunk.org>
References: <CAJTo0LYeerPnHpaxAw36N7BiWH4PKUMAX=1j+Szc7J9zvB7jjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Burton, Ross" <ross.burton@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38050 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbaGABCy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jun 2014 21:02:54 -0400
Content-Disposition: inline
In-Reply-To: <CAJTo0LYeerPnHpaxAw36N7BiWH4PKUMAX=1j+Szc7J9zvB7jjw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 30, 2014 at 05:52:29PM +0100, Burton, Ross wrote:
> 
> Would anyone object to a patch set to remove all generated files
> (aclocal.m4, configure, intl/*, po/Makefile.in.in, etc) from the
> e2fsprogs git repository?  They'll still exist in tarballs, but anyone
> building from git would need to run autoreconf to regenerate them -
> the plus side being that the shipped aclocal.m4 won't be forcing
> archaic macros onto users.


I don't trust autoreconf.  Different versions of autoconf can end up
with different incompatible versions of autoconf macros, and I have
seen some rather disastrous failures as a result.  That's why I update
autoconf under my control, and if you run autoreconf as a user, and it
breaks because the "archaic macros" work, and the "new shiny" macros
fail, that's your problem, and I will laugh at you....

      	     	  	       	      - Ted
