From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add lazyinit stats support
Date: Tue, 17 May 2016 00:05:39 -0400
Message-ID: <20160517040539.GV7799@thunk.org>
References: <1463456488-93466-1-git-send-email-wangshilong1991@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@dilger.ca, sihara@ddn.com
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:32772 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbcEQEFm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 May 2016 00:05:42 -0400
Content-Disposition: inline
In-Reply-To: <1463456488-93466-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 17, 2016 at 11:41:28AM +0800, Wang Shilong wrote:
> From: Wang Shilong <wshilong@ddn.com>
> 
> Somtimes, we need figure out progress of Lazyinit
> in the background, this patch try to add stats support
> for it, output is something like:
> 
> $ cat /sys/fs/ext4/vda/lazyinit_stats
> groups_finished: 80
> groups_total: 80

That's more of a procfs style of output.  In general the sysfs idiom
would be to have two sysfs variables:

/sys/fs/ext4/vda/nr_block_groups
/sys/fs/ext4/vda/nr_lazyinit_bg_done

and each would return an integer value.

For example:

% cat /sys/block/sda/queue/discard_granularity
512
% cat /sys/block/sda/queue/discard_max_bytes
2147450880
% cat /sys/block/sda/queue/discard_zeroes_data
0

There are certainly some exceptions to this rule, but it certainly
simplifies the sysfs support code, as well as making it a bit easier
for userspace programs to parse the output from those files.

    	      	       	  	    - Ted
