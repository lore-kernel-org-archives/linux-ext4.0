From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: re: ext4: Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
Date: Mon, 31 Mar 2014 10:41:58 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1403311041410.4996@localhost.localdomain>
References: <20140328080356.GB25192@mwanda>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbaCaImG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Mar 2014 04:42:06 -0400
In-Reply-To: <20140328080356.GB25192@mwanda>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 28 Mar 2014, Dan Carpenter wrote:

> Date: Fri, 28 Mar 2014 11:03:56 +0300
> From: Dan Carpenter <dan.carpenter@oracle.com>
> To: lczerner@redhat.com
> Cc: linux-ext4@vger.kernel.org
> Subject: re: ext4: Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
> 
> Hello Lukas Czerner,
> 
> The patch 1f0e51771281: "ext4: Introduce FALLOC_FL_ZERO_RANGE flag
> for fallocate" from Mar 18, 2014, leads to the following static
> checker warning:
> 
> 	fs/ext4/extents.c:3653 ext4_split_convert_extents()
> 	warn: odd binop '0x4 & 0x10'
> 
> fs/ext4/extents.c
>   3650          } else if (flags | EXT4_GET_BLOCKS_CONVERT) {
>   3651                  split_flag |= ee_block + ee_len <= eof_block ?
>   3652                                EXT4_EXT_MAY_ZEROOUT : 0;
>   3653                  split_flag |= (EXT4_EXT_MARK_UNINIT2 & EXT4_EXT_DATA_VALID2);
>                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Right,

thanks.

-Lukas

> This statement is a no-op.  Probably | was intended?
> 
>   3654          }
>   3655          flags |= EXT4_GET_BLOCKS_PRE_IO;
> 
> regards,
> dan carpenter
> 
