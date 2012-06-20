From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] vfs: avoid hang caused by attempting to rmdir an
 invalid file system
Date: Wed, 20 Jun 2012 11:57:03 +0200
Message-ID: <20120620095703.GB3435@quack.suse.cz>
References: <1338226422-8845-1-git-send-email-tytso@mit.edu>
 <4790434C-0DF2-4186-BE4C-CE97633F107C@dilger.ca>
 <20120528210511.GA5610@thunk.org>
 <20120529195019.GE23991@quack.suse.cz>
 <20120529200856.GF23991@quack.suse.cz>
 <20120530173709.GB16317@fieldses.org>
 <20120530201256.GA32477@quack.suse.cz>
 <20120618211930.GB12929@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>,
	linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@ZenIV.linux.org.uk, sami.liedes@iki.fi
To: "J. Bruce Fields" <bfields@fieldses.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60997 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab2FTJ5G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Jun 2012 05:57:06 -0400
Content-Disposition: inline
In-Reply-To: <20120618211930.GB12929@fieldses.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 18-06-12 17:19:30, J. Bruce Fields wrote:
> On Wed, May 30, 2012 at 10:12:57PM +0200, Jan Kara wrote:
> > On Wed 30-05-12 13:37:09, J. Bruce Fields wrote:
> > > On Tue, May 29, 2012 at 10:08:56PM +0200, Jan Kara wrote:
> > > > On Tue 29-05-12 21:50:19, Jan Kara wrote:
> > > > > On Mon 28-05-12 17:05:11, Ted Tso wrote:
> > > > > > On Mon, May 28, 2012 at 02:29:05PM -0600, Andreas Dilger wrote:
> > > > > > > This patch is good from the POV of covering all filesystems, and
> > > > > > > avoiding the deadlock at the dcache level.  It would be possible to
> > > > > > > detect this problem in the filesystem itself during lookup, before
> > > > > > > the bad link got into the dcache itself.  Something like:
> > > > > > 
> > > > > > I like that as a solution for detecting the problem in ext4.  As you
> > > > > > say, it's still an issue for other file systems, and so the patch I
> > > > > > proposed is still probably a good idea for the VFS.  But this way ext4
> > > > > > (and ext3 when Jan backports it) will be able to detect the problem
> > > > > > and mark the file system as being corrupted.
> > > > >   Actually, I think there's even better way. d_splice_alias() can rather
> > > > > easily detect the problem and report it to filesystem. The advantage is
> > > > > that the check in d_splice_alias() can catch any "hardlinks" to
> > > > > directories, not just self loops. The patch is attached, I also have
> > > > > corresponding handling written for ext? filesystems but that's trivial.
> > > > > I'll post the whole series to Al to have a look.
> > > >   And now with the attachment. Sorry.
> > > 
> > > Well, my understanding of d_splice_alias is that it should just return
> > > the existing dentry instead of failing.  (It does that now for
> > > DISCONNECTED dentries, but I don't understand why they're special.)
> > > So that's what:
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/viro/vfs.git;a=commit;h=9d345b3217b384813680901d42eae3fb380b9f77
> > > 
> > > does.
> >   Thanks for the pointer. In the case I tried to solve, returning the
> > existing dentry will solve the deadlocks, just user won't be warned that
> > the filesystem is corrupted. Since you seem to describe a valid case where
> > we can spot other !DISCONNECTED dentry of a directory, I guess we have no
> > other choice than using your approach.
> 
> But my patch got reverted, on suspicion that it was either wrong or
> covering up some other problem:
> 
> 	http://marc.info/?l=linux-fsdevel&m=133917767003505&w=2
> 
> ... which an approach like yours might help at least find?  So maybe
> it's worth another try.
  Yeah, I'll rebase and resubmit those patches (plus fixup error handling
as Al suggested) today or tomorrow.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
