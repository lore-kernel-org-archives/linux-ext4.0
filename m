From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: Re: undelete still opened file
Date: Fri, 17 Oct 2008 19:32:50 +0530
Message-ID: <ea11fea30810170702t295fe37dw43e33e0105cbe73@mail.gmail.com>
References: <20081017120852.1f04dc36.taeuber@bbaw.de>
	 <ea11fea30810170333n4ba9a681l7b64862834899aac@mail.gmail.com>
	 <20081017143311.52d50a23.taeuber@bbaw.de>
	 <20081017132443.GA8755@mit.edu>
	 <20081017153957.28a4dd67.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Tso" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "=?ISO-8859-1?Q?Lars_T=E4uber?=" <taeuber@bbaw.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.188]:26695 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbYJQOCx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Oct 2008 10:02:53 -0400
Received: by ti-out-0910.google.com with SMTP id b6so298188tic.23
        for <linux-ext4@vger.kernel.org>; Fri, 17 Oct 2008 07:02:50 -0700 (PDT)
In-Reply-To: <20081017153957.28a4dd67.taeuber@bbaw.de>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 17, 2008 at 7:09 PM, Lars T=E4uber <taeuber@bbaw.de> wrote:
> Hi Theodore,
>
>
> Theodore Tso <tytso@mit.edu> schrieb:
>> On Fri, Oct 17, 2008 at 02:33:11PM +0200, Lars T=E4uber wrote:
>> > Is the space of the file on the underlying block device already
>> > marked as free? Or does this happen after all processes have close=
d
>> > all file descriptors pointing to the file?
>>
>> No, the space on the file is not yet marked as free.  *However* for
>> ext3 and ext4, the inode has been placed on the orphaned inode list,
>> so that if the system crashes, part of the journal recovery process
>> will at that point free the blocks.
>
> not that it is a way I would go, but theoretically: I could provoke a=
 crash and mount the ext3 filesystem as ext2 and restore the file?

Errr.... If I read the code correctly, once deleted the inode is added
to the orphan list and on recovery this orphan list is traversed and
iput will be called on each of the inodes. So even a crash will not
restore your inode on the contrary *it will make sure that the inode
is deleted*.


>
>> > I really want to undo the deletion. (get a link/name connected to
>> > the root inode of the file again) Is there a way to do this?
>>
>> Not currently using ext3/ext4, no.

Isn't it possible to some extent using ext3grep for ext3 ????


  There would have to be an entirely
>> new system call or other userspace interface for something like this=
=2E
>
> Is this planned?
>
> But a solution should be independent of the real filesystem.

No as I said...depending on the nature of filesystem it may be write
in place or it might write to a new block every time like logfs.  So
it is very much filesystem dependant.


Thanks -
Manish

>Because the file is still somewhere in the ram and represented in linu=
x vfs, isn't it?



> It only needs to be copied/recreated on to a (different) filesystem s=
omehow.
>
> Regards
> Lars
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
