From: Michal Schmidt <mschmidt@redhat.com>
Subject: Re: [PATCH] ext4: reduce scheduling latency with delayed allocation
Date: Wed, 10 Mar 2010 14:09:34 +0100
Message-ID: <20100310140934.60c06148@leela>
References: <20100301133435.141c4bc5@leela>
	<20100302030619.GB6077@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab0CJNJk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Mar 2010 08:09:40 -0500
In-Reply-To: <20100302030619.GB6077@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 1 Mar 2010 22:06:19 -0500 tytso@mit.edu wrote:
> On Mon, Mar 01, 2010 at 01:34:35PM +0100, Michal Schmidt wrote:
> > mpage_da_submit_io() may process tens of thousands of pages at a
> > time. Unless full preemption is enabled, it causes scheduling
> > latencies in the order of tens of milliseconds.
> >=20
> > It can be reproduced simply by writing a big file on ext4
> > repeatedly with dd if=3D/dev/zero of=3D/tmp/dummy bs=3D10M count=3D=
50
> >=20
> > The patch fixes it by allowing to reschedule in the loop.
>=20
> Have you tested for any performance regressions as a result of this
> patch, using some file system benchmarks?

I used the 'fio' benchmark to test sequential write speed. Here are the
results:

           Test               kernel   aggregate bandwidth
 ------------------------------------------------------
      hdd-multi     2.6.33.nopreempt   32.7 =C2=B1  3.5 MB/s
      hdd-multi        2.6.33.reduce   33.8 =C2=B1  3.7 MB/s
      hdd-multi       2.6.33.preempt   33.4 =C2=B1  3.1 MB/s

     hdd-single     2.6.33.nopreempt   35.9 =C2=B1  2.1 MB/s
     hdd-single        2.6.33.reduce   36.6 =C2=B1  2.3 MB/s
     hdd-single       2.6.33.preempt   35.9 =C2=B1  2.0 MB/s

  ramdisk-multi     2.6.33.nopreempt  189.7 =C2=B1  9.2 MB/s
  ramdisk-multi        2.6.33.reduce  191.4 =C2=B1  9.5 MB/s
  ramdisk-multi       2.6.33.preempt  163.5 =C2=B1  9.4 MB/s

 ramdisk-single     2.6.33.nopreempt  152.3 =C2=B1 10.9 MB/s
 ramdisk-single        2.6.33.reduce  171.3 =C2=B1 17.0 MB/s
 ramdisk-single       2.6.33.preempt  144.2 =C2=B1 15.2 MB/s

The tests were run on a laptop with dual AMD Turion 2 GHz, 2 GB RAM.
A newly created filesystem was used for every fio run.
In the 'hdd' tests the filesystem was on a 24 GB LV on a harddisk. Thes=
e
tests were repeated 12 times.
 - In the '-single' variant a single process wrote a 5 GB file.
 - In the '-multi' variant 5 processes wrote a 1 GB file each.
In the 'ramdisk' tests the filesystem was on a 1.5 GB ramdisk. These
tests were repeated >40 times.
 - In the '-single' variant a single process wrote a 1400 MB file.
 - In the '-multi' variant 5 processes wrote a 280 MB file each.
The kernels were:
 '2.6.33.nopreempt' - vanilla 2.6.33 with CONFIG_PREEMPT_NONE
 '2.6.33.reduce'    - the same + the patch to add the cond_resched()
 '2.6.33.preempt'   - 2.6.33 with CONFIG_PREEMPT (for curiosity)
The data for 'aggregate bandwidth' were taken from fio's 'aggrb' result=
=2E
The margin of error as reported in the table is 2 * standard deviation.

Conclusion: Adding the cond_resched() did not result in any measurable
performance decrease of sequential writes. (The results show a
performance increase, but it's within the margin of error.)

> I don't think this is the best way to fix this problem, though.  The
> real right answer is to change how the code is structued.  All of the
> callsites that call mpage_da_submit_io() are immediately preceeded by
> mpage_da_map_blocks().  These two functions should be combined and
> instead of calling ext4_writepage() for each page,
> mpage_da_map_and_write_blocks() should make a single call to
> submit_bio() for each extent.  That should far more CPU efficient,
> solving both your scheduling latency issue as well as helping out for
> benchmarks that strive to stress both the disk and CPU simultaneously
> (such as for example the TPC benchmarks).
>=20
> This will also make our blktrace results much more compact, and Chris
> Mason will be very happy about that!

You're almost certainly right, but I'm not likely to make such a change
in the near future.

Michal
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
