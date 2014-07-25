From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Unable to build e2fsprogs 1.42.11 on RHEL 5
Date: Fri, 25 Jul 2014 10:33:38 -0400
Message-ID: <20140725143338.GS1865@thunk.org>
References: <CFF6DF2A.B393D%andreas.dilger@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Dilger, Andreas" <andreas.dilger@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56587 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561AbaGYOdo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2014 10:33:44 -0400
Content-Disposition: inline
In-Reply-To: <CFF6DF2A.B393D%andreas.dilger@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 24, 2014 at 10:04:53PM +0000, Dilger, Andreas wrote:
> I'm unable to build the latest e2fsprogs on RHEL 5, since it returns an
> error running autoconf:
> 
>   autoconf
>   aclocal.m4:3095: error: Autoconf version 2.60 or higher is required
>   aclocal.m4:3095: the top level

What I try to tell everyone is that the only people who should run
autoconf are developers.  If you are building on a systems that are
running older versions of autoconf, such as RHEL or LTS, you should
simply *not* run autoconf, or autoreconf, or anything else like that.
If you do, that's something which is explicitly disclaimed.

The reason why we have the AC_PREREQ(2.60) is because of the
AC_PROG_MKDIR_P requirement which you noted.

> It looks like this was added in commit 93613951 "aclocal.m4: update
> to newer versions of autoconf macros".  Was there a particular
> reason for that change (there is no explanation given in the commit
> message)?

It was part of some work to update the autoconf and config.* files to
support some new platforms, such as ppcle.  (I think there was some
other platform that Ross Burton at Intel was trying to enable, but I'm
not sure what it was.)  While I was looking at these files, I noticed
that the gettext related macros were close to a decade old, and I
decided it was time to update them.

For RHEL5, it should be safe to revert the change, but the simpler
thing is to simply lay off trying to regenerate the configure.in file.
Autoconf doesn't have very good compatibility support, so whenever we
update autoconf related files, it's possible that future changes will
require changes to the Makefile.in files.

Cheers,

						- Ted
