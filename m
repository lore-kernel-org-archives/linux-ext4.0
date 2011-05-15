From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] NULL pointer when make_indexed_dir returns -ENOSPC
Date: Sun, 15 May 2011 00:21:08 -0400
Message-ID: <20110515042108.GJ21165@thunk.org>
References: <4DCC1FF8.6040103@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44698 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216Ab1EOEVS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 May 2011 00:21:18 -0400
Content-Disposition: inline
In-Reply-To: <4DCC1FF8.6040103@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 12, 2011 at 10:59:20AM -0700, Allison Henderson wrote:
> Hi all,
> 
> I wasnt sure if people were expecting a v2 for this one, but I
> noticed the modified version of v1 was removed from the tree, so I
> am assuming we needed v2?  This one handles marking the buffer dirty
> before calling do split to avoid the null pointer.  It introduces a
> little overhead, but the only other option would be to introduce a
> new flag set to do_split.  But if there's any one that would prefer
> the flags to this solution, please let me know.  Thx! :)
> 
> Allison Henderson
> 
> Signed-off-by: Allison Henderson <achender@us.ibm.com>

Applied, thanks.  In the future, I'd appreciate it if you resent the
patch with a formal commit description.  I recreated the commit
description from the older patch in this case.

	    	     	   	    	 - Ted
