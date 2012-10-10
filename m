From: David Sterba <dave@jikos.cz>
Subject: Re: [RFC v3 02/13] vfs: introduce private radix tree structures
Date: Wed, 10 Oct 2012 17:34:50 +0200
Message-ID: <20121010153450.GY4405@twin.jikos.cz>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
 <1349863655-29320-3-git-send-email-zwu.kernel@gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	david@fromorbit.com, dave@jikos.cz, tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: zwu.kernel@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:44992 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab2JJPia (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Oct 2012 11:38:30 -0400
Content-Disposition: inline
In-Reply-To: <1349863655-29320-3-git-send-email-zwu.kernel@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 10, 2012 at 06:07:24PM +0800, zwu.kernel@gmail.com wrote:
> +void hot_track_init(struct super_block *sb)
> +{
...
> +}

> +void hot_track_exit(struct super_block *sb)
> +{
> +	hot_cache_exit();
> +}

Needs to be exported if btrfs is built as a module, otherwise does not
link

  LDS     arch/x86/boot/compressed/vmlinux.lds
  AS      arch/x86/boot/compressed/head_64.o
  CC      arch/x86/boot/compressed/misc.o
  CC      arch/x86/boot/compressed/string.o
  CC      arch/x86/boot/compressed/cmdline.o
  CC      arch/x86/boot/compressed/early_serial_console.o
  OBJCOPY arch/x86/boot/compressed/vmlinux.bin
ERROR: "hot_track_init" [fs/btrfs/btrfs.ko] undefined!
ERROR: "hot_track_exit" [fs/btrfs/btrfs.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2
make: *** Waiting for unfinished jobs....


david
