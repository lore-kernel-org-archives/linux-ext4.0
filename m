From: "Riccardo S." <sirmy15@gmail.com>
Subject: Re: [PATCH 3/3] fs/ext4: create ext4_kset dynamically
Date: Tue, 28 Nov 2017 11:51:47 +0100
Message-ID: <20171128105147.GC83442@rschirone-mbp.local>
References: <20171127231801.27652-1-sirmy15@gmail.com>
 <20171127231801.27652-4-sirmy15@gmail.com>
 <7CD43048-B60A-43B2-BB18-F2B1432C111D@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:40523 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933997AbdK1Kvy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Nov 2017 05:51:54 -0500
Received: by mail-wm0-f68.google.com with SMTP id b189so879142wmd.5
        for <linux-ext4@vger.kernel.org>; Tue, 28 Nov 2017 02:51:54 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <7CD43048-B60A-43B2-BB18-F2B1432C111D@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/27, Andreas Dilger wrote:
> On Nov 27, 2017, at 4:18 PM, Riccardo Schirone <sirmy15@gmail.com> wrote:
> > 
> > -	ext4_feat->kset = &ext4_kset;
> > +	ext4_feat->kset = ext4_kset;
> > 	ret = kobject_init_and_add(ext4_feat, &ext4_feat_ktype,
> > 				   NULL, "features");
> > 	if (ret)
> > @@ -455,14 +464,14 @@ int __init ext4_init_sysfs(void)
> > feat_err:
> > 	kobject_put(ext4_feat);
> > kset_err:
> > -	kset_unregister(&ext4_kset);
> > +	kset_unregister(ext4_kset);
> 
> 
> It would be prudent in this case to set "ext4_kset = NULL" here
> so that it isn't cleaned up again somewhere else.  Otherwise,
> it seems possible that ext4_kset could be cleaned up twice.
> 
> Otherwise, the whole premise of this patch seems flawed.

Right, I'll do it in V2.

> 
> > 	return ret;
> > }
> > 
> > void ext4_exit_sysfs(void)
> > {
> > 	kobject_put(ext4_feat);
> > -	kset_unregister(&ext4_kset);
> > +	kset_unregister(ext4_kset);
> 
> Same here.
> 
> > 	remove_proc_entry(proc_dirname, NULL);
> > 	ext4_proc_root = NULL;
> > }
> > --
> > 2.14.3
> > 
> 
> 
> Cheers, Andreas
> 
> 

Thanks,

Riccardo
