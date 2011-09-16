From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 00/25] e2fsprogs: Misc cleanups & fixes
Date: Fri, 16 Sep 2011 18:05:40 -0400
Message-ID: <20110916220540.GC16246@thunk.org>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
 <4E73BF52.4090704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50502 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422Ab1IPWFn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 18:05:43 -0400
Content-Disposition: inline
In-Reply-To: <4E73BF52.4090704@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 04:27:46PM -0500, Eric Sandeen wrote:
> 
> Heh, and I should have pulled from github prior to doing all this.  :(
> 
> I take back that comment about recent work, at least slightly.
> 
> Is the quota library really full of void functions which cannot return
> errors?  My fault for not reviewing while it was on the list, sorry.

Yeah, the quota library is going to need a lot of fixups before 1.42
ships.  I don't consider the ABI (or the function naming, since it
doesn't have any kind of namespace discpline) fixed in stone yet.
Perhaps I shouldn't have integrated the patches right away but we'll
get it fixed up before 1.42 goes out the door.

       	     	       	    	     	 - Ted
