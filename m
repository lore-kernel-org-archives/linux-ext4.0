From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] test: add f_mke2fs_baddisk
Date: Wed, 7 Dec 2016 09:19:41 -0500
Message-ID: <20161207141941.vs6zt5wblze34u23@thunk.org>
References: <1481116459-8770-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57676 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751726AbcLGOTo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 7 Dec 2016 09:19:44 -0500
Content-Disposition: inline
In-Reply-To: <1481116459-8770-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 07, 2016 at 05:14:18PM +0400, Dmitry Monakhov wrote:
> Check what mke2fs will return non zero error on broken device.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Most developers don't run "make check" as root.  So at minimum the
test should check to see if it is running as root, or be able to deal
with dmsetup failing due to permissions check.

I wouldn't object if there was some environment variable, say SUDO or
DOROOT, which, if set, would prefix the commands which require root
with $DOROOT such that if the developer is willing to enable running
specific commands as root, that was allowed for the regression test.

Alternatively the long-term plan that I have is to allow pathnames to
be specified using a URL-like scheme, e.g.;

   unix://path/to/filename
   test://unix/path/to/filename

Which would allow us to define a proper test mock I/O manager that
would allow for these sorts of tests without requiring root.

Cheers,

					- Ted
