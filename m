From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck/e2fsprogs: use sscanf() instead of atoi() in the option parser
Date: Fri, 3 Aug 2007 22:19:12 -0400
Message-ID: <20070804021912.GG7449@thunk.org>
References: <f8q6is$tg3$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Bernd Schubert <bschubert@q-leap.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35359 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187AbXHDGCW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Aug 2007 02:02:22 -0400
Content-Disposition: inline
In-Reply-To: <f8q6is$tg3$1@sea.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 01, 2007 at 04:50:04PM +0200, Bernd Schubert wrote:
> [resent since the first mail doesn't seem to make it to this list]
> 
> using atoi() should be avoided in the option parser since it doesn't check
> for errors. I almost destroyed an important filesystem since I
> specified "e2fsck -C -n" and -n was parsed as option to -C

Hi Bernd,

Can you please include a DCO.  i.e.,

Signed-off-by: Bernd Schubert <bschubert@q-leap.de>

In your patch submissions.  See the SUBMITTING-PATCHES file in the
top-level directory of e2fsprogs source tree for the significance of
the Signed-off-by line.  For this patch, can you indicate whether you
are willing to add a Signed-off-by: DCO?

Thanks, regards,

						- Ted
