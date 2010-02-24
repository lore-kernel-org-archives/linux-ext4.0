From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] mk2fs lazy_journal_init option
Date: Tue, 23 Feb 2010 22:30:38 -0700
Message-ID: <5B7315EF-A0AC-4C57-A0D4-DC0B071F87B8@sun.com>
References: <127958.57045.qm@web43516.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Shuichi Ihara <ihara@sun.com>
To: number9652 <number9652@yahoo.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:44866 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab0BXFal (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Feb 2010 00:30:41 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o1O5UeTP008121
	for <linux-ext4@vger.kernel.org>; Tue, 23 Feb 2010 21:30:40 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KYB00500Z1VSR00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Tue,
 23 Feb 2010 21:30:40 -0800 (PST)
In-reply-to: <127958.57045.qm@web43516.mail.sp1.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-02-19, at 12:53, number9652 wrote:
> I hope you decide to continue unconditionally zeroing the journal at  
> mkfs time.

That will continue to be the default for the time being, unless we can  
be sure that there is no possibility of error.  That would be possible  
in conjunction with the journal checksum patch, if the checksum  
function is changed slightly to include the journal UUID.

> In this case, block_iterate2 was being used to create a file, but  
> when the file became big enough to have an extent leaf,  
> ext2fs_get_extent was returning an extent when it shouldn't have  
> been.  That caused ext2fs_block_iterate2 to go wrong, eventually  
> calling mkjournal_proc millions of times more than it needed to  
> (during which it would immediately return).  A patch which resolves  
> this is below.  It shows normal mkfs times for me with a 512 MB  
> journal and passes make check.
>
> Signed-off-by Nic Case <number9652@yahoo.com>

I haven't looked at this from a logic POV, but I tested this with a  
1GB journal and it ran the same time with/without specifying "-O  
extents" (10s vs. 650s without this patch).  I also ran our additional  
e2fsck extents tests without errors, and on a couple of my extent- 
based filesystems.

Tested-by: Andreas Dilger <adilger@sun.com>

> --- lib/ext2fs/extent-orig.c    2010-02-05 08:58:41.000000000 -0600
> +++ lib/ext2fs/extent.c 2010-02-19 13:37:32.000000000 -0600
> @@ -307,16 +307,12 @@
>                                op = EXT2_EXTENT_DOWN;
>                        } else if (path->left > 0)
>                                op = EXT2_EXTENT_NEXT_SIB;
> -                       else if (handle->level > 0)
> -                               op = EXT2_EXTENT_UP;
>                        else
>                                return EXT2_ET_EXTENT_NO_NEXT;
>                } else {
>                        /* leaf node */
>                        if (path->left > 0)
>                                op = EXT2_EXTENT_NEXT_SIB;
> -                       else if (handle->level > 0)
> -                               op = EXT2_EXTENT_UP;
>                        else
>                                return EXT2_ET_EXTENT_NO_NEXT;
>                }
>
>
>
>
>
>


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

