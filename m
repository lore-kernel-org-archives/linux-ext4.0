From: Andreas Dilger <adilger@dilger.ca>
Subject: Potential problems with ext4 crypto
Date: Thu, 24 Sep 2015 23:10:30 +0200
Message-ID: <C30D20D8-0360-4E11-93F9-81CE87E5D8F0@dilger.ca>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>,
	Michael Halcrow <mhalcrow@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34152 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602AbbIXVKV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Sep 2015 17:10:21 -0400
Received: by wicfx3 with SMTP id fx3so45669908wic.1
        for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2015 14:10:20 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I recently found a blog describing ext4 crypto:
http://blog.quarkslab.com/a-glimpse-of-ext4-filesystem-level-encryption.html

that reported several problems with the ext4 crypto code.  Sadly, it
doesn't seem that these issues were reported to the list, only the
blog, so I'm not sure if any of the crypto developers are aware of them?

I looked through the Git commit logs, and don't see any significant
patches to the crypto code since before 4.1 was released, so I'd guess
these issues are still open?

Is there anything that could be done about the leakage of the file size
for encrypted inodes without the decryption key?  It seems that it would
at least be possible to return the size rounded up to the end of the
block, to at least disguise the file sizes a bit without losing the
file data if there is some valid reason to copy it encrypted (some
garbage bytes would be left at the end of the file when decrypted).

Cheers, Andreas





