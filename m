From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: status of the ext3/jbd error handling enhancement patches
Date: Mon, 20 Oct 2008 13:25:01 +0900
Message-ID: <48FC081D.60306@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	tytso@mit.edu, adilger@sun.com, jack@suse.cz, sandeen@redhat.com
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail9.hitachi.co.jp ([133.145.228.44]:53524 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbYJTE0S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Oct 2008 00:26:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andrew,

Thank you for pushing my ext3/jbd to Linus.  But some of patches
in -mm (following three patches) haven't been sent to Linus.

  #jbd-fix-error-handling-for-checkpoint-io.patch: double-check this
  jbd-fix-error-handling-for-checkpoint-io.patch
  ext3-add-checks-for-errors-from-jbd.patch
  jbd-test-bh_write_eio-to-detect-errors-on-metadata-buffers.patch

They improve filesystem corruption problem and it is needed by
mission critical systems.

Could you tell me what is your concern (you commented, "double-check
this") ?  Are there something that I can help?  For example, I can
provide some SystemTap scripts to help tests.

Thank you,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center


