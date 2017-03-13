From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ext4: evict inline data when writing to memory map
Date: Mon, 13 Mar 2017 16:33:13 -0700
Message-ID: <20170313233313.GA23580@infradead.org>
References: <20170313004708.29838-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Nick Alcock <nick.alcock@oracle.com>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:46539 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751243AbdCMXdP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Mar 2017 19:33:15 -0400
Content-Disposition: inline
In-Reply-To: <20170313004708.29838-1-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>     mkfs.ext4 -O inline_data /dev/vdb
>     mount /dev/vdb /mnt
>     xfs_io -f /mnt/file \
> 	-c 'pwrite 0 1' \
> 	-c 'mmap -w 0 1m' \
> 	-c 'mwrite 0 1' \
> 	-c 'fsync'

Please add this test case to xfstests.
