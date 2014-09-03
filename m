From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 4/6] ext4: change lru to round-robin in extent status
 tree shrinker
Date: Wed, 3 Sep 2014 18:38:05 -0400
Message-ID: <20140903223805.GD12154@thunk.org>
References: <1407382553-24256-1-git-send-email-wenqing.lz@taobao.com>
 <1407382553-24256-5-git-send-email-wenqing.lz@taobao.com>
 <20140827150121.GC22211@quack.suse.cz>
 <20140903033738.GB2504@thunk.org>
 <20140903153122.GA17066@quack.suse.cz>
 <20140903200039.GM2504@thunk.org>
 <20140903221402.GD19005@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36362 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757269AbaICWiL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Sep 2014 18:38:11 -0400
Content-Disposition: inline
In-Reply-To: <20140903221402.GD19005@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 04, 2014 at 12:14:02AM +0200, Jan Kara wrote:
> > I didn't think we were allowed to reschedule or sleep while in
> > shrinker context?
>   I believe we are allowed to sleep in the shrinker if appropriate gfp
> flags are set (__GFP_WAIT) and we enter extent cache shrinker only if
> __GFP_FS is set which guarantees __GFP_WAIT.

I must be missing something.  How is this guaranteed?

I can see how we can determine what gfp_mask was used in the
allocation which triggered the shrinker callback, by checking
shrink->gfp_mask, but I don't see anything that guarantees that the
extent cache shrinker is only entered if __GFP_FS is set.

I guess we could add something like:

	if ((shrink->gfp_mask & __GFP_WAIT) == 0)
		return 0;

to the beginning of ext4_es_scan(), but we're not doing that at the
moment.

       	     	      	      	      	 - Ted
