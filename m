From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Ext4: Uninitialized Block Groups
Date: Tue, 18 Sep 2007 20:05:15 -0700
Message-ID: <20070918200515.0b320062.akpm@linux-foundation.org>
References: <46F06C7B.20308@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@clusterfs.com>, cmm@us.ibm.com
To: Avantika Mathur <mathur@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40248 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751009AbXISDGD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Sep 2007 23:06:03 -0400
In-Reply-To: <46F06C7B.20308@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 18 Sep 2007 17:25:31 -0700 Avantika Mathur <mathur@linux.vnet.ibm.com> wrote:

> +
> +__u16 crc16(__u16 crc, __u8 const *buffer, size_t len)

And is we really really have to do this, then the ext4-private crc16() 
should have static scope.
