From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 13/35] fallthru: ext2 fallthru support
Date: Wed, 21 Apr 2010 10:22:35 +0100
Message-ID: <20100421092235.GB13114@shareable.org>
References: <1271372682-21225-14-git-send-email-vaurora@redhat.com> <20100419124025.GG10776@bolzano.suse.de> <1271682168.14748.718.camel@macbook.infradead.org> <20100419132344.GI10776@bolzano.suse.de> <20100419133028.GA3631@shareable.org> <20100419141248.GK10776@bolzano.suse.de> <20100419142315.GA2688@shell> <E1O3sLi-0008EA-QW@pomaz-ex.szeredi.hu> <20100420213450.GM11723@shareable.org> <20100421084211.GB22741@bolzano.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Valerie Aurora <vaurora@redhat.com>, dwmw2@infradead.org,
	viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Jan Blunck <jblunck@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:57003 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab0DUJWw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Apr 2010 05:22:52 -0400
Content-Disposition: inline
In-Reply-To: <20100421084211.GB22741@bolzano.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Blunck wrote:
> On Tue, Apr 20, Jamie Lokier wrote:
> 
> > Miklos Szeredi wrote:
> > > On Mon, 19 Apr 2010, Valerie Aurora wrote:
> > > > I don't recall there being any technical reason not to look up the
> > > > real inode number.  I just wrote it that we because I was lazy.  So I
> > > > like returning the directory's d_ino better than a single magic
> > > > number, but I'd at least like to try returning the real inode number
> > > > too.
> > > 
> > > Note, "struct dirent" doesn't have d_dev, so you really can't return
> > > the "real" inode number, that's on a different filesystem and just a
> > > random number in the context of the the readdir in question.
> > 
> > Agree.  Does this inappropriate inode number for the union mount's
> > st_dev happen with stat() on the actual files too?  That could be bad.
> 
> No, for stat() you do a lookup and that is returning the correct
> dentry/inode for the filesystem the name is on.

Hmm.  I smell potential confusion for some otherwise POSIX-friendly
userspaces.

When I open /path/to/foo, call fstat (st_dev=2, st_ino=5678), and then
keep the file open, then later do a readdir which includes foo
(dir.st_dev=1, d_ino=1234), I'm going to immediately assume a rename
or unlink happened, close the file, abort streaming from it, refresh
the GUI windows, refresh application caches for that name entry, etc.

Because in the POSIX world I think open files have stable inode
numbers (as long as they are open), and I don't think that an open
file can have it's name's d_ino not match the inode number unless it's
a mount point, which my program would know about.

This plays into inotify, where you have to know if you are monitoring
every directory that contains a link to a file, to know if you need to
monitor the file itself directly instead.

Now I think it's fair enough that a union mount doesn't play all the
traditional rules :-)  C'est la vie.

This mismatch of (dir.st_dev,d_ino) and st_ino strongly resembles a
file-bind-mount.  Like bind mounts, it's quite annoying for programs
that like to assume they've seen all of a file's links when they've
seen i_nlink of them.

Bind mounts can be detected by looking in /proc/mounts.  st_dev
changing doesn't work because it can be a binding of the same
filesystem.

How would I go about detecting when a union mount's directory entry
has similar behaviour, without calling stat() on each entry?  Is it
just a matter of recognising a particular filesystem name in
/proc/mounts, or something more?

Thanks,
-- Jamie
