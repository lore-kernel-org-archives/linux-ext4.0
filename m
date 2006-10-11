From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] Get rid of extents mount option - try 2
Date: Wed, 11 Oct 2006 11:16:38 -0600
Message-ID: <20061011171638.GP22010@schatzie.adilger.int>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com> <20061005205526.7fe744f5.akpm@osdl.org> <20061006122105.GA21816@thunk.org> <1160169015.8658.50.camel@kleikamp.austin.ibm.com> <1160169700.8658.56.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@osdl.org>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:38815 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1161157AbWJKRQk
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Oct 2006 13:16:40 -0400
To: Dave Kleikamp <shaggy@austin.ibm.com>
Content-Disposition: inline
In-Reply-To: <1160169700.8658.56.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 06, 2006  16:21 -0500, Dave Kleikamp wrote:
> EXT4: Get rid of extents mount option
> 
> Enabling an ext4 file system to use extents should be done with
> 'tune2fs -O extents' or 'mke2fs -O extents', not with a mount option

I would agree that the presence of INCOMPAT_EXTENTS should imply the
EXTENTS mount option, but it is also desirable to be able to turn this
off for testing.  In our internal patches we also have a "noextents"
mount option to disable extents at runtime even if "extents" was given
as a default mount option.

So, I would leave most of the code as-is (with "test_opt(sb, EXTENTS)"),
and just have ext3_fill_super() enable EXT4_MOUNT_EXTENTS if
INCOMPAT_EXTENTS is set.  This is a tiny bit tricky since parse_options()
is called before the superblock is read, so I suspect we'll need a
separate EXT4_MOUNT_NOEXTENTS to distinguish between no mount "extents"
option given and "noextents" disabling this.

The Opt_noextents handling would clear EXT4_MOUNT_EXTENTS, and vice versa.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

