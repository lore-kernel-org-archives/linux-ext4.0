From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: Query regarding ext4 filesystem
Date: Thu, 25 Nov 2010 10:37:53 -0500
Message-ID: <1805.1290699473@gamaville.dokosmarshall.org>
References: <4CEE0225.6010205@tataelxsi.co.in>
Reply-To: nicholas.dokos@hp.com
Cc: linux-ext4@vger.kernel.org, nicholas.dokos@hp.com
To: Nivedita J N <niveditajn@tataelxsi.co.in>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vms173007pub.verizon.net ([206.46.173.7]:60992 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab0KYPh4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Nov 2010 10:37:56 -0500
Received: from gamaville.dokosmarshall.org ([unknown] [173.76.32.106])
 by vms173007.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0LCG00BXQ634OQ50@vms173007.mailsrvcs.net> for
 linux-ext4@vger.kernel.org; Thu, 25 Nov 2010 09:37:53 -0600 (CST)
In-reply-to: Message from Nivedita J N <niveditajn@tataelxsi.co.in> of
 "Thu, 25 Nov 2010 11:58:53 +0530." <4CEE0225.6010205@tataelxsi.co.in>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>    I'm planning to use ext4 filesystem in my ubuntu machine.I am doing
> a detailed search on the filesystem.I would like to know where the
> journal is stored in ext4 file system? Is it visible?
> 

You can use debugfs for this - do ``man 8 debugfs'' for more info. The
journal is generally inode 8 (you can do

    dumpe2fs -h /dev/FOO | grep "Journal inode:"

to make sure), so in debugfs you can do

    stat <8>
    ex <8>

to get metadata (size, perms, etc.) and extent information and

    logdump <OPTIONS>

to examine the contents of the journal - see the debugfs man page
for <OPTIONS> info.

HTH,
Nick
