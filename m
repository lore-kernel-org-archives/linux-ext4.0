From: "Peter Teoh" <htmldeveloper@gmail.com>
Subject: Re: ext2_block_alloc_info
Date: Sun, 21 Dec 2008 09:25:45 +0800
Message-ID: <804dabb00812201725r304bed36ufc56ebc2393e2299@mail.gmail.com>
References: <2d08ef090812200743o47cd4abdwd9915653f6f4f3f7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Kernelnewbies <kernelnewbies@nl.linux.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: "Rohit Sharma" <imreckless@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:62873 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbYLUBZr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Dec 2008 20:25:47 -0500
Received: by yw-out-2324.google.com with SMTP id 9so559621ywe.1
        for <linux-ext4@vger.kernel.org>; Sat, 20 Dec 2008 17:25:45 -0800 (PST)
In-Reply-To: <2d08ef090812200743o47cd4abdwd9915653f6f4f3f7@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 20, 2008 at 11:43 PM, Rohit Sharma <imreckless@gmail.com> wrote:
> A little confusion.
>
> Just refer this structure in linux/ext2_fs_sb.h
>
> struct ext2_block_alloc_info {
>  46        /* information about reservation window */
>  47        struct ext2_reserve_window_node rsv_window_node;
>  48        /*
>  49         * was i_next_alloc_block in ext2_inode_info
>  50         * is the logical (file-relative) number of the
>  51         * most-recently-allocated block in this file.
>  52         * We use this for detecting linearly ascending allocation requests.
>  53         */
>  54        __u32                   last_alloc_logical_block;

if i interpret the meaning of "file-relative logical number"
correctly, and since one-file-one-inode concept, then it means that it
should mean inode-relative logical block number.

>  55        /*
>  56         * Was i_next_alloc_goal in ext2_inode_info
>  57         * is the *physical* companion to i_next_alloc_block.
>  58         * it the the physical block number of the block which was

> inode1 has logical blocks 0 1 2 , physical 22 23 24
> inode2 has logical blocks 0 1 2 , physical 34 35 50
>

as per comment above, the sequence above looks likely, but then this
is my guess again.

-- 
Regards,
Peter Teoh

Ernest Hemingway - "Never mistake motion for action."
