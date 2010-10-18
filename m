From: Sedat Dilek <sedat.dilek@googlemail.com>
Subject: linux-2.6-block/for-next: Removal of BLKDEV_IFL_BARRIER and BLKDEV_IFL_WAIT
Date: Mon, 18 Oct 2010 02:11:25 +0200
Message-ID: <AANLkTi=EiCvRxAqnbWoPMhqYAZDQmsjaDRt+0dK-fRcV@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: axboe@kernel.dk, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62073 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab0JRAL0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Oct 2010 20:11:26 -0400
Received: by qyk5 with SMTP id 5so3773643qyk.19
        for <linux-ext4@vger.kernel.org>; Sun, 17 Oct 2010 17:11:25 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

today, I pulled linux-2.6-block/for-next GIT branch [1] on top of
Linus-tree (2.6.36-rc8-git3).

Unfortunately, ext4/next GIT branch [2] is not "GIT-pull-able" on top
of this local GIT repository.
The cause for this is the removal of BLKDEV_IFL_BARRIER and
BLKDEV_IFL_WAIT in linux-2.6-block/for-next.

As there are few days left for 2.6.36-final, it would be great when
ext4/next could be prepared to work with linux-2.6-block/for-next.
Thanks in advance.

Kind Regards,
- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=shortlog;h=refs/heads/for-next
[2] http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=shortlog;h=refs/heads/next
