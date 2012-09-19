From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC][PATCH 2/8 v2] ext4: add operations on extent status tree
Date: Wed, 19 Sep 2012 14:34:52 -0400
Message-ID: <20120919183452.GB28470@thunk.org>
References: <1345615545-26133-1-git-send-email-wenqing.lz@taobao.com>
 <1345615545-26133-3-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Lukas Czerner <lczerner@redhat.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1345615545-26133-3-git-send-email-wenqing.lz@taobao.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 22, 2012 at 02:05:39PM +0800, Zheng Liu wrote:
> + * 3. performance analysis
> + *   --	overhead
> + *	1. Apart from operations on a delayed extent tree, we need to
> + *	down_write(inode->i_data_sem) in delayed write path to maintain delayed
> + *	extent tree, this can have impact on parallel read-write and write-write

I'm working on going through this patch set now, and I'm not sure this
is worth holding back on this patch series, but I am really concerned
about the performance impact of this....  it would definitely show up
on some of the scalability testing that Eric Whitney had been doing,
for example.

Given that operations on the delayed extent tree should be fast,
instead of using a mutex, any reason why we can't just add a new
spinlock (I'm not even sure we need a rw_spinlock here) to the
ext4_inode_info structure and use that to serialize operations on the
delayed extent tree?

						- Ted
