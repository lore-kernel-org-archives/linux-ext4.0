From: Andreas Dilger <adilger@sun.com>
Subject: Re: Scripting e2fsck: no errors,
 but still exit code 1 "FILE SYSTEM	WAS MODIFIED"
Date: Wed, 21 May 2008 10:14:23 -0600
Message-ID: <20080521161423.GO3516@webber.adilger.int>
References: <483006F1.6080008@tuxes.nl> <20080518122853.GB31413@mit.edu>
 <483056DC.4060108@tuxes.nl> <48316565.1040501@tuxes.nl>
 <20080520120953.GO15035@mit.edu> <48334068.1090205@tuxes.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@MIT.EDU>, linux-ext4@vger.kernel.org
To: Bas van Schaik <bas@tuxes.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:60698 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222AbYEUQOe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 May 2008 12:14:34 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m4LGEWP3016157
	for <linux-ext4@vger.kernel.org>; Wed, 21 May 2008 09:14:33 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K1800A017JBSM00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 21 May 2008 09:14:32 -0700 (PDT)
In-reply-to: <48334068.1090205@tuxes.nl>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 20, 2008  23:19 +0200, Bas van Schaik wrote:
> Theodore Tso wrote:
> > Andreas is right though that if you are taking a proper snapshot, the
> > disk really should be quiesced and no journal replay should be
> > required at all.  That's how a devicemapper snapshot works in LVM ---
> > so one good question to explore is how *are* you doing your snapshots.
>
> Exactly my thoughts, but apparently something is wrong here too. Maybe I
> should note that my journal commit interval is set to something like 5
> or 10 seconds, is that relevant?

No, this is normal.

> Again a small snippet of bash responsible for snapshotting:
> > snapshot_stamp=`date +%Y%m%d-%H%M%S`
> > lvcreate --snapshot --size 50G --name backups-snapshot-$snapshot_stamp
> > $LV &> $TMPLOGFILE
> 
> This is not a weird way to snapshot, is it?

No, this is normal, yet it doesn't seem to work correctly.  Can you please
add some sort of debug message into ext3_write_super_lockfs() and
ext3_unlockfs() to make sure these functions are being called for your
filesystem when you are doing the snapshot.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

