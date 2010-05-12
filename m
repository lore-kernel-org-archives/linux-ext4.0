From: Jamie Lokier <jamie@shareable.org>
Subject: Re: Rampant ext3/4 corruption on 2.6.34-rc7 with VIVT ARM (Marvell 88f5182)
Date: Wed, 12 May 2010 23:21:54 +0100
Message-ID: <20100512222154.GA6841@shareable.org>
References: <1273569821.21352.19.camel@pasglop> <1273575478.21352.29.camel@pasglop> <EAF47CD23C76F840A9E7FCE10091EFAB02C545537F@dbde02.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Nicolas Pitre <nico@marvell.com>,
	Saeed Bishara <saeed@marvell.com>,
	"James E.J. Bottomley" <jejb@parisc-linux.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:54606 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757149Ab0ELWWR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 May 2010 18:22:17 -0400
Content-Disposition: inline
In-Reply-To: <EAF47CD23C76F840A9E7FCE10091EFAB02C545537F@dbde02.ent.ti.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Shilimkar, Santosh wrote:
> There was a memory write barrier missing before the DMA descriptors 
> are handed over to DMA controller.

On that note, are the cache flush functions implicit memory barriers?

-- Jamie
