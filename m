From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 4/9 v4] ext4: adjust interfaces of extent status tree
Date: Fri, 1 Feb 2013 10:51:20 +0800
Message-ID: <20130201025120.GA10176@gmail.com>
References: <1359609477-29845-1-git-send-email-wenqing.lz@taobao.com>
 <1359609477-29845-5-git-send-email-wenqing.lz@taobao.com>
 <20130131160206.GD4612@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:52362 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab3BAChN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jan 2013 21:37:13 -0500
Received: by mail-pa0-f53.google.com with SMTP id bg4so2028941pad.26
        for <linux-ext4@vger.kernel.org>; Thu, 31 Jan 2013 18:37:12 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130131160206.GD4612@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 31, 2013 at 05:02:06PM +0100, Jan Kara wrote:
[snip]
> > @@ -465,6 +490,9 @@ static int __es_remove_extent(struct ext4_es_tree *tree, ext4_lblk_t lblk,
> >  
> >  			newes.es_lblk = end + 1;
> >  			newes.es_len = len2;
> > +			newes.es_pblk = ext4_es_get_pblock(&orig_es,
> > +				orig_es.es_pblk + orig_es.es_len - len2);
> > +			newes.es_status = orig_es.es_status;
> >  			err = __es_insert_extent(tree, &newes);
> >  			if (err) {
> >  				es->es_lblk = orig_es.es_lblk;
> > @@ -474,6 +502,8 @@ static int __es_remove_extent(struct ext4_es_tree *tree, ext4_lblk_t lblk,
> >  		} else {
> >  			es->es_lblk = end + 1;
> >  			es->es_len = len2;
> > +			es->es_pblk = ext4_es_get_pblock(es,
> > +				orig_es.es_pblk + orig_es.es_len - len2);
> >  		}
> >  		goto out;
> >  	}
> > @@ -498,9 +528,13 @@ static int __es_remove_extent(struct ext4_es_tree *tree, ext4_lblk_t lblk,
> >  	}
> >  
> >  	if (es && es->es_lblk < end + 1) {
> > +		ext4_lblk_t orig_len = es->es_len;
> > +
> >  		len1 = ext4_es_end(es) - end;
> >  		es->es_lblk = end + 1;
> >  		es->es_len = len1;
> > +		es->es_pblk = ext4_es_get_pblock(es,
> > +						 es->es_pblk + orig_len - len1);
> >  	}
> >  
> >  out:
>   So ext4_es_get_pblock() seems a bit confusing. I understand that for
> delayed extents physical block doesn't make sence and that you wanted to
> save some typing by that function but IMHO it's making the code less
> readable. I'd rather see there e.g.:
>   if (!ext4_es_is_delayed(es))
> 	es->es_pblk += orig_len - len1;
> and for delayed extents we can just leave es_pblk undefined because nobody
> should really look at it anyway.

Agree.  It will be fixed in next version.

Thanks,
                                                - Zheng
