From: tytso@mit.edu
Subject: Re: [PATCH] ext4: Do not zeroout uninitialized extents beyond
 i_size
Date: Wed, 21 Apr 2010 13:45:57 -0400
Message-ID: <20100421174557.GH14986@thunk.org>
References: <1270833748-14381-1-git-send-email-dmonakhov@openvz.org>
 <20100414212831.GD19959@thunk.org>
 <8739yx3wd8.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:37450 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978Ab0DURqH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Apr 2010 13:46:07 -0400
Content-Disposition: inline
In-Reply-To: <8739yx3wd8.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 15, 2010 at 01:20:35PM +0400, Dmitry Monakhov wrote:
> I've attached incremental patch for you.
> In fact, this not result in any serious bugs but increase our changes to
> use zeroout optimization and helps us to overcome ENOSPC if possible.

I've integrated your incremental patch into what I have in the ext4
patch queue, thanks.  (It's been there for a while actually but due to
the LF collaboration summit I haven't had a chance to ack things that
I've integrated, update the patchwork site, etc.)

     		 	    	      	    - Ted
