From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH][e2fsprogs] Allow user to disable Undo manager through
	MKE2FS_SCRATCH_DIR
Date: Mon, 7 Apr 2008 00:20:21 -0400
Message-ID: <20080407042021.GA29983@mit.edu>
References: <20080404140235.28080.97243.stgit@gara.konoha.net> <20080406221947.GA13284@mit.edu> <47F97C87.3060603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Jose R. Santos" <jrs@us.ibm.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:42735 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750831AbYDGEUv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Apr 2008 00:20:51 -0400
Content-Disposition: inline
In-Reply-To: <47F97C87.3060603@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 06, 2008 at 08:44:39PM -0500, Eric Sandeen wrote:
> Theodore Tso wrote:
> 
> > (This will be merged into the patch "e2fsprogs: Make mke2fs use undo
> > I/O manager" before the whole branch gets integrated into the next or
> > master branches, using the magic that is git rebase --interactive.
> > Also needing fixing is the code to hook into the profile lookup.)
> 
> What is the rationale for turning mke2fs into a nanny for
> administrators, anyway?  Maybe to complete the transformation we should
> just make it a gtk application with a windows-like "Are you sure? [Yes]
> [No]" alert dialog box that pops up?
> 
> Seriously, what does this gain us, other than a slowdown of an
> already-slow mkfs?  I'm sure there are stories of people who mkfs'd the
> wrong device but there are a million sad stories out there; rm -rf /, dd
> if=/dev/null of=/dev/sda, fdisk the wrong device, you name it.  We can't
> save them all.  :)

The plan is to only enable it for uninit_groups, once uninit_groups
actually really does what the name implies (i.e., actually not
initialize the inode tables).  Unfortunately uninit_groups still needs
some fix-up work.  (As does flex_bg.)  That's one of the reasons why
I've been holding off on merging the undo manager at all.

So the idea is that we can make a reversible mke2fs in such a way that
it's way cheaper than it currently is today.  Sure, there are many
tales of woe out there, but we have made things a bit harder to
prevent users from accidentally running mke2fs on half of an MD
device, by adding the exclusive open feature in the kernel.

The fact that its defaults are bested right now is a problem, and
maybe I'll just fix it up so that for now, the MKE2FS_SCRATCH_DIR
environment variable must be set for it to save the undo file.

> The notion of an (optional) undo IO manager is fine in general, I like
> the idea that if I have dicey fsck to do I can in theory recover from it
> if it goes badly, though even there I'd personally rather not have it on
> by default...  (how do I turn it off for fsck?)  But mkfs, by default -
> really?  I don't much like it, and on my boxes I'd like a way to
> permanently turn it off, regardless of whether I'm testing or not...
> Sure I could put it in my .bashrc or whatnot, but really, what does this
> gain us?

Ultimately, a line in mke2fs.conf would also turn it off, but again,
there's a reason why the patch series has *not* been merged into the
"next" or "master" branch.  It still has a bunch of rough spots that
certainly does make it very annoying in its current state ---
completely granted.

						- Ted
