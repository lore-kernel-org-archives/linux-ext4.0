From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: fine grain block allocation API request
Date: Wed, 13 Aug 2014 22:38:06 +0200
Message-ID: <30E81BCD-E53F-412D-BA78-8061176A5792@dilger.ca>
References: <87bnrosdu6.fsf@openvz.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Lukas Czerner <lczerner@redhat.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:33503 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbaHMUiK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Aug 2014 16:38:10 -0400
Received: by mail-wg0-f48.google.com with SMTP id x13so245926wgg.19
        for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2014 13:38:09 -0700 (PDT)
In-Reply-To: <87bnrosdu6.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

One question to ask is whether a goal inode allocation API would be enough
or if you need specific block allocation, or both? If you could start
allocation at a specific inode, would that be enough to avoid the messy
code below?

Cheers, Andreas

> On Aug 13, 2014, at 15:45, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> 
> 
> Currently we have not public API for block allocation from some
> specific region (group/flex_group/blk_range).  The only existing
> hack is available in migrate.c where we use goal_inode for
> ext4_new_inode().
> 
> In fact this tend make some specific task very complicated.
> For example my e4defrag2 utility try to compact small files from
> one group together. In order to allocate blocks from given group
> I have to perform number of crazy stuff, such as:
> 1) Prepare cache of directories according to it's group (where dir_inode
> is placed)
> 
> 2) Try to allocate local donor file with local blocks (from given group)
>   Pseudo code of donor creation procedure :
>   int find_donor(int grp, ...) {
>       for (i = 0; i = dir_cache[grp].num;i++) {
>           fd = openat(dir_cache[grp].fd[i], "donor", O_CREAT|flags,... )
>           fstat(fd, &stat);
>           if (inode_group(stat->st_ino) != grp)
>              goto next_candidate;
>           do_falloc(fd, size);
>           /* Check that blocks we allocated are belongs to group we want*/
>           if (!is_block_local(fd, group))
>              goto next_candidate;
>           goto found_donor;
>          .....
>       }
>      .....
>   }
> All this machinery is very ugly, unstable and increase code-base about
> 500-700 lines of code. And I want to ask you why we do not have such
> API? AFAIR this API was requested several times, but it was rejected.
> I do understand that this is not good idea to allow unprivileged user to
> manipulate block allocator, but IMHO we can hide it under CAP_RESOURCES
> or CAP_ADMIN.
> Please tell be your opinion. I'll happy to implement that ioctl.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
