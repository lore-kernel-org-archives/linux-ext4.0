From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsck: Device or resource busy
Date: Mon, 2 Jun 2008 16:21:44 -0400
Message-ID: <20080602202144.GD23119@mit.edu>
References: <alpine.DEB.1.10.0806021951460.6160@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:55542 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754180AbYFBUV7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 16:21:59 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0806021951460.6160@sheep.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 02, 2008 at 08:29:24PM +0200, Christian Kujau wrote:
> Hi there,
>
> I'm trying to repair a severely damaged ext4 partition. Actually, I don't 
> care any more for the data, I just wanted to see how far I could get, 
> because the "damage" here is: the partition was 1/3 of a RAID-0 setup :)

The key thing that you need to do when trying to recover from RAID
setups where you are missing one or more disks is to align the pieces
so they are in their original places, with the missing pieces replaced
with a /dev/zero device.

There is a starting point here which you may find helpful:

      http://debian.co.nz/Recovery+of+RAID+and+LVM2.html

      http://tldp.org/HOWTO/LVM-HOWTO/index.html

      http://www.tldp.org/HOWTO/Software-RAID-HOWTO.html 

(I'm assuming here you were using software RAID; if this was a
hardware RAID setup, then you need to know what sort of low-level
format was used by your hardware RAID device.)

						- Ted
