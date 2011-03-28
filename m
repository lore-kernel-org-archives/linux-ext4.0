From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Remove redundant check for first_not_zeroed in
 ext4_register_li_request.
Date: Mon, 28 Mar 2011 14:41:15 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1103281437440.3158@dhcp-27-109.brq.redhat.com>
References: <1301298622-4014-1-git-send-email-tm@tao.ma> <alpine.LFD.2.00.1103281433180.3158@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab1C1MlV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Mar 2011 08:41:21 -0400
In-Reply-To: <alpine.LFD.2.00.1103281433180.3158@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 28 Mar 2011, Lukas Czerner wrote:

> On Mon, 28 Mar 2011, Tao Ma wrote:
> 
> > From: Tao Ma <boyu.mt@taobao.com>
> > 
> > We have checked first_not_zeroed == ngroups already above,
> > so remove this redundant check.
> > 
> > Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> > ---
> >  fs/ext4/super.c |    5 -----
> >  1 files changed, 0 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index 2d1378f..37448a7 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -2953,11 +2953,6 @@ static int ext4_register_li_request(struct super_block *sb,
> >  		return 0;
> >  	}
> >  
> > -	if (first_not_zeroed == ngroups) {
> > -		sbi->s_li_request = NULL;
> > -		return 0;
> > -	}
> > -
> >  	elr = ext4_li_request_new(sb, first_not_zeroed);
> >  	if (!elr)
> >  		return -ENOMEM;
> > 
> 
> Patch looks good.
> 
> Thanks!
> -Lukas

Just one tiny thing, we do not even need to set
sbi->s_li_request = NULL since it is NULL already and we check that
in the beginning of the function.

Thanks!
-Lukas
