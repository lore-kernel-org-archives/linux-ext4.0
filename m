From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/1] mm/block: convert rw_page users to bio op use
Date: Fri, 5 Aug 2016 12:18:55 +1000
Message-ID: <20160805021854.GV12670@dastard>
References: <201608050158.hllBWy4G%fengguang.wu@intel.com>
 <38523086-1436-fdbf-bd89-9f31ad134bed@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild test robot <lkp@intel.com>,
	Mike Christie <mchristi@redhat.com>, kbuild-all@01.org,
	ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	minchan@kernel.org, ngupta@vflare.org, vishal.l.verma@intel.com
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <38523086-1436-fdbf-bd89-9f31ad134bed@kernel.dk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 04, 2016 at 01:27:37PM -0600, Jens Axboe wrote:
> On 08/04/2016 11:50 AM, kbuild test robot wrote:
> >Hi Mike,
> >
> >[auto build test ERROR on linus/master]
> >[also build test ERROR on next-20160804]
> >[cannot apply to v4.7]
> >[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> >
> >url:    https://github.com/0day-ci/linux/commits/Mike-Christie/mm-block-convert-rw_page-users-to-bio-op-use/20160805-012041
> >config: i386-tinyconfig (attached as .config)
> >compiler: gcc-6 (Debian 6.1.1-9) 6.1.1 20160705
> >reproduce:
> >        # save the attached .config to linux build tree
> >        make ARCH=i386
> >
> >All errors (new ones prefixed by >>):
> >
> >   mm/filemap.c: In function 'page_endio':
> >>>mm/filemap.c:892:7: error: implicit declaration of function 'op_is_write' [-Werror=implicit-function-declaration]
> >     if (!op_is_write(op)) {
> >          ^~~~~~~~~~~
> 
> Mike, how about moving op_is_write() outside of CONFIG_BLOCK protection
> in fs.h, and making the REQ_OP_* enum generally available as well? That
> should fix it.

Give this is being spread all over the kernel way outside the block
layer and IO path, shouldn't this have some kind of namespace
component to the name? i.e "req_op_is_write()"?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
