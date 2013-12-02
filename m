From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2image: double free when restoring image
Date: Mon, 2 Dec 2013 13:03:37 -0500
Message-ID: <20131202180337.GA6200@thunk.org>
References: <529664F6.3040103@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Dilger, Andreas" <andreas.dilger@intel.com>
To: Kit Westneat <kwestneat@ddn.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35686 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900Ab3LBSDm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Dec 2013 13:03:42 -0500
Content-Disposition: inline
In-Reply-To: <529664F6.3040103@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 27, 2013 at 04:32:38PM -0500, Kit Westneat wrote:
> Hello,
> 
> I've been running into a double free when trying to apply an e2image to a
> loopback device:

It looks like there are a number of memory pointer overruns which
valgrind is finding, not just the one you have pointed out.  Thanks
for pointing out this issue.

For this particular case, it's probably better to set
new_io->block_size to fs->blocksize; I'll send out some patches to fix
these issues, and very clearly we need to add some regression tests to
catch these in the future.

Thanks,

					- Ted
