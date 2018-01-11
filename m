From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] fs/ext4: create ext4_kset dynamically
Date: Thu, 11 Jan 2018 15:40:54 -0500
Message-ID: <20180111204054.GI19241@thunk.org>
References: <20171127231801.27652-1-sirmy15@gmail.com>
 <20171127231801.27652-4-sirmy15@gmail.com>
 <7CD43048-B60A-43B2-BB18-F2B1432C111D@dilger.ca>
 <20171128105147.GC83442@rschirone-mbp.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: "Riccardo S." <sirmy15@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38146 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932392AbeAKUk7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 11 Jan 2018 15:40:59 -0500
Content-Disposition: inline
In-Reply-To: <20171128105147.GC83442@rschirone-mbp.local>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 28, 2017 at 11:51:47AM +0100, Riccardo S. wrote:
> On 11/27, Andreas Dilger wrote:
> > On Nov 27, 2017, at 4:18 PM, Riccardo Schirone <sirmy15@gmail.com> wrote:
> > > 
> > > -	ext4_feat->kset = &ext4_kset;
> > > +	ext4_feat->kset = ext4_kset;
> > > 	ret = kobject_init_and_add(ext4_feat, &ext4_feat_ktype,
> > > 				   NULL, "features");
> > > 	if (ret)
> > > @@ -455,14 +464,14 @@ int __init ext4_init_sysfs(void)
> > > feat_err:
> > > 	kobject_put(ext4_feat);
> > > kset_err:
> > > -	kset_unregister(&ext4_kset);
> > > +	kset_unregister(ext4_kset);
> > 
> > 
> > It would be prudent in this case to set "ext4_kset = NULL" here
> > so that it isn't cleaned up again somewhere else.  Otherwise,
> > it seems possible that ext4_kset could be cleaned up twice.
> > 
> > Otherwise, the whole premise of this patch seems flawed.
> 
> Right, I'll do it in V2.

I don't think we ever got a V2, so I've applied this patch with
Andreas's suggestions.

  	      	      	    	    	 - Ted
					 
