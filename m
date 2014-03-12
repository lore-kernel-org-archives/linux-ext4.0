From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] create_inode: fix gcc -Wall complaints
Date: Tue, 11 Mar 2014 20:48:41 -0700
Message-ID: <20140312034841.GC31864@birch.djwong.org>
References: <1394595670-11193-1-git-send-email-tytso@mit.edu>
 <20140312034539.GC26898@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	liezhi.yang@windriver.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36320 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbaCLDsr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 23:48:47 -0400
Content-Disposition: inline
In-Reply-To: <20140312034539.GC26898@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 11, 2014 at 11:45:39PM -0400, Theodore Ts'o wrote:
> On Tue, Mar 11, 2014 at 11:41:10PM -0400, Theodore Ts'o wrote:
> > We had several functions that were not returning zero on success.  Fix
> > this.
> > 
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> One additional gcc -Wall nit which I have not yet fixed:
> 
> create_inode.c is using ext2fs_inline_data_init() which is currently a
> private function defined in ext2fsP.h.
> 
> We either need to make this a publically exported interface (in which
> case we have to guarantee that it is stable), or we need to find
> another way to make the right thing happen here.
> 
> Darrick, Robert, do you have any thoughts or suggestions?

I fixed that up in the cppcheck cleanups patch by moving those declarations to
ext2fs.h.  Maybe I should have shoved the patch closer to the head.

--D
> 
> 	       	    	      	    	   - Ted
> 
> P.S.  My bad for not doing a gcc -Wall run on the patches before
> accepting them.  And in the future, I'd appreciate it if people who
> are preparing patches do a "make gcc-wall" and make sure you're not
> making things worse.  There are plenty of bugs that can be turned up
> this way.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
