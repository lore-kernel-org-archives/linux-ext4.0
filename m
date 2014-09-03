From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 4/6] ext4: change lru to round-robin in extent status
 tree shrinker
Date: Thu, 4 Sep 2014 00:14:02 +0200
Message-ID: <20140903221402.GD19005@quack.suse.cz>
References: <1407382553-24256-1-git-send-email-wenqing.lz@taobao.com>
 <1407382553-24256-5-git-send-email-wenqing.lz@taobao.com>
 <20140827150121.GC22211@quack.suse.cz>
 <20140903033738.GB2504@thunk.org>
 <20140903153122.GA17066@quack.suse.cz>
 <20140903200039.GM2504@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44977 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724AbaICWOG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Sep 2014 18:14:06 -0400
Content-Disposition: inline
In-Reply-To: <20140903200039.GM2504@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 03-09-14 16:00:39, Ted Tso wrote:
> On Wed, Sep 03, 2014 at 05:31:22PM +0200, Jan Kara wrote:
> > Also one question:
> > 
> > > -		if (ei == locked_ei || !write_trylock(&ei->i_es_lock)) {
> > > -			nr_skipped++;
> > > -			spin_lock(&sbi->s_es_lock);
> > >  			__ext4_es_list_add(sbi, ei);
> > > +			if (spin_is_contended(&sbi->s_es_lock)) {
> > > +				spin_unlock(&sbi->s_es_lock);
> > > +				spin_lock(&sbi->s_es_lock);
> > > +			}
> >   Why not cond_resched_lock(&sbi->s_es_lock)?
> 
> I didn't think we were allowed to reschedule or sleep while in
> shrinker context?
  I believe we are allowed to sleep in the shrinker if appropriate gfp
flags are set (__GFP_WAIT) and we enter extent cache shrinker only if
__GFP_FS is set which guarantees __GFP_WAIT.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
