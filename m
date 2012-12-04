From: Darren Hart <dvhart@infradead.org>
Subject: Re: [e2fsprogs] initdir: Writing inode after the initial write?
Date: Tue, 04 Dec 2012 11:40:47 -0800
Message-ID: <50BE51BF.6020208@infradead.org>
References: <50B967E2.7090703@infradead.org> <92FEB3B3-D4EA-4E84-83F2-F9946D7BCE3B@dilger.ca> <50B990CB.3080607@infradead.org> <85A86E8F-EEB9-495C-AB10-EF3C871EE2B9@dilger.ca> <50BD017F.1070400@infradead.org> <E9A4182B-CEE4-419A-AE6B-F7133766ABC3@gmail.com> <50BE3639.7090704@infradead.org> <20121204190829.GA7790@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <aedilger@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:35928 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab2LDTks (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Dec 2012 14:40:48 -0500
In-Reply-To: <20121204190829.GA7790@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 12/04/2012 11:08 AM, Theodore Ts'o wrote:
> On Tue, Dec 04, 2012 at 09:43:21AM -0800, Darren Hart wrote:
>>> "modify_inode" is not a terribly easy use interface. Probably better to add something like "chmod" and "chown" for debugfs as well.
>>
>> I was thinking the same thing.
>>
>
> modify_inode is the old command, and it is indeed hard to use.  The
> new one (and the one I use all the time) is set_inode_field
> (abbreviation "sif"):
>
>     sif /bin/su mode 0104755
>     sif /bin/su uid 0


Ah, excellent.


> BTW, one of the things that I've always toyed with was to create a
> shim layer between the libss API and the tcl embedding API, which
> would add some scripting, aliases, and automation relatively easily to
> debugfs.
>
> What people have done in practice who have cared about this is to
> create perl scripts which emits a series of commands which they then
> feed to a pipe which has debugfs on the other end.

And this is what Andreas suggested with the example bash script. I may
convert
this to a python script, but the concept is sound. That said, I still
feel that
a logical approach would be the following:

1) Update debugfs to completely support our use-case
   [ ] Add symlink support
   [ ] Add hardlink support
   [ ] Add meta-data mirroring
   (some of this belongs in the script and not in the ext2fsprogs)
2) Refactor filesystem creation functions from debugfs and move them into
   libext2fs alongside existing filesystem creation functions like
   ext2fs_mkdir()
3) Add the "-r initialdir" option to mke2fs that leverages these new
functions
   from libext2fs.

#3 makes for a more consistent filesystem creation process across
filesystems.

Does this seem like a reasonable approach? Any objection to the migration of
code into libext2fs?

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
