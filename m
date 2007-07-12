From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [EXT4 set 2][PATCH 2/5] cleanups: Add extent sanity checks
Date: Thu, 12 Jul 2007 08:57:51 -0500
Message-ID: <1184248671.10312.7.camel@kleikamp.austin.ibm.com>
References: <1183275382.4010.121.camel@localhost.localdomain>
	 <20070710163020.196d32a0.akpm@linux-foundation.org>
	 <469612B4.5070105@shadowen.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, cmm@us.ibm.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andy Whitcroft <apw@shadowen.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43159 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762147AbXGLN5y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jul 2007 09:57:54 -0400
In-Reply-To: <469612B4.5070105@shadowen.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-07-12 at 12:38 +0100, Andy Whitcroft wrote:
> Andrew Morton wrote:
> >> +			if (ext4_ext_check_header(inode, ext_block_hdr(bh),
> >> +							depth - i - 1)) {
> >> +				err = -EIO;
> >> +				break;
> >> +			}
> >> +			path[i+1].p_bh = bh;
> > 
> > Really that should have been "i + 1".  checkpatch misses this.  It seems to
> > be missing more stuff that it used to lately.
> 
> This one is difficult.  The rules up to now have been consistent spacing
> is required on both sides of mathematics operators.  I personally like
> spaces always, but we do tend to use them without spaces too where the
> binding is effectivly part of the value -- the classic case is something
> like:
> 
> 	pfn << MAX_ORDER-1
> 
> In allowing that sort of thing, we implictly allow the one you note
> above.  We have tried to be overly annoying on these things, and so the
> check is consistancy, spaces both or neither.  We could be stricter.

I personally think stricter is better.  An occasionally false-positive
isn't going to hurt anyone.  (Well, maybe the checkpatch.pl maintainers
will get nagged.)  It at least will cause the developer to look at the
line of code in question and make a conscious decision to leave it as it
is.  I'm assuming that upstream maintainers use checkpatch.pl with some
constraint, and don't throw every patch that produces a warning back at
the submitter.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center
