From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [E2FSPROGS, RFC] New mke2fs types parsing
Date: Wed, 20 Feb 2008 17:20:19 -0500
Message-ID: <20080220222019.GG30305@mit.edu>
References: <E1JRpaN-0000Bs-4N@closure.thunk.org> <47BC76A9.307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:42026 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753617AbYBTWVM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Feb 2008 17:21:12 -0500
Content-Disposition: inline
In-Reply-To: <47BC76A9.307@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 20, 2008 at 12:51:21PM -0600, Eric Sandeen wrote:
> Theodore Ts'o wrote:
> > The following patch is a work in progress, but I'm sending it out so
> > folks can take a look at it and comment on the general approach.
> > 
> > What this does is change how mke2fs -T works so it can take a comma
> > separated list, so you can do things like this:
> > 
> > 	  mke2fs -T ext4,small,news
> 
> Is there some hierarchy of what these options are and how they fit
> together?  i.e. small & news might go together (in bizarro world...) but
> "small,large" wouldn't make sense - nor would -T ext3,ext4.  Or, if
> somebody stores mail & news on the same fs, nad they say -T mail,news
> but the mail & news types have conflicting directives...
> 
> how will you define what an acceptable composite of subtypes will be?

There are only three things which mke2fs will do, in my design:

#1) If the first type is not one of "ext2", "ext3", "ext4", or
"ext4dev", mke2fs will determine a suitable default based on either
argv[0] if it is of the form mke2fs.*, or via defaults.fs_type in
/etc/mke2fs.conf.  If neither of these is available it will default to "ext2".

#2) If the second type is not one of "small", "floppy" or "default",
mke2fs will create a default type by checking the size of the
to-be-created filesystem.  If it is less than 3mb, it is "floppy", if
it is less than 512mb, it is "small", otherwise it is default.

#3) Once it has the list of types, i.e., "ext3,defaults,squid", or
"ext2,floppy,rescue", "ext4,defaults,largefile", etc. it uses this as
a search path when mke2fs needs to look up some parameter, such as
"base_features", or "inode_size", etc.  

So suppose we are looking up the inode_size and the fs_types list is
"ext3,defaults,squid".  The possible places where the inode_size
parameter cna be found are: defaults.inode_size,
fs_types.ext3.inode_size, fs_types.defaults.inode_size,
fs_types.squid.inode_size.  Mke2fs will look in the most specific
place (fs_types.squid.inode_size), and then successively more general,
all the way up to defaults.inode_size for the inode_size parameter in
/etc/mke2fs.conf.

(Oh, looks like I got things backwards for the string lookups; oops,
I'll fix that.)

So the basic idea is that it's as free form as possible, and it's all
based on defaults getting overridden in the config file.  So if the
mke2fs.conf file has something like this:

[defaults]
	base_features = sparse_super,filetype,resize_inode,dir_index,ext_attr
	blocksize = 4096
	inode_size = 256
	inode_ratio = 16384

[fs_types]
	ext3 = {
		features = has_journal
	}
	ext4 = {
		features = extents,flex_bg
		inode_size = 256
	}
	small = {
		blocksize = 1024
		inode_size = 128
		inode_ratio = 4096
	}
	news = {
		inode_ratio = 4096
	}

And the user runs the command:  /sbin/mkfs.ext4 -T news /dev/hda5

(and let's assume for the same of argument that /dev/hda5 is 400
megabytes)

Then mke2fs will expand the fs_types field to be "ext4,small,news".
The user could have specified this explicitly as an argument to the -T
option, but 99% of the time, they won't.

So that means that when we look for the inode_ratio parameter, it will
come form fs_types.news.inode_ratio, and mke2fs will use the value
4096.  For the inode_size, the most specific version will be
fs_types.small.inode_size, or 128.   

In terms of handling features, things are a bit more complicated.  The
design is that we use base_features (first looked in [defaults],
[fs_types].ext4, et. al) to determine the base set of features to
initialize feature set flags.  Next, we look for fs_types.ext4.features, 
fs_types.small.features, fs_types.news.features, and if any of them
exist, they are used to modify the feature set.   Just as with tune2fs, 
the ^ character can be used to turn off a feature.  Finally, the argument 
to -O is used to further modify the feature set.

This are a little bit complicated because I wanted to preserve
backwards compatibility with the existing mke2fs.conf semantics, while
still making it possible to incrementally override portions of the
mke2fs configuration parameters in the simplest but yet most powerful
way possible.

In practice, I suspect most poeple will just say:

   mke2fs -T ext4 /dev/hda5

or
   mkfs.ext4 /dev/hda5

or

   mkfs.ext4 -T news /dev/hda5

Some people might also do:

   mke2fs -T ext4,news /dev/hda5

I doubt many people will do something as complicated as:

   mke2fs -T ext4,largefiles,squid,extra-resize-space /dev/hda5

and have a complicated mke2fs.conf file site on their system --- but
if they really want to do that, they can.

I could also imageine people using this to make it easier to create
different kinds of filesystems for creating test cases or benchmarks, so
/etc/mke2fs.conf could contain things like 

[fs_types]
	benchmark_tpc_h = {
		raid_stride = 31
		raid_stripe_width = 65536
		blocksize = 65536
	}
	benchmark_specweb = {
		inode_size = 256
		inode_ratio = 16384
		blocksize = 4096
	}

(Yes, this assumes adding more parameters that can be configured via
mke2fs.conf getting added into mke2fs, but that's part of the point of
this system.  We shouldn't be forcing people into needing to type very
long mke2fs command lines if there are ways we can make things more
convenient for them.)

					- Ted
