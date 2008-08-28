From: Andreas Dilger <adilger@sun.com>
Subject: Re: Online resize with flex bg
Date: Thu, 28 Aug 2008 13:57:39 -0600
Message-ID: <20080828195739.GP3392@webber.adilger.int>
References: <1219934280.3591.121.camel@frecb007923.frec.bull.fr>
 <20080828171156.GK26987@mit.edu> <20080828173652.GL26987@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: =?utf-8?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:38374 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbYH1T5s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Aug 2008 15:57:48 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m7SJvkHA002699
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 12:57:46 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K6B00301S6ZXS00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 28 Aug 2008 12:57:46 -0700 (PDT)
In-reply-to: <20080828173652.GL26987@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 28, 2008  13:36 -0400, Theodore Ts'o wrote:
> And here's the short-term fix.  With this patch, e2fsprogs will work
> on ext4 filesystems with flex_bg.  Interested in working on the
> long-term fix, where we put all or most of the resizing logic in the
> kernel?  :-)

Yes, that was my thought also.  The setup_new_group_blocks() can already
do pretty much everything, the only piece lacking in the past was the
ability to specify the raid stride, but that is now in the superblock
also.

What would be good is to fix up setup_new_group_blocks() if GDT_CSUM[*]
feature is set to flag uninit_bg groups and set the itable_unused field.
We still need the itable zeroing, but setting ITABLE_ZERO flag will save
possibly duplicate work later.

Cheers, Andreas

[*] maybe we should add an UNINIT_BG #define and move over to that slowly?
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

