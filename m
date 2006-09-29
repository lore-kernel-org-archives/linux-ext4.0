From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Newbie ext2 forensics question...
Date: Fri, 29 Sep 2006 11:24:38 -0600
Message-ID: <20060929172438.GQ22010@schatzie.adilger.int>
References: <loom.20060929T063450-383@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:28889 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1161831AbWI2RYk
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Sep 2006 13:24:40 -0400
To: Dave Edwards <ext2@dpe.lusars.net>
Content-Disposition: inline
In-Reply-To: <loom.20060929T063450-383@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 29, 2006  04:47 +0000, Dave Edwards wrote:
> I'm trying to tune a linux system to spin down its (ext2-formatted) disk when
> the system is idle. I've worked down to two problematic applications that
> periodically spin up the disk, even though the (tiny) file they're writing is
> (allegedly) on a tmpfs partition (/tmp/application/datafile, as it happens).
> Enabling the vm debugging gets me output like:
> 
> kjournald(303): WRITE block 151824 on hda1
> kjournald(303): WRITE block 151832 on hda1
> kjournald(303): WRITE block 151840 on hda1
> kjournald(303): WRITE block 151848 on hda1
> kjournald(303): WRITE block 151856 on hda1
> kjournald(303): WRITE block 151864 on hda1

This is ext3 (journal thread) not ext2.

> pdflush(135): WRITE block 258211840 on hda1
> pdflush(135): WRITE block 258211848 on hda1
> pdflush(135): WRITE block 258211856 on hda1
> pdflush(135): WRITE block 258310144 on hda1
> pdflush(135): WRITE block 0 on hda1
> pdflush(135): WRITE block 16 on hda1
> pdflush(135): WRITE block 64 on hda1
> pdflush(135): WRITE block 56098816 on hda1
> pdflush(135): WRITE block 56100968 on hda1
> pdflush(135): WRITE block 61079552 on hda1

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

