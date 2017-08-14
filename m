From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix clang build regression
Date: Mon, 14 Aug 2017 08:29:38 -0400
Message-ID: <20170814122938.caz2j2rqjcuxfqoz@thunk.org>
References: <20170807105701.3835991-1-arnd@arndb.de>
 <48473218.z3lFQE8RDq@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arnd Bergmann <arnd@arndb.de>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Stefan Agner <stefan@agner.ch>, Jan Kara <jack@suse.cz>,
        Daeho Jeong <daeho.jeong@samsung.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <48473218.z3lFQE8RDq@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Aug 12, 2017 at 02:09:29PM +0530, Chandan Rajendra wrote:
> On Monday, August 7, 2017 4:26:51 PM IST Arnd Bergmann wrote:
> > As Stefan pointed out, I misremembered what clang can do specifically,
> > and it turns out that the variable-length array at the end of the
> > structure did not work (a flexible array would have worked here
> > but not solved the problem):
> > 
> > fs/ext4/mballoc.c:2303:17: error: fields must have a constant size:
> > 'variable length array in structure' extension will never be supported
> >                 ext4_grpblk_t counters[blocksize_bits + 2];
> > 
> > This reverts part of my previous patch, using a fixed-size array
> > again, but keeping the check for the array overflow.
> > 
> > Fixes: 2df2c3402fc8 ("ext4: fix warning about stack corruption")
> > Reported-by: Stefan Agner <stefan@agner.ch>
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> I executed xfstests on a ppc64 machine with both 4k and 64k block size 
> combination.
> 
> Tested-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Thanks, applied.

						- Ted
