From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tests: use make rules to run tests in parallel (v3)
Date: Tue, 29 May 2012 08:33:49 -0400
Message-ID: <20120529123349.GB16351@thunk.org>
References: <1338245904-31827-1-git-send-email-adilger@whamcloud.com>
 <20120529012859.GF5610@thunk.org>
 <37AFC02E-AB57-4B17-906A-D5FE643B7226@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46211 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab2E2Mdx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 May 2012 08:33:53 -0400
Content-Disposition: inline
In-Reply-To: <37AFC02E-AB57-4B17-906A-D5FE643B7226@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 29, 2012 at 01:02:11AM -0600, Andreas Dilger wrote:
> 
> Hrm, one reason I made the generated files read-only is to avoid
> accidentally editing the generated copy, and then losing the resulting
> changes when the file is recreated (as happened several times with the
> test_script file, when rebasing the patch).  I'd prefer to mark the
> generated files read-only, and then have the Makefile rules delete the
> file before recreating it.

I tend to just edit the foo.in file; the Makefile dependencies
automatically take care of rebuiling the test_one and test_script
files --- and it's much easier just to type "make" to retry the
generated scripts....

> That avoids accidentally having developers edit the file, while allowing
> the always-remembering Makefile rule to recreate the file without errors.

Yeah, but I don't want to encourage developers editing generated
files...  it's much better to make things much more convenient for
them to do things in the "right" way.  In the long run that's much
more effective at avoiding lost work, and it saves you effort (since
otherwise you might forget to fix the foo.in file before you commit
the change, etc.)

						- Ted
