From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4_fallocate
Date: Tue, 26 Jun 2012 16:44:08 -0400
Message-ID: <4FEA1F18.6010206@redhat.com>
References: <4FE8086F.4070506@zoho.com> <20120625085159.GA18931@gmail.com> <20120625191744.GB9688@thunk.org> <4FE9B57F.4030704@redhat.com> <4FE9F9F4.7010804@zoho.com> <4FEA0DD1.8080403@gmail.com> <4FEA1415.8040809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Fredrick <fjohnber@zoho.com>, Ric Wheeler <rwheeler@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@dilger.ca>, wenqing.lz@taobao.com
To: Ric Wheeler <ricwheeler@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975Ab2FZUoV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jun 2012 16:44:21 -0400
In-Reply-To: <4FEA1415.8040809@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/26/12 3:57 PM, Eric Sandeen wrote:
> On 6/26/12 3:30 PM, Ric Wheeler wrote:
> 
>> Thanks!  Eric is also running some tests to evaluate the impact of various techniques :)
>>
>> ric
> 
> Yup forgive me for interjecting actual numbers into the discussion ;)
> 
> I tried running this fio recipe on v3.3, which I think does a decent job of
> emulating the situation (fallocate 1G, do random 1M writes into it, with
> fsyncs after each):
> 
> [test]
> filename=testfile
> rw=randwrite
> size=1g
> filesize=1g
> bs=1024k
> ioengine=sync
> fallocate=1
> fsync=1
> 
> Stock ext4 (3 tests w/ file remove & cache drop in between):
> 
>   WRITE: io=1024.0MB, aggrb=16322KB/s, minb=16713KB/s, maxb=16713KB/s, mint=64243msec, maxt=64243msec
>   WRITE: io=1024.0MB, aggrb=16249KB/s, minb=16639KB/s, maxb=16639KB/s, mint=64528msec, maxt=64528msec
>   WRITE: io=1024.0MB, aggrb=16370KB/s, minb=16763KB/s, maxb=16763KB/s, mint=64052msec, maxt=64052msec

And as a sanity check, here are the rates for overwriting existing, written blocks in the file:

  WRITE: io=1024.0MB, aggrb=17778KB/s, minb=18205KB/s, maxb=18205KB/s, mint=58980msec, maxt=58980msec
  WRITE: io=1024.0MB, aggrb=17825KB/s, minb=18252KB/s, maxb=18252KB/s, mint=58826msec, maxt=58826msec
  WRITE: io=1024.0MB, aggrb=17769KB/s, minb=18195KB/s, maxb=18195KB/s, mint=59010msec, maxt=59010msec

so this does look like about ~10% overhead for converting the extents.

> With the patch which exposes other users' data:
> 
>   WRITE: io=1024.0MB, aggrb=17840KB/s, minb=18268KB/s, maxb=18268KB/s, mint=58776msec, maxt=58776msec
>   WRITE: io=1024.0MB, aggrb=17841KB/s, minb=18269KB/s, maxb=18269KB/s, mint=58773msec, maxt=58773msec
>   WRITE: io=1024.0MB, aggrb=17828KB/s, minb=18255KB/s, maxb=18255KB/s, mint=58816msec, maxt=58816msec

overwrites:

  WRITE: io=1024.0MB, aggrb=17768KB/s, minb=18194KB/s, maxb=18194KB/s, mint=59014msec, maxt=59014msec
  WRITE: io=1024.0MB, aggrb=17855KB/s, minb=18283KB/s, maxb=18283KB/s, mint=58726msec, maxt=58726msec
  WRITE: io=1024.0MB, aggrb=17838KB/s, minb=18266KB/s, maxb=18266KB/s, mint=58783msec, maxt=58783msec

As expected, overwriting stale data is no slower than overwriting file data.

> so about 10% faster than without.
> 
> XFS, FWIW:
> 
>   WRITE: io=1024.0MB, aggrb=24008KB/s, minb=24584KB/s, maxb=24584KB/s, mint=43675msec, maxt=43675msec
>   WRITE: io=1024.0MB, aggrb=24069KB/s, minb=24647KB/s, maxb=24647KB/s, mint=43564msec, maxt=43564msec
>   WRITE: io=1024.0MB, aggrb=24054KB/s, minb=24632KB/s, maxb=24632KB/s, mint=43591msec, maxt=43591msec

overwrites:

  WRITE: io=1024.0MB, aggrb=24108KB/s, minb=24687KB/s, maxb=24687KB/s, mint=43494msec, maxt=43494msec
  WRITE: io=1024.0MB, aggrb=24129KB/s, minb=24708KB/s, maxb=24708KB/s, mint=43456msec, maxt=43456msec
  WRITE: io=1024.0MB, aggrb=24164KB/s, minb=24744KB/s, maxb=24744KB/s, mint=43393msec, maxt=43393msec

looks like negligible overhead for the conversions here, < 1%.

-Eric

> which is 35% faster than ext4 with the risky patch.
> 
> Haven't yet tried overwrites or done any tracing or profiling, but I think the fio recipe is a decent demonstrator, I'll try the overwrites etc in a bit when I get a moment.
> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


