From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4_fallocate
Date: Wed, 27 Jun 2012 19:02:45 -0400
Message-ID: <4FEB9115.6090309@redhat.com>
References: <4FE8086F.4070506@zoho.com> <20120625085159.GA18931@gmail.com> <20120625191744.GB9688@thunk.org> <4FE9B57F.4030704@redhat.com> <4FE9F9F4.7010804@zoho.com> <4FEA0DD1.8080403@gmail.com> <4FEA1415.8040809@redhat.com> <4FEA1F18.6010206@redhat.com> <20120627193034.GA3198@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <ricwheeler@gmail.com>, Fredrick <fjohnber@zoho.com>,
	Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@dilger.ca>, wenqing.lz@taobao.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065Ab2F0XC4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jun 2012 19:02:56 -0400
In-Reply-To: <20120627193034.GA3198@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/27/12 3:30 PM, Theodore Ts'o wrote:
> On Tue, Jun 26, 2012 at 04:44:08PM -0400, Eric Sandeen wrote:
>>>
>>> I tried running this fio recipe on v3.3, which I think does a decent job of
>>> emulating the situation (fallocate 1G, do random 1M writes into it, with
>>> fsyncs after each):
>>>
>>> [test]
>>> filename=testfile
>>> rw=randwrite
>>> size=1g
>>> filesize=1g
>>> bs=1024k
>>> ioengine=sync
>>> fallocate=1
>>> fsync=1
> 
> A better workload would be to use a blocksize of 4k.  By using a
> blocksize of 1024k, it's not surprising that the metadata overhead is
> in the noise.
> 
> Try something like this; this will cause the extent tree overhead to
> be roughly equal to the data block I/O.
> 
> [global]
> rw=randwrite
> size=128m
> filesize=1g
> bs=4k
> ioengine=sync
> fallocate=1
> fsync=1
> 
> [thread1]
> filename=testfile

Well, ok ... TBH I changed it to size=16m to finish in under 20m.... so here are the results:

fallocate 1g, do 16m of 4k random IOs, sync after each:

# for I in a b c; do rm -f testfile; echo 3 > /proc/sys/vm/drop_caches; fio tytso.fio | grep 2>&1 WRITE; done

  WRITE: io=16384KB, aggrb=154KB/s, minb=158KB/s, maxb=158KB/s, mint=105989msec, maxt=105989msec
  WRITE: io=16384KB, aggrb=163KB/s, minb=167KB/s, maxb=167KB/s, mint=99906msec, maxt=99906msec
  WRITE: io=16384KB, aggrb=176KB/s, minb=180KB/s, maxb=180KB/s, mint=92791msec, maxt=92791msec

same, but overwrite pre-written 1g file (same as the expose-my-data option ;)

# dd if=/dev/zero of=testfile bs=1M count=1024
# for I in a b c; do echo 3 > /proc/sys/vm/drop_caches; fio tytso.fio | grep 2>&1 WRITE; done

  WRITE: io=16384KB, aggrb=164KB/s, minb=168KB/s, maxb=168KB/s, mint=99515msec, maxt=99515msec
  WRITE: io=16384KB, aggrb=164KB/s, minb=168KB/s, maxb=168KB/s, mint=99371msec, maxt=99371msec
  WRITE: io=16384KB, aggrb=164KB/s, minb=168KB/s, maxb=168KB/s, mint=99677msec, maxt=99677msec

so no great surprise, small synchronous 4k writes have terrible performance, but I'm still not seeing a lot of fallocate overhead.

xfs, FWIW:

# for I in a b c; do rm -f testfile; echo 3 > /proc/sys/vm/drop_caches; fio tytso.fio | grep 2>&1 WRITE; done

  WRITE: io=16384KB, aggrb=202KB/s, minb=207KB/s, maxb=207KB/s, mint=80980msec, maxt=80980msec
  WRITE: io=16384KB, aggrb=203KB/s, minb=208KB/s, maxb=208KB/s, mint=80508msec, maxt=80508msec
  WRITE: io=16384KB, aggrb=204KB/s, minb=208KB/s, maxb=208KB/s, mint=80291msec, maxt=80291msec

# dd if=/dev/zero of=testfile bs=1M count=1024
# for I in a b c; do echo 3 > /proc/sys/vm/drop_caches; fio tytso.fio | grep 2>&1 WRITE; done

  WRITE: io=16384KB, aggrb=197KB/s, minb=202KB/s, maxb=202KB/s, mint=82869msec, maxt=82869msec
  WRITE: io=16384KB, aggrb=203KB/s, minb=208KB/s, maxb=208KB/s, mint=80348msec, maxt=80348msec
  WRITE: io=16384KB, aggrb=202KB/s, minb=207KB/s, maxb=207KB/s, mint=80827msec, maxt=80827msec

Again, I think this is just a diabolical workload ;)

-Eric
