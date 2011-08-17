From: Ted Ts'o <tytso@mit.edu>
Subject: Re: a (documented) way to get the Ext2+ filesystem size?
Date: Wed, 17 Aug 2011 14:31:01 -0400
Message-ID: <20110817183101.GC6901@thunk.org>
References: <86aab94mfg.fsf@gray.siamics.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ivan Shmakov <oneingray@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39782 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362Ab1HQSbF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Aug 2011 14:31:05 -0400
Content-Disposition: inline
In-Reply-To: <86aab94mfg.fsf@gray.siamics.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 16, 2011 at 06:37:23PM +0700, Ivan Shmakov wrote:
> 	How do I get the Ext2+ filesystem size (in blocks)?

I assume you need the exact numbers, so you can't use statfs(2)?  What
are you using it for?

  	     	      	    	     - Ted
