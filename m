From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix ext4_flush_completed_IO wait semantics
Date: Fri, 5 Oct 2012 10:20:05 -0400
Message-ID: <20121005142005.GD21358@thunk.org>
References: <1349289807-18811-1-git-send-email-dmonakhov@openvz.org>
 <20121005124027.GA21358@thunk.org>
 <87a9w1ax91.fsf@openvz.org>
 <20121005132853.GC21358@thunk.org>
 <877gr5auu7.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53981 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012Ab2JEOUJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Oct 2012 10:20:09 -0400
Content-Disposition: inline
In-Reply-To: <877gr5auu7.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 05, 2012 at 05:53:36PM +0400, Dmitry Monakhov wrote:
> Jiaying Zhang removed i_mutex from ext4_evict_inode here 8c0bec2151
> because of false positive lockdep complains.
> Let's just learn warning about evict_inode 

Yes, good point.  I'm starting a testing cycle with your patch.

     	  	      	       	 	 - Ted
