From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v3 02/13] vfs: introduce private radix tree structures
Date: Thu, 11 Oct 2012 21:35:47 +0800
Message-ID: <CAEH94Lh8=Ww_wFH_Q6KkOFxbcZ9Tdh66M5yCe30aaSB-tUFg1Q@mail.gmail.com>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
	<1349863655-29320-3-git-send-email-zwu.kernel@gmail.com>
	<20121010153450.GY4405@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: dave@jikos.cz, zwu.kernel@gmail.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, tytso@mit.edu,
	cmm@us.ibm.com, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60379 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab2JKNft (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Oct 2012 09:35:49 -0400
In-Reply-To: <20121010153450.GY4405@twin.jikos.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 10, 2012 at 11:34 PM, David Sterba <dave@jikos.cz> wrote:
> On Wed, Oct 10, 2012 at 06:07:24PM +0800, zwu.kernel@gmail.com wrote:
>> +void hot_track_init(struct super_block *sb)
>> +{
> ...
>> +}
>
>> +void hot_track_exit(struct super_block *sb)
>> +{
>> +     hot_cache_exit();
>> +}
>
> Needs to be exported if btrfs is built as a module, otherwise does not
> link
>
>   LDS     arch/x86/boot/compressed/vmlinux.lds
>   AS      arch/x86/boot/compressed/head_64.o
>   CC      arch/x86/boot/compressed/misc.o
>   CC      arch/x86/boot/compressed/string.o
>   CC      arch/x86/boot/compressed/cmdline.o
>   CC      arch/x86/boot/compressed/early_serial_console.o
>   OBJCOPY arch/x86/boot/compressed/vmlinux.bin
> ERROR: "hot_track_init" [fs/btrfs/btrfs.ko] undefined!
> ERROR: "hot_track_exit" [fs/btrfs/btrfs.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> make: *** Waiting for unfinished jobs....
Sorry for late response at first. Great, thanks.

>
>
> david



-- 
Regards,

Zhi Yong Wu
