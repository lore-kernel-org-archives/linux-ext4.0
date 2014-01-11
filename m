From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: deleted "set but not used" variables
Date: Sat, 11 Jan 2014 13:27:54 -0500
Message-ID: <20140111182754.GA1582@thunk.org>
References: <CAGW2f1H1nj9YMUYZ+Fe5knzNQLNzFUk_7eZi2YrkE=J0c1R-cg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: jon ernst <jonernst07@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47548 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbaAKS2C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Jan 2014 13:28:02 -0500
Content-Disposition: inline
In-Reply-To: <CAGW2f1H1nj9YMUYZ+Fe5knzNQLNzFUk_7eZi2YrkE=J0c1R-cg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 08, 2013 at 05:23:49AM +0000, jon ernst wrote:
> to delete "set but not used" variables
> 
> Signed-off-by: Jon Ernst <jonernst07@gmail.com>

Thanks for your patch!

My apologies for the delay in processing this patch; it fell through
the cracks and I found it while going through my backlog.  The set but
not used variable in ext4_ext_truncate() has since been addressed by
actually checking the error returns, but the set but not used
variables in ioctl.c and inline.c were still applicable, and I've
applied those portions of the patch to the ext4 tree.

	      	       	      	       - Ted
