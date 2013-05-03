From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: fix fio regression
Date: Fri, 3 May 2013 02:17:20 -0400
Message-ID: <20130503061720.GA32297@thunk.org>
References: <1367166541-5618-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Yan, Zheng" <zheng.z.yan@intel.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46072 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762085Ab3ECGRZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 May 2013 02:17:25 -0400
Content-Disposition: inline
In-Reply-To: <1367166541-5618-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 29, 2013 at 12:29:01AM +0800, Zheng Liu wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> 
> We (Linux Kernel Performance project) found a regression introduced
> by commit:
> 
>   f7fec032aa ext4: track all extent status in extent status tree
> 
> The commit causes about 20% performance decrease in fio random write
> test. Profiler shows that rb_next() uses a lot of CPU time. The call
> stack is:
> 
>   rb_next
>   ext4_es_find_delayed_extent
>   ext4_map_blocks
>   _ext4_get_block
>   ext4_get_block_write
>   __blockdev_direct_IO
>   ext4_direct_IO
>   generic_file_direct_write
>   __generic_file_aio_write
>   ext4_file_write
>   aio_rw_vect_retry
>   aio_run_iocb
>   do_io_submit
>   sys_io_submit
>   system_call_fastpath
>   io_submit
>   td_io_getevents
>   io_u_queued_complete
>   thread_main
>   main
>   __libc_start_main
> 
> The cause is that ext4_es_find_delayed_extent() doesn't have an
> upper bound, it keeps searching until a delayed extent is found.
> When there are a lots of non-delayed entries in the extent state
> tree, ext4_es_find_delayed_extent() may uses a lot of CPU time.
> 
> Reported-by: LKP project <lkp@linux.intel.com>
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>

Thanks, applied.

					- Ted
