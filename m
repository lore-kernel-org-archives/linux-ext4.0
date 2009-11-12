From: Andreas Dilger <adilger@sun.com>
Subject: Re: build issue #34 for v2.6.32-rc6-346-gaa021ba :ERROR:
 "log_start_commit" [fs/ext3/ext3.ko] undefined!
Date: Thu, 12 Nov 2009 10:02:59 -0700
Message-ID: <04B31A2B-6807-4B71-A3CB-997E611C765B@sun.com>
References: <200911121756.25718.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	kernel list <linux-kernel@vger.kernel.org>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:43245 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbZKLRDH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Nov 2009 12:03:07 -0500
In-reply-to: <200911121756.25718.toralf.foerster@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On 2009-11-12, at 09:56, Toralf F=F6rster wrote:
> the build (.config attached) failed, make ends with :
> =7FERROR: "log_start_commit" [fs/ext3/ext3.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2


A fix has already been submitted upstream for this, please see
the list archives.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
