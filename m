From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 0/4] quota: add project quota support
Date: Mon, 11 Aug 2014 09:48:36 -0400
Message-ID: <20140811134836.GA3506@thunk.org>
References: <CAPTn0cBGU+bsBc6DumassOyw0HuDP2tAetFaoAOV4TFw21Ud4A@mail.gmail.com>
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
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54424 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778AbaHKNsz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Aug 2014 09:48:55 -0400
Content-Disposition: inline
In-Reply-To: <CAPTn0cBGU+bsBc6DumassOyw0HuDP2tAetFaoAOV4TFw21Ud4A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 11, 2014 at 06:23:53PM +0800, Li Xi wrote:
> As a distributed file system, Lustre is able to use hundreds of seperate
> ext4 file systems to store its data as well as metadata, yet provides a
> united global name space. Some of users start to use SSD devices for better
> performance on Lustre. However as we can expect, they might want to replace
> only part of the drivers to SSD, since SSD is expensive. That means, part
> of the ext4 file systems are using SSD and the other part of the ext4 file
> systems are using hard disks. In the sight of Lustre, users can choose to
> locate files on SSDs or hard disks using features of Lustre, namely 'stripe'
> and 'OST pool'. Here comes the problem, how to limit the usage of SSD since
> all end users want good performance badly?

Ext4 quotas are per-disk, and storage technologies are per disk.  So
if *I* were designing a clustered file system, and we had different
cost centers, say, "mail", and "maps", "social", and "search", each of
which might have differnt amounts disk drive and SSD space, which
might be based on how much SSD each of the product area budgets are
willing to pay, and what the requires of each of the products might
be, I'd simply assign different groups to each of these cost centers.

For the purposes of usages of clustered file systems, you don't want
to do quota enforcement.  If you've spent tens or hundreds of CPU
years working on some distributed computation, you don't want to throw
it all away due to a quota failure.  Or if you are running an
international web-based service, causing a even a partial downtime of
everyone's maps or e-mail due to quota failure is also considered,
well, not cool.

So let's assume that you're only doing usage tracking, but even if you
wanted to do usage control, the files will be scattered across many
different servers and file systems, and so it doesn't make sense to do
quota control, or even usage tracking, on a disk by disk basis.

Hence, the clustered file system will have to sum up the usage quotas
of every each underlying file system, with different sums for the
HDD's and SSD's, by group.  Fortunately, Map Reduce is your friend.

Then for each group the cluster file system can report usage of HDD
and SSD space and inodes, separately.  When a project gets within a
few terabytes of being filled, or the overall free space in the
cluster drops below a few petabytes, you page the your SRE or devops
team so they can take care of things, perhaps by negotiating an
emergency quota increase, or moving files around, or deleting old
files, etc.

The bottom line is that you *can* run an exabyte+ cluster file system
supporting many different budget/cost centers with only group-level
quotas and nothing else.  And you can do this even supporting both
HDD's and SSD's, with separate quota tracking of the two storage
technologies.

Can you go into more detail about how Lustre would use project quotas
from a the cluster file system centric perspective, such as I've
sketched out above?

> Of course, we might be able to find some walk-around ways using group quota.
> However, because the owners of the files can change the group attributes
> freely, it is so easy for the users to evade the group quota and steal the
> tight resources.

But all of the users will be sending chgrp request through Lustre, or
whatever the cluster file system is.  So Lustre can enforce whatever
permissions policy it would like.

> For example, in order to steal SSD space, a user can just
> creating the files using the sepcific group ID and then change it back.

But since you've been arguing that the project id should get preserved
across renames, they can evade quota usage by doing:

	 touch /product/mail/huge_file
	 mv  /product/mail/huge_file /product/maps

And if you allow the rename, and allow the project id to be preserved
across renames, then the quota evasion is just as easy.  And yes, you
could prevent renames at the cluster file system level.  But the
question remains what makes sense on a single disk system, and if
users can trivially subvert the project quota by creating the file in
one directory, where it inherits the quota of project A, and then be
able to move the file to another directory, they have evaded quota
enforcement just as surely if they used chgrp.

Hence, to prevent this, you need to restrict administrator changes to
the superuser, *and* not allow renames across project hierarchies.
And surprise!  That looks exactly what XFS has built.

Cheers,

       		     	       	       	       - Ted
