From: Christoph Hellwig <hch@lst.de>
Subject: nobh mount option in ext3/4?
Date: Mon, 31 May 2010 14:40:51 +0200
Message-ID: <20100531124051.GA17262@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: jack@suse.cz, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:37686 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066Ab0EaMkz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 May 2010 08:40:55 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext3 and ext4 heave inherited the nobh option from ext2, but the
implementation is rather interesting.  Except for the usual
option parsing / display it's only respected in
ext3_writeback_writepage/ext4_writepage and the truncate_page
implementation.  Given that we don't take any more than usual
care to not create buffers heads during read this is not going
to effect a whole lot.

Is there a good reason to keep these options and the associated
code complexity?  I'd be rather surprised if it gets any sufficient
testing..
