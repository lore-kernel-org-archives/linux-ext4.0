From: Christian Kujau <lists@nerdbynature.de>
Subject: benchmark results
Date: Thu, 24 Dec 2009 02:31:10 -0800 (PST)
Message-ID: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net,
	ext-users <ext3-users@redhat.com>, linu
Return-path: <linux-btrfs-owner@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I've had the chance to use a testsystem here and couldn't resist running a 
few benchmark programs on them: bonnie++, tiobench, dbench and a few 
generic ones (cp/rm/tar/etc...) on ext{234}, btrfs, jfs, ufs, xfs, zfs.

All with standard mkfs/mount options and +noatime for all of them.

Here are the results, no graphs - sorry:
   http://nerdbynature.de/benchmarks/v40z/2009-12-22/

Reiserfs is locking up during dbench, so I removed it from the 
config, here are some earlier results:

   http://nerdbynature.de/benchmarks/v40z/2009-12-21/bonnie.html

Bonnie++ couldn't complete on nilfs2, only the generic tests 
and tiobench were run. As nilfs2, ufs, zfs aren't supporting xattr, dbench 
could not be run on these filesystems.
   
Short summary, AFAICT:
    - btrfs, ext4 are the overall winners
    - xfs to, but creating/deleting many files was *very* slow
    - if you need only fast but no cool features or journaling, ext2
      is still a good choice :)

Thanks,
Christian.
-- 
BOFH excuse #84:

Someone is standing on the ethernet cable, causing a kink in the cable
