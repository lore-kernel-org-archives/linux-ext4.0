From: Camille Moncelier <pix@devlife.org>
Subject: Re: [ext3] Changes to block device after an ext3 mount point has been
	remounted readonly
Date: Fri, 19 Feb 2010 08:38:15 +0100
Message-ID: <baaef4711002182338g17e42a7dpa47242dd334a27c2@mail.gmail.com>
References: <baaef4711002180845n29561ccif451fae62e49e520@mail.gmail.com>
	<9F53CAF8-B6B4-40EB-89FA-CD6779D17DBE@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52679 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660Ab0BSHig (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Feb 2010 02:38:36 -0500
In-Reply-To: <9F53CAF8-B6B4-40EB-89FA-CD6779D17DBE@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 18, 2010 at 10:41 PM, Andreas Dilger <adilger@sun.com> wrote:

> Are you sure this isn't because e2fsck has been run at boot time and changed
> e.g. the "last checked" timestamp in the superblock?
>
No, I replaced /sbin/init by something which compute the sha1sum of
the root partition, display it then call /sbin/init and I can see that
the hash has changed after mount -o remount,ro.

As little as I understand, I managed to make a diff between two
hexdump of small images where changes happened after I created a file
and remounted the fs ro and it seems that, the driver didn't wrote
changes to the disk until unmount  ( The hexdump clearly shows that
/lost+found and /test file has been written after the umount )

workaround: Is there some knob in /proc or /sys which can trigger all
pending changes to disk ? ( Like /proc/sys/vm/drop_caches but for
filesystems ? )
>> This only happen when the rootfs hash been mounted ro, then remounted
>> rw to make some changes and remounted ro.
>> On the next reboot the hash will change, but only one time. Next
>> reboots will not alter the control sum, until of course I remount it
>> RW.
>
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>
>



-- 
Camille Moncelier
http://devlife.org/

If Java had true garbage collection, most programs would
delete themselves upon execution.
