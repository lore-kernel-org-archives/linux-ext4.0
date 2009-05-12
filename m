From: ranjith kannikara <ranjithkannikara@gmail.com>
Subject: Re: Help to edit inode content
Date: Tue, 12 May 2009 21:32:16 +0530
Message-ID: <20aa8c370905120902o71ab9adflb8619e2a9ae343d0@mail.gmail.com>
References: <20aa8c370905120847j4b19175akbdcafc0db2004567@mail.gmail.com>
	 <3e8340490905120856w62c6c5cexa247937bf7e84002@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Bryan Donlan <bdonlan@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:11342 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbZELQCP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 May 2009 12:02:15 -0400
In-Reply-To: <3e8340490905120856w62c6c5cexa247937bf7e84002@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 12, 2009 at 9:26 PM, Bryan Donlan <bdonlan@gmail.com> wrote:
> On Tue, May 12, 2009 at 11:47 AM, ranjith kannikara
> <ranjithkannikara@gmail.com> wrote:
>> Hi,
>> I am a computer science engineering student. We have started a project
>> to make an application to recover deleted files from an ext3
>> filesystem. For that we have a doubt . Can we edit the inode content?
>> ie the recovery will be robust if we could edit the inode contents and
>> give the pointer address manually or through a code. The inode is
>> being created in the kernel mode and is it possible to edit those
>> contents if the code is allowed to have the kernel mode permissions..?
>
> You'd probably be best off doing this in userspace, with the
> filesystem unmounted.
Of course we are doing it from another filesystem. ie only after
unmounting the filesystem which is being worked on. in some case we
make image of the filesystem to ensure security of data.
> Generally speaking, don't attempt to alter the filesystem from
> userspace while it is mounted.
>
But we would like to know whether it is possible to edit the inode
because it will make the recovery easy and robust. ie he know the
details of the inode of the file which had been deleted is it possible
to edit the content of that inode with the pointers of the deleted
file.?
Regards
Ranju.



-- 
http://www.ranjithkannikara.blogspot.com/
