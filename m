From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC] fadvise: add more flags to provide a hint for block allocation
Date: Mon, 5 Mar 2012 20:50:29 +0800
Message-ID: <20120305125029.GA5121@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44794 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738Ab2CEMpS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Mar 2012 07:45:18 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi list,

Block allocation is a key component of file system.  Every file systems try to
improve the performance with optimizing the block allocation of a file.  But no
matter what file system does, it just guesses what the user expects.  Thus, it
is not very accurate.  fadvise(2) provides a method to let the user to give a
hint to file system.  However, until now, only few flags are provided.  So we
can provide more flags to tell file system how to allocate the blocks for a
file.

For example:
we can add these flags into fadvise(2):
FADV_ALLOC_READ_SEQ
FADV_ALLOC_READ_RANDOM
FADV_ALLOC_WRITE_ONCE
FADV_ALLOC_WRITE_APPEND

FADV_ALLOC_READ_* are not similar with FADV_SEQUENTIAL and FADV_RANDOM.
FADV_ALLOC_READ_SEQ tells file system that this file need to allocate some
sequential blocks, and FADV_ALLOC_READ_RADOM tells file system that this file
can endure the fragmentation.

FADV_ALLOC_WRITE_ONCE indicates that this file just is written once.  So file
system can allocate some sequential blocks for it to improve the read
performance.  FADV_ALLOC_WRITE_APPEND flag is set to point out that data will be
appended to the end of this file, and file system can reserve some blocks for it
to guarantee the sequence as much as possible.

File systems can support a subset of these flags according to its design.  These
flags provide a rich interface that lets the user to control block allocation of
files.  The user could precisely control the allocation of their files to
improve the performance of appliatons.

Any comments or suggestions are appreciated.  Thank you.

Regards,
Zheng
