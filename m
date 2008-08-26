From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH] blkid: optimize dm_device_is_leaf() usage
Date: Tue, 26 Aug 2008 15:51:02 +0200
Message-ID: <20080826135102.GK6029@nb.net.home>
References: <1219697316-5632-1-git-send-email-kzak@redhat.com> <20080826122405.GA8720@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	mbroz@redhat.com, agk@redhat.com
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068AbYHZNvH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Aug 2008 09:51:07 -0400
Content-Disposition: inline
In-Reply-To: <20080826122405.GA8720@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 26, 2008 at 08:24:05AM -0400, Theodore Tso wrote:
> commit 3f66ecf24e896377997b909edef040be98ac76b3
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Tue Aug 26 08:13:56 2008 -0400
> 
>     libblkid: Optimize devicemapper support
>     
>     This commit works by removing all calls from libdevicemapper
>     altogether, and using the standard support for "normal" non-dm
>     devices.
>     
>     It depends on dm devices being placed in /dev/mapper (but the previous
>     code had this dependency anyway), and /proc/partitions containing dm
>     devices.

 Well, I see few problems:

 * /proc/partitions containing internal dm device names (e.g. dm-0).
   The libdevmapper provides translation from internal to the "real"
   names (e.g /dev/mapper/foo). I guess (hope:-) /sys provides the
   real names too.

 * we probably need to resolve dependencies for multi-path devices
   where the same FS is accessable by more than one physical device.
   If I good remember it was the original purpose for DM support 
   in libblkid.

        # mount LABEL=blabla /mnt

   has to mount the "right" device. I guess that only DM is able to
   answer which device is the "right" one ;-)

   The /sys/block/<devname>/slaves/ provides information about
   dependencies.

 I see these two things as critical for fsck, mount, ...

>  
> +/* Directories where we will try to search for device names */
> +static const char *dirlist[] = { "/dev", "/dev/mapper", "/devfs", "/devices", NULL };

I think "/dev/mapper" does not make any sense here, ...because the
names from /proc/partitions are in dm-<N> format, but the names in
/dev/mapper uses different format.

> -	if (!pri && !strncmp(ptname, "md", 2))
> -		pri = BLKID_PRI_MD;
> -	if (dev)
> -		dev->bid_pri = pri;
> +	if (dev) {
> +		if (pri)
> +			dev->bid_pri = pri;
> +		else if (!strncmp(dev->bid_name, "/dev/mapper/", 11))
> +			dev->bid_pri = BLKID_PRI_DM;

 the same problem

> +		else if (!strncmp(ptname, "md", 2))
> +			dev->bid_pri = BLKID_PRI_MD;
> + 	}
>  	return;
>  }

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
