From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 37/37] ext5: define new subtype to add features and reduce
 testing complexity
Date: Tue, 6 May 2014 14:50:39 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405061339470.2255@localhost.localdomain>
References: <20140501231222.31890.82860.stgit@birch.djwong.org> <20140501231629.31890.34812.stgit@birch.djwong.org> <alpine.LFD.2.00.1405021133520.2154@localhost.localdomain> <20140506013317.GO8434@birch.djwong.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1319512602-1399376874=:2255"
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbaEFNZF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 May 2014 09:25:05 -0400
In-Reply-To: <20140506013317.GO8434@birch.djwong.org>
Content-ID: <alpine.LFD.2.00.1405061349390.2255@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1319512602-1399376874=:2255
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.2.00.1405061349391.2255@localhost.localdomain>

On Mon, 5 May 2014, Darrick J. Wong wrote:

> Date: Mon, 5 May 2014 18:33:17 -0700
> From: Darrick J. Wong <darrick.wong@oracle.com>
> To: Luká¨ Czerner <lczerner@redhat.com>
> Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
> Subject: Re: [PATCH 37/37] ext5: define new subtype to add features and reduce
>      testing complexity
> 
> On Fri, May 02, 2014 at 11:45:25AM +0200, Luká¨ Czerner wrote:
> > On Thu, 1 May 2014, Darrick J. Wong wrote:
> > 
> > > Date: Thu, 01 May 2014 16:16:29 -0700
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > To: tytso@mit.edu, darrick.wong@oracle.com
> > > Cc: linux-ext4@vger.kernel.org
> > > Subject: [PATCH 37/37] ext5: define new subtype to add features and reduce
> > >     testing complexity
> > > 
> > > This patch defines ext5 as a set of required feature flags and mount
> > > options, for the purpose of spreading new features to freshly
> > > formatted filesystems and reducing the testing matrix by disabling
> > > nearly all mount options.  The patch uses the s_minor_rev_level field
> > > to indicate the existence of ext5, and switch on feature/mount option
> > > enforcement in the kernel.
> > > 
> > > The required feature set is:
> > > ^resize_inode,dirindex,ext_attr,sparse_super2,filetype,meta_bg,extents,
> > > ^flex_bg,64bit,inline_data,sparse_super,huge_file,large_file,dir_nlink,
> > > extra_isize,metadata_csum
> > > 
> > > The required mount options are:
> > > acl,block_validity,user_xattr,journal_checksum
> > > 
> > > All other mount options are no longer functional.
> > > 
> > > The 'ext4' type remains unchanged, for people who require mount
> > > options or a different feature set.  I don't intend to fork any code;
> > > I'm just painting a bigger target (for testing).
> > 
> > This is definitely NACK by me. I do not like this and there are
> > several reasons why.
> > 
> > First of all the name. Given the history of ext file system we tend
> > to increase then number with the new version of file system. However
> > you're saying that this is just for testing features ... in that
> > case it does not make any sense to call it ext5, but not just that
> > it's stupid to call it ext5 especially since we might actually want
> > to release ext5 in the future and this would be really confusing for
> > everybody involved.
> 
> I should have been clearer about my aim for "ext5" -- I want to define
> ext5 to be "ext4 + some new features - some mount options", and then
> work on stabilizing those features.  Historically, we've defined each
> extN to be ext(N-1) + more features, and that's what I'm doing here
> too.  ext5 would be a real release, with new features and fewer mount
> options.  The comment about reducing testing was merely a reflection
> upon the side effects of locking down some of the feature flags and
> mount options.
> 
> I don't think it's a good idea to change what features you get with
> 'mke2fs -T ext4' since that hasn't changed since ~2008 or so.
> 
> Maybe I should have called it ext5dev and killed off ext4dev.
> 
> > I've been trying to get rid of the ext4dev bits and pieces
> > more-or-less successfully and you're adding new type once again. We
> > might start the discussion whether to revive ext4dev for this kind
> > of thing but I am not really convinced that this is the right way to
> > go either.
> > 
> > What about just simply using mkefs.conf to specify the feature set
> > we want and use that ? It's simple enough and it should work. We
> > could also extend the configuration to be able to set default
> > mount options and such if that's not possible. I just do not understand
> > why to introduce new file system type if that's just for testing
> > ext4 features.
> 
> Well, yes, I could just create a new fs_types stanza in mke2fs.conf.
> I wanted to put a little more teeth in that and actually have the
> kernel and e2fsck be able to check that a FS has been declared as
> 'ext5' and that all the required bits are really there, hence the
> ability to set s_minor_rev_level.  I'm not really married to going
> that far, though.
> 
> (There's already an interface for specifying some of the default mount
> options in the superblock; that was sufficient for me.)

"ext5 would be a real release"

This is the most important information that was somewhat hidden in
the original post. If that's the case we should have the discussion
whether we want to release ext5 in reasonably near future.


Let's see what are the difference between ext4 feature wise:

 + 64bit
 + meta_bg
 + sparse_super2
 + inline_data
 + metadata_csum
 - resize_inode

64bit - This is something I've proposed enabling by default for ext4
	already
	(http://www.spinics.net/lists/linux-ext4/msg42294.html) as
	this is a logical step and not really a huge change.
	This also implies disabling resize_inode.

meta_bg - Just makes group descriptors to be spread across the file
	system. It has been around for some time and I am not sure
	why this is not a default already. It should also increase
	the limit of the file system size but I am not sure whether
	this is still true with flex_bg ?
	This does not work together with resize_inode but that's
	true for 64bit as well. So I think that this should be
	default on ext4 or do we have any concerns about this one ?
	Not a big change anyway.

sparse_super2 -
	Limits the number of backup superblocks even more than
	sparse_super. This generally does not bring anything
	useful. It allows us to have more flexible layout for a
	specialized devices such as SMR. I do not thin there is a
	reason for this to be a default, but we can use it on those
	specialized devices which should be determined at mkfs time.
	On the other hand this is really small change to the format
	and I would not strongly object against this being the
	default, but it does not bring us anything on itself.

inline_data -
	I think that this is only really useful if we're using
	bigalloc feature, or if we have really big inodes, otherwise
	it does not bring anything useful. I do not think we want
	this as a default but rather having it enabled at mkfs time
	simultaneously with bigalloc and possibly with big inodes.

metadata_csum -
	That's the biggest feature, which is the most significant
	from the user perspective and changes the behaviour of the
	file system. Eventually yes, I think that this should be
	enabled by default because indeed we're in the business of
	keeping user data safe. However is this a reason to release
	a new file system ? I definitely do not think so.

Please correct me if I forgot about something.

So my conclusion is that it's not at all worth releasing a new file
system for this set of feature where only one of which is actually
more significant.

Yes, if we were to change the file system format significantly, like
let's say get rid of bitmaps and replace it with b-trees following a
huge change in the allocator, then I think it would be worthwhile to
make this big step and start with a new file system.

As fat as mount options are concerned I do not think there is
anything significant either. And releasing a new file system just to
get rid of the mount options does not seem like a best approach
either :)

Thanks!
-Lukas
--8323328-1319512602-1399376874=:2255--
