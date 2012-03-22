From: Akshay Nehe <akshaynehe785@gmail.com>
Subject: Re: Required help for understanding ext4 block allocation
Date: Thu, 22 Mar 2012 20:52:31 +0530
Message-ID: <CA+tw96CP=Psbmvn5zn5=SD0BteWjcxAwDYqg0Jfu1-dpTfSf0g@mail.gmail.com>
References: <CA+tw96DSaJH50o1F4sW9XMnmPD8dFO9VCyvK4tbsLFqfgK9CWQ@mail.gmail.com>
	<20120316091810.GB24821@quack.suse.cz>
	<CA+tw96C9kRHYhiQoyRRH8U_gPtcXZimJL0=kHBX4m7dLrXwaPg@mail.gmail.com>
	<20120322141155.GB19587@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:54251 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab2CVPWd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Mar 2012 11:22:33 -0400
Received: by wejx9 with SMTP id x9so1912594wej.19
        for <linux-ext4@vger.kernel.org>; Thu, 22 Mar 2012 08:22:31 -0700 (PDT)
In-Reply-To: <20120322141155.GB19587@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/22/12, Jan Kara <jack@suse.cz> wrote:
>   Hello,
>
> On Thu 22-03-12 18:54:26, Akshay Nehe wrote:
>> Yes, i got extents as you have suggested, but one thing i found that
>> each time modification occurs on any file from ext4 file system then
>> kernel deallocates all current blocks and allocate new blocks and
>> write modified data on newly allocated blocks.
>   That is not true. Why do you think it is? Maybe you are modifying the
> file with something like a text editor? That certainly truncates the old
> file and writes a new one. But generally ext4 supports overwriting.
>
Yes, i m using vim editor to modify files. Actually due to this inode
number of file is changing each time after modification.
>> So by tracing kernel code i got some useful functions, for
>> deallocation: ext4_free_blocks, for allocation: ext4_map_blocks, but
>> found difficult to analyse each of them. Can anyone suggest correct
>> functions which actually dose allocation and deallocation?
>   Ext4 uses multiblock allocator which is in fs/ext4/mballoc.c. In
> particular function allocating blocks in ext4_mb_new_blocks(), function
> freeing blocks is ext4_free_blocks(). But you will need to understand most
> of mballoc.c to understand how mballoc works. You can read comments in the
> beginning of the file to understand some basics about mballoc. You can
> also read some basics from by presentation about ext4 at Linux Kongress in
> 2009 (http://www.linux-kongress.org/2009/slides/ext4+btrfs_jan_kara.pdf).
>
> 								Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
Thanks for help, I will go through both mballoc file and your presentation file.

-- 
Regards,
Akshay Nehe.
