From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/10] mke2fs.c: add an option: -d root-directory
Date: Thu, 26 Dec 2013 11:07:34 -0500
Message-ID: <20131226160734.GB23928@thunk.org>
References: <1387800600-13718-1-git-send-email-liezhi.yang@windriver.com>
 <1387800600-13718-2-git-send-email-liezhi.yang@windriver.com>
 <1387825697.5088.62.camel@dvhart-mobl4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Robert Yang <liezhi.yang@windriver.com>, linux-ext4@vger.kernel.org
To: Darren Hart <dvhart@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43570 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422Ab3LZQHg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Dec 2013 11:07:36 -0500
Content-Disposition: inline
In-Reply-To: <1387825697.5088.62.camel@dvhart-mobl4.amr.corp.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 23, 2013 at 11:08:17AM -0800, Darren Hart wrote:
> On Mon, 2013-12-23 at 07:09 -0500, Robert Yang wrote:
> > This option is used for adding the files from a given directory (the
> > root-directory) to the filesystem, it is similiar to genext2fs, but
> > genext2fs doesn't fully support ext4.
> > 
> > This commit describes the skeleton of the implementation:
> 
> This approach strikes me as a bit odd. We're adding an option and empty
> functions, rather than fleshing them out at the same time. What is the
> motivation for separating this from the actual implementation? At the
> very least the -d option shouldn't be added until it is functional - at
> the end of the series...

I think this approach was used because I complained that intermediate
versions of the commits didn't compile, and this makes bisection
harder.

I'm not going to be that picky about the specific order, though, so
long as after each commit, the result compiles and passes the
regression test suite, although adding support for -d at the very end
does make sense.  Or you could only support directories and regular
files, and then add support for symlinks, special files, etc.

Cheers,

						- Ted
