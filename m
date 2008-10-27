From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4 patch-queue patching issues
Date: Mon, 27 Oct 2008 10:20:55 -0400
Message-ID: <20081027142055.GC10603@mit.edu>
References: <3.0.6.32.20081024165139.024a3ee0@pop.west.cox.net> <49051C54.2060905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gary Hawco <ghawco@cox.net>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:43750 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750782AbYJ0OVA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2008 10:21:00 -0400
Content-Disposition: inline
In-Reply-To: <49051C54.2060905@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 26, 2008 at 08:41:40PM -0500, Eric Sandeen wrote:
> > Looking at the snapshots from another portion of the ext4 tree:
> > http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=summary
> > 
> > with the newest being from 16 Oct 2008 @ 2311hrs. it says they are based
> > against 2.6.27-git7, which again, is which kernel?  
> 
> # BASE 2.6.27-git7
> 
> http://www.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.27-git7.bz2
> 
> I had to chase this down Friday as well :)

Hi Gary,

Sorry, just before and after the 2.6.28-rc1 merge window, things get a
little crazy, because the only way to keep track of things is via the
daily snapshots.

Enclosed is a snippet from a private e-mail that I recent sent to
someone who asked about how to apply the git tree.  It was a private
query, so I sent a private reply, but in retrospect maybe I should
have cc'ed the response to the linux-ext4 list.  The person asking the
question did say he was going to try to find time to get this cleaned
up and wikified for ext4.wiki.kernel.org, so that should hopefully
help as well.

Note that another place for finding the git id and patchsets for the
"daily snapshots" can be found at "http://ftp.kernel.org". 

I'll try to get the ext4 patch queue updated for 2.6.28-rc2 shortly,
and to make sure the ext4-stable branch (and the for-stable branch)
gets updated with most recent regression fix in the next day or two.
Sorry, but I was trying to juggle a rather embarassing ext3/ext4
regression while being out of town at a Thomas Merton conference in
Kentucky over the weekend, so I'm a bit behind on keeping the ext4
patch queue updated after Linus accepted our stable patches for the
2.6.28 merge window.

						- Ted

Ok, if you're going to make the leap to 2.6.27, then what you will
need to do if you want to apply the patches in the ext4 patch queue is
to go pull down the patches that have been applied between 2.6.27 and
2.6.27-git5.   The easist way to do this will be via git:

# Get 2.6.27 from Linus Torvalds' tree:
git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
# Go into the freshly made clone of Linus's tree
cd linux-2.6
# Create a new branch called ext4dev and base it off of v2.6.27
git branch ext4dev v2.6.27
git checkout ext4dev
# Now pull down all of the changes to ext4 since 2.6.27
git pull git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git ext4-stable


Now the easist way to apply the ext4 patch queue is to use a program
called "guilt".  (You can also use the patch management program called
"quilt", which is the original).    You can get "guilt" from this repository:

	 git://git.kernel.org/pub/scm/linux/kernel/git/jsipek/guilt.git

If you have guilt, then the easist way to apply the ext4 patch queue
is as follows:

# Assuming that we are starting from above script, where ext4dev is our
# current git branch where we want to do our ext4 development
#
# Create the directory used by guilt and populate it with the ext4 patch queue:
#
mkdir -p .git/patches
pushd .git/patches
git clone http://repo.or.cz/r/ext4-patch-queue.git ext4dev
cp /dev/null ext4dev/status
popd
# Now push all of the patches on the ext4 patch queue:
guilt push -a


Alternatively, currently, as of this writing the ext4 patch queue is
based off of 2.6.27-git5.  So if you want to go *really* bleeding
edge, you can build a copy versus Linus's tip of tree.  That would
look something like this

# Get 2.6.27 from Linus Torvalds' tree:
git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
# Go into the freshly made clone of Linus's tree
cd linux-2.6
# Determine the git ID for 2.6.27-git5
wget ftp://ftp.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.27-git5.id
git tag v2.6.27-git5 `cat patch-2.6.27-git5.id`
rm patch-2.6.27-git5.id
# Now create a new branch called ext4dev based off of 2.6.27-git5
# and check it out
git branch ext4dev v2.6.27-git5
git checkout ext4dev

(and then continue with the above sequence to pull down and apply the
ext4 patch queue).  The difference between using 2.6.27-git5 and
2.6.27 plus the ext4-stable branch is everyone *else's* changes since
the opening of the 2.6.28 merge window.

If you want to see what the patch queue is based off of, take a look
at the first line of the series file.  That currently reads:

# BASE 2.6.27-git5

which is your hint that you need at least 2.6.27-git5.  That will
change over time, as we push more patches to Linus.  The reason why
things are a bit confusing at the moment is you're starting out during
the highly volatile time between 2.6.27 and 2.6.28-rc1, aka the 2.6.28
merge window.  This is when everyone merges the important fixes to
Linus's git tree.  Given that the ext4-patch-queue is primarily meant
for ext4 developers, this is one of the harder times to try to start
playing with the ext4 patch queue.  (Although no doubt the most
instructive :-)

Hope this helps,

							- Ted
