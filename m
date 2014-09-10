From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 1/4] quota: add project quota support
Date: Wed, 10 Sep 2014 18:45:59 +0200
Message-ID: <20140910164559.GA10507@quack.suse.cz>
References: <CAPTn0cAOeQ_nyKx5k+kJOzx17tq+5WtyrMhBE8bpFCKx0UecGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"hch@infradead.org" <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46242 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbaIJQqC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Sep 2014 12:46:02 -0400
Content-Disposition: inline
In-Reply-To: <CAPTn0cAOeQ_nyKx5k+kJOzx17tq+5WtyrMhBE8bpFCKx0UecGw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 10-09-14 11:52:35, Li Xi wrote:
> Adds general codes to enforces project quota limits
> 
> This patch adds support for a new quota type PRJQUOTA for project quota
> enforcement. Also a new method get_projid() is added into dquot_operations
> structure.
> 
  One general note:
  Your mail client has apparently mangled the patch (replaced tabs with
spaces). Please resend patches using git-send-email or some other email
client that doesn't do this so that they can be applied cleanly.

  Some other comments below.

> Signed-off-by: Li Xi <lixi <at> ddn.com>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
> Index: linux.git/fs/quota/dquot.c
> ===================================================================
> --- linux.git.orig/fs/quota/dquot.c
> +++ linux.git/fs/quota/dquot.c
> @@ -161,6 +161,19 @@ static struct quota_module_name module_n
>  /* SLAB cache for dquot structures */
>  static struct kmem_cache *dquot_cachep;
> 
> +static inline unsigned long compat_qtype2bits(int type)
> +{
> +#ifdef CONFIG_QUOTA_PROJECT
  I don't find CONFIG_QUOTA_PROJECT all that useful. If someone is building
a kernel with CONFIG_QUOTA enabled (i.e., a kernel for a server), he can
well spare those few kilobytes for project quota support and it makes the
code somewhat nicer. So I would just remove this config option.

> +    unsigned long qtype_bits = QUOTA_ALL_BIT;
> +#else
> +    unsigned long qtype_bits = QUOTA_USR_BIT | QUOTA_GRP_BIT;
> +#endif
> +    if (type != -1) {
> +        qtype_bits = 1 << type;
> +    }
> +    return qtype_bits;
> +}
> +
>  int register_quota_format(struct quota_format_type *fmt)
>  {
>      spin_lock(&dq_list_lock);
> @@ -250,7 +263,8 @@ struct dqstats dqstats;
>  EXPORT_SYMBOL(dqstats);
> 
>  static qsize_t inode_get_rsv_space(struct inode *inode);
> -static void __dquot_initialize(struct inode *inode, int type);
> +static void __dquot_initialize(struct inode *inode,
> +                   unsigned long qtype_bits);
  I've noticed you are changing interface of several functions from taking
a type number (or -1) to taking a bitmask. I guess it's because of
CONFIG_QUOTA_PROJECT or is there also any other reason? If we get rid of
that config, we won't need this change either, right?

...
> Index: linux.git/include/uapi/linux/quota.h
> ===================================================================
> --- linux.git.orig/include/uapi/linux/quota.h
> +++ linux.git/include/uapi/linux/quota.h
> @@ -36,11 +36,12 @@
>  #include <linux/errno.h>
>  #include <linux/types.h>
> 
> -#define __DQUOT_VERSION__    "dquot_6.5.2"
> +#define __DQUOT_VERSION__    "dquot_6.6.0"
> 
> -#define MAXQUOTAS 2
> +#define MAXQUOTAS 3
  Hum, actually this isn't so simple. MAXQUOTAS is used in several
filesystems - ext3, ext4, ocfs2, reiserfs, gfs2 - and just bumping up
MAXQUOTAS can have unexpected consequences for them (they won't have
properly initialized data structures for new quota type). So what we have
to do as a preparatory step is to make these filesystems define their own
MAXQUOTAS value (like EXT3_MAXQUOTAS, ...). I'll take care of that.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
