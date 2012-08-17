From: Fengguang Wu <fengguang.wu@intel.com>
Subject: ext4 write performance regression in 3.6-rc1
Date: Fri, 17 Aug 2012 14:09:15 +0800
Message-ID: <20120817060915.GB28786@localhost>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
 <20120816024654.GB3781@thunk.org>
 <20120816111051.GA16036@localhost>
 <20120816152513.GA31346@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Shi, Alex" <alex.shi@intel.com>, linux-fsdevel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Marti Raudsepp <marti@juffo.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22318 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab2HQGJV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Aug 2012 02:09:21 -0400
Content-Disposition: inline
In-Reply-To: <20120816152513.GA31346@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted,

I find ext4 write performance dropped by 3.3% on average in the
3.6-rc1 merge window. xfs and btrfs are fine.

Two machines are tested. The performance regression happens in the
lkp-nex04 machine, which is equipped with 12 SSD drives. lkp-st02 does
not see regression, which is equipped with HDD drives. I'll continue
to repeat the tests and report variations.

The below 3.6.0-rc1+ kernel is 3.6.0-rc1 plus the NULL deference fix.

wfg@bee /export/writeback% ./compare -g ext4 lkp-nex04/*/*-{3.5.0,3.6.0-rc1+}
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  720.62        -1.5%       710.16  lkp-nex04/JBOD-12HDD-thresh=1000M/ext4-100dd-1-3.5.0
                  706.04        -0.0%       705.86  lkp-nex04/JBOD-12HDD-thresh=1000M/ext4-10dd-1-3.5.0
                  702.86        -0.2%       701.74  lkp-nex04/JBOD-12HDD-thresh=1000M/ext4-1dd-1-3.5.0
                  779.52        +6.5%       830.11  lkp-nex04/JBOD-12HDD-thresh=100M/ext4-100dd-1-3.5.0
                  646.70        +4.9%       678.59  lkp-nex04/JBOD-12HDD-thresh=100M/ext4-10dd-1-3.5.0
                  704.49        +2.6%       723.00  lkp-nex04/JBOD-12HDD-thresh=100M/ext4-1dd-1-3.5.0
                  705.26        -1.2%       696.61  lkp-nex04/JBOD-12HDD-thresh=8G/ext4-100dd-1-3.5.0
                  703.37        +0.1%       703.76  lkp-nex04/JBOD-12HDD-thresh=8G/ext4-10dd-1-3.5.0
                  701.66        -0.1%       700.83  lkp-nex04/JBOD-12HDD-thresh=8G/ext4-1dd-1-3.5.0
                  675.08       -10.5%       604.29  lkp-nex04/RAID0-12HDD-thresh=1000M/ext4-100dd-1-3.5.0
                  676.52        -2.7%       658.38  lkp-nex04/RAID0-12HDD-thresh=1000M/ext4-10dd-1-3.5.0
                  512.70        +4.0%       533.22  lkp-nex04/RAID0-12HDD-thresh=1000M/ext4-1dd-1-3.5.0
                  709.76       -15.7%       598.44  lkp-nex04/RAID0-12HDD-thresh=100M/ext4-100dd-1-3.5.0
                  681.39        -2.1%       667.25  lkp-nex04/RAID0-12HDD-thresh=100M/ext4-10dd-1-3.5.0
                  699.77       -19.2%       565.54  lkp-nex04/RAID0-12HDD-thresh=8G/ext4-100dd-1-3.5.0
                  675.79        -1.9%       663.17  lkp-nex04/RAID0-12HDD-thresh=8G/ext4-10dd-1-3.5.0
                  484.84        -7.4%       448.83  lkp-nex04/RAID0-12HDD-thresh=8G/ext4-1dd-1-3.5.0
                  167.97       -38.7%       103.03  lkp-nex04/RAID5-12HDD-thresh=1000M/ext4-100dd-1-3.5.0
                  243.67        -9.1%       221.41  lkp-nex04/RAID5-12HDD-thresh=1000M/ext4-10dd-1-3.5.0
                  248.98       +12.2%       279.33  lkp-nex04/RAID5-12HDD-thresh=1000M/ext4-1dd-1-3.5.0
                   71.18       -34.2%        46.82  lkp-nex04/RAID5-12HDD-thresh=100M/ext4-100dd-1-3.5.0
                  145.84        -7.3%       135.25  lkp-nex04/RAID5-12HDD-thresh=100M/ext4-10dd-1-3.5.0
                  255.22        +6.7%       272.35  lkp-nex04/RAID5-12HDD-thresh=100M/ext4-1dd-1-3.5.0
                  209.24       -23.6%       159.96  lkp-nex04/RAID5-12HDD-thresh=8G/ext4-100dd-1-3.5.0
                  243.73       -10.9%       217.28  lkp-nex04/RAID5-12HDD-thresh=8G/ext4-10dd-1-3.5.0
                  214.25        +5.6%       226.32  lkp-nex04/RAID5-12HDD-thresh=8G/ext4-1dd-1-3.5.0
                13286.46        -3.3%     12851.55  TOTAL write_bw

wfg@bee /export/writeback% ./compare -g xfs lkp-nex04/*/*-{3.5.0,3.6.0-rc1+}
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  687.76        +2.4%       704.52  lkp-nex04/JBOD-12HDD-thresh=1000M/xfs-100dd-1-3.5.0
                  705.09        +0.0%       705.11  lkp-nex04/JBOD-12HDD-thresh=1000M/xfs-10dd-1-3.5.0
                  702.21        -0.1%       701.72  lkp-nex04/JBOD-12HDD-thresh=1000M/xfs-1dd-1-3.5.0
                  664.86       +21.8%       809.81  lkp-nex04/JBOD-12HDD-thresh=100M/xfs-100dd-1-3.5.0
                  609.97       +13.6%       693.12  lkp-nex04/JBOD-12HDD-thresh=100M/xfs-10dd-1-3.5.0
                  708.30        +0.8%       713.68  lkp-nex04/JBOD-12HDD-thresh=100M/xfs-1dd-1-3.5.0
                  701.19        -0.0%       700.85  lkp-nex04/JBOD-12HDD-thresh=8G/xfs-10dd-1-3.5.0
                  701.69        -0.1%       701.01  lkp-nex04/JBOD-12HDD-thresh=8G/xfs-1dd-1-3.5.0
                  699.98        -0.4%       697.40  lkp-nex04/RAID0-12HDD-thresh=1000M/xfs-10dd-1-3.5.0
                  653.92        +0.3%       656.07  lkp-nex04/RAID0-12HDD-thresh=1000M/xfs-1dd-1-3.5.0
                  650.25        +0.5%       653.32  lkp-nex04/RAID0-12HDD-thresh=100M/xfs-10dd-1-3.5.0
                  612.47        -2.9%       594.93  lkp-nex04/RAID0-12HDD-thresh=100M/xfs-1dd-1-3.5.0
                  694.90        +0.0%       695.19  lkp-nex04/RAID0-12HDD-thresh=8G/xfs-10dd-1-3.5.0
                  607.37       +14.2%       693.36  lkp-nex04/RAID0-12HDD-thresh=8G/xfs-1dd-1-3.5.0
                  273.54       +27.1%       347.67  lkp-nex04/RAID5-12HDD-thresh=1000M/xfs-10dd-1-3.5.0
                  277.00       +30.6%       361.71  lkp-nex04/RAID5-12HDD-thresh=1000M/xfs-1dd-1-3.5.0
                  194.74        +6.6%       207.62  lkp-nex04/RAID5-12HDD-thresh=100M/xfs-10dd-1-3.5.0
                  288.92       +21.2%       350.05  lkp-nex04/RAID5-12HDD-thresh=100M/xfs-1dd-1-3.5.0
                  278.33       +26.4%       351.78  lkp-nex04/RAID5-12HDD-thresh=8G/xfs-10dd-1-3.5.0
                  285.64       +24.2%       354.68  lkp-nex04/RAID5-12HDD-thresh=8G/xfs-1dd-1-3.5.0
                10998.15        +6.3%     11693.60  TOTAL write_bw

wfg@bee /export/writeback% ./compare -g btrfs lkp-nex04/*/*-{3.5.0,3.6.0-rc1+}
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  703.26        -0.1%       702.57  lkp-nex04/JBOD-12HDD-thresh=1000M/btrfs-10dd-1-3.5.0
                  701.88        -0.0%       701.85  lkp-nex04/JBOD-12HDD-thresh=1000M/btrfs-1dd-1-3.5.0
                  697.67        +7.1%       747.07  lkp-nex04/JBOD-12HDD-thresh=100M/btrfs-10dd-1-3.5.0
                  712.91        -0.4%       710.36  lkp-nex04/JBOD-12HDD-thresh=100M/btrfs-1dd-1-3.5.0
                  702.02        -0.1%       701.26  lkp-nex04/JBOD-12HDD-thresh=8G/btrfs-10dd-1-3.5.0
                  702.06        -0.1%       701.66  lkp-nex04/JBOD-12HDD-thresh=8G/btrfs-1dd-1-3.5.0
                  709.01        -0.7%       703.83  lkp-nex04/RAID0-12HDD-thresh=1000M/btrfs-10dd-1-3.5.0
                  696.67        -4.2%       667.22  lkp-nex04/RAID0-12HDD-thresh=1000M/btrfs-1dd-1-3.5.0
                  822.15        +0.1%       823.01  lkp-nex04/RAID0-12HDD-thresh=100M/btrfs-10dd-1-3.5.0
                  685.14        +2.9%       705.35  lkp-nex04/RAID0-12HDD-thresh=100M/btrfs-1dd-1-3.5.0
                  702.55        -0.0%       702.23  lkp-nex04/RAID0-12HDD-thresh=8G/btrfs-10dd-1-3.5.0
                  674.09        -7.1%       626.31  lkp-nex04/RAID0-12HDD-thresh=8G/btrfs-1dd-1-3.5.0
                  270.81       +21.0%       327.76  lkp-nex04/RAID5-12HDD-thresh=1000M/btrfs-10dd-1-3.5.0
                  267.19       +15.8%       309.36  lkp-nex04/RAID5-12HDD-thresh=1000M/btrfs-1dd-1-3.5.0
                  273.89       +25.3%       343.10  lkp-nex04/RAID5-12HDD-thresh=100M/btrfs-10dd-1-3.5.0
                  276.31       +19.7%       330.87  lkp-nex04/RAID5-12HDD-thresh=100M/btrfs-1dd-1-3.5.0
                  251.25       +17.3%       294.80  lkp-nex04/RAID5-12HDD-thresh=8G/btrfs-10dd-1-3.5.0
                  267.48        +7.1%       286.47  lkp-nex04/RAID5-12HDD-thresh=8G/btrfs-1dd-1-3.5.0
                10116.34        +2.7%     10385.07  TOTAL write_bw

wfg@bee /export/writeback% ./compare -g ext4 lkp-st02-x8664/*/*-{3.5.0,3.6.0-rc1+}
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  900.62        +0.1%       901.66  lkp-st02-x8664/JBOD-12HDD-thresh=100M/ext4-1dd-1-3.5.0
                  898.13        +1.4%       910.73  lkp-st02-x8664/JBOD-12HDD-thresh=2G/ext4-1dd-1-3.5.0
                  166.95        +3.8%       173.33  lkp-st02-x8664/RAID5-12HDD-thresh=100M/ext4-1dd-1-3.5.0
                  176.14        +2.8%       181.01  lkp-st02-x8664/RAID5-12HDD-thresh=2G/ext4-1dd-1-3.5.0
                   25.84        +0.3%        25.92  lkp-st02-x8664/jbod_12hdd/ext4-fio_jbod_12hdd_randrw_mmap_0_4k-1-3.5.0
                   92.34        -4.8%        87.88  lkp-st02-x8664/jbod_12hdd/ext4-fio_jbod_12hdd_randrw_mmap_0_64k-1-3.5.0
                   21.20        +2.1%        21.65  lkp-st02-x8664/jbod_12hdd/ext4-fio_jbod_12hdd_randrw_mmap_1_4k-1-3.5.0
                   90.43        +1.6%        91.90  lkp-st02-x8664/jbod_12hdd/ext4-fio_jbod_12hdd_randrw_mmap_1_64k-1-3.5.0
                   28.69        -1.8%        28.18  lkp-st02-x8664/jbod_12hdd/ext4-fio_jbod_12hdd_randrw_sync_0_4k-1-3.5.0
                  201.86        +0.2%       202.17  lkp-st02-x8664/jbod_12hdd/ext4-fio_jbod_12hdd_randrw_sync_0_64k-1-3.5.0
                   28.43        -0.2%        28.37  lkp-st02-x8664/jbod_12hdd/ext4-fio_jbod_12hdd_randwrite_mmap_0_4k-1-3.5.0
                  110.25        -0.1%       110.20  lkp-st02-x8664/jbod_12hdd/ext4-fio_jbod_12hdd_randwrite_mmap_0_64k-1-3.5.0
                   31.20        +0.5%        31.36  lkp-st02-x8664/jbod_12hdd/ext4-fio_jbod_12hdd_randwrite_sync_0_4k-1-3.5.0
                  289.28        +1.0%       292.08  lkp-st02-x8664/jbod_12hdd/ext4-fio_jbod_12hdd_randwrite_sync_0_64k-1-3.5.0
                   20.50        +0.9%        20.67  lkp-st02-x8664/jbod_12hdd/ext4-fio_jbod_12hdd_randwrite_sync_1_4k-1-3.5.0
                  294.64        +0.4%       295.94  lkp-st02-x8664/jbod_12hdd/ext4-fio_jbod_12hdd_randwrite_sync_1_64k-1-3.5.0
                 3376.51        +0.8%      3403.05  TOTAL write_bw

wfg@bee /export/writeback% ./compare -g xfs lkp-st02-x8664/*/*-{3.5.0,3.6.0-rc1+}
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  976.57        -4.8%       929.50  lkp-st02-x8664/JBOD-12HDD-thresh=100M/xfs-1dd-1-3.5.0
                 1003.33        +2.3%      1026.41  lkp-st02-x8664/JBOD-12HDD-thresh=2G/xfs-1dd-1-3.5.0
                  796.67        -2.1%       780.09  lkp-st02-x8664/RAID0-12HDD-thresh=100M/xfs-1dd-1-3.5.0
                  754.89        +0.3%       757.24  lkp-st02-x8664/RAID0-12HDD-thresh=2G/xfs-1dd-1-3.5.0
                  183.18        +7.6%       197.02  lkp-st02-x8664/RAID5-12HDD-thresh=100M/xfs-1dd-1-3.5.0
                  191.62        +9.0%       208.92  lkp-st02-x8664/RAID5-12HDD-thresh=2G/xfs-1dd-1-3.5.0
                   71.83        -1.0%        71.13  lkp-st02-x8664/jbod_12hdd/xfs-fio_jbod_12hdd_randrw_mmap_0_4k-1-3.5.0
                  104.93        -1.3%       103.56  lkp-st02-x8664/jbod_12hdd/xfs-fio_jbod_12hdd_randrw_mmap_0_64k-1-3.5.0
                   25.90        -0.4%        25.79  lkp-st02-x8664/jbod_12hdd/xfs-fio_jbod_12hdd_randrw_mmap_1_4k-1-3.5.0
                   88.13        +1.1%        89.06  lkp-st02-x8664/jbod_12hdd/xfs-fio_jbod_12hdd_randrw_mmap_1_64k-1-3.5.0
                   88.63        +0.2%        88.85  lkp-st02-x8664/jbod_12hdd/xfs-fio_jbod_12hdd_randrw_sync_0_4k-1-3.5.0
                  291.55        +0.1%       291.70  lkp-st02-x8664/jbod_12hdd/xfs-fio_jbod_12hdd_randrw_sync_0_64k-1-3.5.0
                   87.44        -1.5%        86.15  lkp-st02-x8664/jbod_12hdd/xfs-fio_jbod_12hdd_randwrite_mmap_0_4k-1-3.5.0
                  122.64        -1.6%       120.69  lkp-st02-x8664/jbod_12hdd/xfs-fio_jbod_12hdd_randwrite_mmap_0_64k-1-3.5.0
                  507.15        +0.2%       508.12  lkp-st02-x8664/jbod_12hdd/xfs-fio_jbod_12hdd_randwrite_sync_0_64k-1-3.5.0
                   32.09        -0.8%        31.85  lkp-st02-x8664/jbod_12hdd/xfs-fio_jbod_12hdd_randwrite_sync_1_4k-1-3.5.0
                  331.16        +0.2%       331.77  lkp-st02-x8664/jbod_12hdd/xfs-fio_jbod_12hdd_randwrite_sync_1_64k-1-3.5.0
                 5657.70        -0.2%      5647.85  TOTAL write_bw

wfg@bee /export/writeback% ./compare -g btrfs lkp-st02-x8664/*/*-{3.5.0,3.6.0-rc1+}
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  970.57        -2.9%       942.80  lkp-st02-x8664/JBOD-12HDD-thresh=100M/btrfs-1dd-1-3.5.0
                  965.95        -0.1%       964.91  lkp-st02-x8664/JBOD-12HDD-thresh=2G/btrfs-1dd-1-3.5.0
                  813.94        -2.3%       794.99  lkp-st02-x8664/RAID0-12HDD-thresh=100M/btrfs-1dd-1-3.5.0
                  860.05       -11.1%       764.50  lkp-st02-x8664/RAID0-12HDD-thresh=2G/btrfs-1dd-1-3.5.0
                  164.02       +15.3%       189.09  lkp-st02-x8664/RAID5-12HDD-thresh=100M/btrfs-1dd-1-3.5.0
                  163.78       +14.1%       186.94  lkp-st02-x8664/RAID5-12HDD-thresh=2G/btrfs-1dd-1-3.5.0
                 3938.30        -2.4%      3843.24  TOTAL write_bw

Thanks,
Fengguang
