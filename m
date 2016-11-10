From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 04/11] ext4: Use iomap for zeroing blocks in DAX mode
Date: Thu, 10 Nov 2016 15:05:32 -0700
Message-ID: <20161110220532.GD27200@linux.intel.com>
References: <1478603297-11793-1-git-send-email-jack@suse.cz>
 <1478603297-11793-5-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:33397 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933073AbcKJWFg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 10 Nov 2016 17:05:36 -0500
Content-Disposition: inline
In-Reply-To: <1478603297-11793-5-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 08, 2016 at 12:08:10PM +0100, Jan Kara wrote:
> Use iomap infrastructure for zeroing blocks when in DAX mode.
> ext4_iomap_begin() handles read requests just fine and that's all that
> is needed for iomap_zero_range().
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
