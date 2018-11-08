Return-Path: <SRS0=LXqi=NT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51946 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728618AbeKHM4N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 8 Nov 2018 07:56:13 -0500
Date: Wed, 7 Nov 2018 22:22:49 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Vasily Averin <vvs@virtuozzo.com>
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] ext4: lost brelse in ext4_expand_extra_isize_ea()
Message-ID: <20181108032249.GC22459@thunk.org>
References: <cover.1541011937.git.vvs@virtuozzo.com>
 <c5dc2118-ac42-c899-f218-4a78aa39c37f@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5dc2118-ac42-c899-f218-4a78aa39c37f@virtuozzo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 31, 2018 at 10:13:09PM +0300, Vasily Averin wrote:
> Fixes de05ca852679 ("ext4: move call to ext4_error() into ...") # 4.17
> 
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>

Thanks, applied.  I used the commit description:

    ext4: fix buffer leak in ext4_expand_extra_isize_ea() on error path

    	      	     	     			- Ted
