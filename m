From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] Ext3 removal, quota & udf fixes
Date: Mon, 31 Aug 2015 22:53:35 -0400
Message-ID: <20150901025335.GF7642@thunk.org>
References: <20150831061920.GA2751@quack.suse.cz>
 <CA+55aFweA1J+a5MYxgWDOAg0p+UdqfP+Z1aFKs1c8n0hWUiBDw@mail.gmail.com>
 <55E4D5DE.2030709@gmail.com>
 <CA+55aFz+n6uE7hRB=2mxeLiaVK8qTwjfSU_f_sAMY7kK0AG0sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Raymond Jennings <shentino@gmail.com>, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFz+n6uE7hRB=2mxeLiaVK8qTwjfSU_f_sAMY7kK0AG0sg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Aug 31, 2015 at 03:39:38PM -0700, Linus Torvalds wrote:
> 
> That's not my only worry. Things like "can you go back to ext3-only"
> is an issue too - I don't think that's been a big priority for ext4
> any more, and if there are any existing hold-outs that still use ext3,
> they may want to be able to go back to old kernels.

Yes, you can go back to ext3-only.  In fact, we do *not* automatically
upgrade the file system to use ext4-specific features.

> So it's not just a "you can use ext4 instead" issue. Can you do that
> *without* then forcing an upgrade forever on that partition? I'm not
> sure the ext4 people are really even willing to guarantee that kind of
> backwards compatibility.

Actually, we do guarantee this.  It's considered poor form to
automatically change the superblock to add new file system features in
a way that would break the ability for the user to roll back to an
older kernel.  This isn't just for ext3->ext4, but for new ext4
features such as metadata checksumming.  The user has to explicitly
enable the feature using "tune2fs -O new_feature /dev/sdXX".

A file system with ext3-only features is part of regression test
suites.  I also test an ext3 file system that has been converted to
ext4 using the tune2fs command, data=journal, nojournal, new
experimental features such as inline data, etc., etc.:

BEGIN TEST 4k: Ext4 4k block Mon Aug 24 23:01:09 EDT 2015
BEGIN TEST 1k: Ext4 1k block Mon Aug 24 23:47:13 EDT 2015
BEGIN TEST ext3: Ext4 4k block emulating ext3 Tue Aug 25 00:40:19 EDT 2015
BEGIN TEST nojournal: Ext4 4k block w/ no journal Tue Aug 25 01:23:16 EDT 2015
BEGIN TEST ext3conv: Ext4 4k block w/nodelalloc and no flex_bg Tue Aug 25 02:04:52 EDT 2015
BEGIN TEST dioread_nolock: Ext4 4k block w/dioread_nolock Tue Aug 25 02:48:32 EDT 2015
BEGIN TEST data_journal: Ext4 4k block w/data=journal Tue Aug 25 03:34:30 EDT 2015
BEGIN TEST inline: Ext4 4k block w/inline Tue Aug 25 04:36:47 EDT 2015
BEGIN TEST bigalloc: Ext4 4k block w/bigalloc Tue Aug 25 05:22:08 EDT 2015
BEGIN TEST bigalloc_1k: Ext4 1k block w/bigalloc Tue Aug 25 06:20:54 EDT 2015

I fire off the test suite using a single command: "gce-xfstests full"
which launches the regression test into the cloud (approximate cost
using Google Compute Engine: $1.50, at retail rates), and then 7-8
hours later, the results get e-mailed to me.  These tests get run
regularly during the development cycle, and I always do at least one
full test run before I send you each pull request.

So supporting and continuing to do regression testing for ext3 is
something we're doing today and I am willing to commit to continue to
do.

> I could be ok with removing ext3 in theory, but I haven't seen a lot
> of rationale for it, and I don't know if there are still users who may
> have their own good reasons to stay with ext3. Maybe there has been
> lots of discussion about this on fsdevel (which I don't follow), and
> I'm just lacking the background, but if so I want to see that
> background. Not just a oneliner description that basically says
> "remove ext3 support".

The main rationale is that two code bases is harder to support than
one.  When bugs get fixed in ext4, they don't necessarily get
back-propagated to ext3 except for a manual process where Jan notices
that a bug fixed in ext4 is also in ext3, and he manually ports the
patch over.

Both Red Hat and SuSE, as well as Debian and Ubuntu, are using ext4
with CONFIG_EXT4_USE_FOR_EXT23 for a couple of years now to support
ext2 and ext3 file systems.  So with the exception of some really
ancient enterprise Linux distros, and people who are manually
configuring their systems, very few people are likely using ext3 code
base, which means the chances that it bitrots increases.  Basically,
it's only been Jan's tireless work that has kept that from happening,
given that all of the major distro's have been using ext4 to support
ext2 and ext3 file systems.

Given that all of the major distributions are using ext4 to support
ext3, full backwards compatibility support for ext3 is something we
support today and will have to continue supporting regardless of
whether or not ext3 gets removed from the kernel sources.

Cheers,

						- Ted

P.S.  Even though most distributions are also using ext4 to support
ext2, I don't support removing ext2 at this time.  Like minix, it's a
simple file system that can be easily used by others to understand
what's needed to create a new file system.  
