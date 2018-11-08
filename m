Return-Path: <SRS0=LXqi=NT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51976 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728499AbeKHNLw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 8 Nov 2018 08:11:52 -0500
Date: Wed, 7 Nov 2018 22:38:25 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Vasily Averin <vvs@virtuozzo.com>
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext4: lost brelse in __ext4_read_dirblock()
Message-ID: <20181108033825.GD22459@thunk.org>
References: <6e5c9e17-5916-7296-35a0-cc0600a79f27@virtuozzo.com>
 <e269cf8c-b5ca-3eed-bd60-a8629378db8b@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e269cf8c-b5ca-3eed-bd60-a8629378db8b@virtuozzo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 07, 2018 at 08:30:17PM +0300, Vasily Averin wrote:
> Fixes dc6982ff4db1 ("ext4: refactor code to read directory blocks ...")
> Cc: stable@kernel.org # 3.9
> 
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>

Thanks, applied.  I used the commit description:

    ext4: fix buffer leak in __ext4_read_dirblock() on error path

	      	     			    - Ted
