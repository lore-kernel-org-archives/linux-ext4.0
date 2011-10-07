From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v3] [SIGNED-OFF] ext4: don't work without procfs
Date: Fri, 7 Oct 2011 10:30:46 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1110071028240.7183@dhcp-27-109.brq.redhat.com>
References: <1317916276-2509-1-git-send-email-yargil@free.fr> <1317916878.1823.2.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Fabrice Jouhaud <yargil@free.fr>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1317916878.1823.2.camel@Joe-Laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 6 Oct 2011, Joe Perches wrote:

> On Thu, 2011-10-06 at 17:51 +0200, Fabrice Jouhaud wrote:
> > From: Yargil <yargil@free.fr>
> 
> It would be better to use your full name on the "From: " line
> 
> > Regression from commit dd68314ccf3fb918c1fb6471817edbc60ece4b52
> > The problem come from the test of the return value of proc_mkdir
> > that is always false without procfs and abort the init of ext4.
> > 
> > Signed-off-by: Fabrice Jouhaud <yargil@free.fr>
> > ---
> >  fs/ext4/super.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index 44d0c8d..9b51b17 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -4985,8 +4985,10 @@ static int __init ext4_init_fs(void)
> >  	if (!ext4_kset)
> >  		goto out6;
> >  	ext4_proc_root = proc_mkdir("fs/ext4", NULL);
> > +#ifdef CONFIG_PROC_FS
> >  	if (!ext4_proc_root)
> >  		goto out5;
> > +#endif
> 
> It would make more sense as:
> 
> +#ifdef CONFIG_PROC_FS
> 	ext4_proc_root = proc_mkdir("fs/ext4", NULL);
>   	if (!ext4_proc_root)
>  		goto out5;
> +#endif

Actually it does not really matter, important is not to check the
condition in case that proc is not configured in.

> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
