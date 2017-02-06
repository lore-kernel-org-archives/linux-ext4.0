From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 7/7] ext4: add EXT4_IOC_GOINGDOWN ioctl
Date: Sun, 5 Feb 2017 19:50:59 -0500
Message-ID: <20170206005059.dpvx2czzbfnjldov@thunk.org>
References: <20170205073430.9109-7-tytso@mit.edu>
 <201702052110.VvYyEfJY%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: kbuild test robot <lkp@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36060 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751686AbdBFAvG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 5 Feb 2017 19:51:06 -0500
Content-Disposition: inline
In-Reply-To: <201702052110.VvYyEfJY%fengguang.wu@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 05, 2017 at 09:03:39PM +0800, kbuild test robot wrote:
> Hi Theodore,
> 
> [auto build test ERROR on ext4/dev]
> [also build test ERROR on next-20170203]
> [cannot apply to v4.10-rc6]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Theodore-Ts-o/ext4-fix-inline-data-error-paths/20170205-153921
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
> config: i386-allmodconfig (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All errors (new ones prefixed by >>):
> 
> >> ERROR: "do_invalidatepage" [fs/ext4/ext4.ko] undefined!

Fixed in the version I just pushed to the ext4 tree.

      	     	       	    	      	  - Ted
