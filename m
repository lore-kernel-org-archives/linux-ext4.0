From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH 2/2] tests: add two more tests of orphaned inode handling
Date: Wed, 13 Jun 2012 00:44:10 -0600
Message-ID: <F7262E20-BC8F-42BE-A8F0-C7DBD49CA8C6@whamcloud.com>
References: <1339467762-5725-1-git-send-email-tytso@mit.edu> <1339479907-19088-1-git-send-email-tytso@mit.edu> <1339479907-19088-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:48132 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab2FMGoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jun 2012 02:44:16 -0400
Received: by dano14 with SMTP id o14so620506dan.11
        for <linux-ext4@vger.kernel.org>; Tue, 12 Jun 2012 23:44:16 -0700 (PDT)
In-Reply-To: <1339479907-19088-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-06-11, at 11:45 PM, Theodore Ts'o wrote:
> Add two tests, f_orphan_indirect_inode, and f_orphan_extents_inode,
> which tests the bug fixes in the two previous commits:
> 
> e2fsck: update global free blocks/inodes count when truncating orphan inodes
> libext2fs: fix block iterator for extents when truncating inodes
> 
> diff --git a/tests/f_orphan_indirect_inode/expect.1 b/tests/f_orphan_indirect_inode/expect.1
> new file mode 100644
> index 0000000..33cdd65
> --- /dev/null
> +++ b/tests/f_orphan_indirect_inode/expect.1
> @@ -0,0 +1,2 @@
> +test_filesys: clean, 12/16 files, 21/100 blocks
> +Exit status is 0

Hmm, this doesn't appear to be truncating an orphan inode, unlike
the f_orphan_extent_inode test is doing?

Cheers, Andreas
--
Andreas Dilger                       Whamcloud, Inc.
Principal Lustre Engineer            http://www.whamcloud.com/




