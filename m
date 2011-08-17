From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: INFO: task jbd2/dm-0-8:3993 blocked for more than 120 seconds
Date: Wed, 17 Aug 2011 08:35:14 -0600
Message-ID: <96850198-2253-40F7-B99C-62A6097278FA@dilger.ca>
References: <4E4BC296.1040004@mageia.org>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Thomas Backlund <tmb@mageia.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:9643 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab1HQOek convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Aug 2011 10:34:40 -0400
In-Reply-To: <4E4BC296.1040004@mageia.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-08-17, at 7:31 AM, Thomas Backlund <tmb@mageia.org> wrote:
> 
> One of our buildnodes, a 8-core Supermicro X7DA8 system,
> and a WDC WD1002FAEX-0 sata disk hits the "blocked for more than 120 seconds" several times, and ends up resetting the ata bus.
> 
> The disk does not report any errors with smart, and we have the same model in a 24-core Supermicro X8DTN, and it does not show this problem.
> 
> ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> ata3.00: failed command: FLUSH CACHE EXT
> ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>         res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata3.00: status: { DRDY }
> ata3: soft resetting link
> ata3.00: configured for UDMA/133
> ata3.00: retrying FLUSH 0xea Emask 0x4
> ata3: EH complete

This is a problem with your disk hardware. 

Cheers, Andreas