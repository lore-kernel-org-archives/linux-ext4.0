From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4_fallocate
Date: Wed, 27 Jun 2012 11:14:00 -0400
Message-ID: <4FEB2338.9080008@redhat.com>
References: <4FE8086F.4070506@zoho.com> <20120625085159.GA18931@gmail.com> <20120625191744.GB9688@thunk.org> <4FE9B57F.4030704@redhat.com> <4FE9F9F4.7010804@zoho.com> <4FEA0DD1.8080403@gmail.com> <4FEA1415.8040809@redhat.com> <4FEA1F18.6010206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Fredrick <fjohnber@zoho.com>, Ric Wheeler <rwheeler@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@dilger.ca>, wenqing.lz@taobao.com
To: Ric Wheeler <ricwheeler@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757016Ab2F0POM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jun 2012 11:14:12 -0400
In-Reply-To: <4FEA1F18.6010206@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/26/12 4:44 PM, Eric Sandeen wrote:
> On 6/26/12 3:57 PM, Eric Sandeen wrote:
>> On 6/26/12 3:30 PM, Ric Wheeler wrote:

...

>> I tried running this fio recipe on v3.3, which I think does a decent job of
>> emulating the situation (fallocate 1G, do random 1M writes into it, with
>> fsyncs after each):
>>
>> [test]
>> filename=testfile
>> rw=randwrite
>> size=1g
>> filesize=1g
>> bs=1024k
>> ioengine=sync
>> fallocate=1
>> fsync=1


I realized the kernel I tested on had a lot of debugging bells & whistles turned on.  For a more performance-configured v3.3 kernel, I see much less impact, more or less negligible:

unwritten conversion on ext4:

  WRITE: io=1024.0MB, aggrb=23077KB/s, minb=23631KB/s, maxb=23631KB/s, mint=45437msec, maxt=45437msec
  WRITE: io=1024.0MB, aggrb=23040KB/s, minb=23593KB/s, maxb=23593KB/s, mint=45511msec, maxt=45511msec
  WRITE: io=1024.0MB, aggrb=23011KB/s, minb=23564KB/s, maxb=23564KB/s, mint=45567msec, maxt=45567msec

overwrites on ext4:

  WRITE: io=1024.0MB, aggrb=23046KB/s, minb=23599KB/s, maxb=23599KB/s, mint=45499msec, maxt=45499msec
  WRITE: io=1024.0MB, aggrb=23222KB/s, minb=23780KB/s, maxb=23780KB/s, mint=45153msec, maxt=45153msec
  WRITE: io=1024.0MB, aggrb=23031KB/s, minb=23584KB/s, maxb=23584KB/s, mint=45528msec, maxt=45528msec


So I guess it's interesting information; the debug kernel showed a much bigger difference; the performance-config'd kernel showed almost no difference.

FWIW, on this same kernel,

unwritten conversion on xfs:

  WRITE: io=1024.0MB, aggrb=28409KB/s, minb=29091KB/s, maxb=29091KB/s, mint=36909msec, maxt=36909msec
  WRITE: io=1024.0MB, aggrb=28372KB/s, minb=29053KB/s, maxb=29053KB/s, mint=36958msec, maxt=36958msec
  WRITE: io=1024.0MB, aggrb=28406KB/s, minb=29088KB/s, maxb=29088KB/s, mint=36913msec, maxt=36913msec

overwrites on xfs:

  WRITE: io=1024.0MB, aggrb=28268KB/s, minb=28946KB/s, maxb=28946KB/s, mint=37094msec, maxt=37094msec
  WRITE: io=1024.0MB, aggrb=28316KB/s, minb=28995KB/s, maxb=28995KB/s, mint=37031msec, maxt=37031msec
  WRITE: io=1024.0MB, aggrb=28576KB/s, minb=29262KB/s, maxb=29262KB/s, mint=36694msec, maxt=36694msec

-Eric
