From: tytso@mit.edu
Subject: Re: [PATCH v4 1/3] ext4: mechanical change on dio get_block code
 in prepare for it to be used by buffer write
Date: Sun, 17 Jan 2010 22:57:59 -0500
Message-ID: <20100118035759.GB8993@thunk.org>
References: <1263583812-21355-1-git-send-email-tytso@mit.edu>
 <1263583812-21355-2-git-send-email-tytso@mit.edu>
 <87y6jw23yn.fsf@linux.vnet.ibm.com>
 <4B533892.5040900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jiaying Zhang <jiayingz@google.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:43938 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab0ARD6Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Jan 2010 22:58:16 -0500
Content-Disposition: inline
In-Reply-To: <4B533892.5040900@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 17, 2010 at 10:19:30AM -0600, Eric Sandeen wrote:

> In addition to Aneesh's suggestions, I'm not sure of the value of
> creating more
> 
> #define FLAG_A = FLAG_B|FLAG_C
> 
> flag macros; unless you have this all in your head you just have to
> go look up the flag definition anyway, since we usually test individual
> flags not the aggregates.  I'm wondering if it might be better to just
> explicitly send in the OR'd flags rather than creating a new one, to
> see the code flow better.

I'd agree with that.  The other reason why it's good to avoid
aggregates is that if you don't realize that that FLAG_A is an
aggregate, you can end up doing this:

	if (flag & FLAG_A) {
		...
	}

and then be surprise when this tests true not just when someone passed
in FLAG_A, but also if someone passes in FLAG_B or FLAG_C...

   	       	       	       	      	 - Ted
