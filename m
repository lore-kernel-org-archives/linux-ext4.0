From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext2: No longer export ext2_fs.h to user space
Date: Sat, 24 Mar 2012 17:51:52 -0400
Message-ID: <20120324215152.GA32554@thunk.org>
References: <20120322183135.GC4028@thunk.org>
 <1332494856-31943-1-git-send-email-thierry.reding@avionic-design.de>
 <20120323131331.GA29631@thunk.org>
 <20120323175534.GI6589@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Andreas Dilger <aedilger@gmail.com>, linux-ext4@vger.kernel.org
To: hpa@zytor.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60920 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220Ab2CXVwJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Mar 2012 17:52:09 -0400
Content-Disposition: inline
In-Reply-To: <20120323175534.GI6589@ZenIV.linux.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Peter,

Note that we are planning on unexporting ext2_fs.h, and then utterly
removing it from the tree (with what fs/ext2 needs being moved to
fs/ext2/ext2.h).

Someone who was compiling "the latest version" of syslinux has
submitted a kernel bugzilla entry that this was breaking due to
ext2_fs.h using umode_t which was no longer being exported by the
kernel header files.  Given that ext2_fs.h is about to go ***poof***
(Al already has the changes in his vfs git tree), I thought I should
give you a heads up....

					- Ted

On Fri, Mar 23, 2012 at 05:55:34PM +0000, Al Viro wrote:
> On Fri, Mar 23, 2012 at 09:13:31AM -0400, Ted Ts'o wrote:
> > On Fri, Mar 23, 2012 at 10:27:36AM +0100, Thierry Reding wrote:
> > > Since the on-disk format has been stable for quite some time, users
> > > should either use the headers provided by libext2fs or keep a private
> > > copy of this header. For the full discussion, see this thread:
> > > 
> > > 	https://lkml.org/lkml/2012/3/21/516
> > > 
> > > While at it, this commit removes all __KERNEL__ guards, which are now
> > > unnecessary.
> > > 
> > > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > > Cc: Jan Kara <jack@suse.cz>
> > > Cc: Ted Ts'o <tytso@mit.edu>
> > > Cc: Artem Bityutskiy <dedekind1@gmail.com>
> > > Cc: Andreas Dilger <aedilger@gmail.com>
> > > Cc: linux-ext4@vger.kernel.org
> > 
> > Acked-by: "Theodore Ts'o" <tytso@mit.edu>
> > 
> > Thanks!!
> > 
> > Al, do you want to take this in the VFS tree, or do you want me to
> > carry this in the ext4 tree?  Or Jan could carry it in the ext2 tree.
> > I don't really have strong feelings about who picks it up.  I will if
> > no one else wants to...
> 
> Applied.  I'll probably add a followup moving most of that stuff to
> fs/ext2/ext2.h on top of that commit...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
