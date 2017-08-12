From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: fix clang build regression
Date: Sat, 12 Aug 2017 14:09:29 +0530
Message-ID: <48473218.z3lFQE8RDq@localhost.localdomain>
References: <20170807105701.3835991-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Stefan Agner <stefan@agner.ch>, Jan Kara <jack@suse.cz>,
        Daeho Jeong <daeho.jeong@samsung.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170807105701.3835991-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Monday, August 7, 2017 4:26:51 PM IST Arnd Bergmann wrote:
> As Stefan pointed out, I misremembered what clang can do specifically,
> and it turns out that the variable-length array at the end of the
> structure did not work (a flexible array would have worked here
> but not solved the problem):
> 
> fs/ext4/mballoc.c:2303:17: error: fields must have a constant size:
> 'variable length array in structure' extension will never be supported
>                 ext4_grpblk_t counters[blocksize_bits + 2];
> 
> This reverts part of my previous patch, using a fixed-size array
> again, but keeping the check for the array overflow.
> 
> Fixes: 2df2c3402fc8 ("ext4: fix warning about stack corruption")
> Reported-by: Stefan Agner <stefan@agner.ch>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

I executed xfstests on a ppc64 machine with both 4k and 64k block size 
combination.

Tested-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

-- 
chandan
