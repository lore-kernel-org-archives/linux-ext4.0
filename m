From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 01/10 v5] ext4: refine extent status tree
Date: Fri, 15 Feb 2013 14:38:30 +0800
Message-ID: <20130215063830.GA26945@gmail.com>
References: <1360313046-9876-1-git-send-email-wenqing.lz@taobao.com>
 <1360313046-9876-2-git-send-email-wenqing.lz@taobao.com>
 <20130208153500.GA10226@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f50.google.com ([209.85.210.50]:46275 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428Ab3BOGX7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Feb 2013 01:23:59 -0500
Received: by mail-da0-f50.google.com with SMTP id h15so1383639dan.9
        for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2013 22:23:59 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130208153500.GA10226@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 08, 2013 at 04:35:00PM +0100, Jan Kara wrote:
[snip]
> > -static int __es_insert_extent(struct ext4_es_tree *tree, ext4_lblk_t offset,
> > -			      ext4_lblk_t len)
> > +static int __es_insert_extent(struct ext4_es_tree *tree,
> > +			      struct extent_status *newes)
> >  {
> >  	struct rb_node **p = &tree->root.rb_node;
> >  	struct rb_node *parent = NULL;
> >  	struct extent_status *es;
> > -	ext4_lblk_t end = offset + len - 1;
> > -
> > -	BUG_ON(end < offset);
> > -	es = tree->cache_es;
> > -	if (es && offset == (extent_status_end(es) + 1)) {
> > -		es_debug("cached by [%u/%u)\n", es->start, es->len);
> > -		es->len += len;
> > -		es = ext4_es_try_to_merge_right(tree, es);
> > -		goto out;
> > -	} else if (es && es->start == end + 1) {
> > -		es_debug("cached by [%u/%u)\n", es->start, es->len);
> > -		es->start = offset;
> > -		es->len += len;
> > -		es = ext4_es_try_to_merge_left(tree, es);
> > -		goto out;
> > -	} else if (es && es->start <= offset &&
> > -		   end <= extent_status_end(es)) {
> > -		es_debug("cached by [%u/%u)\n", es->start, es->len);
> > -		goto out;
> > -	}
> >  
> >  	while (*p) {
> >  		parent = *p;
> >  		es = rb_entry(parent, struct extent_status, rb_node);
> >  
> > -		if (offset < es->start) {
> > -			if (es->start == end + 1) {
> > -				es->start = offset;
> > -				es->len += len;
> > +		if (newes->es_lblk < es->es_lblk) {
> > +			if (ext4_es_can_be_merged(newes, es)) {
> > +				es->es_lblk = newes->es_lblk;
> > +				es->es_len += newes->es_len;
>   This is wrong, isn't it? You cannot change es->es_lblk because that can
> break ordering of elements in the tree... thinking ... ah, it's OK because
> you have non-overlapping intervals. But it deserves a comment I guess.

Hi Jan,

Sorry for the delay reply.  I will add a comment here to describe why
es_lblk can be changed directly.

Thanks,
                                                - Zheng
