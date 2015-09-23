From: "Pocas, Jamie" <Jamie.Pocas@emc.com>
Subject: RE: resize2fs stuck in ext4_group_extend with 100% CPU Utilization
 With Small Volumes
Date: Wed, 23 Sep 2015 14:20:45 -0400
Message-ID: <06724CF51D6BC94E9BEE7A8A8CB82A6740FE22BD55@MX01A.corp.emc.com>
References: <06724CF51D6BC94E9BEE7A8A8CB82A6740FE22BCBA@MX01A.corp.emc.com>
 <5601ACFE.5080904@redhat.com>
 <06724CF51D6BC94E9BEE7A8A8CB82A6740FE22BCCC@MX01A.corp.emc.com>
 <20150922230204.GD3318@thunk.org>
 <06724CF51D6BC94E9BEE7A8A8CB82A6740FE22BCF8@MX01A.corp.emc.com>
 <20150923151406.GE3318@thunk.org>
 <06724CF51D6BC94E9BEE7A8A8CB82A6740FE22BD23@MX01A.corp.emc.com>
 <20150923165907.GF3318@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailuogwhop.emc.com ([168.159.213.141]:59809 "EHLO
	mailuogwhop.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbbIWSVK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Sep 2015 14:21:10 -0400
In-Reply-To: <20150923165907.GF3318@thunk.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I understand the tradeoff. Thanks. I tested a change in the driver from calling bd_set_size() to calling check_disk_size_change() and it is in fact working as expected! I can see that the capacity is increased correctly, but the blocksize reported by 'blockdev --getbsz' is still retained as 1024 correctly. Obviously this needs more review and testing, but I think this is a bug with loopback and any other driver that would call bd_set_size() to do online resize. As far as ext is concerned, consider it case-closed. Thanks again for the tips.

-----Original Message-----
From: Theodore Ts'o [mailto:tytso@mit.edu] 
Sent: Wednesday, September 23, 2015 12:59 PM
To: Pocas, Jamie
Cc: Eric Sandeen; linux-ext4@vger.kernel.org
Subject: Re: resize2fs stuck in ext4_group_extend with 100% CPU Utilization With Small Volumes

On Wed, Sep 23, 2015 at 12:04:49PM -0400, Pocas, Jamie wrote:
> Interesting. Thanks for the detailed break-down! I don't mind the 
> workaround of using 4k "soft" block size on the filesystem, even for 
> smaller filesystems. Now that I understand better, I think you were on 
> target with your earlier explanation of bd_set_size(). So this means 
> it's not an ext4 bug. I think the online resize of loopback device (or 
> any other block device driver) should use something like the code in 
> check_disk_size_change() instead of bd_set_size(). I will have to test 
> this out. Thanks again.

To be clear, the 4k file system block size is an on-disk format thing, and it will give you better performance (at the cost of increasing internal fragmentation overhead which can consume more space).  It will cause the soft block size to be set to be 4k when the file system is mounted, but that's a different thing.

Note that for larger ext4 file systems, or if you are using XFS, the file system block size will be 4k, so explicitly configuring the blocksize to 4k isn't anything particularly unusual.  It's a change in the defaults, but I showed you how you can change the defaults by editing /etc/mke2fs.conf.

Cheers,

						- Ted
