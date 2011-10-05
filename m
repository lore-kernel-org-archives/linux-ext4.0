From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Remove some deprecated mount options
Date: Wed, 5 Oct 2011 16:34:33 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1110051634250.4423@dhcp-27-109.brq.redhat.com>
References: <1309276394-11536-1-git-send-email-lczerner@redhat.com> <alpine.LFD.2.00.1109011035390.3665@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934462Ab1JEOeh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Oct 2011 10:34:37 -0400
In-Reply-To: <alpine.LFD.2.00.1109011035390.3665@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 1 Sep 2011, Lukas Czerner wrote:

> On Tue, 28 Jun 2011, Lukas Czerner wrote:
> 
> > Remove deprecated mount options bsddf, nogrpid, sysvgroups which has
> > been marked as deprecated since 2.6.23 and should be removed in 2.6.28.
> > However it is not a big deal because those are defaults anyway and the
> > options for setting their opposites still remains in kernel (however are
> > still deprecated). Also push the kernel version to remove those leftover
> > options further in time.
> 
> ping

ping^2

> 
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  Documentation/filesystems/ext4.txt |    4 ----
> >  fs/ext4/super.c                    |   20 +++-----------------
> >  2 files changed, 3 insertions(+), 21 deletions(-)
> > 
> > diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
> > index 9544e2c..b33434f 100644
> > --- a/Documentation/filesystems/ext4.txt
> > +++ b/Documentation/filesystems/ext4.txt
> > @@ -223,7 +223,6 @@ noacl			This option disables POSIX Access Control List
> >  			page and http://acl.bestbits.at/ for more information
> >  			about acl.
> >  
> > -bsddf		(*)	Make 'df' act like BSD.
> >  minixdf			Make 'df' act like Minix.
> >  
> >  debug			Extra debugging information is sent to syslog.
> > @@ -247,9 +246,6 @@ data_err=abort		Abort the journal if an error occurs in a file
> >  grpid			Give objects the same group ID as their creator.
> >  bsdgroups
> >  
> > -nogrpid		(*)	New objects have the group ID of their creator.
> > -sysvgroups
> > -
> >  resgid=n		The group ID which may use the reserved blocks.
> >  
> >  resuid=n		The user ID which may use the reserved blocks.
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index 9ea71aa..a75320e 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -1274,7 +1274,7 @@ static const struct export_operations ext4_export_ops = {
> >  };
> >  
> >  enum {
> > -	Opt_bsd_df, Opt_minix_df, Opt_grpid, Opt_nogrpid,
> > +	Opt_minix_df, Opt_grpid,
> >  	Opt_resgid, Opt_resuid, Opt_sb, Opt_err_cont, Opt_err_panic, Opt_err_ro,
> >  	Opt_nouid32, Opt_debug, Opt_oldalloc, Opt_orlov,
> >  	Opt_user_xattr, Opt_nouser_xattr, Opt_acl, Opt_noacl,
> > @@ -1297,12 +1297,9 @@ enum {
> >  };
> >  
> >  static const match_table_t tokens = {
> > -	{Opt_bsd_df, "bsddf"},
> >  	{Opt_minix_df, "minixdf"},
> >  	{Opt_grpid, "grpid"},
> >  	{Opt_grpid, "bsdgroups"},
> > -	{Opt_nogrpid, "nogrpid"},
> > -	{Opt_nogrpid, "sysvgroups"},
> >  	{Opt_resgid, "resgid=%u"},
> >  	{Opt_resuid, "resuid=%u"},
> >  	{Opt_sb, "sb=%u"},
> > @@ -1486,24 +1483,13 @@ static int parse_options(char *options, struct super_block *sb,
> >  		args[0].to = args[0].from = NULL;
> >  		token = match_token(p, tokens, args);
> >  		switch (token) {
> > -		case Opt_bsd_df:
> > -			ext4_msg(sb, KERN_WARNING, deprecated_msg, p, "2.6.38");
> > -			clear_opt(sb, MINIX_DF);
> > -			break;
> >  		case Opt_minix_df:
> > -			ext4_msg(sb, KERN_WARNING, deprecated_msg, p, "2.6.38");
> > +			ext4_msg(sb, KERN_WARNING, deprecated_msg, p, "3.5");
> >  			set_opt(sb, MINIX_DF);
> > -
> >  			break;
> >  		case Opt_grpid:
> > -			ext4_msg(sb, KERN_WARNING, deprecated_msg, p, "2.6.38");
> > +			ext4_msg(sb, KERN_WARNING, deprecated_msg, p, "3.5");
> >  			set_opt(sb, GRPID);
> > -
> > -			break;
> > -		case Opt_nogrpid:
> > -			ext4_msg(sb, KERN_WARNING, deprecated_msg, p, "2.6.38");
> > -			clear_opt(sb, GRPID);
> > -
> >  			break;
> >  		case Opt_resuid:
> >  			if (match_int(&args[0], &option))
> > 
> 
> 

-- 
