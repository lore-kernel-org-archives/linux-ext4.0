From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Ext4: Uninitialized Block Groups
Date: Tue, 18 Sep 2007 20:03:21 -0700
Message-ID: <20070918200321.d7da53e2.akpm@linux-foundation.org>
References: <46F06C7B.20308@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@clusterfs.com>, cmm@us.ibm.com
To: Avantika Mathur <mathur@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60045 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751695AbXISDDd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Sep 2007 23:03:33 -0400
In-Reply-To: <46F06C7B.20308@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 18 Sep 2007 17:25:31 -0700 Avantika Mathur <mathur@linux.vnet.ibm.com> wrote:

> +#if !defined(CONFIG_CRC16)
> +/** CRC table for the CRC-16. The poly is 0x8005 (x16 + x15 + x2 + 1) */
> +__u16 const crc16_table[256] = {
> +	0x0000, 0xC0C1, 0xC181, 0x0140, 0xC301, 0x03C0, 0x0280, 0xC241,
> +	0xC601, 0x06C0, 0x0780, 0xC741, 0x0500, 0xC5C1, 0xC481, 0x0440,
> +	0xCC01, 0x0CC0, 0x0D80, 0xCD41, 0x0F00, 0xCFC1, 0xCE81, 0x0E40,
> +	0x0A00, 0xCAC1, 0xCB81, 0x0B40, 0xC901, 0x09C0, 0x0880, 0xC841,
> +	0xD801, 0x18C0, 0x1980, 0xD941, 0x1B00, 0xDBC1, 0xDA81, 0x1A40,
> +	0x1E00, 0xDEC1, 0xDF81, 0x1F40, 0xDD01, 0x1DC0, 0x1C80, 0xDC41,

That's rather sad.  A plain old "depends on" would be better.
