From: Darren Hart <dvhart@infradead.org>
Subject: Re: [e2fsprogs] initdir: Writing inode after the initial write?
Date: Tue, 04 Dec 2012 12:10:32 -0800
Message-ID: <50BE58B8.6020909@infradead.org>
References: <50B967E2.7090703@infradead.org> <92FEB3B3-D4EA-4E84-83F2-F9946D7BCE3B@dilger.ca> <50B990CB.3080607@infradead.org> <85A86E8F-EEB9-495C-AB10-EF3C871EE2B9@dilger.ca> <50BD017F.1070400@infradead.org> <E9A4182B-CEE4-419A-AE6B-F7133766ABC3@gmail.com> <50BE3639.7090704@infradead.org> <20121204190829.GA7790@thunk.org> <50BE51BF.6020208@infradead.org> <20121204200013.GD7790@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <aedilger@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32320 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731Ab2LDUKd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Dec 2012 15:10:33 -0500
In-Reply-To: <20121204200013.GD7790@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 12/04/2012 12:00 PM, Theodore Ts'o wrote:
> On Tue, Dec 04, 2012 at 11:40:47AM -0800, Darren Hart wrote:
>>
>> 1) Update debugfs to completely support our use-case
>>    [ ] Add symlink support
>>    [ ] Add hardlink support
> 
> This exists already.  See the "link" command.  It doesn't update the
> inode i_links_count, but that's probably something I would add by
> adding an option (-i) which did this.

Right, this seems like it will need to be managed at a higher level (the
script for the debugfs appraoch).

> 
>>    [ ] Add meta-data mirroring
> 
> Not sure what what you mean by meta-data mirroring?


Sorry, just uid, gid, permissions... basically the inode. This could be
done by updating the script to use the sif command, but having a -i or
similar option to "write" (or maybe a new "copy" which did effectively
the same thing) by reading stat and copying the data across would be a
nice abstraction.


>> 2) Refactor filesystem creation functions from debugfs and move them into
>>    libext2fs alongside existing filesystem creation functions like
>>    ext2fs_mkdir()
> 
> I'm not sure that creating new libext2fs functions is necessarily
> needed.  We'll need to discuss that on a case-by-case basis.  For
> creating a new symlink, sure, I'll buy that --- there's enough
> complexity involved that it makes sense to move that into the library.
> 
> For creating a new hard link, we already have ext2fs_link().  Whether
> or not it makes sense to add an entirely new function just to bump
> i_links_count seems very dubious to me.  We could add a flag which
> reads in the target inode, bumps i_links_count, and then writes it
> back out, but then we start asking whether or not we need to add an
> option to set the ctime field or not, etc., etc., etc.


Agreed on the hard link. However, things like mknod and write from
debugfs seem like good candidates to be moved into libext2fs, then
other tools can make use of the code.


> Taken to extremes that way lies the insanity of VMS's create_process
> system call, with its huge number of parameters and options, as
> opposed to separating fork() and exec(), and allowing the application
> program to close file descriptors dup them, edit environment
> variables, etc., between the fork() and exec(), which was a much saner
> way of doing things in Unix.
> 
> So it's actually quite deliberate that what we have are very low-level
> primitives in libext2fs.  That being said, API design is a bit of an
> art, as I said, for something as complicated as symlink creation,
> where you need to do different things depending on whether the symlink
> pathname can fit in the inode, etc., it does make sense to have a new
> function.
> 
>> 3) Add the "-r initialdir" option to mke2fs that leverages these new
>> functions
>>    from libext2fs.
> 
> Assuming the code for -r can be well constrained in terms of cleanly
> added to the mke2fs sources (probably the bulk of the code should go
> in a new .c file), and assuming that it doesn't bloat the mke2fs
> binary too badly, I have no objections to adding the -r option to
> mke2fs.  (Worst case we can have a --disable-mke2fs-init-dir if there
> are still people worried about making mke2fs fit on a boot/root 1.44M
> floppy.  :-)
> 
> That being said, if it bloats mke2fs too badly (for example, because
> you tried using libxml2 for some kind of control file to specify the
> character/block devices, and it dragged in megabytes and megabytes of
> compiled object code, I'd certainly object, both because of the
> addition of the external dependency, and because at that point people
> really would complain --- and of course, because XML is just
> horrible.  :-)


Indeed! I understand the requirement and will keep a close eye on
dependencies and compiled size. I will include these numbers in any
patches that result from this.

So far the dependencies are minimal and I'll work to keep them that way.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
