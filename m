From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: error should be cleared if ea_inode isn't added to
 the cache
Date: Mon, 31 Jul 2017 00:43:23 -0400
Message-ID: <20170731044323.rnfbumdlfmhupgsm@thunk.org>
References: <1499831813-13218-1-git-send-email-emoly.liu@intel.com>
 <07A0E441A926DB4D91D25518F435CC777C9D62FD@SHSMSX104.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Liu, Emoly" <emoly.liu@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47398 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750808AbdGaEn1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 31 Jul 2017 00:43:27 -0400
Content-Disposition: inline
In-Reply-To: <07A0E441A926DB4D91D25518F435CC777C9D62FD@SHSMSX104.ccr.corp.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 17, 2017 at 02:12:34AM +0000, Liu, Emoly wrote:
> Hi,
> 
> This patch needs to be included into the release along with the ea_inode feature to maintain proper feature compatibility with Lustre.
> Could it be landed as soon as possible?

Thanks, applied.  It will be pushed to Linus before 4.13 is released.

		     	     	    - Ted
