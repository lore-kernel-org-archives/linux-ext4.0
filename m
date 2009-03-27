From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Update locking coments
Date: Fri, 27 Mar 2009 17:22:12 -0400
Message-ID: <20090327212212.GB5176@mit.edu>
References: <1237988609-31699-1-git-send-email-jack@suse.cz> <1237988609-31699-2-git-send-email-jack@suse.cz> <1237988609-31699-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lin Tan <tammy000@gmail.com>, "."@suse.cz
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:54932 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbZC0VWQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Mar 2009 17:22:16 -0400
Content-Disposition: inline
In-Reply-To: <1237988609-31699-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 25, 2009 at 02:43:29PM +0100, Jan Kara wrote:
> Update information about locking in JBD2 revoke code. Inconsistency in comments
> found by Lin Tan <tammy000@gmail.com>.
> 

Thanks, I've added this patch to the ext4 patch queue.

	     	   	      	     	  - Ted
