Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22EB3C9458;
	Wed,  8 Apr 2026 13:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.32.30.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775653666; cv=none; b=kZclgadXzWYsKJIqe6JB7Q3HPv9d8YDipOogfZKaP4W7bmWChGX5PePECKiDpllIC8RS4wlVX/BZRe/7WA/XygTMj2y30puR7kMhAKnYBnAb3TXMVCm7ZesYcafxk51fLdddgUc71Z8MCtR5f3DeiBJWmtK/LEBptaoelYBBLtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775653666; c=relaxed/simple;
	bh=qzzmyovrtrzp1o2tZ4GbzmbIUbnliJkltIybOfk2jVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=fPp8ZtjQMBz2Sgj5XXv3Q90z+8xdHy6gqAO4UOlLhO59MaWE8oIr13p09ns3kVgVRvFL/aGQczyE+mbR5N/GQ8KshCK8SOSY1GfNXPIXoAFHwE9KiubaJ5lED1LQdQMuXigpkrFTrUNwaZutQLlPWdX3k/QT8sxrRU3DmK3qdvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk; spf=none smtp.mailfrom=armlinux.org.uk; dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b=YKDi7ouQ; arc=none smtp.client-ip=78.32.30.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="YKDi7ouQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=LJcb5JzkrNworeoIACd17sSdMyXcwWbNruEp7hbByvY=; b=YKDi7ouQsw5Cu03ml+uU76eoBT
	cgP2CCjRK2+s2prwZyfnXFtKKE4NFMBsIAlmoIVZmGL2WJ5NmQq6nIw92y9Q7aePEANaCJbzzmNgE
	bbUFs1F4mHXa50huAMGsp8i1smCXHQZwBt8VhgiJ4wps6laxkUkVDtTwu+RYTAM7dgq+ba1aGZEv1
	GXg//hmFB3e0TIGQToBSRBUc3YQrwII0ZVKJuE8cYs9d4aj1WPw8nZG6+P4BTbXsbeb0no/lI8ndt
	yI6EhTetwtnx6T6nhCqrqvFfR5Sc1KRyxFcmspXPLopQDKs3bciGVScUldjr29jywAgBhu2HnE/g+
	n8hXNDXA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34780)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1wASdA-000000002Lz-2XUB;
	Wed, 08 Apr 2026 14:07:40 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.98.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1wASd6-000000003Ln-3HCb;
	Wed, 08 Apr 2026 14:07:36 +0100
Date: Wed, 8 Apr 2026 14:07:36 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	linux-ext4@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Subject: BUG: net-next (7.0-rc6 based and later) fails to boot on Jetson
 Xavier NX
Message-ID: <adZTGOjjJrVJOcT8@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>

Hi,

Just a heads-up that current net-next (v7.0-rc6 based) fails to boot on
my nVidia Jetson Xavier platform. v7.0-rc5 and v6.14 based net-next both
boot fine. This is an arm64 platform.

The problem appears to be completely random in terms of its symptoms,
and looks like severe memory corruption - every boot seems to produce
a different problem. The common theme is, although the kernel gets to
userspace, it never gets anywhere close to a login prompt before
failing in some way.

The last net-next+ boot (which is currently v7.0-rc6 based) resulted
in:

tegra-mc 2c00000.memory-controller: xusb_hostw: secure write @0x00000003ffffff00: VPR violation ((null))
...
irq 91: nobody cared (try booting with the "irqpoll" option)
...
depmod: ERROR: could not open directory /lib/modules/7.0.0-rc6-net-next+: No such file or directory
...
Unable to handle kernel paging request at virtual address 0003201fd50320cf


A previous boot of the exact same kernel didn't oops, but was unable
to find the block device to mount for /mnt via block UUID.

A previous boot to that resulted in an oops.


The intersting thing is - the depmod error above is incorrect:

root@tegra-ubuntu:~# ls -ld /lib/modules/7.0.0-rc6-net-next+
drwxrwxr-x 3 root root 4096 Apr  8 10:23 /lib/modules/7.0.0-rc6-net-next+

The directory is definitely there, and is readable - checked after
booting back into net-next based on 7.0-rc5. In some of these boots,
stmmac hasn't probed yet, which rules out my changes.

Rootfs is ext4, and it seems there were a lot of ext4 commits merged
between rc5 and rc6, but nothing for rc7.

My current net-next head is dfecb0c5af3b. Merging rc7 on top also
fails, I suspect also randomly, with that I just got:

EXT4-fs (mmcblk0p1): VFS: Can't find ext4 filesystem
mount: /mnt: wrong fs type, bad option, bad superblock on /dev/mmcblk0p1, missing codepage or helper program, or other error.
mount: /mnt/: can't find PARTUUID=741c0777-391a-4bce-a222-455e180ece2a.
Unable to handle kernel paging request at virtual address f9bf0011ac0fb893
Mem abort info:
  ESR = 0x0000000096000004
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x04: level 0 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
  CM = 0, WnR = 0, TnD = 0, TagAccess = 0
  GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[f9bf0011ac0fb893] address between user and kernel address ranges
Internal error: Oops: 0000000096000004 [#1]  SMP
Modules linked in:
CPU: 1 UID: 0 PID: 936 Comm: mount Not tainted 7.0.0-rc7-net-next+ #649 PREEMPT
Hardware name: NVIDIA NVIDIA Jetson Xavier NX Developer Kit/Jetson, BIOS 6.0-37391689 08/28/2024
pstate: 20400009 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : refill_objects+0x298/0x5ec
lr : refill_objects+0x1f0/0x5ec

...

Call trace:
 refill_objects+0x298/0x5ec (P)
 __pcs_replace_empty_main+0x13c/0x3a8
 kmem_cache_alloc_noprof+0x324/0x3a0
 alloc_iova+0x3c/0x290
 alloc_iova_fast+0x168/0x2d4
 iommu_dma_alloc_iova+0x84/0x154
 iommu_dma_map_sg+0x2c4/0x538
 __dma_map_sg_attrs+0x124/0x2c0
 dma_map_sg_attrs+0x10/0x20
 sdhci_pre_dma_transfer+0xb8/0x164
 sdhci_pre_req+0x38/0x44
 mmc_blk_mq_issue_rq+0x3dc/0x920
 mmc_mq_queue_rq+0x104/0x2b0
 __blk_mq_issue_directly+0x38/0xb0
 blk_mq_request_issue_directly+0x54/0xb4
 blk_mq_issue_direct+0x84/0x180
 blk_mq_dispatch_queue_requests+0x1a8/0x2e0
 blk_mq_flush_plug_list+0x60/0x140
 __blk_flush_plug+0xe0/0x11c
 blk_finish_plug+0x38/0x4c
 read_pages+0x158/0x260
 page_cache_ra_unbounded+0x158/0x3e0
 force_page_cache_ra+0xb0/0xe4
 page_cache_sync_ra+0x88/0x480
 filemap_get_pages+0xd8/0x850
 filemap_read+0xdc/0x3d8
 blkdev_read_iter+0x84/0x198
 vfs_read+0x208/0x2d8
 ksys_read+0x58/0xf4
 __arm64_sys_read+0x1c/0x28
 invoke_syscall.constprop.0+0x50/0xe0
 do_el0_svc+0x40/0xc0
 el0_svc+0x48/0x2a0
 el0t_64_sync_handler+0xa0/0xe4
 el0t_64_sync+0x19c/0x1a0
Code: 54000189 f9000022 aa0203e4 b9402ae3 (f8634840)
---[ end trace 0000000000000000 ]---
Kernel panic - not syncing: Oops: Fatal exception

Looking at the changes between rc5 and rc6, there's one drivers/block
change for zram (which is used on this platform), one change in
drivers/base for regmap, nothing for drivers/mmc, but plenty for
fs/ext4. There are five DMA API changes.

Now building straight -rc7. If that also fails, my plan is to start
bisecting rc5..rc6, which will likely take most of the rest of the
day. So, in the mean time I'm sending this as a heads-up that rc6
and onwards has a problem.

I'll update when I have a potential commit located.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
