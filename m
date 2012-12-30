From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [ext4:dev 68/75] include/trace/events/ext4.h:484:1: error: macro
 "DEFINE_EVENT" requires 4 arguments, but only 3 given
Date: Sat, 29 Dec 2012 21:44:57 -0500
Message-ID: <20121230024457.GH20918@thunk.org>
References: <50df1b6d.jLf9SqkSRJbKbQF1%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40915 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153Ab2L3CpB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Dec 2012 21:45:01 -0500
Content-Disposition: inline
In-Reply-To: <50df1b6d.jLf9SqkSRJbKbQF1%fengguang.wu@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 30, 2012 at 12:33:49AM +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
> head:   b977f3efba01c959b5e47f65e65dba81ef3c4cbe
> commit: fdd2c03289562245422d920645990ba3e4165034 [68/75] ext4: split off ext4_journalled_invalidatepage()
> config: make ARCH=x86_64 allmodconfig
> 
> Note: the ext4/dev HEAD b977f3e builds fine.
>       It only hurts bisectibility.

I've fixed this up in the ext4 patch queue.

     	   	      	       	     - Ted
