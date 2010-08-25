From: Ted Ts'o <tytso@mit.edu>
Subject: Re: question about i_dtime being used as an orphan list pointer
Date: Wed, 25 Aug 2010 16:39:14 -0400
Message-ID: <20100825203914.GF4453@thunk.org>
References: <AANLkTi=3hK1RLRJ+2Kt0ju=HEr-LdkO9eX_YxLfp0wea@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Vitali Lovich <vlovich@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35435 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183Ab0HYUjR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Aug 2010 16:39:17 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTi=3hK1RLRJ+2Kt0ju=HEr-LdkO9eX_YxLfp0wea@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 25, 2010 at 12:22:22PM -0700, Vitali Lovich wrote:
> So I've run into this problem where the clock was reset into the 1970s
> on my system, causing e2fsck to get confused & think a file I deleted
> actually had an orphan list inode pointer stored in the i_dtime
> instead of the deletion time, causing e2fsck to get all confused &
> return an error code.

Are you worried about solving this problem as a one shot deal, or as a
long-term design issue.  The long-term proper solution is run your
clock so it is correct.  :-)

In the short term, probably the easist thing to do is just run e2fsck
-y and let those inodes get populated into lost+found, and then delete
them by hands afterwards.

For a long-term fix, it probably would make sense to patch ext3/ext4
so that when we delete a file, and the current time is less than
number of inodes, that we set dtime to 0xffffffff.

> Even a value of midnight 2010 corresponds to a limit of only about 1
> billion files (1 262 304 000).  Thus it seems if you delete a file on
> a partition with more than a billion files, it will make e2fsck think
> you've got a corrupt file-system even though you don't.

And if you assuming the smallest possible inode ratio, that's a 4.5TB
file.  If you use the default inode, that's a 18TB.  Ext3 is limited
to 16TB, so that's not even an issue....

	   	    				- Ted
