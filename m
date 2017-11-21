From: Ashlie Martinez <ashmrtn@utexas.edu>
Subject: Re: ext4 fix for interaction between i_size, fallocate, and delalloc
 after a crash
Date: Tue, 21 Nov 2017 10:17:15 -0600
Message-ID: <CAFk8rvZRHaQH1DBXw_DQEkjVtn8ur4jRX97U5PqqDTMi7P5gzg@mail.gmail.com>
References: <CAFk8rvZYEN4kGP9dF_FQxhP+UGfAY55uKrdsGr4-6ztWSoUp6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: Theodore Tso <tytso@mit.edu>,
        Vijay Chidambaram <vvijay03@gmail.com>,
        Ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:36016 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750794AbdKUQRQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Nov 2017 11:17:16 -0500
Received: by mail-ua0-f177.google.com with SMTP id w47so8619304uah.3
        for <linux-ext4@vger.kernel.org>; Tue, 21 Nov 2017 08:17:16 -0800 (PST)
In-Reply-To: <CAFk8rvZYEN4kGP9dF_FQxhP+UGfAY55uKrdsGr4-6ztWSoUp6w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

I wasn't sure if this got buried under other things in your inbox, so
I just wanted to ping you about it again (also apologies that my
original email was so long) :)

On Fri, Nov 17, 2017 at 9:43 AM, Ashlie Martinez <ashmrtn@utexas.edu> wrote:
> Hi Ted,
>
> I've been looking into the bug Amir Goldstein found (way back in
> August) as well as the patch you created for it. After examining both
> the patch and some the code for delayed allocation and fallocate, I
> find that I don't understand what is actually going on to cause the
> bug. I'll outline what I've found so far below. Maybe you can help me
> fill in some of the gaps or point me in the right direction if I've
> made a mistake.
>
> Delayed allocation:
> Delayed allocation is enabled if the `da` set of aops is used in the
> ext4 code (set sometime close to file system mount time). When a
> delayed allocation write occurs, a function higher up the storage
> stack calls into ext4_da_write_begin. This function will go through
> the rb tree representing the extents for a file and either 1. find
> blocks already allocated that can be used for the write or 2. reserve
> space in the extent tree. The bh returned from this function informs
> later code about whether preexisting blocks were found or if space was
> reserved. ext4_da_write_begin also appears to create a journal handle
> (with a handle on the stack), but never closes the handle unless an
> error occurs.
>
> After ext4_da_write_begin, control returns to some functions higher in
> the storage stack before going into ext4_da_write_end. This function
> conditionally updates the i_disksize value of the file if non-delay
> allocated extents were used and the file size was extended. It also
> closes the journal handle opened in ext4_da_begin write. Furthermore,
> it calls generic_write_end.
>
> generic_write_end updates the i_size value if needed, and also marks
> the inode as dirty. By marking the inode as dirty, a bdi_writeback is
> scheduled later that will call ext4_writepages.
>
> ext4_writepages resolves the delayed allocation block mappings and
> updates i_disksize as needed. Each update to the extent tree on disk
> and i_disksize is done using a single journal handle.
>
> fallocate (just fallocate to change the file size, not to collapse
> ranges or anything else):
> fallocate will check if offset + len > the current i_size value and,
> if it is, set new_size. Later, in a call to ext4_alloc_file_blocks
> (which modifies the extent tree, using a journal handle it makes, for
> the fallocate call), new_size is checked to determine if i_disksize
> needs to be updated, and, if it does, it writes that update to the
> current journal handle. Otherwise, no update to i_disksize is made.
>
> zero_range:
> The main portion of zero_range appears to be copy/paste from fallocate
> code. However, one notable difference is that is has the possibility
> of opening three different journal handles (2 from calls to
> ext4_alloc_file_blocks, and one later in zero_range for writing out
> blocks and the updated inode size. In this function, new_size is used
> to update i_disksize in both the calls to ext4_alloc_file_blocks and
> at the bottom of the function (so they will all either update
> i_disksize or not update it).
>
>
> What I don't really understand from the above is how the patch for
> Amir's bug fixes the bug. It appears that what is happening in the bug
> is an old value of i_disksize is being persisted while a new extent
> tree is being persisted. I am confused how adding an extra clause to
> the if statement in fallocate and zero_range (which causes new_size to
> be set on more conditions) later translates into correct behavior. It
> seems like in order to get incorrect behavior in the first place, you
> would have to have the file size updated in a different journal
> transaction than the extent tree so that, on replay, one is updated
> but the other is not. Another piece of the puzzle I am missing is when
> the extent tree is journaled in fallocate and zero_range. I can
> clearly see the i_disksize updates being journaled in the call to
> ext4_mark_inode_dirty, but it doesn't appear that that function also
> persists the extent tree.
>
> Could you give me any clarifications on when the extent tree is
> journaled and some more of the logic behind the patch for Amir's bug?
>
> Thanks,
> Ashlie
