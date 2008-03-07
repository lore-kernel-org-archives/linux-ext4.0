From: Bas van Schaik <bas@tuxes.nl>
Subject: Re: e2fsck dies with error "this should never happen!!!"
Date: Fri, 07 Mar 2008 17:29:49 +0100
Message-ID: <47D16D7D.9030700@tuxes.nl>
References: <47BEBAF1.4090505@tuxes.nl> <20080222123852.GI20118@mit.edu> <47BECAC0.5010707@tuxes.nl> <20832.81.207.193.3.1203702265.squirrel@guust.tuxes.nl> <47BF0A7B.50902@redhat.com> <20909.81.207.193.3.1203702913.squirrel@guust.tuxes.nl> <47BF0DAC.9080200@redhat.com> <21151.81.207.193.3.1203703570.squirrel@guust.tuxes.nl> <20080222182711.GT20118@mit.edu> <21200.81.207.193.3.1203708673.squirrel@guust.tuxes.nl> <20080222194826.GW20118@mit.edu> <47CAFB3F.2010409@tuxes.nl> <47D145F8.3040300@tuxes.nl> <47D16456.6030400@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from castor.sshunet.nl ([145.97.192.41]:42144 "EHLO
	castor.sshunet.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbYCGQ35 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Mar 2008 11:29:57 -0500
In-Reply-To: <47D16456.6030400@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Bas van Schaik wrote:
>
>   
>> Why is e2image refusing to restore the metadata, and what does "File too
>> large" mean?
>>     
> How big are things really?  stracing the command would show you what is
> returning the error...
>   
The image file is 35335922 kbytes (= about 33GB), but is of course
sparse and actually uses 4218560 kbytes (= about 4 GB). The original
filesystem is 550502400 blocks long (block size 4096, number of inodes:
275251200).

The last few lines of output when using strace:
> close(4)                                = 0
> open("/usr/lib/gconv/ISO8859-1.so", O_RDONLY) = 4
> read(4, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\200\4\0"...,
> 512) = 512
> fstat64(4, {st_mode=S_IFREG|0644, st_size=9436, ...}) = 0
> mmap2(NULL, 8228, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4,
> 0) = 0xb1ab3000
> mmap2(0xb1ab4000, 8192, PROT_READ|PROT_WRITE,
> MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x1) = 0xb1ab4000
> close(4)                                = 0
> write(2, "e2image-pre-e2fsck-snapshot_2008"...,
> 55e2image-pre-e2fsck-snapshot_2008-03-06: File too large
> ) = 55
> exit_group(1)                           = ?
> Process 6218 detached
I can't see what's going wrong here.

  -- Bas


