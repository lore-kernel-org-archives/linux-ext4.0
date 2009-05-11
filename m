From: Alexander Shishkin <alexander.shishckin@gmail.com>
Subject: [Q] ext3 mkfs: zeroing journal blocks
Date: Mon, 11 May 2009 18:03:13 +0300
Message-ID: <71a0d6ff0905110803t1a6b34ccq91d5494f95fe1f34@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:57353 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbZEKPDO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 May 2009 11:03:14 -0400
Received: by fxm2 with SMTP id 2so2741785fxm.37
        for <linux-ext4@vger.kernel.org>; Mon, 11 May 2009 08:03:13 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Here's a question regarding ext3, jbd and mkfs. I'm not 100% confident
this is the right
list, got it from MAINTAINERS for ext3 and jbd. Please correct me if
this is wrong.

As far as I could tell from brief looking at jbd code, it seemed to me
that the only thing
that has to be reset during the filesystem creation time is journal
superblock (talking
about the default case when journal resides within an ext3 partition).
However, currently
mke2fs -j would zero every journal block no matter what. So, the
question is: can this
zeroing really be avoided in mkfs?
I tried commenting-out ext2fs_zero_block() in mkjournal_proc() and it
seems to speed
up mkfs a great deal while the kernel is still able to mount the
partition afterwards. Also,
for the sake of experiment, I filled the partition with urandom's
contents before doing
the modified mkfs and it still works. My next step in this direction
would be to go
through jbd code, but before doing that, I thought, I'd ask here.

Please CC me in replies as I'm not (yet) subscribed.

Regards,
-- 
Alex
