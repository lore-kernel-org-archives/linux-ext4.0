From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] ext4: Return the length of a hole from get_block
Date: Mon, 13 Jul 2015 11:26:15 -0400
Message-ID: <20150713152615.GH13681@linux.intel.com>
References: <1435936511-17705-1-git-send-email-matthew.r.wilcox@intel.com>
 <20150713151610.GC17075@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:45826 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbbGMP0R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jul 2015 11:26:17 -0400
Content-Disposition: inline
In-Reply-To: <20150713151610.GC17075@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 13, 2015 at 05:16:10PM +0200, Jan Kara wrote:
> On Fri 03-07-15 11:15:11, Matthew Wilcox wrote:
> > From: Matthew Wilcox <willy@linux.intel.com>
> > 
> > Currently, if ext4's get_block encounters a hole, it does not modify the
> > buffer_head.  That's fine for many callers, but for DAX, it's useful to
> > know how large the hole is.  XFS already returns the length of the hole,
> > so this improvement should not confuse any callers.
> > 
> > Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> 
> So I'm somewhat wondering: What is the reason of BH_Uptodate flag being
> set? I can see the XFS sets it in some cases as well but the use of the
> flag isn't really clear to me...

No clue.  I'm just following the documentation in buffer.c:

 * NOTE! All mapped/uptodate combinations are valid:
 *
 *      Mapped  Uptodate        Meaning
 *
 *      No      No              "unknown" - must do get_block()
 *      No      Yes             "hole" - zero-filled
 *      Yes     No              "allocated" - allocated on disk, not read in
 *      Yes     Yes             "valid" - allocated and up-to-date in memory.

