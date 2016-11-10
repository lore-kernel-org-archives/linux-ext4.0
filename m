From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 01/11] ext4: Factor out checks from ext4_file_write_iter()
Date: Thu, 10 Nov 2016 14:25:43 -0700
Message-ID: <20161110212543.GA27200@linux.intel.com>
References: <1478603297-11793-1-git-send-email-jack@suse.cz>
 <1478603297-11793-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27000 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934360AbcKJVZp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 10 Nov 2016 16:25:45 -0500
Content-Disposition: inline
In-Reply-To: <1478603297-11793-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 08, 2016 at 12:08:07PM +0100, Jan Kara wrote:
> Factor out checks of 'from' and whether we are overwriting out of
> ext4_file_write_iter() so that the function is easier to follow.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
