From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] e2info: create a tool to display ext4 fs geometry
 online
Date: Fri, 3 Mar 2017 00:12:07 -0500
Message-ID: <20170303051207.b5zleowuydshuh2m@thunk.org>
References: <148843032650.21733.13980225191301375698.stgit@birch.djwong.org>
 <148843033922.21733.4922683685279348093.stgit@birch.djwong.org>
 <0AA96991-8F69-4004-BAC8-8C1DBB8368E0@dilger.ca>
 <20170302215018.GH5266@birch.djwong.org>
 <6C771B1F-1947-416A-874F-34427B1586A5@dilger.ca>
 <20170302224413.GN26319@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50458 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751409AbdCCGGq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 3 Mar 2017 01:06:46 -0500
Content-Disposition: inline
In-Reply-To: <20170302224413.GN26319@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 02, 2017 at 02:44:13PM -0800, Darrick J. Wong wrote:
> That's true.  You're right in pointing out that dumpe2fs ought to be the
> sole ext4 header dumping tool... but then there'll be complaints that
> the online mode doesn't print the group descriptor information like the
> offline mode does; also if I want to replicate dumpe2fs -h's output then
> I basically have to export the whole ext4 superblock via ioctl (which
> binds userspace to the ext4 superblock so dumpe2fs is likely to be the
> only program ever to use it) to avoid complaints about the output
> missing header fields; and finally combine that with the various
> suggestions that I try to come up with some sort of generic fs geometry
> ioctl, which (IMO) doesn't make enough sense to justify all the
> inevitable fsdevel bikeshedding...

Well, one advantage of using the ioctl is that it won't require
special (root) privileges.  So if we only use it when the block device
can't be opened directly, it might still be useful, even if we don't
return all of the information as dumpe2fs -h.


> ...at that point I decided I just don't care anymore.  I'll leave it to
> whomever actually /does/ want this, since the original justification
> (being able to hook up xfs_spaceman's reporting tools to ext4) is never
> going to happen anyway.

I'll take a look at this when I have a chance.  I agree that
integrating these two programs with e2freefrag and dumpe2fs makes the
most amount of sense.

						- Ted
