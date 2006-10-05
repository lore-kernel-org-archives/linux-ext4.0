From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: creation time stamps for ext4 ?
Date: Thu, 5 Oct 2006 14:07:26 -0600
Message-ID: <20061005200726.GW22010@schatzie.adilger.int>
References: <E1GVUd2-0006O6-00@intern.SerNet.DE> <20061005151937.GV22010@schatzie.adilger.int> <20061005165504.GA23727@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?Qmrvv71ybg==?= JACKE <bjacke@sernet.de>,
	ext3-users@redhat.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:61361 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1751146AbWJEUH2
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Oct 2006 16:07:28 -0400
To: Theodore Tso <tytso@mit.edu>
Content-Disposition: inline
In-Reply-To: <20061005165504.GA23727@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 05, 2006  12:55 -0400, Theodore Tso wrote:
> > I've given this some thought for adding creation time as part of the nsec
> > timestamp patch.  That is more feasable if we move the nsec ctime into
> > the main inode to double as the version field.
> 
> Shoehorning an extra creation time field into the inode is relatively
> easy, but it's also necessary to have system calls to get and set the
> creation time.  The stat structure doesn't have room for the creation
> time, so that means a new version of the stat structure exported the
> kernel, and a new version of the stat structure exported by glibc.

For Lustre and NFSv4, an in-kernel interface is sufficient.

I was thinking that as a preliminary userspace interface we can use
getxattr with a standard name like user.crtime.  Storing the crtime
directly in the inode is more efficient than a separate EA, but it would
also be compatible if Samba wanted to use real EAs to store this in the
absence of large inodes.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

