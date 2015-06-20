From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [e2fsprogs] rename configure.in to configure.ac
Date: Sat, 20 Jun 2015 15:21:01 -0400
Message-ID: <20150620192101.GG29480@thunk.org>
References: <1432546352-1855-1-git-send-email-vapier@gentoo.org>
 <20150608145922.GA15795@thunk.org>
 <20150608155606.GD13517@vapier>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46621 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219AbbFTTVD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 20 Jun 2015 15:21:03 -0400
Content-Disposition: inline
In-Reply-To: <20150608155606.GD13517@vapier>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 08, 2015 at 11:56:06AM -0400, Mike Frysinger wrote:
> On 08 Jun 2015 10:59, Theodore Ts'o wrote:
> > On Mon, May 25, 2015 at 05:32:32AM -0400, Mike Frysinger wrote:
> > > Newer versions of autotools have started warning when using the old
> > > configure.in name.
> > 
> > Note that I ship a version of configure (and keep one checked in to
> > git) because I do not trust the autoconf maintainers' ability to
> > maintain backwards compatibility, having gotten badly burned in the
> > past.  I am currently using autoconf 2.69, and people who try to rerun
> > autoconf on some other version of autoconf are venturing into
> > unsupported territory.  It may work; it may screw up in amazing ways.
> > Some autoconf macro may silently assume that some feature is present
> > when it is not, or vice versa.
> > 
> > And if it breaks, you get to keep both pieces.  :-)
> 
> that's fine, but it doesn't really matter to this patch -- it should be 
> configure.ac and not configure.in.  the version of autoconf you're using 
> certainly supports the newer name.

This patch breaks the automatic rebuild of configure if the
configure.ac/configure.in file is modified.  I've fixed it up by
adding the necessary change to MCONFIG.in.

						- Ted

       	   	     
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
