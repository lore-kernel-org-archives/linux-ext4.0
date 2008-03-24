From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: e2fsprogs and fast symlink
Date: Mon, 24 Mar 2008 13:25:33 +0100 (CET)
Message-ID: <alpine.DEB.1.00.0803241323350.4451@sheep.housecafe.de>
References: <20080321114234.GB6542@skywalker>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns2.g-housing.de ([81.169.133.75]:42783 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228AbYCXM0o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Mar 2008 08:26:44 -0400
In-Reply-To: <20080321114234.GB6542@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 21 Mar 2008, Aneesh Kumar K.V wrote:
> The below test case fails x86
> #ln -s sfdajsfsdsdfskjdgfkshdfkshdfkgdsjdsjdhsdfdafdsgakfasdgfsjksdsdsdfsd p
> #sync
> #rm p
> root@elm3b165:~# /usr/local/e2fsprogs/sbin/e2fsck  -f  /dev/sda5
> e2fsck 1.40.8 (13-Mar-2008)
> Pass 1: Checking inodes, blocks, and sizes
> Fast symlink 12 has EXTENT_FL set.  Clear<y>?
>
> ie because after deleting the file we have
> debugfs:  stat <12>
> Inode: 12   Type: symlink    Mode:  0777   Flags: 0x80000   Generation:
> 25346603
> User:     0   Group:     0   Size: 0
> File ACL: 0    Directory ACL: 0
> Links: 0   Blockcount: 0
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x47e39ea3 -- Fri Mar 21 11:40:19 2008
> atime: 0x47e39e9e -- Fri Mar 21 11:40:14 2008
> mtime: 0x47e39e9a -- Fri Mar 21 11:40:10 2008
> dtime: 0x47e39ea3 -- Fri Mar 21 11:40:19 2008
> Size of extra inode fields: 28
> Fast_link_dest:

Aneesh, can you elaborate a bit for me (a user, not a developer) what this 
means? I too had these "Fast symlink 12 has EXTENT_FL set.  Clear<y>?" 
messages on my ext4 fs and I went on to "Clear" these things. Now I notice 
some serious performance (or better: load) problems when doing stuff on 
ext4 and I'm not sure if this could be related to the changes e2fsprogs 
did.

Thanks,
Christian.
-- 
BOFH excuse #199:

the curls in your keyboard cord are losing electricity.
