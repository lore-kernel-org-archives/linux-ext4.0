From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: fine grain block allocation API request
Date: Wed, 13 Aug 2014 17:45:21 +0400
Message-ID: <87bnrosdu6.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:60166 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaHMNpZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Aug 2014 09:45:25 -0400
Received: by mail-lb0-f178.google.com with SMTP id c11so8163774lbj.23
        for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2014 06:45:23 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Currently we have not public API for block allocation from some
specific region (group/flex_group/blk_range).  The only existing
hack is available in migrate.c where we use goal_inode for
ext4_new_inode().

In fact this tend make some specific task very complicated.
For example my e4defrag2 utility try to compact small files from
one group together. In order to allocate blocks from given group
I have to perform number of crazy stuff, such as:
1) Prepare cache of directories according to it's group (where dir_inode
 is placed)

2) Try to allocate local donor file with local blocks (from given group)
   Pseudo code of donor creation procedure :
   int find_donor(int grp, ...) {
       for (i = 0; i = dir_cache[grp].num;i++) {
           fd = openat(dir_cache[grp].fd[i], "donor", O_CREAT|flags,... )
           fstat(fd, &stat);
           if (inode_group(stat->st_ino) != grp)
              goto next_candidate;
           do_falloc(fd, size);
           /* Check that blocks we allocated are belongs to group we want*/
           if (!is_block_local(fd, group))
              goto next_candidate;
           goto found_donor;
          .....
       }
      .....
   }
All this machinery is very ugly, unstable and increase code-base about
500-700 lines of code. And I want to ask you why we do not have such
API? AFAIR this API was requested several times, but it was rejected.
I do understand that this is not good idea to allow unprivileged user to
manipulate block allocator, but IMHO we can hide it under CAP_RESOURCES
or CAP_ADMIN.
Please tell be your opinion. I'll happy to implement that ioctl.
