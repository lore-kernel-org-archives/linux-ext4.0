From: "George Spelvin" <linux@horizon.com>
Subject: Re: mke2fs -O 64bit -E resize=<anything> divides by 0
Date: 11 Nov 2012 23:32:43 -0500
Message-ID: <20121112043243.6736.qmail@science.horizon.com>
References: <FF74F654-B6E0-4BF9-A3FC-C2077275B542@dilger.ca>
Cc: linux-ext4@vger.kernel.org
To: adilger@dilger.ca, linux@horizon.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:20451 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752114Ab2KLEcp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 Nov 2012 23:32:45 -0500
In-Reply-To: <FF74F654-B6E0-4BF9-A3FC-C2077275B542@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> However, it should be pointed out that the "resize" option does not
> make sense for filesystems larger than 16TB.  The mechanism used for
> resizing beyond 16TB is different and does not need to reserve blocks.

Ah, thank you.  Is this tidbit documented anywhere?

After my patch, I ran the command, with a resize=<> option.
Was that number simply ignored?

(I'm presently bulk-copying into the partition, so I can re-mkfs
and restart the bulk copy if necessary.)
