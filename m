From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 1/4] quota: add project quota support
Date: Tue, 16 Sep 2014 21:58:05 +0200
Message-ID: <20140916195805.GE1205@quack.suse.cz>
References: <CAPTn0cAOeQ_nyKx5k+kJOzx17tq+5WtyrMhBE8bpFCKx0UecGw@mail.gmail.com>
 <20140910164559.GA10507@quack.suse.cz>
 <CAPTn0cBXjePDOmT+dr4VOVs1r9sKbFC16pJv1fTc_oHLNYLsDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"hch@infradead.org" <hch@infradead.org>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPTn0cBXjePDOmT+dr4VOVs1r9sKbFC16pJv1fTc_oHLNYLsDA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 16-09-14 16:15:35, Li Xi wrote:
> On Thu, Sep 11, 2014 at 12:45 AM, Jan Kara <jack@suse.cz> wrote:
> >> Index: linux.git/include/uapi/linux/quota.h
> >> ===================================================================
> >> --- linux.git.orig/include/uapi/linux/quota.h
> >> +++ linux.git/include/uapi/linux/quota.h
> >> @@ -36,11 +36,12 @@
> >>  #include <linux/errno.h>
> >>  #include <linux/types.h>
> >>
> >> -#define __DQUOT_VERSION__    "dquot_6.5.2"
> >> +#define __DQUOT_VERSION__    "dquot_6.6.0"
> >>
> >> -#define MAXQUOTAS 2
> >> +#define MAXQUOTAS 3
> >   Hum, actually this isn't so simple. MAXQUOTAS is used in several
> > filesystems - ext3, ext4, ocfs2, reiserfs, gfs2 - and just bumping up
> > MAXQUOTAS can have unexpected consequences for them (they won't have
> > properly initialized data structures for new quota type). So what we have
> > to do as a preparatory step is to make these filesystems define their own
> > MAXQUOTAS value (like EXT3_MAXQUOTAS, ...). I'll take care of that.
> Yeah, you are right. It is likely that a new MAXQUOTAS value will hurt other
> file systems. And I saw your patch for it. I will use EXT4_MAXQUOTAS
> in Ext4 instead.
> 
> However, the general codes in fs/quota or head files like quotaops.h use
> MAXQUOTAS heavily too. I guess I have no better choice but replace
> MAXQUOTAS there with a new macro, e.g. MAXQUOTAS_NEW (3). I will handle
> the interfaces carefully so that they remain exactly the same semantics. Do you
> have any better idea?
  The idea is that MAXQUOTAS is the number of quota types supported by VFS.
So you should really increase MAXQUOTAS in your patch because VFS will now
support three quota types. You should make sure that all places that use
MAXQUOTAS in fs/quota/ are safe with that change and fix them if not.

> The reason why I replaced the sepcail type number (i.e. -1) with a
> bitmask is that I thought there might be some cases when we want to
> operate on some of the quota types rather than all of them. When the
> number of quota types was 2, -1 is alright. But since we are using 3
> quota types, it becomes a problem. In order to keep the compatibility of
> quota interfaces, we need to pass only QUOTA_USR_BIT | QUOTA_GRP_BIT to
> functions like __dquot_initialize().  But for ext4, we need to pass
> QUOTA_ALL_BIT. This is an important use case which -1 quota type is not
> able to satisfy.
  Yes, I understand current calling convention isn't able to express
"QUOTA_USR_BIT | QUOTA_GRP_BIT" but I don't see a place where we would
really need that. All the places I'm aware of either want just one quota
type or all of them. That's why I'm asking whether you really need to
express just two types out of three.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
