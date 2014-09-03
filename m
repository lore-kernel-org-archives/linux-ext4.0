From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 4/6] ext4: change lru to round-robin in extent status
 tree shrinker
Date: Wed, 3 Sep 2014 16:00:39 -0400
Message-ID: <20140903200039.GM2504@thunk.org>
References: <1407382553-24256-1-git-send-email-wenqing.lz@taobao.com>
 <1407382553-24256-5-git-send-email-wenqing.lz@taobao.com>
 <20140827150121.GC22211@quack.suse.cz>
 <20140903033738.GB2504@thunk.org>
 <20140903153122.GA17066@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35835 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbaICUAt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Sep 2014 16:00:49 -0400
Content-Disposition: inline
In-Reply-To: <20140903153122.GA17066@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 03, 2014 at 05:31:22PM +0200, Jan Kara wrote:
> Also one question:
> 
> > -		if (ei == locked_ei || !write_trylock(&ei->i_es_lock)) {
> > -			nr_skipped++;
> > -			spin_lock(&sbi->s_es_lock);
> >  			__ext4_es_list_add(sbi, ei);
> > +			if (spin_is_contended(&sbi->s_es_lock)) {
> > +				spin_unlock(&sbi->s_es_lock);
> > +				spin_lock(&sbi->s_es_lock);
> > +			}
>   Why not cond_resched_lock(&sbi->s_es_lock)?

I didn't think we were allowed to reschedule or sleep while in
shrinker context?

					- Ted
