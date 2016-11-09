From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/11 v2] ext4: Convert ext4 DAX IO to iomap framework
Date: Wed, 9 Nov 2016 07:02:35 -0800
Message-ID: <20161109150235.GA11757@infradead.org>
References: <1478603297-11793-1-git-send-email-jack@suse.cz>
 <20161108231739.GQ28177@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58658 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753196AbcKIPCw (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Nov 2016 10:02:52 -0500
Content-Disposition: inline
In-Reply-To: <20161108231739.GQ28177@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 09, 2016 at 10:17:39AM +1100, Dave Chinner wrote:
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git dax-4.10-iomap-pmd

Can you add Jan's patch to add IOMAP_FAULT from the series we're
replying to to the branch quickly as well?  That way I can use it as
the base for the next spin of the direct I/O series without creating
conflicts.
