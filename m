From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: completely ignore last-mount and last-write
 within fudge_time
Date: Wed, 1 Apr 2015 11:08:37 -0400
Message-ID: <20150401150837.GA7105@thunk.org>
References: <5509DCE4.1010706@redhat.com>
 <20150329023226.GA19097@thunk.org>
 <20150401130642.GL26339@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45023 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753560AbbDAPIl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Apr 2015 11:08:41 -0400
Content-Disposition: inline
In-Reply-To: <20150401130642.GL26339@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 01, 2015 at 03:06:42PM +0200, Jan Kara wrote:
> >     e2fsck: use PROMPT_NONE for FUTURE_SB_LAST_*_FUDGED problems
> >     
> >     This allows us to print a message warning the user that there is
> >     something funny going on with their hardware clock (probably time zone
> >     issues caused by trying to be compatible with legacy OS's such as
> >     Windows), without triggering a full file system check.
> >     
> >     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>   OK, so this will just print the error but won't fix it unless in preen
> or full check mode. Am I right. That sounds fine to me.

Actually, it will fix it unless the run in -n mode, but it won't count
it as a "fix".  Hence, it won't trigger the full file system check.

      		       	  		    - Ted
