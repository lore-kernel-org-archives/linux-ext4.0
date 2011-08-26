From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: [URGENT PATCH] ext4: fix potential deadlock in ext4_evict_inode()
Date: Fri, 26 Aug 2011 09:58:45 -0700
Message-ID: <CAFgt=MBAGurdr6Cce9zZ5sWX=BQz4RXJ4HHVWuUvM+gPcgpkFg@mail.gmail.com>
References: <E1QwnAu-00087H-8X@tytso-glaptop.cam.corp.google.com>
	<20110826073507.GZ3162@dastard>
	<20110826084403.GA3162@dastard>
	<4E576152.9060405@tao.ma>
	<20110826092426.GB3162@dastard>
	<4E57670B.6070205@tao.ma>
	<20110826155234.GC5176@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tao Ma <tm@tao.ma>, Dave Chinner <david@fromorbit.com>,
	linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:6246 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab1HZQ6s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Aug 2011 12:58:48 -0400
Received: from hpaq5.eem.corp.google.com (hpaq5.eem.corp.google.com [172.25.149.5])
	by smtp-out.google.com with ESMTP id p7QGwlhm020647
	for <linux-ext4@vger.kernel.org>; Fri, 26 Aug 2011 09:58:47 -0700
Received: from gxk7 (gxk7.prod.google.com [10.202.11.7])
	by hpaq5.eem.corp.google.com with ESMTP id p7QGvqBx007006
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Fri, 26 Aug 2011 09:58:46 -0700
Received: by gxk7 with SMTP id 7so3478682gxk.7
        for <linux-ext4@vger.kernel.org>; Fri, 26 Aug 2011 09:58:45 -0700 (PDT)
In-Reply-To: <20110826155234.GC5176@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On Fri, Aug 26, 2011 at 8:52 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Fri, Aug 26, 2011 at 05:27:39PM +0800, Tao Ma wrote:
>> No, it doesn't mean the ext4_truncate. But another race pasted below=
=2E
>>
>> Flush inode's i_completed_io_list before calling ext4_io_wait to
>> prevent the following deadlock scenario: A page fault happens while
>> some process is writing inode A. During page fault,
>> shrink_icache_memory is called that in turn evicts another inode
>> B. Inode B has some pending io_end work so it calls ext4_ioend_wait(=
)
>> that waits for inode B's i_ioend_count to become zero. However, inod=
e
>> B's ioend work was queued behind some of inode A's ioend work on the
>> same cpu's ext4-dio-unwritten workqueue. As the ext4-dio-unwritten
>> thread on that cpu is processing inode A's ioend work, it tries to
>> grab inode A's i_mutex lock. Since the i_mutex lock of inode A is
>> still hold before the page fault happened, we enter a deadlock.
>
> ... but that shouldn't be a problem since we're not holding A's
> i_mutex at this point, right? =A0Or am I missing something?
I think it is possible that we are holding A's i_mutex lock if the page
fault happens while we are writing inode A. The problem is if we call
ext4_evict_inode for inode B during the page fault handling and we
just call ext4_ioend_wait() to wait for inode B's i_ioend_count to
become zero, we rely on the ext4-dio-unwritten worker thread to
finish any queued work at some time. But as mentioned in the change
commit log, B's io_end work may be queued after A's work on the
same cpu. Since A's i_mutex lock may be still hold during the page
fault time, the ext4-dio-unwritten worker thread can't make progress.

Now thinking about an alternative approach to resolve the deadlock
mentioned above, maybe we can use mutex_trylock() in
ext4_end_io_work() and if we can't grab the mutex lock for an inode,
just requeue the work to the end of workqueue?

Jiaying
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 - Ted
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
