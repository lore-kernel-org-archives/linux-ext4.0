From: tytso@mit.edu
Subject: Re: [PATCH 08/19] ext4: replace inode uid,gid,mode initialization
 with helper function
Date: Thu, 18 Feb 2010 15:52:18 -0500
Message-ID: <20100218205218.GL5337@thunk.org>
References: <1266431353-8549-1-git-send-email-dmonakhov@openvz.org>
 <1266432013-9241-3-git-send-email-dmonakhov@openvz.org>
 <E5AA2C0B-42FA-4025-A155-7ACD02EDE261@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:52016 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937Ab0BRUwY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Feb 2010 15:52:24 -0500
Content-Disposition: inline
In-Reply-To: <E5AA2C0B-42FA-4025-A155-7ACD02EDE261@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 17, 2010 at 04:39:54PM -0700, Andreas Dilger wrote:
> 
> Ted,
> what do you think of just removing the "GRPID" mount option?  I
> believe this was around for ages, due to the lack of BSD setgid-on-
> parent functionality in Linux.  I don't think it is needed anymore,
> since the BSD functionality is much more flexible (it can be set on
> a per-directory basis instead of for the whole filesystem).
> 
> I suppose one way to find out positively would be to add a printk()
> to case Opt_grpid: in the option parsing that this option is
> deprecated, and to contact linux-ext4@vger.kernel.org if you are
> still using it.

There are whole raft of options I'd love to deprecate:

* bsddf/minixdf
* grpid/bsdgroups/nogrpiid/sysvgroups

I also wonder whether it's time that we just enable acls and xattrs
all the time, instead of making them be explicit mount options.

So anyone wants to send me a patch, feel free....  (or I may get to it
maybe this weekend.)

					- Ted
