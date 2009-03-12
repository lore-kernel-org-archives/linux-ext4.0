From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: Re: BUG at fs/ext4/mballoc.c:3295
Date: Thu, 12 Mar 2009 18:13:52 +0100
Message-ID: <49B942D0.7080707@ph.tum.de>
References: <49B93E44.8070109@ph.tum.de> <49B94167.4070409@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:60249 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751927AbZCLRN7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Mar 2009 13:13:59 -0400
In-Reply-To: <49B94167.4070409@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> I don't see it:
> 
> # dd if=/dev/zero of=2mbfile bs=1M count=2
> # mkfs.ext4 -F 2mbfile
> # mount -o loop 2mbfile mnt/
> # dd if=/dev/zero of=mnt/file
> dd: writing to `mnt/file': No space left on device
> 1917+0 records in
> 1916+0 records out
> 980992 bytes (981 kB) copied, 0.0162723 s, 60.3 MB/s
> 
> is this more or less what you did?

Yes, except that I used the following parameters for mkfs.ext4 (IIRC):

/sbin/mkfs.ext4 -v -F -b 1024 -m 0 -g 512 -G 4 -I 128 -N 1 -O 
large_file,dir_index,flex_bg,extent,sparse_super image.ext4

Kind regards,

Thiemo Nagel
