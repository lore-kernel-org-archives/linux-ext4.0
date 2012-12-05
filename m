From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [ext4:dev 40/60] fs/ext4/inode.c:1953
 __ext4_journalled_writepage() error: potential NULL dereference 'page_bufs'.
Date: Wed, 5 Dec 2012 11:31:41 +0300
Message-ID: <20121205083141.GJ22569@mwanda>
References: <20121204111011.GD22569@mwanda>
 <1354627545-2792-1-git-send-email-tm@tao.ma>
 <20121204135602.GE22569@mwanda>
 <20121205054125.GC18885@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35906 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab2LEIbw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Dec 2012 03:31:52 -0500
Content-Disposition: inline
In-Reply-To: <20121205054125.GC18885@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 05, 2012 at 12:41:25AM -0500, Theodore Ts'o wrote:
> On Tue, Dec 04, 2012 at 04:56:02PM +0300, Dan Carpenter wrote:
> > It looks good.
> > 
> > Like I mentioned before Smatch doesn't understand
> > ext4_has_inline_data() so it still complains later on in the
> > function.  But it's now obvious to a human reader that there won't
> > be a NULL dereference.
> 
> This is what I plan to fold into the patch.  It should make it easier
> for gcc to produce optimized code, as well as being easier to
> understand.   Hopefully this should also keep smatch happy.
> 

Yeah, moving the check for (inode_bh == NULL) forward is nice.
Thanks.

regards,
dan carpenter

