From: Paul Collins <paul@burly.ondioline.org>
Subject: tune2fs -I 256 -- kind of slow?
Date: Tue, 14 Oct 2008 17:48:05 +1300
Message-ID: <87d4i3lr3u.fsf@burly.wgtn.ondioline.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from jenny.ondioline.org ([66.220.1.122]:56295 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbYJNE6z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Oct 2008 00:58:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I just ran "tune2fs -I 256 /dev/sda3" and it took about an hour and
forty minutes.  The filesystem is about 33GiB, 3/4 full, ~85,000 inodes.
The machine is a 2.13GHz Core 2 Duo, SATA disk.  It seemed to be
CPU-bound, soaking up a core for the whole run.  Does this sound right?

Running e2fsprogs 1.41.3-1 from Debian unstable.

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
