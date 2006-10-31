From: Nikolai Joukov <kolya@cs.sunysb.edu>
Subject: Re: Shred mount option for ext4?
Date: Tue, 31 Oct 2006 15:14:48 -0500 (EST)
Message-ID: <Pine.GSO.4.53.0610311444550.4220@compserv1>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sbcs.cs.sunysb.edu ([130.245.1.15]:36762 "EHLO
	sbcs.cs.sunysb.edu") by vger.kernel.org with ESMTP id S1423846AbWJaUQA
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Oct 2006 15:16:00 -0500
To: Erik Mouw <erik@harddisk-recovery.com>,
	Samuel Tardieu <sam@rfc1149.net>, linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

It is a surprizing coincidence that Erik posted this request today.  We
also discussed possible ext4 patches for secure deletion yesterday at
StorageSS workshop (www.storagess.org).

> Why don't you just make a libc wrapper for the unlink(2) system call?
> (A modified libc.so should do as well). That way it will work for all
> of your applications on all filesystems.

This won't intercept unlink and truncate requests from statically linked
binaries that you need to intercept.  Users will not trust a solution that
only works in some cases.

> In practice a single overwrite is enough because of the sheer size of
> the task to reproduce the overwritten data.

Agreed.  There is not even a single commercial company that can
recover overwritten data (e.g., see the Action Front (www.actionfront.com)
survey).  It is obvious that data recovery companies tried it and
all failed.  However, some users will believe that governmental labs can
recover overwritten data no matter what you say.  Therefore, there
is a need for two solutions: 1) overwrite the data once and make
it impossible to recover using software tools and all commercially
available methods 2) perform N overwrites for these who want it.

> > Some people (me included) would most likely accept the time penalty of
> > using this option on selected filesystems (as well as the reduced
> > lifetime of the disks because of the extra writes).

We have posted a simple ext3 patch that does one-time overwriting back in
February (http://lwn.net/Articles/171924/).  Valerie Henson made an
interesting point yesterday at StorageSS that we may also need to
overwrite the journal.  Even though the journal gets overwritten quickly
some users will want it to be overwritten for sure.

We plan to post two more patches for secure deletion in ext4 soon.
(Well, as for most of us, it is a side project and the development was not
pretty rapid but now we really plan to release these patches.)  They
already work but still require some polishing:

1. One of the patches performs N overwrites with configurable patterns
(can comply with NIST and NISPOM standards).  Because of the transaction
compaction we had to separately add overwriting as separate transactions.
Fortunately, the whole procedure is still atomic due to the orphan list.
The problem that we have right now is per-file syncing of dirty data
buffers between overwrites.  We sync the whole device at the moment.

2. Another compromise solution is to combine secure deletion with the
trash-bin support (which is requested by even more people :-).  Moving
files on unlink to a special directory is trivial.  Later (e.g., when the
system is idle) a user-mode daemon can just scan this directory,
overwrite, and unlink the files.  For big files it can actually improve
performance.  Also, as Ted T'so suggested for the possible trash bin
patch long ago it may be necessary to add a mechanism for the file system
to initiate the user-mode deletion once the space becomes scarce.  The
benefits of this approach are obvious: 1) small kernel bloat, 2) two
solutions (trash bin and secure deletion) in one, and 3) user-mode part
can be complicated and do overwriting with many patterns, many times, and
at configurable times.  Our current patch makes moved files visible and
accessible by root only.  For a user-friendly trash-bin implementation we
will make files in trash-bin visible for their users.  It will require
readdir and/or lookup changes.

For these who are interested, the preliminary patches are downloadable
from http://www.filesystems.org/project-sdfs.html
We will really appreciate any comments, help, and feedback.

Thank you,
Nikolai Joukov and Harry Papaxenopoulos.
Filesystems and Storage Laboratory,
Stony Brook University
