From: Adam Huffman <adam.huffman@gmail.com>
Subject: Errors from e2image
Date: Wed, 28 Nov 2012 18:32:24 +0000
Message-ID: <CAP5prOhNaffwJaPQageP-jvHTccaEKhQCmwqVbMeSwPq-DUodg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44995 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab2K1ScZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Nov 2012 13:32:25 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so5930284eek.19
        for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2012 10:32:24 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello again

I've just run e2image, as you suggested and it doesn't look like it's
ever going to complete.

There are lots of errors on the console like:

Illegal block number passed to ext2fs_mark_block_bitmap #822751537 for
in-use block map
Illegal block number passed to ext2fs_mark_block_bitmap #825307441 for
in-use block map
Illegal block number passed to ext2fs_mark_block_bitmap #825307441 for
in-use block map
Illegal block number passed to ext2fs_mark_block_bitmap #825307441 for
in-use block map
Illegal block number passed to ext2fs_mark_block_bitmap #170996017 for
in-use block map
Illegal block number passed to ext2fs_mark_block_bitmap #825307441 for
in-use block map
Illegal block number passed to ext2fs_mark_block_bitmap #825307441 for
in-use block map
Illegal block number passed to ext2fs_mark_block_bitmap #825307441 for
in-use block map
Illegal block number passed to ext2fs_mark_block_bitmap #825307441 for
in-use block map
Illegal block number passed to ext2fs_mark_block_bitmap #825307402 for
in-use block map
Illegal block number passed to ext2fs_mark_block_bitmap #825307441 for
in-use block map

Is this something I need to leave running for a long time?  I tried it
on the other problematic LV and the command did complete, though the
qcow2 file it produced was empty.

Cheers,
Adam
