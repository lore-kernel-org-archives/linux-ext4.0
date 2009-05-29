From: ed1989 <edshrock@live.com>
Subject: I lost 15G from ext4 fsck failures tonight!
Date: Thu, 28 May 2009 21:55:42 -0700 (PDT)
Message-ID: <23774225.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kuber.nabble.com ([216.139.236.158]:44351 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbZE2Ezl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 May 2009 00:55:41 -0400
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1M9u86-0002Ap-5i
	for linux-ext4@vger.kernel.org; Thu, 28 May 2009 21:55:42 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I moved some data off of a 115G ext4 filesystem on an LVM logical volume. 
Then I resized the ext4 filesystem.  Unfortunately, 15G of the remaining 95G
in data was lost to /lost+found due to repeated fsck errors.

I have also had the problem of ext4 destroying my kde4 configuration files
so that my kde4 desktop would revert back to the defaults occasionally.

I don't see what the benefit of ext4 really is, when data loss doesn't seem
to be a concern among ext4 developers.  I would expect that data loss should
be the primary concern.

I am most likely going to move back to ext3 or else to some other stable
filesystem like xfs.
-- 
View this message in context: http://www.nabble.com/I-lost-15G-from-ext4-fsck-failures-tonight%21-tp23774225p23774225.html
Sent from the linux-ext4 mailing list archive at Nabble.com.

