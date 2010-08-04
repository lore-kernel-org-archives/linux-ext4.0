From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/3] Add batched discard support for ext3
Date: Wed, 4 Aug 2010 16:32:53 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1008041631400.2932@localhost>
References: <1280929475-12823-1-git-send-email-lczerner@redhat.com> <1280929475-12823-2-git-send-email-lczerner@redhat.com> <20100804140345.GA4139@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	jmoyer@redhat.com, rwheeler@redhat.com, eshishki@redhat.com,
	sandeen@redhat.com, tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758195Ab0HDOdD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Aug 2010 10:33:03 -0400
In-Reply-To: <20100804140345.GA4139@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 4 Aug 2010, Jan Kara wrote:

>   Hi,
> 
>   The patch looks good. Just one small thing:
> 
> On Wed 04-08-10 15:44:34, Lukas Czerner wrote:
> > +	gdp = ext3_get_group_desc(sb, group, &gdp_bh);
> > +	if (!gdp)
> > +		goto err_out;
> > +
> > +	BUFFER_TRACE(gd_bh, "get_write_access");
>                      ^^^^^ gdp_bh
> 
>   So you can add: Reviewed-by: Jan Kara <jack@suse.cz>
> 
> 								Honza
> 

Hi,

thanks a lot for your review. I will resend both patches shortly.

Regards.

-Lukas
