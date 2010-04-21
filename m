From: Eric Paris <eparis@redhat.com>
Subject: Re: busy inodes -> ext3 umount crash
Date: Wed, 21 Apr 2010 12:00:48 -0400
Message-ID: <1271865648.2899.19.camel@dhcp235-240.rdu.redhat.com>
References: <4BC8A7C1.20102@gmail.com> <20100419141158.GB5439@quack.suse.cz>
	 <4BCC69B4.2050308@gmail.com> <4BCDB633.9040901@gmail.com>
	 <20100420152844.GB3885@quack.suse.cz>  <4BCF16CE.2080403@gmail.com>
	 <1271863450.2899.12.camel@dhcp235-240.rdu.redhat.com>
	 <4BCF1DFB.8020202@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	adilger@sun.com, linux-ext4@vger.kernel.org,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	mszeredi@suse.cz
To: Jiri Slaby <jirislaby@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab0DUQB3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Apr 2010 12:01:29 -0400
In-Reply-To: <4BCF1DFB.8020202@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2010-04-21 at 17:47 +0200, Jiri Slaby wrote:
> On 04/21/2010 05:24 PM, Eric Paris wrote:
> > I'll take a look, but I'm not seeing a problem right off
> > hand.  This patch wasn't supposed to mess with inode refcounting at
> > all....
> 
> Heh, but with very high probability now, it did :). Do you want me to
> inject some printouts anywhere? Can you reproduce it? KDE doesn't
> trigger the bug. After I switched from KDE to gnome in qemu, it started
> to occur (X :0 & (sleep 1; DISPLAY=:0 gnome-session)).

Well I reproduced and I'll take a look.  reliable steps seem to be:

# dd if=/dev/zero of=/dev/shm/ext3 bs=1024 count=1 seek=$((100*1024))
# mkfs.ext3 -m 0 /dev/shm/ext3
# mount -oloop /dev/shm/ext3 /mnt/c
# touch /mnt/c/file
# inotifywait -m /mnt/c/file
# umount /mnt/c
# dmesg|tail

-Eric

