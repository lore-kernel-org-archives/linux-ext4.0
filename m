From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: Is it deliberate that the device mapper is not passing the
 DISCARD ioctls
Date: Tue, 21 Sep 2010 12:42:25 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1009211232010.3008@dhcp-lab-213.englab.brq.redhat.com>
References: <E1OxgCu-0000XW-29@tytso-glaptop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, dm-devel@redhat.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab0IUKmf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Sep 2010 06:42:35 -0400
In-Reply-To: <E1OxgCu-0000XW-29@tytso-glaptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 20 Sep 2010, Theodore Ts'o wrote:

> Hi there,
> 
> I was just testing discard support in mke2fs, and I was surprised that
> although the dm layer appears to pass discard requests through to the
> underlying block device driver when submitted through the bio layer
> (i.e., from kernel file systems), apparently the discard ioctls (i.e.,
> BLKDISCARD, BLKDISCARDSEC, BLKDISCARDZEROES) are not currently wired up
> in the dm layer.
> 
> Is this deliberate, or an oversight?
> 
> Thanks, regards,

Hi Ted,

I have tested this with 2.6.35 and it really did not work for me as
well, but with 2.6.36-rc5 (latests kernel) it works just fine. Though,
not sure when it was added. But according to the log it seems it was
merged in with 8357422d4bf33bc2c35884d4016c3fc9efbbc1d2.

-Lukas

> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
