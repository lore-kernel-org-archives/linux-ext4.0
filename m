From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 0/4] quota: add project quota support
Date: Mon, 11 Aug 2014 10:45:35 -0400
Message-ID: <20140811144535.GD3506@thunk.org>
References: <CAPTn0cCh0fh2REPgyXg_nBrJVVppiujVyj6XKruocg1q7MVVVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shuichi Ihara <sihara@ddn.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"hch@infradead.org" <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger@dilger.ca>,
	"Niu, Yawei" <yawei.niu@intel.com>
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPTn0cCh0fh2REPgyXg_nBrJVVppiujVyj6XKruocg1q7MVVVA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Aug 11, 2014 at 10:40:38PM +0800, Li Xi wrote:
> > But since you've been arguing that the project id should get preserved
> > across renames, they can evade quota usage by doing:
> >
> >          touch /product/mail/huge_file
> >          mv  /product/mail/huge_file /product/maps
> I don't really understand why these commands can evade project quota
> since:
> 1) A newly created file will inherit project ID from its parent inode.
> 2) Project ID will be preserved across renames
> 3) Project quota won't be transfered unless its project ID is changed.
> 4) Only root user has the right to change project ID.
> The rule 2) and 3) are just the same sematics with UID/GID quotas.
> So, becasue of rule 1), after 'touch /product/mail/huge_file', the project
> ID of 'huge_file' is 'mail', and its usage is accouted as project 'mail'.
> Even we do 'mv /product/mail/huge_file /product/maps', because
> of rule 2), there is no project ID updating and no quota transfer. Since
> so, the project quota of file 'huge_file' is always accounted as 'mail',
> from the first beginning to the end. And that is why I think project quota
> of 'mail' can't be evaded in this way.

Yes, and *that* is the quota evasion.  There is no difference in terms
of who ends up owning the quota between:

     touch /product/mail/huge_file
     mv /product/mail/huge_file /product/maps

and

    touch /product/maps/huge_file
    chgrp mail /product/maps/huge_file

Either way, a file that is storing maps information (that is why it is
in /product/maps/huge_file) ends up getting accounted against the mail
product's quota.

So if you say, ok, we're using project quota, we won't allow:

    chproject mail /product/maps/huge_file

But then the user can just do this instead:

     touch /product/mail/huge_file
     mv /product/mail/huge_file /product/maps

This is why we MUST NOT allow the rename, or force the project quota
to change when you move the inode to a different directory hierarchy
owned by a different project.

					- Ted
