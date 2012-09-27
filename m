From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC v2 03/10] vfs: add one new mount option '-o hottrack'
Date: Thu, 27 Sep 2012 17:05:08 +1000
Message-ID: <20120927070508.GS15236@dastard>
References: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
 <1348404995-14372-4-git-send-email-zwu.kernel@gmail.com>
 <20120925092819.GC29154@dastard>
 <CAEH94LimEZcAFKFMVNUzBcTeDxvkgeD3jCO3AgmkEKXVE4ym+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	cmm@us.ibm.com, tytso@mit.edu, marco.stornelli@gmail.com,
	stroetmann@ontolinux.com, diegocg@gmail.com, chris@csamuel.org,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:17757 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755624Ab2I0HFL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Sep 2012 03:05:11 -0400
Content-Disposition: inline
In-Reply-To: <CAEH94LimEZcAFKFMVNUzBcTeDxvkgeD3jCO3AgmkEKXVE4ym+A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 27, 2012 at 01:25:34PM +0800, Zhi Yong Wu wrote:
> On Tue, Sep 25, 2012 at 5:28 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Sun, Sep 23, 2012 at 08:56:28PM +0800, zwu.kernel@gmail.com wrote:
> >> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> >>
> >>   Introduce one new mount option '-o hottrack',
> >> and add its parsing support.
> >>   Its usage looks like:
> >>    mount -o hottrack
> >>    mount -o nouser,hottrack
> >>    mount -o nouser,hottrack,loop
> >>    mount -o hottrack,nouser
> >
> > I think that this option parsing should be done by the filesystem,
> > even though the tracking functionality is in the VFS. That way ony
> > the filesystems that can use the tracking information will turn it
> > on, rather than being able to turn it on for everything regardless
> > of whether it is useful or not.
> >
> > Along those lines, just using a normal superblock flag to indicate
> > it is active (e.g. MS_HOT_INODE_TRACKING in sb->s_flags) means you
> > don't need to allocate the sb->s_hot_info structure just to be able
> If we don't allocate one sb->s_hot_info, where will those hash list
> head and btree roots locate?

I wrote that thinking (mistakenly) that s-hot)info was dynamically
allocated rather than being embedded in the struct super_block.

Indeed, if the mount option is held in s_flags, then it could be
dynamically allocated, but I don't think that's really necessary...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
