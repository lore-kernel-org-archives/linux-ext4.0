From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] e2fsck: regression tests for INCOMPAT_MMP feature
Date: Sun, 25 Sep 2011 08:05:05 -0400
Message-ID: <20110925120505.GA14539@thunk.org>
References: <1316821124-7461-1-git-send-email-adilger@whamcloud.com>
 <1316821124-7461-4-git-send-email-adilger@whamcloud.com>
 <20110924185155.GG2779@thunk.org>
 <A094EB47-CDD0-4A72-8659-841FC9848BFD@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35035 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278Ab1IYMFJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 Sep 2011 08:05:09 -0400
Content-Disposition: inline
In-Reply-To: <A094EB47-CDD0-4A72-8659-841FC9848BFD@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 25, 2011 at 12:04:14AM -0600, Andreas Dilger wrote:
> FYI, the reason that I ordered the MMP tests in that way is because it
> makes sense to verify that mke2fs can create a filesystem with the MMP
> feature before using a filesystem created by mke2fs with MMP to test if
> e2fsck handles it correctly.

There are other e2fsck tests that use mke2fs, and for better or for
worse I've never worried about test ordering.  If mke2fs blows up for
whatever reason, then some f_* tests will fail for reasons that have
nothing to do with e2fsck.  Since the test suite doesn't take that
long to run, most of the time people will let the tests run to
completion and the wise developer will notice the string of mke2fs
failures, and decide to tackle that first.  (Or it will be obvious the
moment he or she looks like the failed log files.)

       	     	       	    	       - Ted
