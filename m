From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 1/4] quota: add project quota support
Date: Wed, 17 Sep 2014 14:17:32 +0200
Message-ID: <20140917121732.GA2512@quack.suse.cz>
References: <CAPTn0cAOeQ_nyKx5k+kJOzx17tq+5WtyrMhBE8bpFCKx0UecGw@mail.gmail.com>
 <20140910164559.GA10507@quack.suse.cz>
 <CAPTn0cBXjePDOmT+dr4VOVs1r9sKbFC16pJv1fTc_oHLNYLsDA@mail.gmail.com>
 <20140916195805.GE1205@quack.suse.cz>
 <CAPTn0cD0zabPgf2Vm2pyFo4ougJE3BMx204QfkKSEj217icAxQ@mail.gmail.com>
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
In-Reply-To: <CAPTn0cD0zabPgf2Vm2pyFo4ougJE3BMx204QfkKSEj217icAxQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 17-09-14 11:02:01, Li Xi wrote:
> On Wed, Sep 17, 2014 at 3:58 AM, Jan Kara <jack@suse.cz> wrote:
> > On Tue 16-09-14 16:15:35, Li Xi wrote:
> >> On Thu, Sep 11, 2014 at 12:45 AM, Jan Kara <jack@suse.cz> wrote:
> >> >> Index: linux.git/include/uapi/linux/quota.h
> >> >> ===================================================================
> >> >> --- linux.git.orig/include/uapi/linux/quota.h
> >> >> +++ linux.git/include/uapi/linux/quota.h
> >> >> @@ -36,11 +36,12 @@
> >> >>  #include <linux/errno.h>
> >> >>  #include <linux/types.h>
> >> >>
> >> >> -#define __DQUOT_VERSION__    "dquot_6.5.2"
> >> >> +#define __DQUOT_VERSION__    "dquot_6.6.0"
> >> >>
> >> >> -#define MAXQUOTAS 2
> >> >> +#define MAXQUOTAS 3
> >> >   Hum, actually this isn't so simple. MAXQUOTAS is used in several
> >> > filesystems - ext3, ext4, ocfs2, reiserfs, gfs2 - and just bumping up
> >> > MAXQUOTAS can have unexpected consequences for them (they won't have
> >> > properly initialized data structures for new quota type). So what we have
> >> > to do as a preparatory step is to make these filesystems define their own
> >> > MAXQUOTAS value (like EXT3_MAXQUOTAS, ...). I'll take care of that.
> >> Yeah, you are right. It is likely that a new MAXQUOTAS value will hurt other
> >> file systems. And I saw your patch for it. I will use EXT4_MAXQUOTAS
> >> in Ext4 instead.
> >>
> >> However, the general codes in fs/quota or head files like quotaops.h use
> >> MAXQUOTAS heavily too. I guess I have no better choice but replace
> >> MAXQUOTAS there with a new macro, e.g. MAXQUOTAS_NEW (3). I will handle
> >> the interfaces carefully so that they remain exactly the same semantics. Do you
> >> have any better idea?
> >   The idea is that MAXQUOTAS is the number of quota types supported by VFS.
> > So you should really increase MAXQUOTAS in your patch because VFS will now
> > support three quota types. You should make sure that all places that use
> > MAXQUOTAS in fs/quota/ are safe with that change and fix them if not.
> Sorry, I am confused here. Would you please explain more? As you mentioned
> before, MAXQUOTAS is a so critial macro that we can't change it without taking
> care of other file systems. So, should I update MAXQUOTAS directly or not?
  So as you noted, I've already posted patches for all filesystems to stop
using MAXQUOTAS. So after these patches are merged you are safe to change
MAXQUOTAS as you need.

> I would prefer to update MAXQUOTAS to 3 rather than add MAXQUOTAS_NEW or
> hack in other ways. I understand that MAXQUOTAS has been 2 from the first
> begining, and it is possible that some codes take its invariance for
> granted for too long. But if a file system is using MAXQUOTAS in a wrong
> way, maybe it is possible for us to find and fix the problems after this
> patch is merged, yet before Linux is released as next major version?
  As I wrote above filesystems won't be using MAXQUOTAS anymore. Each
filesystem now has its own define. Thus it is enough to audit VFS for
MAXQUOTAS usage and that you have to do to allow for project quotas anyway.

> Another solution would be to replace MAXQUOTAS in these file systems to
> ${FS}_MAXQUOTAS. It won't cost much time to prepare those patches. And
> If these patches can be accepted and merged quickly, it would a safer
> solution. For example, that would prevent Ext3 from allocating unnecessary
> transaction blocks because MAXQUOTAS is increased. I checked other
> places where MAXQUOTAS is used. I haven't found any problems yet. But
> as you said, we are not sure whether there will be any critical problem.
  This is exactly what I meant and patches for this are already sitting in
maintainer's trees. So in the next merge window this will be done.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
