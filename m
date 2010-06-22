From: Amir Goldstein <amir73il@gmail.com>
Subject: Next3 on-disk format change request
Date: Tue, 22 Jun 2010 13:30:54 +0300
Message-ID: <AANLkTikAoKpZNGvtyYscPLVH1HrW3xaCZ84sVc62UGD4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56896 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab0FVKa5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jun 2010 06:30:57 -0400
Received: by bwz7 with SMTP id 7so1331406bwz.19
        for <linux-ext4@vger.kernel.org>; Tue, 22 Jun 2010 03:30:55 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

As you may have read, Next3 release 1.0.11 automatically migrates to
new on-disk format.
(see http://next3.sf.net)

Also, I would like to ask you again to promote Next3/Ext4 merge as a
topic on LSF,
if you think it is an appropriate topic.

My on-disk format change request is to re-assign a ro_compat feature
for IS_SNAPSHOT (currently in s_flags).

The reason for this request is the following scenario, which was
posted on next3-users list:

"If I use dd to restore a full snapshot image to another volume, can I
mount it as Next3?"

The answer to this question is that read-only mount is ok, but for
read-write mount,
fsck needs to be run first to fix the free blocks counters.

The restored image is identified with the IS_SNAPSHOT flag.
If it was a ro_compat feature, it would prevent users from mistakingly
mounting it read-write before the fix.
Also, 'tune2fs -O ^is_snapshot' could be used to fix the counters,
without running full fsck.

Please assign me a constant for the feature if you agree,
Thanks,
Amir.
