From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: [URGENT PATCH] ext4: fix potential deadlock in ext4_evict_inode()
Date: Tue, 30 Aug 2011 18:15:23 -0700
Message-ID: <CAFgt=MBOnhCQG+dmHa1crFKU4+XL6RyihnMq=-O8UuK4yEEXnA@mail.gmail.com>
References: <E1QwnAu-00087H-8X@tytso-glaptop.cam.corp.google.com>
	<20110826073507.GZ3162@dastard>
	<20110826084403.GA3162@dastard>
	<4E576152.9060405@tao.ma>
	<20110826092426.GB3162@dastard>
	<4E57670B.6070205@tao.ma>
	<20110826155234.GC5176@thunk.org>
	<CAFgt=MBAGurdr6Cce9zZ5sWX=BQz4RXJ4HHVWuUvM+gPcgpkFg@mail.gmail.com>
	<20110826202251.GD5176@thunk.org>
	<CAFgt=MA+YokAz4Nzd+OFk7XTDYXMbjXv8G_oXFieDMDr-u4RAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tao Ma <tm@tao.ma>, Dave Chinner <david@fromorbit.com>,
	linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:23662 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab1HaBP1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Aug 2011 21:15:27 -0400
Received: from hpaq1.eem.corp.google.com (hpaq1.eem.corp.google.com [172.25.149.1])
	by smtp-out.google.com with ESMTP id p7V1FPQ2031247
	for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 18:15:25 -0700
Received: from gwm11 (gwm11.prod.google.com [10.200.13.11])
	by hpaq1.eem.corp.google.com with ESMTP id p7V1F7LB031208
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 18:15:23 -0700
Received: by gwm11 with SMTP id 11so199782gwm.2
        for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 18:15:23 -0700 (PDT)
In-Reply-To: <CAFgt=MA+YokAz4Nzd+OFk7XTDYXMbjXv8G_oXFieDMDr-u4RAg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=46YI, I just sent out a patch to the linux-ext4@ that uses
mutex_trylock() in ext4_end_io_work() and removes the i_mutex
lock and ext4_flush_completed_IO() in ext4_evict_inode():
http://www.spinics.net/lists/linux-ext4/msg27407.html

Jiaying

On Fri, Aug 26, 2011 at 10:17 PM, Jiaying Zhang <jiayingz@google.com> w=
rote:
> On Fri, Aug 26, 2011 at 1:22 PM, Ted Ts'o <tytso@mit.edu> wrote:
>> On Fri, Aug 26, 2011 at 09:58:45AM -0700, Jiaying Zhang wrote:
>>> Now thinking about an alternative approach to resolve the deadlock
>>> mentioned above, maybe we can use mutex_trylock() in
>>> ext4_end_io_work() and if we can't grab the mutex lock for an inode=
,
>>> just requeue the work to the end of workqueue?
>>
>> Good idea! =A0That should speed up work queue processing in general,=
 I
>> think.
>>
>> The downside is that inodes that currently locked might take longer =
to
>> complete. =A0In the case of fsync() we'll just force the I/O complet=
ion
>> to happen in the context of the fsync'ing process, so I don't think =
it
>> should be a problem in practice I think.
>>
> Ted,
>
> I am working on a patch to use mutex_trylock() in ext4_end_io_work()
> so that we can fix the described deadlock without needing to call
> mutex_lock() and =A0ext4_flush_completed_IO() in ext4_evict_inode().
> I run into some problem while testing it. Given that the deadlock my
> original patch intended to fix only exists with dioread_nolock enable=
d
> but the lockdep issue happens in all of cases, I think we should roll
> that part back as you have planned. I am going to send a separate pat=
ch
> later to fix the deadlock issue once I resolved the problem found in
> my test.
>
> Jiaying
>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0- Ted
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
