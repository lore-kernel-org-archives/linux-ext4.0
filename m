From: John Reiser <jreiser@bitwagon.com>
Subject: resize2fs shrink ext3 can be CPU limited
Date: Thu, 10 Feb 2011 19:23:54 -0800
Message-ID: <4D54ABCA.9020700@bitwagon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bitwagon.com ([74.82.39.175]:33180 "HELO bitwagon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750910Ab1BKDjP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Feb 2011 22:39:15 -0500
Received: from f14-64.local ([67.171.188.169]) by bitwagon.com for <linux-ext4@vger.kernel.org>; Thu, 10 Feb 2011 19:24:13 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

When I use resize2fs to shrink a 153GB ext3 from about 53% full
to about 55% of its original size (thus becoming about 98% full),
then Pass 3, Scanning inode table, is CPU limited and a significant
fraction of elapsed wall-clock time (tens of minutes out of more than
an hour).  Being CPU-limited for such a duration seems peculiar to me.

The behavior is reproducible.  The details are at
  https://bugzilla.redhat.com/show_bug.cgi?id=676683
including reports from oprofile.

  resize2fs 1.41.12 (17-May-2010)
    input: 1071971/9863168 files (0.1% non-contiguous), 21597266/39423744
    output: The filesystem on /dev/sdc2 is now 22989038 blocks long.
real 69m52.167s
user 26m29.431s
sys 2m3.456s

[I'm not subscribed to this mailing list.]

-- 
John Reiser, jreiser@BitWagon.com
