From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, E2FSPROGS] blkid: Automatically chose between ext4 and
	ext4dev as appropriate
Date: Mon, 11 Feb 2008 16:46:43 -0700
Message-ID: <20080211234643.GL3029@webber.adilger.int>
References: <E1JNboG-0000IP-8D@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:64334 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbYBKXqt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Feb 2008 18:46:49 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m1BNkm3E021887
	for <linux-ext4@vger.kernel.org>; Mon, 11 Feb 2008 15:46:48 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JW300601LXC2A00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 11 Feb 2008 15:46:48 -0800 (PST)
In-reply-to: <E1JNboG-0000IP-8D@closure.thunk.org>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 08, 2008  17:35 -0500, Theodore Ts'o wrote:
> I plan to release this in an upcoming 1.40.6 release, along with code
> that allows "tune2fs -E test_fs" to work on ext4 filesystems.  The idea
> is that if I can get this into community distro's, it will make it
> easier for them to experiment with ext4/ext4dev, with the appropriate
> forward compatibility when sometime (hopefully 2.6.26 or 2.6.27?) we
> rename ext4dev to ext4.
> 
> Any comments before I push this change out to the maint branch?
> 
> 						- Ted
> 
> 
> @@ -158,6 +159,109 @@ static void get_ext2_info(blkid_dev dev, struct blkid_magic *id,
>  		blkid_set_tag(dev, "SEC_TYPE", "ext2", sizeof("ext2"));
>  }
>  
> +/*
> + * Check to see if a filesystem is in /proc/filesystems.
> + * Returns 1 if found, 0 if not
> + */
> +int fs_proc_check(const char *fs_name)
> +{
> +}

Sure.

> +int check_for_modules(const char *fs_name)
> +{
> +}

This part is quite fragile IMHO.  Why not blindly do an attempt to load
this module via the equivalent of system("modprobe %s", fs_name) and then
call fs_proc_check() to see if it is available?  That removes all of the
kernel/module knowlege/complexity from blkid.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
