From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tune2fs: remove dire warning about check intervals
Date: Wed, 19 Jul 2017 10:42:20 -0400
Message-ID: <20170719144220.rfs5prb2265mjtyj@thunk.org>
References: <ce6bff3e-49f4-2bed-67ce-a7be604ce1cf@redhat.com>
 <CD3439EC-F272-4172-8C7F-229C6DAE06EC@dilger.ca>
 <20170719011517.tfvnzb7mzfle25hi@thunk.org>
 <20170719072157.7kjwyltmuvzk2oec@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Andreas Dilger <adilger@dilger.ca>,
        Eric Sandeen <sandeen@redhat.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40336 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754734AbdGSOmY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 19 Jul 2017 10:42:24 -0400
Content-Disposition: inline
In-Reply-To: <20170719072157.7kjwyltmuvzk2oec@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 19, 2017 at 09:21:57AM +0200, Lukas Czerner wrote:
> I am actually worried that with this approach we are, simply by adding
> complexity, making situation worse than just not running periodic
> e2fsck.

How would it make things worse?  If you don't trust lvm or dm-thin to
create a read-only snapshot, you've got **way** worse problems.  I
acutally think relying on e2fsck on a r/o snapshot to be much simpler
than trying to add an on-line file systme check.  That requires much
more kernel code which almost by definition is higher risk (e.g., to
bugs of the sort found by AFL) than already-existing userspace code.

> What we should be aiming for I think is the online file system check and
> scrub. This would of course not replace the need rof e2fsck, but we
> would be able to catch errors early while fixing some of those that we
> can. But that's long term. Short term I think we're better off without
> this snapshotting/checking complexity. Those who are concerned can still
> enable the time/mount based checks right ?

time/mount-based checks only help if you reboot; the advantage of
doing a check on read-only snapshot is you can schedule it once a
week, or once a month, during idle times.  Picking idle times might be
tricky, but distro's when they decide on a default for running
updatedb(8) for the locate command.  And whether the crontab entry is
installed by default, or has to be explicitly enabled by the user, or
e2croncheck is put in a separate package for distributions to use are
all distro decisions.

I would probably go for the last, with a debian-style "recommends" or
"suggests" dependency for easy discoverability but different
distributions can do what they like --- including not packaging
e2croncheck at all.  But in terms of a short-term solution it's really
not hard to add.  And I don't believe I've heard any reports of
instability for r/o snapshot functionality.  That's been around for a
long, long, time at least for LVM snapshots.  dm-thin might be
considered more flakey, but that reputation seems to apply for dm-thin
as a whole, as opposed to just its snapshot functionality.  If a user
is willing to trust their data to dm-thin, are taking a bigger risk by
using dm-thin snapshots?

					- Ted
