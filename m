From: "Sandeep K Sinha" <sandeepksinha@gmail.com>
Subject: Re: ext2_block_alloc_info
Date: Sun, 21 Dec 2008 01:10:47 +0530
Message-ID: <37d33d830812201140r1bc64a83kdc3f27b3fa88cc1b@mail.gmail.com>
References: <2d08ef090812200743o47cd4abdwd9915653f6f4f3f7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Kernelnewbies <kernelnewbies@nl.linux.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: "Rohit Sharma" <imreckless@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:7782 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbYLTTks (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Dec 2008 14:40:48 -0500
Received: by rv-out-0506.google.com with SMTP id k40so1386551rvb.1
        for <linux-ext4@vger.kernel.org>; Sat, 20 Dec 2008 11:40:47 -0800 (PST)
In-Reply-To: <2d08ef090812200743o47cd4abdwd9915653f6f4f3f7@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Rohit,

On Sat, Dec 20, 2008 at 9:13 PM, Rohit Sharma <imreckless@gmail.com> wrote:
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
>  55        /*
>  56         * Was i_next_alloc_goal in ext2_inode_info
>  57         * is the *physical* companion to i_next_alloc_block.
>  58         * it the the physical block number of the block which was
> most-recentl
>  59         * allocated to this file.  This give us the goal (target)
> for the next

Look at the comment, this clearly suggests that its a file specific information.
So, its specific to inode.

>  60         * allocation when we detect linearly ascending requests.
>  61         */

It can be only to a file, as for the file system it is already ascending.

>  62        ext2_fsblk_t            last_alloc_physical_block;
>  63};
>
>
> this information is maintained by ext2 for every inode.
>
> here  last_alloc_logical_block is for every inode or its for filesystem.
>

inode.

> I mean if we are allocating blocks for inode
> it can be block no.  0 to n logically
> and physically like 23 24 25 34 36 40 41 42
>
> i mean to say
>
> is it like
>
> inode1 has logical blocks 1 2 3 , physical 22 23 24
> inode2 has logical blocks 4 5 6 , physical 34 35 50
>

This is correct.
> OR
>
> inode1 has logical blocks 0 1 2 , physical 22 23 24
> inode2 has logical blocks 0 1 2 , physical 34 35 50
>

You cannot have the same logical block assigned to two inodes with
diff physical blocks, probably. Doesn't make sense to me.
> ??
>
> --
> To unsubscribe from this list: send an email with
> "unsubscribe kernelnewbies" to ecartis@nl.linux.org
> Please read the FAQ at http://kernelnewbies.org/FAQ
>
>



-- 
Regards,
Sandeep.





 	
"To learn is to change. Education is a process that changes the learner."
