From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 4/4] ext4: fix possible use-after-free
 ext4_remove_li_request()
Date: Fri, 20 May 2011 11:27:18 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1105201122510.5226@dhcp-27-109.brq.redhat.com>
References: <1304956630-20384-1-git-send-email-lczerner@redhat.com> <1304956630-20384-4-git-send-email-lczerner@redhat.com> <4DD57827.9060104@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934934Ab1ETJ1X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 May 2011 05:27:23 -0400
In-Reply-To: <4DD57827.9060104@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 19 May 2011, Eric Sandeen wrote:

> On 5/9/11 10:57 AM, Lukas Czerner wrote:
> > We need to take reference to the s_li_request after we take a mutex,
> > because it might be freed since then, hence result in accessing old
> > already freed memory. Also we should protect the whole
> > ext4_remove_li_request() because ext4_li_info might be in the process of
> > being freed in ext4_lazyinit_thread().
> 
> It'd be really great to have some comments which explain just what
> ext4_li_mtx protects, but I'm working on an add-comments patch for
> the lazyinit stuff (I commented things a bit as I reviewed your 
> changes) so I'll send that along later.

The ext4_li_mtx is protecting the whole ext4_li_info structure so it can
be atomically created and freed.

> 
> in any case, the change looks ok, thanks.
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks!
-Lukas
> 
> 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  fs/ext4/super.c |   10 ++++++----
> >  1 files changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index c379af6..6a8e48f 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -2721,14 +2721,16 @@ static void ext4_remove_li_request(struct ext4_li_request *elr)
> >  
> >  static void ext4_unregister_li_request(struct super_block *sb)
> >  {
> > -	struct ext4_li_request *elr = EXT4_SB(sb)->s_li_request;
> > -
> > -	if (!ext4_li_info)
> > +	mutex_lock(&ext4_li_mtx);
> > +	if (!ext4_li_info) {
> > +		mutex_unlock(&ext4_li_mtx);
> >  		return;
> > +	}
> >  
> >  	mutex_lock(&ext4_li_info->li_list_mtx);
> > -	ext4_remove_li_request(elr);
> > +	ext4_remove_li_request(EXT4_SB(sb)->s_li_request);
> >  	mutex_unlock(&ext4_li_info->li_list_mtx);
> > +	mutex_unlock(&ext4_li_mtx);
> >  }
> >  
> >  static struct task_struct *ext4_lazyinit_task;
> 
> 
