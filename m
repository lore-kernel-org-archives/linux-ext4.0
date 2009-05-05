From: Andreas Dilger <adilger@sun.com>
Subject: Re: fsck ate my ext4 home partition, help!?
Date: Tue, 05 May 2009 10:51:59 -0600
Message-ID: <20090505165159.GJ3209@webber.adilger.int>
References: <20090504131128.135100@gmx.net>
 <alpine.DEB.2.01.0905042222260.6162@bogon.housecafe.de>
 <20090505144436.125410@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Christian Kujau <lists@nerdbynature.de>, linux-ext4@vger.kernel.org
To: Marcel Partap <mpartap@gmx.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:42554 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbZEEQwT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 May 2009 12:52:19 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n45GqF31012610
	for <linux-ext4@vger.kernel.org>; Tue, 5 May 2009 09:52:16 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KJ600D00JQIAW00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Tue,
 05 May 2009 09:52:15 -0700 (PDT)
In-reply-to: <20090505144436.125410@gmx.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 05, 2009  16:44 +0200, Marcel Partap wrote:
> > You did not take the dd image before the first e2fsck, hm?
> Well backing up files before trashing them is sooo unadventurous aint it.
> e2fsck really needs the ability to write all actions to an undo log file.
> By default. Hmmpf.

There is a feature in newer e2fsprogs that does create an undo log for
e2fsck, but the performance isn't necessarily great.  I don't know how
bad it gets, but maybe for the majority of people this would be an
acceptable alternative to the risk of major filesystem errors.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

