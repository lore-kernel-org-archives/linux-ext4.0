From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] vfs: avoid hang caused by attempting to rmdir an
 invalid file system
Date: Tue, 29 May 2012 21:50:19 +0200
Message-ID: <20120529195019.GE23991@quack.suse.cz>
References: <1338226422-8845-1-git-send-email-tytso@mit.edu>
 <4790434C-0DF2-4186-BE4C-CE97633F107C@dilger.ca>
 <20120528210511.GA5610@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@ZenIV.linux.org.uk, sami.liedes@iki.fi
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41613 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581Ab2E2TuX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 May 2012 15:50:23 -0400
Content-Disposition: inline
In-Reply-To: <20120528210511.GA5610@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 28-05-12 17:05:11, Ted Tso wrote:
> On Mon, May 28, 2012 at 02:29:05PM -0600, Andreas Dilger wrote:
> > This patch is good from the POV of covering all filesystems, and
> > avoiding the deadlock at the dcache level.  It would be possible to
> > detect this problem in the filesystem itself during lookup, before
> > the bad link got into the dcache itself.  Something like:
> 
> I like that as a solution for detecting the problem in ext4.  As you
> say, it's still an issue for other file systems, and so the patch I
> proposed is still probably a good idea for the VFS.  But this way ext4
> (and ext3 when Jan backports it) will be able to detect the problem
> and mark the file system as being corrupted.
  Actually, I think there's even better way. d_splice_alias() can rather
easily detect the problem and report it to filesystem. The advantage is
that the check in d_splice_alias() can catch any "hardlinks" to
directories, not just self loops. The patch is attached, I also have
corresponding handling written for ext? filesystems but that's trivial.
I'll post the whole series to Al to have a look.

								Honza

