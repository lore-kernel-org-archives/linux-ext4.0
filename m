From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: [URGENT PATCH] ext4: fix potential deadlock in ext4_evict_inode()
Date: Fri, 26 Aug 2011 22:17:52 -0700
Message-ID: <CAFgt=MA+YokAz4Nzd+OFk7XTDYXMbjXv8G_oXFieDMDr-u4RAg@mail.gmail.com>
References: <E1QwnAu-00087H-8X@tytso-glaptop.cam.corp.google.com>
	<20110826073507.GZ3162@dastard>
	<20110826084403.GA3162@dastard>
	<4E576152.9060405@tao.ma>
	<20110826092426.GB3162@dastard>
	<4E57670B.6070205@tao.ma>
	<20110826155234.GC5176@thunk.org>
	<CAFgt=MBAGurdr6Cce9zZ5sWX=BQz4RXJ4HHVWuUvM+gPcgpkFg@mail.gmail.com>
	<20110826202251.GD5176@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tao Ma <tm@tao.ma>, Dave Chinner <david@fromorbit.com>,
	linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:14027 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab1H0FR4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Aug 2011 01:17:56 -0400
Received: from wpaz37.hot.corp.google.com (wpaz37.hot.corp.google.com [172.24.198.101])
	by smtp-out.google.com with ESMTP id p7R5HsF4016300
	for <linux-ext4@vger.kernel.org>; Fri, 26 Aug 2011 22:17:54 -0700
Received: from gxk1 (gxk1.prod.google.com [10.202.11.1])
	by wpaz37.hot.corp.google.com with ESMTP id p7R5HrqC031885
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Fri, 26 Aug 2011 22:17:53 -0700
Received: by gxk1 with SMTP id 1so3616375gxk.38
        for <linux-ext4@vger.kernel.org>; Fri, 26 Aug 2011 22:17:53 -0700 (PDT)
In-Reply-To: <20110826202251.GD5176@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 26, 2011 at 1:22 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Fri, Aug 26, 2011 at 09:58:45AM -0700, Jiaying Zhang wrote:
>> Now thinking about an alternative approach to resolve the deadlock
>> mentioned above, maybe we can use mutex_trylock() in
>> ext4_end_io_work() and if we can't grab the mutex lock for an inode,
>> just requeue the work to the end of workqueue?
>
> Good idea! =A0That should speed up work queue processing in general, =
I
> think.
>
> The downside is that inodes that currently locked might take longer t=
o
> complete. =A0In the case of fsync() we'll just force the I/O completi=
on
> to happen in the context of the fsync'ing process, so I don't think i=
t
> should be a problem in practice I think.
>
Ted,

I am working on a patch to use mutex_trylock() in ext4_end_io_work()
so that we can fix the described deadlock without needing to call
mutex_lock() and  ext4_flush_completed_IO() in ext4_evict_inode().
I run into some problem while testing it. Given that the deadlock my
original patch intended to fix only exists with dioread_nolock enabled
but the lockdep issue happens in all of cases, I think we should roll
that part back as you have planned. I am going to send a separate patch
later to fix the deadlock issue once I resolved the problem found in
my test.

Jiaying

> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0- Ted
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
