From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 3/3] ext4: optimize block allocation on grow indepth
Date: Tue, 23 Sep 2014 14:26:01 +0400
Message-ID: <87fvfizl8m.fsf@openvz.org>
References: <1411455752-2332-1-git-send-email-dmonakhov@openvz.org> <1411455752-2332-3-git-send-email-dmonakhov@openvz.org> <20140923100031.GD2359@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:34462 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbaIWK0G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Sep 2014 06:26:06 -0400
Received: by mail-lb0-f172.google.com with SMTP id p9so7826663lbv.31
        for <linux-ext4@vger.kernel.org>; Tue, 23 Sep 2014 03:26:03 -0700 (PDT)
In-Reply-To: <20140923100031.GD2359@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 23 Sep 2014 12:00:31 +0200, Jan Kara <jack@suse.cz> wrote:
> On Tue 23-09-14 11:02:32, Dmitry Monakhov wrote:
> > It is reasonable to prepent newly created index to older one.
> ...
> > -	newblock = ext4_ext_new_meta_block(handle, inode, NULL,
> > -		newext, &err, flags);
> > +	/* Try to prepend new index to old one */
> > +	if (ext_depth(inode))
> > +		goal = ext4_idx_pblock(EXT_FIRST_INDEX(ext_inode_hdr(inode)));
> > +	if (goal > le32_to_cpu(es->s_first_data_block)) {
> > +		flags |= EXT4_MB_HINT_TRY_GOAL;
> > +		goal--;
> > +	} else
> > +		goal =  ext4_inode_to_goal_block(inode);
> > +	newblock = ext4_new_meta_blocks(handle, inode, goal, flags,
> > +					NULL, &err);
> >  	if (newblock == 0)
> >  		return err;
>   Hum, did you actually observe any improvement in file layout with this
> patch?
Hmmm.... well this patch itself unlikely result in improvements because
the block we asks is likely used already. This is because non optimal block
allocation for mdata. I hope to fix it once we start working on ideas
which was described in "fast fsck" tread
(http://comments.gmane.org/gmane.comp.file-systems.ext4/41472)

> 
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
