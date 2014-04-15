From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] fs/ext4: increase parallelism in updating ext4 orphan
 list
Date: Tue, 15 Apr 2014 19:25:22 +0200
Message-ID: <20140415172522.GA13276@quack.suse.cz>
References: <1380728283-61038-1-git-send-email-tmac@hp.com>
 <1396456148-20455-1-git-send-email-tmac@hp.com>
 <20140402174109.GD8657@quack.suse.cz>
 <534C135A.9010803@hp.com>
 <20140414174024.GC13860@quack.suse.cz>
 <534D5E02.6030500@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, T Makphaibulchoke <tmac@hp.com>,
	tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	aswin@hp.com
To: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbaDORZZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Apr 2014 13:25:25 -0400
Content-Disposition: inline
In-Reply-To: <534D5E02.6030500@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 15-04-14 10:27:46, Thavatchai Makphaibulchoke wrote:
> On 04/14/2014 11:40 AM, Jan Kara wrote:
> >   Thanks for trying that out! Can you please send me a patch you have been
> > testing? Because it doesn't quite make sense to me why using i_mutex should
> > be worse than using hashed locks...
> >
> 
> Thanks again for the comments.
> 
> Since i_mutex is also used for serialization in other operations on an
> inode, in the case that the i_mutex is not held  using it for
> serialization could cause contention with other operations on the inode.
> As the number shows substantial instances of orphan add or delete calls
> without holding the i_mutex, I presume the performance degradation is due
> to the contention.
  I have checked the source and I didn't find many places where i_mutex was
not held. But maybe I'm wrong. That's why I wanted to see the patch where
you are using i_mutex instead of hashed mutexes and which didn't perform
good enough.

> As for the patch, could you please let me know if you need the patch
> using i_mutex or the patch I'm planning to submit.  If it's the latter,
> I'm thinking of go ahead and resubmit it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
