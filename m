From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][PATCH] Multiple mount protection
Date: Fri, 1 Jun 2007 03:14:35 -0600
Message-ID: <20070601091435.GR5181@schatzie.adilger.int>
References: <1179777153.3910.13.camel@garfield> <p731wgwcbac.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:33091 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411AbXFAJOh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Jun 2007 05:14:37 -0400
Content-Disposition: inline
In-Reply-To: <p731wgwcbac.fsf@bingen.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 01, 2007  10:46 +0200, Andi Kleen wrote:
> Kalpak Shah <kalpak@clusterfs.com> writes:
> > There have been reported instances of a filesystem having been
> mounted at 2 places at the same time causing a lot of damage to the
> filesystem....  The superblock will have a block number (s_mmp_block)
> which will hold a MMP structure which has a sequence number which will be
> periodically updated every 5 seconds by a mounted filesystem.
> 
> That will make laptop users very unhappy if you spin up their disks every
> 5 seconds.  And even on other systems it might reduce the MTBF if you
> write the super block much more often than before. It might be better to
> set it up in some way to only increase that number when the super block is
> written for some other reason anyways.

It was mentioned before but deserves mentioning again that this will
be an optional feature, mostly for use on SANs, iSCSI, etc where a disk
might be accessed by multiple nodes at the same time.  That means there
will not be any impact for desktop users waiting 10s for each of their
filesystems to mount.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
