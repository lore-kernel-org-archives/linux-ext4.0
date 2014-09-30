From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Journal under-reservation bug on first >2G file
Date: Tue, 30 Sep 2014 16:22:04 -0500
Message-ID: <542B1EFC.4050500@redhat.com>
References: <542B1C38.9010409@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbaI3VWD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Sep 2014 17:22:03 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s8ULM3D0003833
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Tue, 30 Sep 2014 17:22:03 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s8ULM1xI029580
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 30 Sep 2014 17:22:02 -0400
In-Reply-To: <542B1C38.9010409@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/30/14 4:10 PM, Eric Sandeen wrote:
> Hey all -
> 
> So the following testcase will overrun the 1-credit journal reservation
> made during a delalloc write in ext4_da_write_begin(), because we
> may cross the 2G threshold, and need to modify both the inode and the
> superblock in the same transaction.
> 
> I see a few was to fix this:
> 
> 1) Always set LARGE_FILE on mount if not set.  This will break
>    RW compatiblity with very old kernels.  Do we care?

  1.5) Don't update the feature on the fly - we don't for
       HUGE_FILE, either.

  1.5a) Always set the large_file feature with a fresh mkfs, insteadl
        of relying on the accident of the resize inode being > 2G!

> 2) Bump the reservation to 2 under the fiddly condition of
>    large file not yet set but this write might do it
> 3) bump the delalloc reservation to 2 just in case, always
> 
> I'll be happy to write the patch to fix it, just wondering what
> people think the best approach is
> 
> Thoughts?
> -Eric
> 
> 
> #!/bin/bash
> 
> # A 400m fs won't get the large_file feature, oddly
> # enough, because the resize inode will be < 2G.
> 
> truncate --size=400m test.img
> mkfs.ext4 -F test.img
> # This shouldn't have large_file set, exit if it does for some reason
> dumpe2fs -h test.img | grep large_file && exit
> 
> mkdir -p mnt
> mount -o loop test.img mnt
> 
> echo "writing 1 byte at 2147483646" 
> dd if=/dev/zero of=mnt/testfile bs=1 seek=2147483646 count=1 conv=notrunc of=mnt/testfile
> sync
> 
> # This will make sure i_disksize is on disk, and
> # that the buffer will be mapped on the next write.
> #
> # This is critical because ext4_da_should_update_i_disksize()
> # checks buffer_mapped():
> #
> #        if (!buffer_mapped(bh) || (buffer_delay(bh)) || buffer_unwritten(bh))
> #                return 0;
> #        return 1;
> 
> # This tries to update i_disksize, and also requires a superblock
> # update for the large_file feature flag, but only has 1 credit
> # available on the delalloc write path
> 
> echo "writing 1 byte at 2147483647"
> dd if=/dev/zero of=mnt/testfile bs=1 seek=2147483647 count=1 conv=notrunc of=mnt/testfile
> 
> # Should go boom, but if not, unmount
> umount mnt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

