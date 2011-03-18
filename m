From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/4 v2] e2fsprogs: Add rbtree library
Date: Fri, 18 Mar 2011 10:46:13 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1103181041230.4087@dhcp-27-109.brq.redhat.com>
References: <1300387821-21705-1-git-send-email-lczerner@redhat.com> <1300387821-21705-2-git-send-email-lczerner@redhat.com> <C0759906-5B2F-4A73-9248-4C1B1897F4EB@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, sandeen@redhat.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932336Ab1CRJqU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Mar 2011 05:46:20 -0400
In-Reply-To: <C0759906-5B2F-4A73-9248-4C1B1897F4EB@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 17 Mar 2011, Andreas Dilger wrote:

> On 2011-03-17, at 12:50 PM, Lukas Czerner wrote:
> > +#undef offsetof
> > +#ifdef __compiler_offsetof
> > +#define offsetof(TYPE,MEMBER) __compiler_offsetof(TYPE,MEMBER)
> > +#else
> > +#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
> > +#endif
> 
> This may as well go into a more common header like lib/ext2fs/ext2fs.h, since I see offsetof() is #defined 5 separate times in the e2fsprogs code already.
> 
> > +#define container_of(ptr, type, member) ({			\
> > +	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
> > +	(type *)( (char *)__mptr - offsetof(type,member) );})
> 
> Same.
> 
> > +#define rb_parent(r)   ((struct rb_node *)((r)->rb_parent_color & ~3))
> > +#define rb_color(r)   ((r)->rb_parent_color & 1)
> > +#define rb_is_red(r)   (!rb_color(r))
> > +#define rb_is_black(r) rb_color(r)
> > +#define rb_set_red(r)  do { (r)->rb_parent_color &= ~1; } while (0)
> > +#define rb_set_black(r)  do { (r)->rb_parent_color |= 1; } while (0)
> > +
> > +#define RB_ROOT	(struct rb_root) { NULL, }
> > +#define	rb_entry(ptr, type, member) container_of(ptr, type, member)
> 
> The indenting here is a bit broken, but I see it is the same in the upstream kernel code, so it probably shouldn't be changed just for e2fsprogs.
> 
> 
> Cheers, Andreas
> 

Hi Andreas,

thank you for the review! You're right I'll move those macros into
lib/ext2fs/ext2fs.h

Thanks!
-Lukas
