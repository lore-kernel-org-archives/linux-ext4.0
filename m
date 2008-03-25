From: Andreas Dilger <adilger@sun.com>
Subject: Re: e2fsprogs and fast symlink
Date: Mon, 24 Mar 2008 18:40:32 -0600
Message-ID: <20080325004032.GO2691@webber.adilger.int>
References: <20080321114234.GB6542@skywalker>
 <20080324113747.GA18042@skywalker> <20080324204510.GH2691@webber.adilger.int>
 <20080324212639.GC30110@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:46764 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbYCYAkp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Mar 2008 20:40:45 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m2P0eixN025568
	for <linux-ext4@vger.kernel.org>; Mon, 24 Mar 2008 17:40:44 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JY900M01GC1Z300@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 24 Mar 2008 17:40:44 -0700 (PDT)
In-reply-to: <20080324212639.GC30110@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 24, 2008  17:26 -0400, Theodore Ts'o wrote:
> On Mon, Mar 24, 2008 at 02:45:10PM -0600, Andreas Dilger wrote:
> > Instead I propose that we just use the i_size itself to determine if
> > there is a fast symlink, because there has never (AFAIK) been a kernel
> > that created slow symlinks for files < 60 bytes in length.
> 
> I have a vague memory that at one point (along time ago, over ten
> years ago) there were slow symlinks where the target was < 60 bytes.

Hmm, I don't recall this, but it seems possible.  As far back as 2.2
kernels I checked this wasn't the case, I haven't looked back further.

> And the kernel has always determined whether or not a symlink was fast
> or slow by looking i_blocks.  (See ext3_inode_is_fast_symlink() in
> fs/ext3/inode.c).

Sure, but that doesn't mean it is the best way...

> In retrospect, the true clean way to do this would have been an
> explicit i_flags bitfield.  One thing we could do is make a change
> into ext4 (and ext3) so that we silently set an EXT3_SLOW_LINK_FL and
> EXT3_FAST_LINK_FL, and if neither is set, we fall back to a hueristic
> involving i_blocks.  This gives e2fsck one more bit of redundancy to
> make sure it notices problems and to make sure it gets things right.
> I'm not sure it's worth it, but eventually it would allow us to clean
> things up.

Since it is impossible to have a fast symlink with > 60 bytes of data
it seems reasonable to only flag slow symlinks explicitly.  The unusual,
but theoretically possible, case would be slow symlinks <= 60 bytes, so
we may as well flag all slow symlinks and assume fast symlinks for others.
I don't think there are a huge number of available flags left (12 or less)
so we can't use them without good reason.

Hmm, that brings up a question as I look at the used flags in 2.6.24 -
did the HUGE_FILE support make it into the ext4 upstream?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

