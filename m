From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: INFO: task umount:1524 blocked for more than 120 seconds
Date: Sun, 16 May 2010 11:28:38 -0700
Message-ID: <4BF03956.6020105@gmail.com>
References: <h2xdd18b0c31005101446pf8201153vaed5b38afe72d7ad@mail.gmail.com> <4BE88705.9030105@gmail.com> <4BE890E8.9010700@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:53898 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab0EPS2I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 May 2010 14:28:08 -0400
In-Reply-To: <4BE890E8.9010700@s5r6.in-berlin.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

well, I'm confused on this one..

If I cp -R 2.6.34(kernel) using the macbook pro
I can umount cleanly. But if I do the same for
the iMac9,1 I get this issue.

At first thought this might be an ext4 sync(and possibly)
hardware issue but if it was, then the  macbook would portrait
similar issues as well(but could be wrong).

I did add(hopefully)the firelite device to the
workaround list with as many options as possible,
but had no difference(added/removed options as well)
here is what the patch looks like:


  From 445d63a80e336408151f4dff7c23fb59a070d246 Mon Sep 17 00:00:00 2001
  From: Justin P. Mattock <justinmattock@gmail.com>
  Date: Sun, 16 May 2010 11:23:00 -0700
  Subject: [PATCH] fix an umount bug
   Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

  ---
   drivers/ieee1394/sbp2.c |   11 +++++++++++
   1 files changed, 11 insertions(+), 0 deletions(-)

  diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
  index 4565cb5..ce826f3 100644
  --- a/drivers/ieee1394/sbp2.c
  +++ b/drivers/ieee1394/sbp2.c
  @@ -393,6 +393,17 @@ static const struct {
   		.model			= SBP2_ROM_VALUE_WILDCARD,
   		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS,
   	},
  +		/* SmartDsk FireLite Model #FWFL60-N */
  +	{
  +		.firmware_revision	= 0x000470,
  +		.model			= 0x000000,
  +		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS |
  +					  SBP2_WORKAROUND_INQUIRY_36 |
  +					  SBP2_WORKAROUND_MODE_SENSE_8 |
  +					  SBP2_WORKAROUND_FIX_CAPACITY |
  +					  SBP2_WORKAROUND_DELAY_INQUIRY |
  +					  SBP2_WORKAROUND_POWER_CONDITION,
  +	},
   	/*
   	 * iPod 2nd generation: needs 128k max transfer size workaround
   	 * iPod 3rd generation: needs fix capacity workaround
  --
  1.6.5.2.180.gc5b3e


I'm might be wrong with the .firmware_revision and model
which I got  echo 1 >  /sys/module/sbp2/parameters/workarounds

only thing I didn't test was adding this patch, then doing
the echo command(not sure if it matters or not though).

Justin P. Mattock
