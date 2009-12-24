From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: benchmark results
Date: Thu, 24 Dec 2009 21:06:45 +0900 (JST)
Message-ID: <20091224.210645.57462112.ryusuke@osrg.net>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net, ext3-users@redhat.com,
	linux-nilfs@vger.kernel.org
To: lists@nerdbynature.de
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,
On Thu, 24 Dec 2009 02:31:10 -0800 (PST), Christian Kujau wrote:
> I've had the chance to use a testsystem here and couldn't resist running a 
> few benchmark programs on them: bonnie++, tiobench, dbench and a few 
> generic ones (cp/rm/tar/etc...) on ext{234}, btrfs, jfs, ufs, xfs, zfs.
> 
> All with standard mkfs/mount options and +noatime for all of them.
> 
> Here are the results, no graphs - sorry:
>    http://nerdbynature.de/benchmarks/v40z/2009-12-22/
> 
> Reiserfs is locking up during dbench, so I removed it from the 
> config, here are some earlier results:
> 
>    http://nerdbynature.de/benchmarks/v40z/2009-12-21/bonnie.html
> 
> Bonnie++ couldn't complete on nilfs2, only the generic tests 
> and tiobench were run.

I looked at the log but couldn't identify the error.
Is that a disk full?

Thanks,
Ryusuke Konishi


> As nilfs2, ufs, zfs aren't supporting xattr, dbench 
> could not be run on these filesystems.
>    
> Short summary, AFAICT:
>     - btrfs, ext4 are the overall winners
>     - xfs to, but creating/deleting many files was *very* slow
>     - if you need only fast but no cool features or journaling, ext2
>       is still a good choice :)
> 
> Thanks,
> Christian.
> -- 
> BOFH excuse #84:
> 
> Someone is standing on the ethernet cable, causing a kink in the cable
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
