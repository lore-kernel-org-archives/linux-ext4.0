From: Theodore Tso <tytso@mit.edu>
Subject: Re: what fsck can (and can't) do was Re: [patch] ext2/3: document
	conditions when reliable operation is possible
Date: Thu, 3 Sep 2009 15:27:25 -0400
Message-ID: <20090903192725.GB7378@mit.edu>
References: <20090824212518.GF29763@elf.ucw.cz> <alpine.DEB.2.00.0908280748080.6822@asgard.lang.hm> <20090829100558.GH1634@ucw.cz> <200908291522.07694.rob@landley.net> <alpine.DEB.2.00.0909030848480.28411@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rob Landley <rob@landley.net>, Pavel Machek <pavel@ucw.cz>,
	Ric Wheeler <rwheeler@redhat.com>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: david@lang.hm
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0909030848480.28411@asgard.lang.hm>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 03, 2009 at 09:56:48AM -0700, david@lang.hm wrote:
> from this discussin (and the similar discussion on lwn.net) there appears 
> to be confusion/disagreement over what fsck does and what the results of  
> not running it are.
>
> it has been stated here that fsck cannot fix broken data, all it tries to 
> do is to clean up metadata, but it would probably help to get a clear  
> statement of what exactly that means.

Let me give you my formulation of fsck which may be helpful.  Fsck can
not fix broken data; and (particularly in fsck -y mode) may not even
recover the maximal amount of lost data caused by metadata corruption.
(This is why sometimes an expert using debugfs can recover more data
than fsck -y, and if you have some really precious data, like ten
years' worth of Ph.D. research that you've never bothered to back
up[1], the first thing you should do is buy a new hard drive and make a
sector-by-sector copy of the disk and *then* run fsck.  A new
terrabyte hard drive costs $100; how much is your data worth to you?)

[1] This isn't hypothetical; while I was at MIT this sort of thing
actually happened more than once --- which brings up the philosophical
question of whether someone who is that stupid about not doing backups
on critical data *deserves* to get a Ph.D. degree.  :-)

Fsck's primary job is to make sure that further writes to the
filesystem, whether you are creating new files or removing directory
hierarchies, etc., will not cause *additional* data loss due to meta
data corruption in the file system.  Its secondary goals are to
preserve as much data as possible, and to make sure that file system
metadata is valid (i.e., so that a block pointer contains a valid
block address, so that an attempt to read a file won't cause an I/O
error when the filesystems attempts to seek to a non-existent sector
on disk).

For some filesystems, invalid, corrupt metadata can actually cause a
system panic or oops message, so it's not necessarily safe to mount a
filesystem with corrupt metadata read-only without risking the need to
reboot the machine in question.  More recently, there are folks who
have been filing security bugs when they detect such cases, so there
are fewer examples of such cases, but historically it was a good idea
to run fsck because otherwise it's possible the kernel might oops or
panic when it tripped over some particularly nasty metadata corruption.

> but if a fsck does not get run on a filesystem that has been damaged, 
> what additional damage can be done?

Consider the case where there are data blocks in use by inodes,
containing precious data, but which are marked free in a filesystem
allocation data structures (e.g., ext3's block bitmaps, but this
applies to pretty much any filesystem, whether it's xfs, reiserfs,
btrfs, etc.).  When you create a new file on that filesystem, there's
a chance that blocks that really contain data belonging to other
inodes (perhaps the aforementioned ten years' of unbacked-up
Ph.D. thesis research) will get overwritten by the newly created file.

Another example is an inode which has multiple hard links, but the
hard link count is wrong by being too low.  Now when you delete one of
the hard links, the inode will be released, and the inode and its data
blocks returned to the free pool, despite the fact that it is still
accessible via another directory entry in the filesystem, and despite
the fact that the file contents should be saved.

In the case where you have a block which is claimed by more than one
file, if that file is rewritten in place, it's possible that the newly
written file could have its data corrupted, so it's not just a matter
of potential corruption to existing files; the newly created files are
at risk as well.

> can it overwrite data that could have been saved?
>
> can it cause new files that are created (or new data written to existing, 
> but uncorrupted files) to be lost?
>
> or is it just a matter of not knowing about existing corruption?

So it's yes to all of the above; yes, you can overwrite existing data
files; yes it can cause data blocks belonging to newly created files
to be list; and no you won't know about data loss caused by metadata
corruption.  (Again, you won't know about data loss caused by
corruption to the data blocks.)

					- Ted

