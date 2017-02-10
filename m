From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Do not use stripe_with if it is not set
Date: Fri, 10 Feb 2017 01:00:36 -0500
Message-ID: <20170210060036.mbdmeoi4vfp7vbtz@thunk.org>
References: <20170209153050.15317-1-jack@suse.cz>
 <20170209153050.15317-2-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54114 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751023AbdBJGBD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 10 Feb 2017 01:01:03 -0500
Content-Disposition: inline
In-Reply-To: <20170209153050.15317-2-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 09, 2017 at 04:30:50PM +0100, Jan Kara wrote:
> Avoid using stripe_width for sbi->s_stripe value if it is not actually
> set. It prevents using the stride for sbi->s_stripe.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
