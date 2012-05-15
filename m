From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] ext4: potential NULL dereference on error
Date: Tue, 15 May 2012 09:13:51 +0300
Message-ID: <20120515061351.GI16984@mwanda>
References: <20120513144104.GA21998@elgon.mountain>
 <20120514222535.GW5353@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:28420 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2EOGK4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 May 2012 02:10:56 -0400
Content-Disposition: inline
In-Reply-To: <20120514222535.GW5353@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 15, 2012 at 12:25:35AM +0200, Jan Kara wrote:
> On Sun 13-05-12 17:41:04, Dan Carpenter wrote:
> > @@ -508,7 +509,8 @@ fallback_retry:
> >  	for (i = 0; i < ngroups; i++) {
> >  		grp = (parent_group + i) % ngroups;
> >  		desc = ext4_get_group_desc(sb, grp, NULL);
> > -		grp_free = ext4_free_inodes_count(sb, desc);
> > +		if (desc)
> > +			grp_free = ext4_free_inodes_count(sb, desc);
> >  		if (desc && grp_free && grp_free >= avefreei) {
>   So you it would be more logical to do:
> 		if (desc) {
> 			grp_free = ext4_free_inodes_count(sb, desc);
> 			if (grp_free && grpfree >= avefreei) {
> 	 			*group = grp;
> 	 			return 0;
> 			}
> 		}
> 
>   Wouldn't it?

Yeah.  You're obviously right.  I'll resend.

regards,
dan carpenter

