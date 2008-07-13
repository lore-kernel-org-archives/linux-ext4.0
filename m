From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: 5% diskspace used for ext4?
Date: Sun, 13 Jul 2008 18:41:12 -0500
Message-ID: <487A9298.8040707@redhat.com>
References: <alpine.DEB.1.10.0807140054000.4469@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274AbYGMXlX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Jul 2008 19:41:23 -0400
In-Reply-To: <alpine.DEB.1.10.0807140054000.4469@sheep.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Christian Kujau wrote:
> Hi,
> 
> I suspect this being a FAQ already, but I could not find[0] it:
> does ext4 really use 5% of available space for internal housekeeping? 
> After formatting and mounting a ~917GB partition I see:
> 
> # df -h /mnt/bench/
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sdb1             917G  200M  871G   1% /mnt/bench
> 
> The "200 MB used" would seem more sensible, but the difference between
> "available" and "size" is really 46 GB. How comes?
> 
> Thanks,
> Christian.
> 
> [0] http://ext4.wiki.kernel.org/index.php/Frequently_Asked_Questions
> 
> PS, a few more details how the filesystem got created and mounted:
> 
> # /opt/e2fsprogs/sbin/mkfs.ext4 -V
> mke2fs 1.41.0 (10-Jul-2008)
>  	Using EXT2FS Library version 1.41.0
> 
> # /opt/e2fsprogs/sbin/mkfs.ext4 /dev/sdb1
> [...]

Somewhere in [...] was:

XXX blocks (5.00%) reserved for the super user

this can be tuned and maybe should actually be on a sliding scale for
larger filesystems.

-Eric
