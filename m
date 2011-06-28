From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Remove some deprecated mount options
Date: Tue, 28 Jun 2011 10:35:07 -0600
Message-ID: <B9B585C1-330D-487B-9E1A-B55255377451@dilger.ca>
References: <1309276394-11536-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:10055 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758043Ab1F1QfL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Jun 2011 12:35:11 -0400
In-Reply-To: <1309276394-11536-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-28, at 9:53 AM, Lukas Czerner wrote:
> Remove deprecated mount options bsddf, nogrpid, sysvgroups which has
> been marked as deprecated since 2.6.23 and should be removed in 2.6.28.
> However it is not a big deal because those are defaults anyway and the
> options for setting their opposites still remains in kernel (however are
> still deprecated). Also push the kernel version to remove those leftover
> options further in time.
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 9ea71aa..a75320e 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1486,24 +1483,13 @@ static int parse_options(char *options, struct super_block *sb,
> 		args[0].to = args[0].from = NULL;
> 		token = match_token(p, tokens, args);
> 		switch (token) {
> -		case Opt_bsd_df:
> -			ext4_msg(sb, KERN_WARNING, deprecated_msg, p, "2.6.38");
> -			clear_opt(sb, MINIX_DF);
> -			break;
> 		case Opt_minix_df:
> -			ext4_msg(sb, KERN_WARNING, deprecated_msg, p, "2.6.38");
> +			ext4_msg(sb, KERN_WARNING, deprecated_msg, p, "3.5");
> 			set_opt(sb, MINIX_DF);
> -
> 			break;
> 		case Opt_grpid:
> -			ext4_msg(sb, KERN_WARNING, deprecated_msg, p, "2.6.38");
> +			ext4_msg(sb, KERN_WARNING, deprecated_msg, p, "3.5");
> 			set_opt(sb, GRPID);
> -
> -			break;
> -		case Opt_nogrpid:
> -			ext4_msg(sb, KERN_WARNING, deprecated_msg, p, "2.6.38");
> -			clear_opt(sb, GRPID);

One problem is that these options haven't been deprecated in major vendor
releases (e.g. 2.6.32 for RHEL6 and SLES11), which is what most people are
using.  I think that they should be deprecated for at least one major
vendor release before being removed, otherwise it is nearly the same as just
deleting them on some random kernel version without telling anyone.

I'm not sure where you got "2.6.23" and "2.6.28" from, maybe you meant "2.6.33",
which is unfortunately just after the cutoff for both RHEL6 and SLES11SP1.


Cheers, Andreas





