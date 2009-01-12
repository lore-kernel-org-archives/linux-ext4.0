From: "Sandeep K Sinha" <sandeepksinha@gmail.com>
Subject: Re: Copying Data Blocks
Date: Mon, 12 Jan 2009 12:18:01 +0530
Message-ID: <37d33d830901112248r1616865aye537b5ff3f72780f@mail.gmail.com>
References: <2d08ef090901060236p46d4d396x797e4bceb24a2a34@mail.gmail.com>
	 <804dabb00901110715x2baf84e8kc0fc5d6fa2512fe8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Rohit Sharma" <imreckless@gmail.com>,
	ext4 <linux-ext4@vger.kernel.org>,
	Kernelnewbies <kernelnewbies@nl.linux.org>
To: "Peter Teoh" <htmldeveloper@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:59700 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbZALGsD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Jan 2009 01:48:03 -0500
Received: by wa-out-1112.google.com with SMTP id v27so5519154wah.21
        for <linux-ext4@vger.kernel.org>; Sun, 11 Jan 2009 22:48:01 -0800 (PST)
In-Reply-To: <804dabb00901110715x2baf84e8kc0fc5d6fa2512fe8@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Peter,

As our work veery tightly couples with the FS for our intial
implementation and we are working around with the inodes, we will
require to work at the filesystem level itself.
Though it may not be very feasible, but we will try to push everything
to the blockdev level once our base system is up and running.

Thanks a lot for your finding, I went through it and found that it
will be useful, but with some kind of tweaking around here and there.

We have taken note of the links that you have provided.

Thanks again.
On Sun, Jan 11, 2009 at 8:45 PM, Peter Teoh <htmldeveloper@gmail.com> wrote:
> Sorry.....some mistakes...a resent:
>
> Here are some tips on the blockdevice API:
>
> http://lkml.org/lkml/2006/1/24/287
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2006-01/msg09388.html
>
> as indicated, documentation is rather sparse in this area.
>
> not sure if anyone else have a summary list of blockdevice API and its
> explanation?
>
> not wrt the following "cleanup patch", i am not sure how the API will change:
>
> http://lwn.net/Articles/304485/
>
> thanks.
>
> On Tue, Jan 6, 2009 at 6:36 PM, Rohit Sharma <imreckless@gmail.com> wrote:
>>
>> I want to read data blocks from one inode
>> and copy it to other inode.
>>
>> I mean to copy data from data blocks associated with one inode
>> to the data blocks associated with other inode.
>>
>> Is that possible in kernel space.?
>> --
>
>
>
> --
> Regards,
> Peter Teoh
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
