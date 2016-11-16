From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 10/11] ext2: Use iomap_zero_range() for zeroing truncated
 page in DAX path
Date: Wed, 16 Nov 2016 10:31:30 -0700
Message-ID: <20161116173130.GB31337@linux.intel.com>
References: <1478603297-11793-1-git-send-email-jack@suse.cz>
 <1478603297-11793-11-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:52897 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932140AbcKPRbc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 16 Nov 2016 12:31:32 -0500
Content-Disposition: inline
In-Reply-To: <1478603297-11793-11-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 08, 2016 at 12:08:16PM +0100, Jan Kara wrote:
> Currently the last user of ext2_get_blocks() for DAX inodes was
> dax_truncate_page(). Convert that to iomap_zero_range() so that all DAX
> IO uses the iomap path.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
