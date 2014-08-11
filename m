From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 0/4] quota: add project quota support
Date: Mon, 11 Aug 2014 12:49:50 +0200
Message-ID: <20140811104950.GD29526@quack.suse.cz>
References: <CAPTn0cAKi64Fh1pAVTDLvSS5-1Kjv7KN2HpGxtm4J8-ym-4nOQ@mail.gmail.com>
 <20140808223335.GQ25145@thunk.org>
 <CAPTn0cCwczoaH7va4x3yJZBgtRr8b7_eG9V0YO16YzQcnshdTA@mail.gmail.com>
 <20140809172427.GF15431@thunk.org>
 <20140809221710.GH15431@thunk.org>
 <CAPTn0cBQZsXfcC5FL17s48REGiO0YnQiZB0ez6neCmQr3V5Z4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@zeniv.linux.org.uk, hch@infradead.org,
	Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
	"Niu, Yawei" <yawei.niu@intel.com>
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPTn0cBQZsXfcC5FL17s48REGiO0YnQiZB0ez6neCmQr3V5Z4Q@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun 10-08-14 10:15:36, Li Xi wrote:
> > An additional philosophical question.  If your argument is that you
> > want project quotas to be as fully general and to work like group
> > quotas --- then this brings up a fundamental question --- why can't
> > you just use group quotas?
> I think the reason that people want another quota type is that the UID/GID
> is used in privilege management. And it is always troublesome when things
> are related to privilege, because no administrator want to be blamed for
> file access from unauthorized users. UID/GID usually has a determined
> mapping rule to customers in reality. In this sense, I don't think
> administrators want to (or can) change user/group settings frequently.
> And that is why we need an extra quota type. It looks like group quota,
> but it is flexible and safer for management.
  Well, but you can easily setup the system in such a way that GID (outside
of several system groups) has no priviledge implications (you can use ACLs
if you need more users to access files) and use group quotas if you really
need full flexibility of additional file ID... So I'm not sure I buy this
fear of security implications.

> > What is the use case where you need to have two different quotas that
> > work exactly like group quotas?  And following in the general design
> > rule of "Zero, one, or infinity: there is no two", for whatever use
> > case where you might argue that you need _two_ quotas with identical
> > semantics as group quotas, who is to say that there won't be someone
> > that comes up with some other use case where you need _three_ quotas
> > with identical semantics as group quotas.  Or _four_ group quotas
> > being tracked simultaneously.  Etc, etc., etc.
> "Zero, one, or infinity: there is no two" looks like a beautiful philosophy.
> I totally agree on that. However, I think general project quota happens to
> be the one, not two. If it is an acceptable conclusion that administrator
> can't change global group settings and group attributes of inodes frequently,
  But why would administrator have to change group setting or attributes
frequently?

> project quota become the first flexible and fully controled quota type,
> which administrators can use for freewill space accountment and limit
> enforcement. Unfortunately, this feature has been missing for such a long
> time and the requirement for it grows to a critical point that a lot of
> distributed file systems find their own way of providing similar features,
> e.g. directory/volume/file-set/project quotas. These features looks
> extremely familar, yet aim at different use cases and havs different
> restraints. I prefer a version without any unnecessary restraints becasue
> it retains all possibility.
  I agree additional ID for quota purposes is useful. The question is
whether we leave it as 'just another ID attached to a file' or constrain it
in some way.

> > The advantage of doing the directory hierarcy based quota system is
> > not just that it's compatible with XFS; it is that it is *different*
> > from group quotas.  Not more restrictive, but *different*.  There will
> > certainly be scenarios where someone wants to enforce a restriction on
> > the size or number of inodes in a directory hierarcy, and where when
> > you move a file out of a directory hierarcy into another one, you
> > *want* the usage quota to be transfered from the source to the
> > destination hierarcy.
> I agree that project quota and group quota is different. And I gree that
> the use case of enforcing directory-tree quota is a very important use case,
> probably the most important use case. What I am suggesting is that, with an
> unlimited general project quota, we can enable other potential use cases
> without harming this use case at all. For example, if we want to move
> a file out of a directory hierarcy into another and want the usage quota
> to be transfered, why can't we add a 'setproject' command following with
> 'rename/mv' command? In this use case, this operation is usually done by
> administrator. And I guess it can be safely assumed that a administrator
> is well trained to know what should be done when managing project related
> directories.
  So I actually don't think project quota as implemented by XFS (and with
which me and Ted want to stay compatible with) isn't different from what you
want. Let me explain what XFS does:
  1) Each file has an additional ID - the project ID
  2) Each dir can have XFS_DIFLAG_PROJINHERIT flag set. When this flag is
     set, all files and directories created in the directory inherit project
     ID, directories also inherit XFS_DIFLAG_PROJINHERIT - this is
     equivalent of sgid bit on directories for gids.
  3) When you hard-link a file into directory with XFS_DIFLAG_PROJINHERIT
     set, the file already has to have the same project ID as the directory
     you are linking into.
  4) When you rename a file into a directory with XFS_DIFLAG_PROJINHERIT
     set, the file already has to have the same project ID as the directory
     you are renaming into.
  5) If you call statfs() on a directory with XFS_DIFLAG_PROJINHERIT set
     and project quota is being enforced, statfs() will return free/used
     blocks of the corresponding project instead of number of free/used
     blocks in the filesystem.

Now if, as an administrator, you decide you need completely generic
additional ID, you can do so. You just never set XFS_DIFLAG_PROJINHERIT.
Quota accounting and enforcement works just fine without that flag.

So the discussion really is about the semantics of the
XFS_DIFLAG_PROJINHERIT flag. If you want automatic inheritance of project
ids, you set XFS_DIFLAG_PROJINHERIT.  With that you'll get additional
limitations described in 3) and 4). And I am of the opinion that these
limitations help to maintain sanity in a system where project quotas are
used. I can imagine XFS_DIFLAG_PROJINHERIT would be split in two flags 
for ext4 - one controlling whether project ID is inherited, another
controlling whether we enforce rules 3) and 4) but such difference from XFS
would have to be very well justified because different filesystems having
subtly different semantics is a real administrative nightmare, much worse
than the additional cp + unlink done when rename() returns EXDEV because
you tried to rename from one project to another.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
