From: Andreas Dilger <adilger@sun.com>
Subject: Re: Scripting e2fsck: no errors,
 but still exit code 1 "FILE	SYSTEM WAS MODIFIED"
Date: Mon, 19 May 2008 21:58:28 -0600
Message-ID: <20080520035828.GQ3491@webber.adilger.int>
References: <483006F1.6080008@tuxes.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Bas van Schaik <bas@tuxes.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:38801 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609AbYETD6z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 May 2008 23:58:55 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m4K3wsbv018900
	for <linux-ext4@vger.kernel.org>; Mon, 19 May 2008 20:58:54 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K1500901EY3J600@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 19 May 2008 20:58:54 -0700 (PDT)
In-reply-to: <483006F1.6080008@tuxes.nl>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 18, 2008  12:37 +0200, Bas van Schaik wrote:
> ... there is a slight
> problem with scripting e2fsck: it seems that e2fsck /always/ exits with
> exit code 1 just because of the fact that the snapshot journal has been
> replayed.

> > e2fsck 1.40.8 (13-Mar-2008)
> > /dev/loop1: recovering journal
> > Pass 1: Checking inodes, blocks, and sizes
> > Pass 2: Checking directory structure
> > Pass 3: Checking directory connectivity
> > Pass 4: Checking reference counts
> > Pass 5: Checking group summary information
> >
> > /dev/loop1: ***** FILE SYSTEM WAS MODIFIED *****

You shouldn't get journal replay after a proper LVM snapshot.  The
LVM code should freeze the filesystem temporarily, flush out the journal,
mark the filesystem clean, take the snapshot of the clean fileysstem,
and then unfreeze the filesystem again.

If you are using LVM for snapshots, and this is not happening, then
the snapshot code is broken.  If you are NOT using LVM, then you
should look into the "freeze ioctl" patches that were on linux-ext4 and
linux-fsdevel recently "[RFC PATCH 1/3] Implement generic freeze feature"
from Takashi Sato.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

