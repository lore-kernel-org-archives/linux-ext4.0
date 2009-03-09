From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: mkfs.ext4: high default -i value undocumented
Date: Mon, 09 Mar 2009 15:17:23 +0100
Message-ID: <87r616vkzw.fsf@frosties.localdomain>
References: <alpine.LSU.2.00.0903040007470.12969@fbirervta.pbzchgretzou.qr>
	<49ADBB03.9070303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@medozas.de>, linux-ext4@vger.kernel.org,
	kzak@redhat.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:60674 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbZCIOR2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Mar 2009 10:17:28 -0400
In-Reply-To: <49ADBB03.9070303@redhat.com> (Eric Sandeen's message of "Tue, 03
	Mar 2009 17:19:31 -0600")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen <sandeen@redhat.com> writes:

> Jan Engelhardt wrote:
>> Hi,
>> 
>> 
>> Creating an ext4 filesystem on a 4 GB image file (to be loop-mounted 
>> later) gives me 256K inodes. Choosing -i 4096 instead gives 1M, which 
>> would mean the default for -i is 16384. 
>
> That's right, look in /etc/mke2fs.conf:
>
> [defaults]
>         base_features =
> sparse_super,filetype,resize_inode,dir_index,ext_attr
>         blocksize = 4096
>         inode_size = 256
>         inode_ratio = 16384
>
>> Besides me finding 16384 a 
>> little unreasonable (XFS offers 2M inodes by default), 
>
> XFS is a totally different beast, because it dynamically allocates
> inodes.  It doesn't really offer *anything* by default.
>
> Which part of a 16384-data-bytes-to-inode-count ratio do you find
> unreasonable?  Do you find it unreasonably high, or unreasonably low?

Too high for 4G, to low for 6 TiB.

MfG
        Goswin
