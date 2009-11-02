From: Stas Sergeev <stsp@aknet.ru>
Subject: Re: Unable to use ext4 as root fs
Date: Mon, 02 Nov 2009 12:02:19 +0300
Message-ID: <4AEEA01B.3080904@aknet.ru>
References: <4AEDEA68.3080803@aknet.ru> <4AEE3AA4.6000500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imp01.mtu.ru ([62.5.255.10]:37292 "EHLO imp01.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987AbZKBJCN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Nov 2009 04:02:13 -0500
In-Reply-To: <4AEE3AA4.6000500@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

02.11.2009 04:49, Eric Sandeen wrote:
>> ---
>> EXT3-fs: sda3: couldn't mount because of unsupported optional features
>> (240).
>> ---
> Depending on your distribution, you may need to fix /etc/fstab to
> reflect ext4 as the fs type, or remake your initrd/initramfs - something
> in your boot process is trying to mount it explicitly as ext3 ("-o
> ext3"), which will of course fail.
Thanks Eric, rebuilding initrd worked!
It is still quite annoying that something
in the initrd makes the latest git kernel
to lock up hard after the mount failure
(and not for the Fedora kernel), but this
is probably unrelated to ext4...
Thanks for your help!
