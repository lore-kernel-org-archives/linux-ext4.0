From: Andreas Dilger <adilger@Sun.COM>
Subject: Re: e2fsck ext4 with extents possible?
Date: Wed, 30 Jan 2008 10:45:35 -0700
Message-ID: <20080130174535.GF23836@webber.adilger.int>
References: <47A0574B.1000002@yahoo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: supersud501 <supersud501@yahoo.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:58083 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbYA3RxZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jan 2008 12:53:25 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m0UHjf6f018069
	for <linux-ext4@vger.kernel.org>; Wed, 30 Jan 2008 09:45:41 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JVG00G01X139R00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 30 Jan 2008 09:45:41 -0800 (PST)
In-reply-to: <47A0574B.1000002@yahoo.de>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 30, 2008  11:54 +0100, supersud501 wrote:
> i'm testing the ext4-filesystem for months now (no data loss experienced ), 
> but i noticed e2fsck not being able to check a ext4-filesystem with extents 
> ("e2fsck: Filesystem has unsupported feature(s)").
>
> i just pulled linus' kernel tree (with the newly added patches to ext4) and 
> e2fsprogs git tree (from git.kernel.org), but still e2fsprogs is not able 
> to check my ext4-fs.
>
> so i wonder whether there's somewhere a patch for e2fsprogs flying around 
> i've missed or whether checking ext4 with extents is simply not supported 
> yet? if so, how's development going on with this?

There is an e2fsprogs RPM that can check ext4 filesystems with extents,
available at ftp://ftp.lustre.org/pub/lustre/other/e2fsprogs/ (no
warranties, etc).  We've been using this for a while already, and are
working to get the patches incorporated into the upstream e2fsprogs
in the interim while Ted is reimplementing the extents support.

Note the above RPMs contain patches which are NOT related just to ext4
and should not become part of a distro.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
