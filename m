Return-Path: <SRS0=hSPz=NR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45904 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726918AbeKGGoV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 7 Nov 2018 01:44:21 -0500
Date: Tue, 6 Nov 2018 16:17:07 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Vasily Averin <vvs@virtuozzo.com>
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/11] ext4 resize: lost rollback in ext4_resize_fs()
Message-ID: <20181106211707.GD2570@thunk.org>
References: <cover.1540935522.git.vvs@virtuozzo.com>
 <916ed44d-d137-060a-bfc3-1925afa03b04@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <916ed44d-d137-060a-bfc3-1925afa03b04@virtuozzo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 31, 2018 at 12:58:09AM +0300, Vasily Averin wrote:
> Fixes 117fff10d7f1 ("ext4: grow the s_flex_groups array as needed ...") # 3.7
> 
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>

Thanks, applied.  I fixed up the commit description and Fixes/Cc
trailers.

					- Ted
