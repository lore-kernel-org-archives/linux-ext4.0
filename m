From: Alexey Lyahkov <alexey_lyashkov@xyratex.com>
Subject: possible bug in ext3/4 recovery
Date: Thu, 25 Jul 2013 13:05:35 +0300
Message-ID: <F894941A-5654-4246-BDD5-A8EE4CBDD396@xyratex.com>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <Andreas.Dilger@intel.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:60976 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab3GYKFm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Jul 2013 06:05:42 -0400
Received: by mail-wg0-f43.google.com with SMTP id z12so1448394wgg.10
        for <linux-ext4@vger.kernel.org>; Thu, 25 Jul 2013 03:05:40 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi list,

While inspecting some strange "corruptions" in Lustre servers i found situation when we try to check disk descriptors before loading/recovering a journal.
but with descriptors checksum enabled we may have a situation when we have update a checksum but don't have a real update for a descriptors because they stay in different blocks on disk. From other view both updates exist in journal and may be replayed to make in consistence.

What about moving a ext4_check_descriptors after 'no_journal' label to be sure we have check in consistence data?

----------------------------------------------
Alexey Lyahkov
alexey_lyashkov@xyratex.com


