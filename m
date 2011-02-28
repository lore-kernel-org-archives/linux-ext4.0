From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 corruption
Date: Mon, 28 Feb 2011 09:01:54 -0600
Message-ID: <4D6BB8E2.7080106@redhat.com>
References: <AANLkTin5hN-gnpmgntApSSrWVWJPQqK99tPJtfmFn5++@mail.gmail.com>	<C5B8C496-E8F1-4BF7-9A51-373C0C63E357@mit.edu> <AANLkTimcKiKgKTVft9N+OVHd5-N+-AscSoimdOfkoBt9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Bill Huey (hui)" <bill.huey@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510Ab1B1PB7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Feb 2011 10:01:59 -0500
In-Reply-To: <AANLkTimcKiKgKTVft9N+OVHd5-N+-AscSoimdOfkoBt9@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/26/11 5:13 AM, Bill Huey (hui) wrote:
> Theodore,
> 
> I did run fsck.ext4 on the file system. It cleared a bunch of errors
> and but it's still showing various problems.
> 
> Another log of the file system. USB->SATA problems ?
> ---------------------------------
> 
> Feb 22 19:23:31 finfin kernel: [    2.402463] sd 6:0:0:0: [sdb]
> 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
> Feb 22 19:23:31 finfin kernel: [    2.403585] sd 6:0:0:0: [sdb] Write
> Protect is off
> Feb 22 19:23:31 finfin kernel: [    2.405920]  sdb:
> Feb 22 19:23:31 finfin kernel: [    2.819633]  sdb1
> Feb 22 19:23:31 finfin kernel: [    2.821592] sd 6:0:0:0: [sdb]
> Attached SCSI disk
> Feb 22 19:27:40 finfin kernel: [  263.857108]  sdb: sdb1
> Feb 22 20:03:18 finfin kernel: [ 2402.182269] EXT4-fs (sdb1): mounted
> filesystem with ordered data mode. Opts: (null)
> Feb 25 03:49:40 finfin kernel: [203184.800029] EXT4-fs (sdb1):
> warning: mounting fs with errors, running e2fsck is recommended

this must not have been post-fsck, if it still is mounting with errors...?

...

> Feb 25 21:51:47 finfin kernel: [59900.021575] EXT4-fs (sdb1): mounted
> filesystem with ordered data mode. Opts: (null)
> Feb 26 02:19:27 finfin kernel: [75959.826438] sd 6:0:0:0: [sdb]
> Unhandled error code
> Feb 26 02:19:27 finfin kernel: [75959.826444] sd 6:0:0:0: [sdb]
> Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> Feb 26 02:19:27 finfin kernel: [75959.826450] sd 6:0:0:0: [sdb] CDB:
> Read(10): 28 00 ac 44 00 3f 00 00 08 00

and this does indeed look like storage problems, ext4 problems are
probably secondary.

-Eric
