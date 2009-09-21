From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: kernel BUG at fs/ext4/move_extent.c:1317!
Date: Mon, 21 Sep 2009 15:06:15 -0400
Message-ID: <87f94c370909211206q6a265d13r7ea868900dd013ee@mail.gmail.com>
References: <37d33d830909200625i574f3688vb0d5b82183ba2476@mail.gmail.com>
	 <6149e97b0909201822y5f29d091jbc00b740244f39a8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: SandeepKsinha <sandeepksinha@gmail.com>,
	ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:13694 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbZIUTGL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Sep 2009 15:06:11 -0400
Received: by qw-out-2122.google.com with SMTP id 5so1024960qwd.37
        for <linux-ext4@vger.kernel.org>; Mon, 21 Sep 2009 12:06:15 -0700 (PDT)
In-Reply-To: <6149e97b0909201822y5f29d091jbc00b740244f39a8@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

resend - I inadvertently was not in plain text mode before.

On Sun, Sep 20, 2009 at 9:22 PM, Peng Tao <bergwolf@gmail.com> wrote:
> Hi, Sandeep,
>
> On Sun, Sep 20, 2009 at 9:25 PM, SandeepKsinha <sandeepksinha@gmail.com> wrote:
>> Hi Akira/others,
>>
>> I hit the following assert kernel BUG at fs/ext4/move_extent.c:1317!
>>
>> The file I was playing around with was a simple holey file created like:
>>
>> [/mnt]
>> [18:35:13 sinhas]$ dd if=/dev/zero of=/mnt/ext4image seek=1000 count=5
>> 5+0 records in
>> 5+0 records out
>> 2560 bytes (2.6 kB) copied, 0.000146457 s, 17.5 MB/s
>>
>> I am using v2.6.31. I have seen some patchsets a couple of days from
>> you. Does any of them address any similar problem.?
> Yes. The BUG_ON is unnecessary and is removed in the latest mainline
> kernel. Please refer to commit
> daea696dbac0e33af3cfe304efbfb8d74e0effe6 for details.
    <snip>
>   --
>   Cheers,
>    Peng Tao

Ted,

I think the few small ext4_move_ext() / e4defrag related fixes for
sparse files to work should get pushed to stable.  I don't know if
this is the only one or if there are others.

Greg
