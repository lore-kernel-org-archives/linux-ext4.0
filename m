From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Possible file system corruption?
Date: Tue, 10 Feb 2015 07:39:49 -0200
Message-ID: <20150210093949.GA1735@hades.maiolino.org>
References: <CAF_MivHO0nVcqUTv6M2rMBkAS0pmSGBa-KSurPdbqaN+MGp=iQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbbBJJjx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Feb 2015 04:39:53 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t1A9drMK003298
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Tue, 10 Feb 2015 04:39:53 -0500
Received: from hades.maiolino.org (dhcp-1-103.brq.redhat.com [10.34.1.103])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id t1A9dn1X021474
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 10 Feb 2015 04:39:52 -0500
Content-Disposition: inline
In-Reply-To: <CAF_MivHO0nVcqUTv6M2rMBkAS0pmSGBa-KSurPdbqaN+MGp=iQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I don't work with ext4 for a while, but maybe I can give a few suggestions.

first of all, I'd suggest you to run `e2fsck -fnv` and attach the whole output
of the command to the e-mail (pastebins are preferred though).

Giving the description, I'd say that you might be trying to run e2fsck in a
different volume/device that you're actually mounting, but well, that's too soon
to say.

have you tried to actually run e2fsck specifying a backup superblock?

cheers

On Mon, Feb 09, 2015 at 07:33:28PM +0800, Kevin Liao wrote:
> Hi All,
> 
> Recently whenvevr I try to access one file, I saw the following kernel log:
> 
> "EXT4-fs error (device md0): ext4_ext_find_extent:400: inode #95223833: comm
>  fio: bad header/extent: invalid magic - magic e2b6, entries 59156, max
>  58100(0), depth 43399(0)"
> 
> inode 95223833 is just the file I want to read. I guess there may be some
> corruption in the file system. Therefore I umount it and run e2fsck command
> but get the following result:
> 
> "ext2fs_check_desc: Corrupt group descriptor: bad block for block bitmap
> ./e2fsck: Group descriptors look bad... trying backup blocks...
> Corruption found in superblock. (reserved_gdt_blocks = 16384).
> 
> The superblock could not be read or does not describe a valid ext2/ext3/ext4
> filesystem. If the device is valid and it really contains an ext2/ext3/ext4
> filesystem (and not swap or ufs or something else), then the superblock
> is corrupt, and you might try running e2fsck with an alternate superblock:
>     e2fsck -b 8193 <device>
>  or
>     e2fsck -b 32768 <device>"
> 
> It seems that the superblock is bad, however I can still mount it and access
> to other files without error. The kernel version is 3.4.23. Is there anything
> I can do to recover the file? Any help is very appreciated. Thank a lot.
> 
> Kevin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
