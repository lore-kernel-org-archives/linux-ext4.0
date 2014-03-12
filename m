From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] create_inode: fix gcc -Wall complaints
Date: Tue, 11 Mar 2014 23:45:39 -0400
Message-ID: <20140312034539.GC26898@thunk.org>
References: <1394595670-11193-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: darrick.wong@oracle.com, liezhi.yang@windriver.com
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40224 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145AbaCLDpm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Mar 2014 23:45:42 -0400
Content-Disposition: inline
In-Reply-To: <1394595670-11193-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 11, 2014 at 11:41:10PM -0400, Theodore Ts'o wrote:
> We had several functions that were not returning zero on success.  Fix
> this.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

One additional gcc -Wall nit which I have not yet fixed:

create_inode.c is using ext2fs_inline_data_init() which is currently a
private function defined in ext2fsP.h.

We either need to make this a publically exported interface (in which
case we have to guarantee that it is stable), or we need to find
another way to make the right thing happen here.

Darrick, Robert, do you have any thoughts or suggestions?

	       	    	      	    	   - Ted

P.S.  My bad for not doing a gcc -Wall run on the patches before
accepting them.  And in the future, I'd appreciate it if people who
are preparing patches do a "make gcc-wall" and make sure you're not
making things worse.  There are plenty of bugs that can be turned up
this way.
