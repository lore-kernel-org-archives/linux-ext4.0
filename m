From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ext3: sreadahead hooks
Date: Tue, 14 Oct 2008 11:13:29 -0400
Message-ID: <20081014151329.GA17926@infradead.org>
References: <20081014101735.04107779@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Arjan van de Ven <arjan@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56528 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbYJNPNa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Oct 2008 11:13:30 -0400
Content-Disposition: inline
In-Reply-To: <20081014101735.04107779@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 14, 2008 at 10:17:35AM -0400, Arjan van de Ven wrote:
> 
> >From 3d7a0ca0ee8a755251251bd9ddca0866c25acdc2 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Tue, 14 Oct 2008 10:12:08 -0400
> Subject: [PATCH] ext3: sreadahead hooks
> 
> The sreadahead program, used to make the OS boot faster, needs to know in
> the approximate order in files are used during the boot process. This patch
> adds the ext3 hook for this functionality, basically it stores "jiffies"
> into the inode at allocation time, and exposes it via an EXT3 ioctl (yes I
> know but ioctl seems fitting for this).

Even if it's an ioctl there's absolutely no point in making this
fileystem specific.  Also the name is rather dumb and non-descriptive.

