From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4_fallocate
Date: Tue, 26 Jun 2012 15:57:09 -0400
Message-ID: <4FEA1415.8040809@redhat.com>
References: <4FE8086F.4070506@zoho.com> <20120625085159.GA18931@gmail.com> <20120625191744.GB9688@thunk.org> <4FE9B57F.4030704@redhat.com> <4FE9F9F4.7010804@zoho.com> <4FEA0DD1.8080403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Fredrick <fjohnber@zoho.com>, Ric Wheeler <rwheeler@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@dilger.ca>, wenqing.lz@taobao.com
To: Ric Wheeler <ricwheeler@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab2FZT5T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jun 2012 15:57:19 -0400
In-Reply-To: <4FEA0DD1.8080403@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/26/12 3:30 PM, Ric Wheeler wrote:

> Thanks!  Eric is also running some tests to evaluate the impact of various techniques :)
> 
> ric

Yup forgive me for interjecting actual numbers into the discussion ;)

I tried running this fio recipe on v3.3, which I think does a decent job of
emulating the situation (fallocate 1G, do random 1M writes into it, with
fsyncs after each):

[test]
filename=testfile
rw=randwrite
size=1g
filesize=1g
bs=1024k
ioengine=sync
fallocate=1
fsync=1

Stock ext4 (3 tests w/ file remove & cache drop in between):

  WRITE: io=1024.0MB, aggrb=16322KB/s, minb=16713KB/s, maxb=16713KB/s, mint=64243msec, maxt=64243msec
  WRITE: io=1024.0MB, aggrb=16249KB/s, minb=16639KB/s, maxb=16639KB/s, mint=64528msec, maxt=64528msec
  WRITE: io=1024.0MB, aggrb=16370KB/s, minb=16763KB/s, maxb=16763KB/s, mint=64052msec, maxt=64052msec

With the patch which exposes other users' data:

  WRITE: io=1024.0MB, aggrb=17840KB/s, minb=18268KB/s, maxb=18268KB/s, mint=58776msec, maxt=58776msec
  WRITE: io=1024.0MB, aggrb=17841KB/s, minb=18269KB/s, maxb=18269KB/s, mint=58773msec, maxt=58773msec
  WRITE: io=1024.0MB, aggrb=17828KB/s, minb=18255KB/s, maxb=18255KB/s, mint=58816msec, maxt=58816msec

so about 10% faster than without.

XFS, FWIW:

  WRITE: io=1024.0MB, aggrb=24008KB/s, minb=24584KB/s, maxb=24584KB/s, mint=43675msec, maxt=43675msec
  WRITE: io=1024.0MB, aggrb=24069KB/s, minb=24647KB/s, maxb=24647KB/s, mint=43564msec, maxt=43564msec
  WRITE: io=1024.0MB, aggrb=24054KB/s, minb=24632KB/s, maxb=24632KB/s, mint=43591msec, maxt=43591msec

which is 35% faster than ext4 with the risky patch.

Haven't yet tried overwrites or done any tracing or profiling, but I think the fio recipe is a decent demonstrator, I'll try the overwrites etc in a bit when I get a moment.

-Eric
