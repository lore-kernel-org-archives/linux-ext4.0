From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 0/3] Fiemap, an extent mapping ioctl
Date: Wed, 10 Sep 2008 13:46:46 -0600
Message-ID: <20080910194646.GO3086@webber.adilger.int>
References: <20080825202250.GY3392@webber.adilger.int>
 <20080910124005.GA4563@wotan.suse.de> <20080910124934.GB4563@wotan.suse.de>
 <20080910114612.314978a8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Mark Fasheh <mfasheh@suse.com>, Eric Sandeen <esandeen@redhat.com>,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:44053 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbYIJTq5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Sep 2008 15:46:57 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m8AJkmYf023568
	for <linux-ext4@vger.kernel.org>; Wed, 10 Sep 2008 12:46:48 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K6Z00F01W2IPS00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 10 Sep 2008 12:46:48 -0700 (PDT)
In-reply-to: <20080910114612.314978a8.akpm@linux-foundation.org>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 10, 2008  11:46 -0700, Andrew Morton wrote:
> On Wed, 10 Sep 2008 05:49:34 -0700 Mark Fasheh <mfasheh@suse.com> wrote:
> > 	The following patches are the latest attempt at implementing a
> > fiemap ioctl, which can be used by userspace software to get extent
> > information for an inode in an efficient manner.
> 
> As these are applicable to all filesystems, Cc:ing only linux-ext4 is
> not sufficient.  All filesystem developers (at least) need an
> opportunity to review and understand these changes.

That was an oversight, partly caused because I launched the thread for
this on linux-ext4 after an ext4 concall.  All previous patches have
gone to linux-fsdevel and been through numerous discussions.

> > The fiemap ioctl is an efficient method for userspace to get file
> > extent mappings. Instead of block-by-block mapping (such as bmap), fiemap
> > returns a list of extents.
> 
> The above is, afacit, the only offered rationale for the addition of
> these new feature.  I don't recall seeing anyone complain about bmap()
> inefficiency.  In fact I rarely hear of anyone using bmap() at all.
> 
> This rationale needs expanding, please.  A lot.

There are several reasons for this new API:
- it avoids tools like "filefrag" (which currently use FIBMAP) having to
  do an ioctl for every block in a file, have the kernel map that block
  from an on-disk extent (in most newer filesystems), then re-assemble the
  extents in userspace.
- it works with filesystems that are not block based (e.g. NTFS, btrfs, etc)
  that may align file data on boundaries other than $blocksize boundaries
- it provides a much more rich API for finding out about on-disk allocation,
  such as whether allocated blocks are unwritten (e.g. fallocate), if they
  are packed along with other data, if the data is in the inode, etc.
- it can share existing XFS-specific functionality (which FIEMAP was designed
  to provide a superset of functionality for) with other filesystems.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

