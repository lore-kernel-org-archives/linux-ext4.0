From: Andreas Dilger <adilger@sun.com>
Subject: Re: Incompatibility between mballoc and online resize
Date: Tue, 10 Jun 2008 00:24:45 -0600
Message-ID: <20080610062445.GH3726@webber.adilger.int>
References: <E1K5uo4-0004t4-4d@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Alex Tomas <alex.tomas@sun.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:48240 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbYFJGYt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Jun 2008 02:24:49 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m5A6Om7p007298
	for <linux-ext4@vger.kernel.org>; Mon, 9 Jun 2008 23:24:48 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K2800C01HR1FF00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 09 Jun 2008 23:24:48 -0700 (PDT)
In-reply-to: <E1K5uo4-0004t4-4d@closure.thunk.org>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 09, 2008  23:46 -0400, Theodore Ts'o wrote:
> I've been trying to track down the problems in ext4's online-resizing,
> and one of the ones which is most noticeable is that online resizing
> mballoc has some specific data structures which need to be enlarged when
> the number of block groups in the filesystem are grown dynamically.
> 
> Specifically, the s_group_info array; in the current ext4 patch queue,
> this isn't happening, which means after the online resizing operation,
> when the filesystem is unmounted, ext4_put_super() calls
> ext4_mb_release(), which then iterates over s_group_info array, and then
> this triggers a kernel oops.
> 
> Is clusterfs running with mballoc in production?  If so, how was this
> problem fixed?  Did we miss a patch to make sure that on-line resizing
> worked with mballoc enabled?

When Lustre is mounting the backing filesystem on the server, there is
no ext3 mountpoint visible to userspace, hence no access to the underlying
filesystem to pass the resize ioctl to, so we haven't had this problem
yet.  We filed a bug on it, for the time that we can pass an ioctl through:

https://bugzilla.lustre.org/show_bug.cgi?id=15208

We have another open bug related to resize2fs and uninit_bg, but that
is for offline resizing:

https://bugzilla.lustre.org/show_bug.cgi?id=12002

Both of these bugs are mere placeholders, they don't have any patches.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

