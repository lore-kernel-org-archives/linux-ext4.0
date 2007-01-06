From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] ext2: conditional removal of NFSD code
Date: Sun, 7 Jan 2007 00:15:10 +0300
Message-ID: <20070106211510.GA4997@martell.zuzino.mipt.ru>
References: <20070106195830.GA6711@martell.zuzino.mipt.ru> <20070106121611.34485a4c.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Neil Brown <neilb@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:9200 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206AbXAFVPT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Jan 2007 16:15:19 -0500
Received: by nf-out-0910.google.com with SMTP id o25so8889900nfa
        for <linux-ext4@vger.kernel.org>; Sat, 06 Jan 2007 13:15:17 -0800 (PST)
To: Andrew Morton <akpm@osdl.org>
Content-Disposition: inline
In-Reply-To: <20070106121611.34485a4c.akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jan 06, 2007 at 12:16:11PM -0800, Andrew Morton wrote:
> On Sat, 6 Jan 2007 22:58:31 +0300
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > --- a/fs/ext2/namei.c
> > +++ b/fs/ext2/namei.c
> > @@ -70,6 +70,7 @@ static struct dentry *ext2_lookup(struct
> >  	return d_splice_alias(inode, dentry);
> >  }
> >
> > +#if defined(CONFIG_EXPORTFS) || defined(CONFIG_EXPORTFS_MODULE)
> >  struct dentry *ext2_get_parent(struct dentry *child)
>
> hm.  Officially, one module isn't supposed to know about the presence of
> another one at compile-time.

Whole new requirement.

> Someone might want to come along and later
> configure and compile the nfsd module and then try to load it into a kernel
> which wasn't compiled with nfsd enabled.

methinks, this is not a case.

	agrep _MODULE -n | grep defined -w

shows plenty of cases, where code is conditionally compiled out with
CONFIG_IPV6 being the major "offender".

> But given that both modules are in mainline I suspect that nobody would
> really be doing that in practice, and in the case of nfsd it might not even
> work.

Yes, compat_sys_nfsservctl() is conditionally compiled in.

I interpret CONFIG_FOO=n as
"I am not going to use FOO, not now, not in future".
