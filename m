From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tests: use make rules to run tests in parallel (v2)
Date: Sun, 27 May 2012 21:18:10 -0400
Message-ID: <20120528011810.GA19152@thunk.org>
References: <1337797871-19357-1-git-send-email-adilger@whamcloud.com>
 <1337803760-20587-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45828 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab2E1BSO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 May 2012 21:18:14 -0400
Content-Disposition: inline
In-Reply-To: <1337803760-20587-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 23, 2012 at 02:09:20PM -0600, Andreas Dilger wrote:
> Change the e2fsck/mke2fs/tune2fs/e2image/debugfs regression tests
> to be driven by Makefile rules instead of by a script loop.  This
> allows the tests to be run in parallel like a build and reduces
> testing time significantly.

The makefile setup you've created has a fatal flaw; it completely
blows up if you are building with VPATH.  That is, try this with your
patch: (starting with cwd in the e2fsprogs source tree)

% mkdir build
% cd build
% ../configure
% make
% make check
    <boom>

Could you take a look at fixing this, please?  I rely pretty
exclusively on building with VPATH (that way I can have a
build.static, build.32, etc.) with a single source tree.

	      		      	     	    	   - Ted
