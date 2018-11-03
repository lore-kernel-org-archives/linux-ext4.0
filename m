Return-Path: <SRS0=UtPy=NO=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33654 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726904AbeKDGHb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 4 Nov 2018 01:07:31 -0500
Date: Sat, 3 Nov 2018 16:55:00 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Vasily Averin <vvs@virtuozzo.com>
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org,
        Yongqiang Yang <xiaoqiangnk@gmail.com>,
        Yongqiang Yang <yangyongqiang01@baidu.com>
Subject: Re: [PATCH v2 03/11] ext4 resize: brelse() cleanup in
 add_new_gdb_meta_bg()
Message-ID: <20181103205500.GG28850@thunk.org>
References: <cover.1540935522.git.vvs@virtuozzo.com>
 <34d94824-834c-fb72-2f93-01e9036e9b38@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34d94824-834c-fb72-2f93-01e9036e9b38@virtuozzo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 31, 2018 at 12:57:55AM +0300, Vasily Averin wrote:
> gdb_bh must be released in case of errors before update of s_group_desc
> but it must not be released after update of group descriptors
> because in this case bh can be used later.
> 
> Fixes 01f795f9e0d6 ("ext4: add online resizing support for meta_bg ...") # 3.7
> 
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>

Thanks, applied.  The commit description is not accurate (I suspect it
was obsoleted when your patch for RHEL was forward ported) do I
dropped it.

I adjusted the patch summary to be:

    ext4: add missing brelse() add_new_gdb_meta_bg()'s error path

The commments for the Fixes and Cc: stable@kernel.org also apply.

							- Ted
								
