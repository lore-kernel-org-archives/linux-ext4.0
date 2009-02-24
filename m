From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, RFC] ext4: add EXT4_IOC_ALLOC_DA_BLKS ioctl
Date: Tue, 24 Feb 2009 03:11:05 -0700
Message-ID: <20090224101105.GM3199@webber.adilger.int>
References: <1235451952-2726-1-git-send-email-tytso@mit.edu>
 <1235451952-2726-2-git-send-email-tytso@mit.edu>
 <1235451952-2726-3-git-send-email-tytso@mit.edu>
 <1235451952-2726-4-git-send-email-tytso@mit.edu>
 <1235451952-2726-5-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:34201 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbZBXKLg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Feb 2009 05:11:36 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n1OABHWq023638
	for <linux-ext4@vger.kernel.org>; Tue, 24 Feb 2009 02:11:30 -0800 (PST)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec 23 2008))
 id <0KFK00K00ETOWF00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Tue,
 24 Feb 2009 02:11:17 -0800 (PST)
In-reply-to: <1235451952-2726-5-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 24, 2009  00:05 -0500, Theodore Ts'o wrote:
> +#define EXT4_IOC_ALLOC_DA_BLKS		_IO('f', 10)
>   /* note ioctl 11 reserved for filesystem-independent FIEMAP ioctl */

Please don't use ioctl number 10 - it was used by an early
version of the FIEMAP ioctl that we still have in use in Lustre
filesystems.  Not that there is much chance of a collision, but
it is also easily enough avoided.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

