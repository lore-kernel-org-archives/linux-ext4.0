Return-Path: <SRS0=mHRP=MP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34294 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbeJCTnj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Oct 2018 15:43:39 -0400
Date: Wed, 3 Oct 2018 05:55:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        stable@kernel.org
Subject: Re: [PATCH] ext4: fix EXT4_IOC_SWAP_BOOT
Message-ID: <20181003125520.GA19655@infradead.org>
References: <20181002233808.16118-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181002233808.16118-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 02, 2018 at 07:38:08PM -0400, Theodore Ts'o wrote:
> The code EXT4_IOC_SWAP_BOOT ioctl hasn't been updated in a while, and
> it's a bit broken with respect to more modern ext4 kernels, especially
> metadata checksums.

Do you have any reports of anyone but sysbot actually using it?
Maybe it is a better idea to drop it unless it also gets coverage
in xfstests?
