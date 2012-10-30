From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: How to use new "native 4k sector sized" HDD with ext4
Date: Tue, 30 Oct 2012 09:31:13 -0500
Message-ID: <508FE4B1.2060903@redhat.com>
References: <CAOiN93kV079jkdzY-R7jMVGQq4nN4c-sdswCq-XRaOpZm=ttwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, adilger@dilger.ca,
	Namjae Jeon <linkinjeon@gmail.com>, linux-ext4@vger.kernel.org
To: Ashish Sangwan <ashishsangwan2@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab2J3Obc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Oct 2012 10:31:32 -0400
In-Reply-To: <CAOiN93kV079jkdzY-R7jMVGQq4nN4c-sdswCq-XRaOpZm=ttwA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/30/12 7:57 AM, Ashish Sangwan wrote:
> We have a 2TB HDD having native 4k sector size but emulated as 512bytes.
> And we want to use this device with sector size 4k and not 512bytes.
> 
> In mkfs.xfs there is option "-s", using which, one can set the sector size.
> What is the use case of this option?

That's a question for the xfs list ;)  xfs does issue IOs down
to that sector size, defaulting to 512, so setting it to the physical
sector size makes sense.  Newer mkfs.xfs does this automatically:

287d168b550857ce40e04b5f618d7eb91b87022f mkfs.xfs: properly handle physical sector size

    This primarily allows us to default to using the physical
    sectorsize for mkfs's "sector size" value, the fundamental
    size of any IOs the filesystem will perform.

> Also, such option is not present for ext4. So, apart from aligining the
>  partition on multiple of 8 sector numbers do we have to do something else
>  for using 4k sectors?

Nope.  Although I wouldn't specify a block size less than the physical
sector size (and if you do, mkfs.ext4 will complain) -

# blockdev --getss --getpbsz /dev/sde
512
4096
# mkfs.ext4 -b 1024 /dev/sde
mke2fs 1.41.12 (17-May-2010)
Warning: specified blocksize 1024 is less than device physical sectorsize 4096
...

> We measured the write performance of XFS/EXT4 with sector size 512bytes and 4KB.
> 
> XFS With 512 byte sector size=>
>  RecSize    WriteSpeed  RanReadSpeed RanWriteSpeed
>   524288   22.12MB/sec    0.00MB/sec    0.00MB/sec
>   262144   18.87MB/sec    0.00MB/sec    0.00MB/sec
>   131072   18.25MB/sec    0.00MB/sec    0.00MB/sec
>    65536   18.90MB/sec    0.00MB/sec    0.00MB/sec
>    32768   23.26MB/sec    0.00MB/sec    0.00MB/sec
>    16384   18.21MB/sec    0.00MB/sec    0.00MB/sec
>     8192   21.23MB/sec    0.00MB/sec    0.00MB/sec
>     4096   20.58MB/sec    0.00MB/sec    0.00MB/sec
> 
> XFS after setting 4KB sector size (-s size 4096) =>
> RecSize    WriteSpeed  RanReadSpeed RanWriteSpeed
>   524288   21.93MB/sec    0.00MB/sec    0.00MB/sec
>   262144   28.49MB/sec    0.00MB/sec    0.00MB/sec
>   131072   25.64MB/sec    0.00MB/sec    0.00MB/sec
>    65536   24.27MB/sec    0.00MB/sec    0.00MB/sec
>    32768   26.39MB/sec    0.00MB/sec    0.00MB/sec
>    16384   28.49MB/sec    0.00MB/sec    0.00MB/sec
>     8192   22.83MB/sec    0.00MB/sec    0.00MB/sec
>     4096   24.88MB/sec    0.00MB/sec    0.00MB/sec
> 
> Ext4 with default mkfs.ext4 options =>
>  RecSize    WriteSpeed  RanReadSpeed RanWriteSpeed
>   524288   31.95MB/sec    0.00MB/sec    0.00MB/sec
>   262144   26.88MB/sec    0.00MB/sec    0.00MB/sec
>   131072   23.04MB/sec    0.00MB/sec    0.00MB/sec
>    65536   25.91MB/sec    0.00MB/sec    0.00MB/sec
>    32768   24.69MB/sec    0.00MB/sec    0.00MB/sec
>    16384   24.27MB/sec    0.00MB/sec    0.00MB/sec
>     8192   32.05MB/sec    0.00MB/sec    0.00MB/sec
>     4096   30.21MB/sec    0.00MB/sec    0.00MB/sec
> 
> Ext4 performed little better than XFS (-s size 4096).
> Seeing this, we are tempted to believe that ext4 is already
> using 4k sectors.
> 
> Is there any way to make sure that ext4 is indeed using 4k sectors?

ext4 will only do IOs in multiples of block size, so if you set it to
4k, and properly align the filesystem start to a 4k boundary, there
is nothing else to do.

-Eric

