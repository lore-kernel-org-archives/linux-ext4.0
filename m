From: Ted Ts'o <tytso@mit.edu>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Sun, 18 Mar 2012 16:56:58 -0400
Message-ID: <20120318205658.GB31682@thunk.org>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
 <alpine.LFD.2.00.1203091158430.4487@dhcp-27-109.brq.redhat.com>
 <BCAD47C1-B95A-4EDB-8EFB-3D4E325DE57D@whamcloud.com>
 <20120310044804.GB5652@thunk.org>
 <9709DE62-CE25-41C4-A33C-63336B51DC5E@whamcloud.com>
 <20120311161320.GC1048@thunk.org>
 <CADDYkjRSd-Dv2jECwKt=3Q95hceVhiA+StZj1fvwywZHWaEgfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@whamcloud.com>,
	Lukas Czerner <lczerner@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Jacek Luczak <difrost.kernel@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44842 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471Ab2CRU47 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Mar 2012 16:56:59 -0400
Content-Disposition: inline
In-Reply-To: <CADDYkjRSd-Dv2jECwKt=3Q95hceVhiA+StZj1fvwywZHWaEgfw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 15, 2012 at 11:42:24AM +0100, Jacek Luczak wrote:
> 
> That was not a SVN server. It was a build host having checkouts of SVN
> projects.
> 
> The many files/dirs case is common for VCS and the SVN is not the only
> that would be affected here. 

Well, with SVN it's 2x or 3x the number of files in the checked out
source code directory, right?  So if a particular source tree has
2,000 files in a source directory, then SVN might have at most 6,000
files, and if you assume each directory entry is 64 bytes, we're still
talking about 375k.  Do you have more files than that in a directory
in practice with SVN?  And if so why?

> AFAIR git.kernel.org was also suffering from the getdents().

git.kernel.org was suffering from a different problem, which was that
the git.kernel.org administrators didn't feel like automatically doing
a "git gc" on all of the repositories, and a lot of people were just
doing "git pushes" and not bothering to gc their repositories.  Since
git.kernel.org users don't have shell access any more, the
git.kernel.org administrators have to be doing automatic git gc's.  By
default git is supposed to automatically do a gc when there are more
than 6700 loose object files (which are distributed across 256 1st
level directories, so in practice a .git/objects/XX directory
shouldn't have more than 30 objects in it, which each directory object
taking 48 bytes).  The problem I believe is that "git push" commands
weren't checking gc.auto limit, and so that's why git.kernel.org had
in the past suffered from large directories.  This is arguably a git
bug, though, and as I mentioned, since we all don't have shell access
to git.kernel.org, this has to be handled automatically now....

> Same applies to commercial products that are
> heavily stuffed with many files/dirs, e.g. ClearCase or Synergy. 

How many files in a dircectory do we commonly see with these systems?
I'm not familiar with them, and so I don't have a good feel for what
typical directory sizes tend to be.

> A medium size you are referring would most probably fit into 256k and
> this could be enough for 90% of cases. Large production system running
> on ext4 need backups thus those would benefit the most here.

Yeah, 256k or 512k is probably the best.  Alternatively, the backup
programs could simply be taught to sort the directory entries by inode
number, and if that's not enough, to grab the initial block numbers
using FIEMAP and then sort by block number.  Of course, all of this
optimization may or may not actually give us as much returns as we
think, given that the disk is probably seeking from other workloads
happening in parallel anyway (another reason why I am suspicious that
timing the tar command may not be an accurate way of measuring actual
performance when you have other tasks accessing the file system in
parallel with the backup).

    	    	  		     	      - Ted
