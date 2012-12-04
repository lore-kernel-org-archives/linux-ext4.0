From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: help about ext3 read-only issue on ext3(2.6.16.30)
Date: Tue, 4 Dec 2012 15:20:44 -0500
Message-ID: <20121204202044.GE7790@thunk.org>
References: <CALOAHbDC8jguV7GeSuN01UWBk+74wVHho8Fe9HLan06FZSpw0g@mail.gmail.com>
 <50BCE885.8010609@redhat.com>
 <50BE007D.5080504@huawei.com>
 <50BE16EC.6060501@tao.ma>
 <50BE20B9.1050404@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tm@tao.ma>, Li Zefan <lizefan@huawei.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Yafang Shao <laoar.shao@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	wuqixuan@huawei.com, wuqixuan@gmail.com
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36782 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab2LDUUz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Dec 2012 15:20:55 -0500
Content-Disposition: inline
In-Reply-To: <50BE20B9.1050404@itwm.fraunhofer.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 04, 2012 at 05:11:37PM +0100, Bernd Schubert wrote:
> I still don't know if it is related to htree only, but e2fsck isn't
> properly fixing directory issues without the "-D" option.
> For example I have a VM here, where the kernel frequently reports
> something like:
> 
> > [  304.096059] EXT4-fs (vdb): error count: 4
> > [  304.096305] EXT4-fs (vdb): initial error at 1352366631: htree_dirblock_to_tree:861: inode 3146582: block 1641814
> > [  304.096857] EXT4-fs (vdb): last error at 1352381914: empty_dir:2334: inode 3146582: block 1641814
> > [86807.520052] EXT4-fs (vdb): error count: 4
> 
> and e2fsck does not report anything.

This is not an error; this is pointing out that there previously *was*
an error, with the first file system error happening at:

% date --date "@1352366631"
Thu Nov  8 04:23:51 EST 2012

and the most recent file system error happening at:

% date --date "@1352381914"
Thu Nov  8 08:38:34 EST 2012

(your results may differ depending on your local time zone :-)

Newer versions of e2fsck clear this information from the superblock
after the file system is successfully fixed.  You upgraded your kernel
without also updating e2fsprogs, and the newer kernels will print this
message approximately once a day so that users who have their file
systems set up to use errors=continue, that they get some warning that
their file system has been corrupted, even if their log files have
been rotated away.

It's also useful when trying to debug user problems where they are
convinced it is an ext4 bug, but in fact it's because they've buggered
their init scripts not to run fsck, or they are using an external USB
disk with ext4 and aren't bothering to check it with e2fsck after an
error was reported, etc.  We can now see that the file system had been
first corrupted $N weeks/months ago, and it isn't a file system
regression worthy of linkbait scares articles on some random website...


In any case, that's why you're seeing it.  It's really not a problem,
only a cosmetic issue, which can be easily fixed by upgrading
e2fsprogs.

> Also the dir_entry_type is for some
> dirs wrongly reported by the kernel, but seen correctly by e2fsck
> (https://bugzilla.kernel.org/show_bug.cgi?id=50261).

I've looked at your bug report, and it seems pretty clear that it's
correct on disk.  I'm not sure what might be going on, but this
doesn't look like an e2fsck problem, but either a problem in glibc,
the vfs kernel code or the ext4 kernel code.

If you re-run your program, is it consistent which directories
apparently have the wrong d_type information returned for them?

> I hope to find some time to investigate that next week. I have seen it
> several times already, but never had the chance to investigate or to
> take an image.
> 
> So I would really recommend to run "e2fsck -D" for the issue reported here.

Did e2fsck -D really change what you saw?  That will rewrite all of
the directories as part of optimizing them all, but it certainly won't
fix the error count/first error/last error series of informational
messages.  For that you just need to get a newer version of e2fsck.

Regards,

	   	    	  	 	     - Ted
