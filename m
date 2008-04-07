From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH][e2fsprogs] Allow user to disable Undo manager through
 MKE2FS_SCRATCH_DIR
Date: Sun, 06 Apr 2008 20:44:39 -0500
Message-ID: <47F97C87.3060603@redhat.com>
References: <20080404140235.28080.97243.stgit@gara.konoha.net> <20080406221947.GA13284@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Jose R. Santos" <jrs@us.ibm.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbYDGBxP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Apr 2008 21:53:15 -0400
In-Reply-To: <20080406221947.GA13284@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:

> (This will be merged into the patch "e2fsprogs: Make mke2fs use undo
> I/O manager" before the whole branch gets integrated into the next or
> master branches, using the magic that is git rebase --interactive.
> Also needing fixing is the code to hook into the profile lookup.)

What is the rationale for turning mke2fs into a nanny for
administrators, anyway?  Maybe to complete the transformation we should
just make it a gtk application with a windows-like "Are you sure? [Yes]
[No]" alert dialog box that pops up?

Seriously, what does this gain us, other than a slowdown of an
already-slow mkfs?  I'm sure there are stories of people who mkfs'd the
wrong device but there are a million sad stories out there; rm -rf /, dd
if=/dev/null of=/dev/sda, fdisk the wrong device, you name it.  We can't
save them all.  :)

The notion of an (optional) undo IO manager is fine in general, I like
the idea that if I have dicey fsck to do I can in theory recover from it
if it goes badly, though even there I'd personally rather not have it on
by default...  (how do I turn it off for fsck?)  But mkfs, by default -
really?  I don't much like it, and on my boxes I'd like a way to
permanently turn it off, regardless of whether I'm testing or not...
Sure I could put it in my .bashrc or whatnot, but really, what does this
gain us?

-Eric
