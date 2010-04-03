From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Changes in quota tools cause xfstests #219 to fail
Date: Sat, 03 Apr 2010 16:06:15 -0500
Message-ID: <4BB7ADC7.4000009@redhat.com>
References: <E1NyATh-00087e-Li@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851Ab0DCVGY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 3 Apr 2010 17:06:24 -0400
In-Reply-To: <E1NyATh-00087e-Li@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> It looks like the output of quota has changed, which is causing xfstests
> #219 to fail.  This was run on Debian unstable, using quota version
> 4.00-pre1:

Dave ran into this too, and I think his solution was to just drop the "-s"
from repquota, and the behavior is then unchanged regardless of quota
version.

-Eric

> 000 - unknown test, ignored
> FSTYP         -- ext4
> PLATFORM      -- Linux/i686 candygram 2.6.34-rc3-00007-g778c832
> MKFS_OPTIONS  -- /dev/sdc1
> MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/sdc1 /scratch
> 
> 219	 - output mismatch (see 219.out.bad)
> --- 219.out	2009-08-18 00:12:27.000000000 -0400
> +++ 219.out.bad	2010-04-03 16:36:01.915309094 -0400
> @@ -24,10 +24,10 @@
>    Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
>  *** Report for user quotas on device [SCR_DEV]
>  Block grace time: 7days; Inode grace time: 7days
> -                        Block limits                File limits
> +                        Space limits                File limits
>  User            used    soft    hard  grace    used  soft  hard  grace
>  ----------------------------------------------------------------------
> -#1        --     144       0       0              3     0     0       
> +#1        --    144K      0K      0K              3     0     0       
>  
>  
>  
> @@ -55,9 +55,9 @@
>    Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
>  *** Report for group quotas on device [SCR_DEV]
>  Block grace time: 7days; Inode grace time: 7days
> -                        Block limits                File limits
> +                        Space limits                File limits
>  Group           used    soft    hard  grace    used  soft  hard  grace
>  ----------------------------------------------------------------------
> -#2        --     144       0       0              3     0     0       
> +#2        --    144K      0K      0K              3     0     0       
>  
>  
> Ran: 219
> Failures: 219
> Failed 1 of 1 tests
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

