From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Unable to use ext4 as root fs
Date: Sun, 01 Nov 2009 19:49:24 -0600
Message-ID: <4AEE3AA4.6000500@redhat.com>
References: <4AEDEA68.3080803@aknet.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Stas Sergeev <stsp@aknet.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbZKBBvH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Nov 2009 20:51:07 -0500
In-Reply-To: <4AEDEA68.3080803@aknet.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Stas Sergeev wrote:
> Hi.
> 
> I am trying to move my PC from
> ext3 to ext4, and so far I can't
> get it to boot. I am getting this:
> ---
> EXT3-fs: sda3: couldn't mount because of unsupported optional features 
> (240).
> ---

Depending on your distribution, you may need to fix /etc/fstab to 
reflect ext4 as the fs type, or remake your initrd/initramfs - something 
in your boot process is trying to mount it explicitly as ext3 ("-o 
ext3"), which will of course fail.

-Eric

> Google reveals that this is normal,
> and the next thing would be the
> ext4 mount, but this doesn't happen.
> The current git kernel just locks
> up tight after that message. NMI
> watchdog doesn't do anything. The
> Fedora kernel doesn't lock up, the
> keyboard works, you can Ctrl-Alt-Del,
> but nothing happens, ext4 does not
> mount.
> I know that ext4 support is compilled
> in (builtin, not a module), because
> this very kernel mounts ext4 fine
> if I boot from ext3 root fs.
> Now, with the lack of the usual
> "unable to mount root, kernel panic",
> I am starting to suspect a bug somewhere.
> Can someone please give me the hint
> about what have to be done to boot
> from ext4? Or, in case there is nothing
> special to do, where should I start
> sticking printk's to get that somehow
> debugged?
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

