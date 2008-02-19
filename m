From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH][7/28] e2fsprogs-extents.patch
Date: Mon, 18 Feb 2008 21:35:45 -0700
Message-ID: <20080219043545.GJ3029@webber.adilger.int>
References: <20080202075943.GB23836@webber.adilger.int>
 <20080202082559.GG31694@webber.adilger.int>
 <20080202082701.GH31694@webber.adilger.int> <47B9C6E5.2010304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:33633 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbYBSEft (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Feb 2008 23:35:49 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m1J4ZmRS029838
	for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2008 20:35:48 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JWG00M01XZRUC00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 18 Feb 2008 20:35:48 -0800 (PST)
In-reply-to: <47B9C6E5.2010304@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 18, 2008  11:56 -0600, Eric Sandeen wrote:
> > @@ -904,21 +910,75 @@ void e2fsck_pass1(e2fsck_t ctx)
> > +		eh = (struct ext3_extent_header *)inode->i_block;
> > +		if ((inode->i_flags & EXT4_EXTENTS_FL)) {
> > +			if ((LINUX_S_ISREG(inode->i_mode) ||
> > +			     LINUX_S_ISDIR(inode->i_mode)) &&
> 
> So this trips up on things like sockets, fifos, and block & char nodes.

Hrm, not impossible, since Lustre only uses extent-based filesystems for
regular file storage.

> Also this is unhappy:
> 
> > @@ -137,7 +141,7 @@ int e2fsck_pass1_check_device_inode(ext2
> >  	 * If the index flag is set, then this is a bogus
> >  	 * device/fifo/socket
> >  	 */
> > -	if (inode->i_flags & EXT2_INDEX_FL)
> > +	if (inode->i_flags & (EXT2_INDEX_FL | EXT4_EXTENTS_FL))
> >  		return 0;
> 
> Do we really care if these have the extents flag set?  IOW should we
> make sure the kernel doesn't set the flag, or should we make e2fsck not
> care...

The Lustre extents patches clear the EXT4_EXTENTS_FL always (i.e. they
are never set on directories) so we've never seen these problems.

> There are enough checks in e2fsck to show the intent was that these
> files should not have the extents flag set, but I'm not sure why it
> matters enough that the kernel needs to run around being sure to clear
> it....
> 
> Or... (rambling on now) it seems odd to me that zero-length files have
> the extents flag set at all; should we only set extents when we actually
> get a block allocated to the file?  That would also take care of this
> from the kernel side I think.

Yes, I'd be for e2fsck clearing this flag, but as I mentioned in the
concall, I think it is better to have the kernel just stop inheriting
all flags from the parent directory, or possibly just have a fixed
range of flags that are being propogated to child inodes.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
