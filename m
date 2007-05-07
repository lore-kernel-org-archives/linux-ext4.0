From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: JBD: ext2online wants too many credits (744 > 256)
Date: Sun, 6 May 2007 21:40:14 -0700
Message-ID: <20070506214014.8b7451ba.akpm@linux-foundation.org>
References: <20070506222626.GA25632@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Frank van Maarseveen <frankvm@frankvm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753903AbXEGEkV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 May 2007 00:40:21 -0400
In-Reply-To: <20070506222626.GA25632@janus>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 7 May 2007 00:26:26 +0200 Frank van Maarseveen <frankvm@frankvm.com> wrote:

> 2.6.20.6, FC4:
> 
> I created a 91248k ext3 fs with 4k blocksize:
> 
> | mke2fs -j -b 4096 /dev/vol1/project 
> | mke2fs 1.38 (30-Jun-2005)
> | Filesystem label=
> | OS type: Linux
> | Block size=4096 (log=2)
> | Fragment size=4096 (log=2)
> | 23552 inodes, 23552 blocks
> | 1177 blocks (5.00%) reserved for the super user
> | First data block=0
> | Maximum filesystem blocks=25165824
> | 1 block group
> | 32768 blocks per group, 32768 fragments per group
> | 23552 inodes per group
> 
> Writing inode tables: done                            
> Creating journal (1024 blocks): done
> Writing superblocks and filesystem accounting information: done
> 
> Next, I tried to resize it to about 3G using ext2online while mounted:
> 
> | # ext2online /dev/vol1/project 
> | ext2online v1.1.18 - 2001/03/18 for EXT2FS 0.5b
> | ext2online: ext2_ioctl: No space left on device
> |
> | ext2online: unable to resize /dev/mapper/vol1-project
> 
> At that time the kernel said:
> 
> |JBD: ext2online wants too many credits (744 > 256)
> 
> What is the limitation I should be aware of? Has it something to do with
> the journal log size?
> 
> The size actually did increase a bit, to 128112k.
> 
> 
> Steps to reproduce:
> Create a 3G partition, say /dev/vol1/project
> mke2fs -j -b 4096 /dev/vol1/project 22812
> mount it
> ext2online /dev/vol1/project said:
> 
> | ext2online v1.1.18 - 2001/03/18 for EXT2FS 0.5b
> | ext2online: ext2_ioctl: No space left on device
> | 
> | ext2online: unable to resize /dev/mapper/vol1-project
> 
> kernel said:
> 
> | JBD: ext2online wants too many credits (721 > 256)
> 

(added linux-ext4 to cc)
