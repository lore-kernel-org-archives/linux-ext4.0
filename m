From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix data corruption with direct IO read in
 dioread_nolock mode
Date: Wed, 10 Apr 2013 20:47:33 -0400
Message-ID: <20130411004733.GB10594@thunk.org>
References: <1365438463-23025-1-git-send-email-jack@suse.cz>
 <20130410210821.GB31424@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33338 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934600Ab3DKArh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Apr 2013 20:47:37 -0400
Content-Disposition: inline
In-Reply-To: <20130410210821.GB31424@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 10, 2013 at 11:08:21PM +0200, Jan Kara wrote:
>   Ted, didn't you miss this patch?

I didn't miss it, I was just dealing with the older patches first, and
waiting to see if anyone would comment on it before I applied it into
the tree.  (That way I'm not the only person reviewing all of the
patches.  :-)

But thanks, I've added it to the ext4 patch queue.

    	    	       	     	 - Ted
