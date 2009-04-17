From: Theodore Tso <tytso@mit.edu>
Subject: Re: Concise description of disk layout?
Date: Fri, 17 Apr 2009 15:36:44 -0400
Message-ID: <20090417193644.GD26479@mit.edu>
References: <1239838392.12688.4.camel@bobble.smo.corp.google.com> <20090416002809.GG21586@mit.edu> <gsahsj$8tk$1@ger.gmane.org> <1239994166.7799.24.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:58956 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbZDQTgs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Apr 2009 15:36:48 -0400
Content-Disposition: inline
In-Reply-To: <1239994166.7799.24.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 17, 2009 at 11:49:26AM -0700, Frank Mayhar wrote:
> On Fri, 2009-04-17 at 18:30 +0000, Frank Mayhar wrote:
> > Sorry for the late reply.
> > 
> > On Wed, 15 Apr 2009 20:28:09 -0400, Theodore Tso wrote:
> > >    http://e2fsprogs.sourceforge.net/ext2intro.html
> > > 
> > > but updated for ext4?
> > 
> > Yeah, the "Physical Structure" section.
> 
> I've read through some of the documents you pointed to and it sounds
> like the actual on-disk format hasn't changed significantly, i.e. block
> groups are laid out in basically the same way and the stuff within them
> is laid out in more or less the same way as in ext2/ext3; the major
> difference seems to be the allocation strategies embedded in the code
> itself.  The new strategies simply mean that files and inodes are
> allocated more efficiently but not really in new places.  Is this (more
> or less) correct or am I totally off-base?

The biggest structural change would be the extent allocation trees,
and the flex_bg changes, which move the block and inode bitmaps and
the inode table out of their individual block groups, and group them
together into larger units.  Take a a look at the dumpe2fs output of a
freshly created ext4 filesystem, and that should become clear.  

On the whole, though, you're correct; the overall on-disk structure
really hasn't changed that much.  Inodes have gotten bigger, and for
64-bit block-sized filesystems, the block group descriptors will also
get bigger, and of course the ext2 description doesn't talk about
where extended attributes are stored, or the htree directory
structures.  But the changes in ext2/3/4 have always been
evolutionary.

Regards,

					- Ted
