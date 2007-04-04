From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: tune2fs -l stale info
Date: Tue, 3 Apr 2007 23:56:19 -0600
Message-ID: <20070404055619.GJ5967@schatzie.adilger.int>
References: <1175170676.5185.42.camel@localhost> <20070329195939.GI5967@schatzie.adilger.int> <1175608557.5079.15.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext3-users@redhat.com, linux-ext4@vger.kernel.org
To: Vincent Caron <vcaron@bearstech.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:37193 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992665AbXDDF4V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Apr 2007 01:56:21 -0400
Content-Disposition: inline
In-Reply-To: <1175608557.5079.15.camel@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Apr 03, 2007  15:55 +0200, Vincent Caron wrote:
>   BTW, if ondisk superblocks are not updated until specific events occur
> (umount, statfs), what is the consequence of a system crash ? Does
> journalization come into play (superblock=metadata?), does fsck fixes
> figures from other ondisk structures ? Just being curious...

The free blocks/inodes count in the superblock aren't really used for
anything these days.  At mount time the kernel sums up the free inode
and block counts from the group descriptors to put into the percpu
counters, and only the group descriptors are kept uptodate.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
