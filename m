From: Evgeniy Ivanov <lolkaantimat@gmail.com>
Subject: ext2 and directory indexing
Date: Sun, 6 Jun 2010 15:29:56 +0400
Message-ID: <AANLkTimPsiqmWPXYXmP6fODEJaS4GrU2y5nzhN9U5Cj3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45109 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab0FFL37 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Jun 2010 07:29:59 -0400
Received: by vws5 with SMTP id 5so1966459vws.19
        for <linux-ext4@vger.kernel.org>; Sun, 06 Jun 2010 04:29:58 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I'm a bit confused by indexing and ext2. It looks like there is no
hash code in ext2, but ext2_fs.h has EXT2_INDEX_FL (most confusing),
EXT2_FEATURE_COMPAT_DIR_INDEX and some other HTree things, but
EXT2_INDEX_FL and EXT2_FEATURE_COMPAT_DIR_INDEX  are not used
anywhere.
I have ext2 partition created with mkfs.ext2 and when I check this
partition e2fsck converts some directories to the indexed format and
sets EXT2_INDEX_FL/EXT3_INDEX_FL. But since I failed grep any usage of
EXT2_INDEX_FL in fs/ext2 that code doesn't reset EXT2_INDEX_FL (some
time ago I was suggested to make my ext2 implementation to reset this
flag which looks correct for ext3, but not ext2). Is it expected
behavior of e2fsck?
Does ext2 have directory indexing support (should my implementation of
ext2 do that)?


-- 
Evgeniy Ivanov
