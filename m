From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: "data=writeback" and TRIM don't get along
Date: Wed, 07 Apr 2010 20:22:39 -0500
Message-ID: <4BBD2FDF.4040407@redhat.com>
References: <4BBD285B.9000603@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Nebojsa Trpkovic <trx.lists@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954Ab0DHBWp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Apr 2010 21:22:45 -0400
In-Reply-To: <4BBD285B.9000603@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Nebojsa Trpkovic wrote:
> Hello.
> 
> TRIM command issued to SSD doesn't work with this mount options:
> 
> ============================
> rootfs / rootfs rw 0 0
> /dev/root / ext4
> rw,noatime,commit=100,barrier=0,nobh,stripe=128,data=writeback,discard 0 0
> proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
> rc-svcdir /lib64/rc/init.d tmpfs
> rw,nosuid,nodev,noexec,relatime,size=1024k,mode=755 0 0
> sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
> udev /dev tmpfs rw,nosuid,relatime,size=10240k,mode=755 0 0
> devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620 0 0
> shm /dev/shm tmpfs rw,nosuid,nodev,noexec,relatime 0 0
> ============================

How does it fail?

> Removing "data=writeback" option from /etc/fstab and from rootflags in
> kernel boot options results in TRIM working just like it should.
> 
> So, the question is:
> 
> Is this "data=writeback" and TRIM incompatibility a bug or a feature? :)

Surely a bug.  :)  If you can provide details we'll look into it.
(perhaps it's obvious on first try but still worth saying exactly
what problematic behavior you saw, when reporting a bug you
encountered)

Thanks,
-Eric

