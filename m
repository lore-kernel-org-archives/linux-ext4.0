From: "HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Subject: patch ext4: fix data exposure after a crash still work ?
Date: Tue, 6 Dec 2016 09:52:01 +0000
Message-ID: <b9885defb2ad439a92c8a64c73e26dba@SGPMBX1004.APAC.bosch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp6-v.fe.bosch.de ([139.15.237.11]:26731 "EHLO
        smtp6-v.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751865AbcLFJwH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Dec 2016 04:52:07 -0500
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Kara

Since we move to kernel 3.18 stable branch. i found the patch " ext4: fix data exposure after a crash " not available but I found below commit which mentioned that patch.
I want to check with you whether " ext4: fix data exposure after a crash " still needed currently ?
I guess yes but I want to confirm with you.
Thanks
Huang weller

ext4: fix deadlock during page writeback
[ Upstream commit 646caa9c8e196880b41cd3e3d33a2ebc752bdb85 ]

Commit 06bd3c36a733 (ext4: fix data exposure after a crash) uncovered a
deadlock in ext4_writepages() which was previously much harder to hit.
After this commit xfstest generic/130 reproduces the deadlock on small
filesystems.

The problem happens when ext4_do_update_inode() sets LARGE_FILE feature
and marks current inode handle as synchronous. That subsequently results
in ext4_journal_stop() called from ext4_writepages() to block waiting for
transaction commit while still holding page locks, reference to io_end,
and some prepared bio in mpd structure each of which can possibly block
transaction commit from completing and thus results in deadlock.

Fix the problem by releasing page locks, io_end reference, and
submitting prepared bio before calling ext4_journal_stop().

[ Changed to defer the call to ext4_journal_stop() only if the handle
  is synchronous.  --tytso ]


Best regards

 Weller HUANG

Base SW (CM/ESW12-CN) 
Bosch Automotive Products (Suzhou) Co. Ltd | No. 126, Su Hong Xi Road
Suzhou Industrial Park | Suzhou P.R.China | P.R.CHINA 
Tel. +86(512)6767-4518 | Weller.Huang@cn.bosch.com

Sitz: Suzhou, Registergericht: State Administration of Industry & Commerce, P.R.China 
Board of Directors: Yudong Chen, Patrick Leinenbach, Liming Chen



