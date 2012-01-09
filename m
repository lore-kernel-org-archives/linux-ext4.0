From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 discard does not apper in /proc/mounts
Date: Mon, 09 Jan 2012 11:12:24 -0600
Message-ID: <4F0B1FF8.8010200@redhat.com>
References: <1325978619.4567.2.camel@ierdnac-hp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: andrei.popa@i-neo.ro
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932266Ab2AIRM3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jan 2012 12:12:29 -0500
In-Reply-To: <1325978619.4567.2.camel@ierdnac-hp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/7/12 5:23 PM, Andrei Popa wrote:
> Hello,
> 
> ierdnac-hp ~ # cat /etc/fstab |grep discard
> /dev/sda3               /               ext4
> discard,noatime,norelatime,barrier=0,errors=remount-ro,data=writeback
> 0 1
> 
> ierdnac-hp ~ # tune2fs -l /dev/sda3|grep discard
> Default mount options:    journal_data_writeback discard
> 
> ierdnac-hp ~ # cat /proc/mounts |grep write
> /dev/root / ext4 rw,noatime,user_xattr,acl,barrier=0,data=writeback 0 0
> 
> 

What kernel?

If it's a recent kernel, here is the logic which controls whether to show it:

        if (test_opt(sb, DISCARD) && !(def_mount_opts & EXT4_DEFM_DISCARD))
                seq_puts(seq, ",discard");

i.e. if "discard" is in the default mount options for the fs, it is not
shown, by design - although I am not 100% sure why that design decision
was made; that logic was explicitly added here:

commit 8b67f04ab9de5d8f3a71aef72bf02c995a506db5
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun Aug 1 23:14:20 2010 -0400

    ext4: Add mount options in superblock
    
    Allow mount options to be stored in the superblock.  Also add default
    mount option bits for nobarrier, block_validity, discard, and nodelalloc.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

which contained:

-       if (test_opt(sb, DISCARD))
+       if (test_opt(sb, DISCARD) && !(def_mount_opts & EXT4_DEFM_DISCARD))
                seq_puts(seq, ",discard");

so maybe Ted can speak to the reasoning behind it; I think the general philosophy
is to not show any defaults in /proc/mounts.

Thanks,
-Eric
