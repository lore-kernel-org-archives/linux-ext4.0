From: Wu Fengguang <fengguang.wu@intel.com>
Subject: ext4 data=writeback performs worse than data=ordered now
Date: Wed, 14 Dec 2011 21:34:00 +0800
Message-ID: <20111214133400.GA18565@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Li Shaohua <shaohua.li@intel.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:61060 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966Ab1LNOMK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Dec 2011 09:12:10 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Shaohua recently found that ext4 writeback mode could perform worse
than ordered mode in some cases. It may not be a big problem, however
we'd like to share some information on our findings.

I tested both 3.2 and 3.1 kernels on normal SATA disks and USB key.
The interesting thing is, data=writeback used to run a bit faster
than data=ordered, however situation get inverted presumably by the
IO-less dirty throttling.

The worst case happens for the USB key, where both old/new kernels
see ~10% worse performance for data=writeback.

wfg@bee /export/writeback% ./compare -g ext4 -c fs snb/JBOD*/*-3.2.0-rc3-pause6+
                    ext4                   ext4:wb
------------------------  ------------------------
                  216.50        -0.5%       215.50  snb/JBOD-4HDD-thresh=100M/ext4-1dd-1-3.2.0-rc3-pause6+
                  210.34        -0.5%       209.36  snb/JBOD-4HDD-thresh=1G/ext4-10dd-1-3.2.0-rc3-pause6+
                  218.92        -0.5%       217.85  snb/JBOD-4HDD-thresh=1G/ext4-1dd-1-3.2.0-rc3-pause6+
                  218.03        -0.1%       217.72  snb/JBOD-4HDD-thresh=8G/ext4-10dd-1-3.2.0-rc3-pause6+
                  221.19        -2.0%       216.82  snb/JBOD-4HDD-thresh=8G/ext4-1dd-1-3.2.0-rc3-pause6+
                 1084.98        -0.7%      1077.26  TOTAL write_bw

wfg@bee /export/writeback% ./compare -g ext4 -c fs fat/*/*-3.2.0-rc3-pause6+
                    ext4                   ext4:wb
------------------------  ------------------------
                   46.87        -1.9%        45.96  fat/UKEY-HDD/ext4-100dd-1-3.2.0-rc3-pause6+
                   57.40        -4.9%        54.61  fat/UKEY-HDD/ext4-10dd-1-3.2.0-rc3-pause6+
                   62.13        -1.2%        61.41  fat/UKEY-HDD/ext4-1dd-1-3.2.0-rc3-pause6+
                    2.46        -1.0%         2.44  fat/UKEY-thresh=100M/ext4-100dd-1-3.2.0-rc3-pause6+
                    4.52        -4.3%         4.33  fat/UKEY-thresh=100M/ext4-10dd-1-3.2.0-rc3-pause6+
                    6.20       -10.6%         5.54  fat/UKEY-thresh=100M/ext4-1dd-1-3.2.0-rc3-pause6+
                    2.55        +8.7%         2.77  fat/fio/ext4-fio_fat_mmap_randwrite_4k-1-3.2.0-rc3-pause6+
                    9.60        -4.0%         9.21  fat/fio/ext4-fio_fat_mmap_randwrite_64k-1-3.2.0-rc3-pause6+
                   53.57        -3.6%        51.61  fat/fio/ext4-fio_fat_rates-1-3.2.0-rc3-pause6+
                   49.16        -1.3%        48.51  fat/thresh=1000M/ext4-100dd-1-3.2.0-rc3-pause6+
                   56.20        -1.4%        55.40  fat/thresh=1000M/ext4-10dd-1-3.2.0-rc3-pause6+
                   57.86        -1.4%        57.07  fat/thresh=1000M/ext4-1dd-1-3.2.0-rc3-pause6+
                   50.36        -3.2%        48.75  fat/thresh=1000M:990M/ext4-100dd-1-3.2.0-rc3-pause6+
                   56.46        -1.4%        55.69  fat/thresh=1000M:990M/ext4-10dd-1-3.2.0-rc3-pause6+
                   57.51        -0.9%        56.97  fat/thresh=1000M:990M/ext4-1dd-1-3.2.0-rc3-pause6+
                   50.02        -0.8%        49.60  fat/thresh=1000M:999M/ext4-100dd-1-3.2.0-rc3-pause6+
                   55.56        -1.3%        54.84  fat/thresh=1000M:999M/ext4-10dd-1-3.2.0-rc3-pause6+
                   56.88        -0.6%        56.52  fat/thresh=1000M:999M/ext4-1dd-1-3.2.0-rc3-pause6+
                   32.03        -3.3%        30.98  fat/thresh=100M/ext4-100dd-1-3.2.0-rc3-pause6+
                   46.63        -2.5%        45.47  fat/thresh=100M/ext4-10dd-1-3.2.0-rc3-pause6+
                   56.67        -2.3%        55.34  fat/thresh=100M/ext4-1dd-1-3.2.0-rc3-pause6+
                   36.16        -0.9%        35.84  fat/thresh=10M/ext4-10dd-1-3.2.0-rc3-pause6+
                   56.01        -0.1%        55.98  fat/thresh=10M/ext4-1dd-1-3.2.0-rc3-pause6+
                   31.45        +0.2%        31.51  fat/thresh=1M/ext4-10dd-1-3.2.0-rc3-pause6+
                   52.83        -2.3%        51.62  fat/thresh=1M/ext4-1dd-1-3.2.0-rc3-pause6+
                 1047.06        -1.8%      1027.98  TOTAL write_bw

wfg@bee /export/writeback% ./compare -g ext4 -c fs fat/*/*-3.1.0+
                    ext4                   ext4:wb
------------------------  ------------------------
                   45.91        +2.2%        46.90  fat/UKEY-HDD/ext4-100dd-1-3.1.0+
                   54.53        +7.4%        58.54  fat/UKEY-HDD/ext4-10dd-1-3.1.0+
                   62.18        -3.8%        59.83  fat/UKEY-HDD/ext4-1dd-1-3.1.0+
                    2.41       -10.7%         2.15  fat/UKEY-thresh=100M/ext4-100dd-1-3.1.0+
                    4.24        -3.0%         4.11  fat/UKEY-thresh=100M/ext4-10dd-1-3.1.0+
                    6.25       -11.6%         5.53  fat/UKEY-thresh=100M/ext4-1dd-1-3.1.0+
                    2.20        +0.6%         2.22  fat/fio/ext4-fio_fat_mmap_randwrite_4k-1-3.1.0+
                    8.76        -4.2%         8.40  fat/fio/ext4-fio_fat_mmap_randwrite_64k-1-3.1.0+
                   50.95        +0.4%        51.17  fat/fio/ext4-fio_fat_rates-1-3.1.0+
                   47.44        +4.1%        49.40  fat/thresh=1000M/ext4-100dd-1-3.1.0+
                   53.30        +4.3%        55.60  fat/thresh=1000M/ext4-10dd-1-3.1.0+
                   56.02        +0.8%        56.47  fat/thresh=1000M/ext4-1dd-1-3.1.0+
                   47.99        +1.3%        48.61  fat/thresh=1000M:990M/ext4-100dd-1-3.1.0+
                   52.82        +0.3%        53.00  fat/thresh=1000M:990M/ext4-10dd-1-3.1.0+
                   54.73        +1.9%        55.74  fat/thresh=1000M:990M/ext4-1dd-1-3.1.0+
                   47.91        -0.6%        47.62  fat/thresh=1000M:999M/ext4-100dd-1-3.1.0+
                   51.51        +3.0%        53.05  fat/thresh=1000M:999M/ext4-10dd-1-3.1.0+
                   52.88        +1.6%        53.71  fat/thresh=1000M:999M/ext4-1dd-1-3.1.0+
                   34.56        -2.3%        33.76  fat/thresh=100M/ext4-100dd-1-3.1.0+
                   46.44        -1.3%        45.86  fat/thresh=100M/ext4-10dd-1-3.1.0+
                   54.76        +3.5%        56.65  fat/thresh=100M/ext4-1dd-1-3.1.0+
                   37.43        +3.4%        38.69  fat/thresh=10M/ext4-10dd-1-3.1.0+
                   55.21        -0.5%        54.95  fat/thresh=10M/ext4-1dd-1-3.1.0+
                   40.36        -1.3%        39.83  fat/thresh=1M/ext4-10dd-1-3.1.0+
                   55.66        -0.1%        55.61  fat/thresh=1M/ext4-1dd-1-3.1.0+
                 1026.44        +1.1%      1037.40  TOTAL write_bw

Here are the comparison between kernels. As you can see, the ordered
mode is improved slightly by 2% w/ IO-less, while data=writeback sees
-0.9% drop.

wfg@bee /export/writeback% ./compare -g ext4- fat/*/*-3.1.0+ fat/*/*-3.2.0-rc3-pause6+
                  3.1.0+         3.2.0-rc3-pause6+
------------------------  ------------------------
                   45.91        +2.1%        46.87  fat/UKEY-HDD/ext4-100dd-1-3.1.0+
                   54.53        +5.3%        57.40  fat/UKEY-HDD/ext4-10dd-1-3.1.0+
                   62.18        -0.1%        62.13  fat/UKEY-HDD/ext4-1dd-1-3.1.0+
                    2.41        +2.1%         2.46  fat/UKEY-thresh=100M/ext4-100dd-1-3.1.0+
                    4.24        +6.6%         4.52  fat/UKEY-thresh=100M/ext4-10dd-1-3.1.0+
                    6.25        -0.9%         6.20  fat/UKEY-thresh=100M/ext4-1dd-1-3.1.0+
                    2.20       +15.6%         2.55  fat/fio/ext4-fio_fat_mmap_randwrite_4k-1-3.1.0+
                    8.76        +9.5%         9.60  fat/fio/ext4-fio_fat_mmap_randwrite_64k-1-3.1.0+
                   50.95        +5.1%        53.57  fat/fio/ext4-fio_fat_rates-1-3.1.0+
                   47.44        +3.6%        49.16  fat/thresh=1000M/ext4-100dd-1-3.1.0+
                   53.30        +5.4%        56.20  fat/thresh=1000M/ext4-10dd-1-3.1.0+
                   56.02        +3.3%        57.86  fat/thresh=1000M/ext4-1dd-1-3.1.0+
                   47.99        +4.9%        50.36  fat/thresh=1000M:990M/ext4-100dd-1-3.1.0+
                   52.82        +6.9%        56.46  fat/thresh=1000M:990M/ext4-10dd-1-3.1.0+
                   54.73        +5.1%        57.51  fat/thresh=1000M:990M/ext4-1dd-1-3.1.0+
                   47.91        +4.4%        50.02  fat/thresh=1000M:999M/ext4-100dd-1-3.1.0+
                   51.51        +7.9%        55.56  fat/thresh=1000M:999M/ext4-10dd-1-3.1.0+
                   52.88        +7.6%        56.88  fat/thresh=1000M:999M/ext4-1dd-1-3.1.0+
                   34.56        -7.3%        32.03  fat/thresh=100M/ext4-100dd-1-3.1.0+
                   46.44        +0.4%        46.63  fat/thresh=100M/ext4-10dd-1-3.1.0+
                   54.76        +3.5%        56.67  fat/thresh=100M/ext4-1dd-1-3.1.0+
                   37.43        -3.4%        36.16  fat/thresh=10M/ext4-10dd-1-3.1.0+
                   55.21        +1.5%        56.01  fat/thresh=10M/ext4-1dd-1-3.1.0+
                   40.36       -22.1%        31.45  fat/thresh=1M/ext4-10dd-1-3.1.0+
                   55.66        -5.1%        52.83  fat/thresh=1M/ext4-1dd-1-3.1.0+
                 1026.44        +2.0%      1047.06  TOTAL write_bw

wfg@bee /export/writeback% ./compare -g ext4:wb fat/*/*-3.1.0+ fat/*/*-3.2.0-rc3-pause6+
                  3.1.0+         3.2.0-rc3-pause6+
------------------------  ------------------------
                   46.90        -2.0%        45.96  fat/UKEY-HDD/ext4:wb-100dd-1-3.1.0+
                   58.54        -6.7%        54.61  fat/UKEY-HDD/ext4:wb-10dd-1-3.1.0+
                   59.83        +2.7%        61.41  fat/UKEY-HDD/ext4:wb-1dd-1-3.1.0+
                    2.15       +13.3%         2.44  fat/UKEY-thresh=100M/ext4:wb-100dd-1-3.1.0+
                    4.11        +5.2%         4.33  fat/UKEY-thresh=100M/ext4:wb-10dd-1-3.1.0+
                    5.53        +0.2%         5.54  fat/UKEY-thresh=100M/ext4:wb-1dd-1-3.1.0+
                    2.22       +24.8%         2.77  fat/fio/ext4:wb-fio_fat_mmap_randwrite_4k-1-3.1.0+
                    8.40        +9.6%         9.21  fat/fio/ext4:wb-fio_fat_mmap_randwrite_64k-1-3.1.0+
                   51.17        +0.9%        51.61  fat/fio/ext4:wb-fio_fat_rates-1-3.1.0+
                   49.40        -1.8%        48.51  fat/thresh=1000M/ext4:wb-100dd-1-3.1.0+
                   55.60        -0.3%        55.40  fat/thresh=1000M/ext4:wb-10dd-1-3.1.0+
                   56.47        +1.1%        57.07  fat/thresh=1000M/ext4:wb-1dd-1-3.1.0+
                   48.61        +0.3%        48.75  fat/thresh=1000M:990M/ext4:wb-100dd-1-3.1.0+
                   53.00        +5.1%        55.69  fat/thresh=1000M:990M/ext4:wb-10dd-1-3.1.0+
                   55.74        +2.2%        56.97  fat/thresh=1000M:990M/ext4:wb-1dd-1-3.1.0+
                   47.62        +4.2%        49.60  fat/thresh=1000M:999M/ext4:wb-100dd-1-3.1.0+
                   53.05        +3.4%        54.84  fat/thresh=1000M:999M/ext4:wb-10dd-1-3.1.0+
                   53.71        +5.2%        56.52  fat/thresh=1000M:999M/ext4:wb-1dd-1-3.1.0+
                   33.76        -8.3%        30.98  fat/thresh=100M/ext4:wb-100dd-1-3.1.0+
                   45.86        -0.8%        45.47  fat/thresh=100M/ext4:wb-10dd-1-3.1.0+
                   56.65        -2.3%        55.34  fat/thresh=100M/ext4:wb-1dd-1-3.1.0+
                   38.69        -7.4%        35.84  fat/thresh=10M/ext4:wb-10dd-1-3.1.0+
                   54.95        +1.9%        55.98  fat/thresh=10M/ext4:wb-1dd-1-3.1.0+
                   39.83       -20.9%        31.51  fat/thresh=1M/ext4:wb-10dd-1-3.1.0+
                   55.61        -7.2%        51.62  fat/thresh=1M/ext4:wb-1dd-1-3.1.0+
                 1037.40        -0.9%      1027.98  TOTAL write_bw

Thanks,
Fengguang
