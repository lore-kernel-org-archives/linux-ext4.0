From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.34 ext4_mb_free_metadata: Double free of blocks
Date: Fri, 2 Jul 2010 21:51:54 -0700
Message-ID: <20100702215154.a0799c1d.akpm@linux-foundation.org>
References: <AANLkTinR6E9hSkopCgqcVK9WHojNKesAH_5V5XoWSjiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Ragnar Hojland Espinosa <ragnar@ragnar-hojland.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774Ab0GCEwD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Jul 2010 00:52:03 -0400
In-Reply-To: <AANLkTinR6E9hSkopCgqcVK9WHojNKesAH_5V5XoWSjiA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(switch to linux-ext4)

On Mon, 28 Jun 2010 01:05:28 +0200 Ragnar Hojland Espinosa <ragnar@ragnar-hojland.com> wrote:

> Moving about 200 GB through the network out of the computer (vanilla
> 2.6.34, sata_via sata device), after it finished I noticed:
> 
> EXT4-fs error (device sda1): ext4_mb_free_metadata: Double free of
> blocks 20764 (20764 395)
> JBD: Spotted dirty metadata buffer (dev = sda1, blocknr = 0). There's
> a risk of filesystem corruption in case of system crash..
> 
> So I proceeded to umount and fsck.
> 
> # umount /vol3/
> # fsck -f /vol3/
> fsck from util-linux-ng 2.17.2
> e2fsck 1.41.11 (14-Mar-2010)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> Free blocks count wrong for group #6764 (17193, counted=16798).
> Fix<y>? yes
> 
> Free blocks count wrong (44974340, counted=44973945).
> Fix<y>? yes
> 
> FWIW.

