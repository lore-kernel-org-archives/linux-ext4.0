From: Andreas Dilger <adilger@sun.com>
Subject: Re: external journal lost [PATCH]
Date: Wed, 08 Apr 2009 22:31:21 -0600
Message-ID: <20090409043121.GR17302@webber.adilger.int>
References: <20090331144755.GA14155@droog.sdf-eu.org>
 <20090402120800.GB6618@droog.sdf-eu.org>
 <alpine.DEB.2.01.0904021408040.6162@bogon.housecafe.de>
 <alpine.DEB.2.01.0904080135360.6162@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: ext-users <ext3-users@redhat.com>, linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:58066 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbZDIEbl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Apr 2009 00:31:41 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n394VXq5003579
	for <linux-ext4@vger.kernel.org>; Wed, 8 Apr 2009 21:31:35 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KHT00A00G8CV300@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Wed,
 08 Apr 2009 21:31:33 -0700 (PDT)
In-reply-to: <alpine.DEB.2.01.0904080135360.6162@bogon.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 08, 2009  01:40 -0700, Christian Kujau wrote:
> On Thu, 2 Apr 2009, Christian Kujau wrote:
> > Hm, I never had to forcefully remove a journal (yet), but from reading the 
> > manpage I'd indeed expect to get this removed even if the filesystem is in 
> > error. The attached patch to e2fsprogs (latest git) makes tune2fs removing 
> > the journal when "-f" is supplied. And it seems to work so far:
> > 
> > http://nerdbynature.de/bits/tune2fs/
> > 
> > Comments?
> 
> Hm, I was really hoping someone would comment on this, as I'm a) puzzled 
> as well, why the -force option does not work as expected and b) if this is 
> the right thing to do:

Proabably the right thing to do.

> --- e2fsprogs-git/misc/tune2fs.c.ORIG	2009-04-02 22:40:58.740218188 +0200
> +++ e2fsprogs-git/misc/tune2fs.c	2009-04-02 22:42:37.221830335 +0200
> @@ -374,8 +374,8 @@ static void update_feature_set(ext2_fils
>  				"read-only.\n"), stderr);
>  			exit(1);
>  		}
> -		if (sb->s_feature_incompat &
> -		    EXT3_FEATURE_INCOMPAT_RECOVER) {
> +		if ((sb->s_feature_incompat &
> +		    EXT3_FEATURE_INCOMPAT_RECOVER) && (!f_flag)) {
>  			fputs(_("The needs_recovery flag is set.  "
>  				"Please run e2fsck before clearing\n"
>  				"the has_journal flag.\n"), stderr);
> 
> -- 
> Bruce Schneier knows the secret formula for Coca-Cola.
> 
> _______________________________________________
> Ext3-users mailing list
> Ext3-users@redhat.com
> https://www.redhat.com/mailman/listinfo/ext3-users

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

