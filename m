From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 09/28] libext2fs: handle inline data in dir iterator
 function
Date: Tue, 3 Dec 2013 22:07:42 -0800
Message-ID: <20131204060742.GQ9535@birch.djwong.org>
References: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
 <1386072715-9869-10-git-send-email-wenqing.lz@taobao.com>
 <20131203221349.GF9535@birch.djwong.org>
 <20131204045736.GF20409@gmail.com>
 <20131204051025.GF9541@birch.djwong.org>
 <20131204052619.GH20409@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31408 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab3LDGHt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Dec 2013 01:07:49 -0500
Content-Disposition: inline
In-Reply-To: <20131204052619.GH20409@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 04, 2013 at 01:26:19PM +0800, Zheng Liu wrote:
> On Tue, Dec 03, 2013 at 09:10:25PM -0800, Darrick J. Wong wrote:
> > On Wed, Dec 04, 2013 at 12:57:36PM +0800, Zheng Liu wrote:
> > > On Tue, Dec 03, 2013 at 02:13:49PM -0800, Darrick J. Wong wrote:
> > > > On Tue, Dec 03, 2013 at 08:11:36PM +0800, Zheng Liu wrote:
> > > > > From: Zheng Liu <wenqing.lz@taobao.com>
> > > > > 
> > > > > Inline_data is handled in dir iterator because a lot of commands use
> > > > > this function to traverse directory entries in debugfs.  We need to
> > > > > handle inline_data individually because inline_data is saved in two
> > > > > places.  One is in i_block, and another is in ibody extended attribute.
> > > > > 
> > > > > After applied this commit, the following commands in debugfs can
> > > > > support the inline_data feature:
> > > > > 	- cd
> > > > > 	- chroot
> > > > > 	- link*
> > > > > 	- ls
> > > > > 	- ncheck
> > > > > 	- pwd
> > > > > 	- unlink
> > > > > 
> > > > > * TODO: Inline_data doesn't expand to ibody extended attribute because
> > > > >   link command doesn't handle DIR_NO_SPACE error until now.  But if we
> > > > >   have already expanded inline data to ibody ea area, link command can
> > > > >   occupy this space.
> > > > 
> > > > A patch for this TODO is coming, right?
> > > 
> > > TBH, I don't have a patch for this because I don't know why ext2fs_link
> > > doesn't handle DIR_NO_SPACE error.  So I will try to fix it later.
> > 
> > Yeah, it's sort of annoying that it doesn't do that.  You might notice that
> > fuse2fs will detect that error code, call ext2fs_expand_dir(), and try again.
> > On the other hand, none of the other programs do that...
> > 
> > ...it's not difficult to change ext2fs_link() to do that, though.
> > 
> > again:
> > 
> > /* link_proc magic... */
> > 
> > if (!ls.done && !not_again) {
> > 	ext2fs_expand_dir(fs, dir...);
> > 	not_again = 1;
> > 	goto again;
> > }
> > 
> > Hmm.  That /is/ easy to fix.  I might as well fix that.
> 
> I don't think we should fix it in ext2fs_link because I am afraid that
> we could break the client that has handled this problem.  So I am plan
> to fix it in make_link().  What do you think?

I think the clients will be fine.  Most likely, if the dir can't be expanded,
then ext2fs_link will return ext2fs_expand_directory's failure code.

On the off chance there's a weird bug somewhere such that we successfully
expand the dir but _link's built-in retry fails again, then the client will see
the "no dir space" error, expand the dir (again!), and retry the link, which
will again fail.  Assuming the client doesn't madly retry in a loop, all that
means is that we bang our heads against the wall a few more times than we need
to.

Luckily, most of the _link clients in the e2fsprogs source are too stupid even
to expand-and-retry.

--D

> 
>                                                 - Zheng
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
