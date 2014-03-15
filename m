From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: Re: [PATCH] ext4: initialize multi-block allocator before checking
 block descriptors
Date: Sun, 16 Mar 2014 03:54:34 +0400
Message-ID: <CAG5DWoj0pYD8O17qw_-MK+JX_hsFj04ReUPztShmKWzz45gRbQ@mail.gmail.com>
References: <20140315214029.GA18873@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f41.google.com ([209.85.216.41]:46191 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590AbaCOXye (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Mar 2014 19:54:34 -0400
Received: by mail-qa0-f41.google.com with SMTP id j5so4025865qaq.14
        for <linux-ext4@vger.kernel.org>; Sat, 15 Mar 2014 16:54:34 -0700 (PDT)
In-Reply-To: <20140315214029.GA18873@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 16, 2014 at 1:40 AM,  <tytso@mit.edu> wrote:
>>With EXT4FS_DEBUG ext4_count_free_clusters() will call
>>ext4_read_block_bitmap() without s_group_info initialized, so we need to
>>initialize multi-block allocator before.
>>
>>And we can't initialize multi-block allocator without group descriptors,
>>since it use them.
>>Also we need to install s_op before initializing multi-block allocator,
>>because in ext4_mb_init_backend() new inode is created.
>
> I've had to drop this patch because it's causing a series of bigalloc
> failures.  I'll take a closer look at this later, but I wantd to give
> you a heads up.

Thanks Ted, I'll take a look.
Are you talking about xfs-tests failures?

>
>                                         - Ted
>
>
>



-- 
Respectfully
Azat Khuzhin
