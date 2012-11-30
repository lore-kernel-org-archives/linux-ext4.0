From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/4] ext4: remove unsafe and unnecessary memset()
Date: Fri, 30 Nov 2012 15:04:59 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1211301504160.8688@dhcp-1-104.brq.redhat.com>
References: <1354257706-6582-1-git-send-email-yan@linux.vnet.ibm.com> <alpine.LFD.2.00.1211301418220.8688@dhcp-1-104.brq.redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1290881619-1354284309=:8688"
Cc: Guo Chao <yan@linux.vnet.ibm.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094Ab2K3OG6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Nov 2012 09:06:58 -0500
In-Reply-To: <alpine.LFD.2.00.1211301418220.8688@dhcp-1-104.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1290881619-1354284309=:8688
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Fri, 30 Nov 2012, Luká¨ Czerner wrote:

> Date: Fri, 30 Nov 2012 14:20:42 +0100 (CET)
> From: Luká¨ Czerner <lczerner@redhat.com>
> To: Guo Chao <yan@linux.vnet.ibm.com>
> Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
> Subject: Re: [PATCH 1/4] ext4: remove unsafe and unnecessary memset()
> 
> On Fri, 30 Nov 2012, Guo Chao wrote:
> 
> > Date: Fri, 30 Nov 2012 14:41:43 +0800
> > From: Guo Chao <yan@linux.vnet.ibm.com>
> > To: tytso@mit.edu
> > Cc: linux-ext4@vger.kernel.org
> > Subject: [PATCH 1/4] ext4: remove unsafe and unnecessary memset()
> > 
> > We memset this page before checking whether it's valid. But we need
> > not memset zeroed page at all.
> > 
> > Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
> > ---
> >  fs/ext4/super.c |    1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index ad6cd8a..66a4e20 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -3206,7 +3206,6 @@ int ext4_calculate_overhead(struct super_block *sb)
> >  	ext4_fsblk_t overhead = 0;
> >  	char *buf = (char *) get_zeroed_page(GFP_KERNEL);
> >  
> > -	memset(buf, 0, PAGE_SIZE);
> >  	if (!buf)
> >  		return -ENOMEM;
> 
> Good catch, thanks!
> 
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>

It looks like that it has been already fixed with a different patch.

http://www.spinics.net/lists/linux-ext4/msg35310.html

> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-1290881619-1354284309=:8688--
