From: "Pocas, Jamie" <Jamie.Pocas@emc.com>
Subject: RE: resize2fs stuck in ext4_group_extend with 100% CPU Utilization
 With Small Volumes
Date: Tue, 22 Sep 2015 23:40:15 -0400
Message-ID: <06724CF51D6BC94E9BEE7A8A8CB82A6740FE22BCF7@MX01A.corp.emc.com>
References: <06724CF51D6BC94E9BEE7A8A8CB82A6740FE22BCBA@MX01A.corp.emc.com>
 <20150922202058.GB3318@thunk.org>
 <06724CF51D6BC94E9BEE7A8A8CB82A6740FE22BCDF@MX01A.corp.emc.com>,<5601E71C.4080705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailuogwdur.emc.com ([128.221.224.79]:54190 "EHLO
	mailuogwdur.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbbIWDkg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Sep 2015 23:40:36 -0400
In-Reply-To: <5601E71C.4080705@redhat.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Yes I am seeing the same problem with physical disks and other types of virtualized disks (e.g. VMware can resize vmdk virtual disks online). Sorry if the initial ambiguity wasted some time. I was trying to come up with the smallest most isolated example that reproduced the issue so I went with the loopback approach since it doesn't have a lot of moving parts or external dependencies and it's easy to make arbitrary sized devices including these small ones. I could care less if loopback didn't work for my intended use but I am happy it is useful in reproducing the issue. Honestly, for my application it's easy to work around by just not allowing devices that small that we will never encounter anyway but I thought I would do my due diligence and report what I think is a bug :)

________________________________________
From: Eric Sandeen [sandeen@redhat.com]
Sent: Tuesday, September 22, 2015 7:41 PM
To: Pocas, Jamie; Theodore Ts'o
Cc: linux-ext4@vger.kernel.org
Subject: Re: resize2fs stuck in ext4_group_extend with 100% CPU Utilization With Small Volumes

On 9/22/15 4:26 PM, Pocas, Jamie wrote:
> Hi Theodore,
>
> I am not sure if you had a chance to see my reply to Eric yet. I can
> see you are using the same general approach that Eric was using. The
> key difference from what I am doing again seems to be that I am
> resizing the underlying disk *while the filesystem is mounted*.

Do you see the same problem if you resize a physical disk, not
just with loopback? Sounds like it...

In theory it should be reproducible w/ lvm too, then, I think,
unless there's some issue specific to your block device similar to
what's happening on the loop device.

> Instead you both are using truncate to grow the disk while the
> filesystem is not currently mounted, and then mounting it.

Always worth communicating a testcase in the first email, if you
have one, so we don't have to guess.  ;)

thanks,
-Eric

