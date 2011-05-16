From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: fix NULL pointer dereference in ext4_quota_off
Date: Mon, 16 May 2011 12:53:47 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1105161248490.3670@dhcp-27-109.brq.redhat.com>
References: <BANLkTin4vEQZ4W5LQT36U3BVxWG4VeDZYw@mail.gmail.com> <alpine.LFD.2.00.1105161148010.3670@dhcp-27-109.brq.redhat.com> <20110516101329.GC5344@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592Ab1EPKxz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 May 2011 06:53:55 -0400
In-Reply-To: <20110516101329.GC5344@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 16 May 2011, Jan Kara wrote:

> On Mon 16-05-11 11:49:22, Lukas Czerner wrote:
> > On Mon, 16 May 2011, Amir Goldstein wrote:
> > > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > > index fc827bb..2689351 100644
> > > --- a/fs/ext4/super.c
> > > +++ b/fs/ext4/super.c
> > > @@ -4681,6 +4681,9 @@ static int ext4_quota_off(struct super_block
> > > *sb, int type)
> > >  	if (test_opt(sb, DELALLOC))
> > >  		sync_filesystem(sb);
> > > 
> > > +	if (!inode)
> > > +		goto out;
> > 
> > Just out of curiosity, why would the quota inode be NULL ?
>   Because quota is already turned off (we then release all references to
> quota file). Just what I don't understand is why in Amir's testing quota is
> not turned on before calling quota off. Because when I run the same test, I
> don't trigger the issue.
> 
> 								Honza
> 

Exactly, I did not read the quota code very deeply, but it seems to me
that when we are turning the quota off, it should be on before. So if it
is not, it might be something broken and this is not the solution (or
maybe it is and I just do not see why:)).

Thanks Honzo!
-Lukas
