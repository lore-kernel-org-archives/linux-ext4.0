From: Akos Csete <akos.csete@gmail.com>
Subject: Fsck repair takes very long for 1,761 inodes containing
 multiply-claimed blocks on ext4
Date: Wed, 15 Apr 2015 11:18:18 -0400
Message-ID: <CAD-ux60opdAx0+t3EmwR1GWT6t3rZv7CXhxNNbwQLKX6jz_z7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:35049 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbbDOPYs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Apr 2015 11:24:48 -0400
Received: by obbfy7 with SMTP id fy7so23838331obb.2
        for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2015 08:24:47 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I ran into a very long execution time, approaching 48 hours, with
e2fsck 1.42.9 when running e2fsck -fyv on a 7.8TB volume after
fsck.ext4 -nf found 1761 inodes containing multiply-claimed blocks.
I've been tailing the e2fsck output combined with a timestamp and
found progress is extremely slow.
Is this slow processing expected? I checked Ted's response to a 2009
posting for ext3 with a similar issue where he recommended selectively
wiping inodes with debugfs clri then restoring files as needed. Are
there any other options for ext4, perhaps other/faster repair
alternatives?

Thanks,
Akos
