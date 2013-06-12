From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: xfstest ext4 'utility required' run stop
Date: Wed, 12 Jun 2013 10:47:43 -0400
Message-ID: <20130612144743.GD27403@thunk.org>
References: <20130612053618.296170@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: jon ernst <jonernst07@gmx.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57275 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214Ab3FLOrr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Jun 2013 10:47:47 -0400
Content-Disposition: inline
In-Reply-To: <20130612053618.296170@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 12, 2013 at 01:36:18AM -0400, jon ernst wrote:
> Hi,
> 
> When I try to run xfstest 301 - 304. They all got error message "utility required, run stop, stkip this test" , test 305 is fine.
> But it did not tell which utility is required. I do have test patition and scratch partition set up. And I do have e4defrag on my linux.
> 
> What could be the reason?please help.

For your convenience, you might want to take a look at:

	git://git.kernel.org/pub/scm/fs/ext2/xfstests-bld.git

This will build all of the tools you need for xfstests, in a hermetic
build environment, and create a tarball that has everything you need
to run xfstests.  There are also some convenience scripts which allow
you to easily kick off an xfstests run using qemu.


       	      	       	  	       	     - Ted
