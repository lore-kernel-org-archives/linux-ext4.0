Return-Path: <SRS0=UtPy=NO=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33686 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbeKDG0h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 4 Nov 2018 01:26:37 -0500
Date: Sat, 3 Nov 2018 17:14:08 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Vasily Averin <vvs@virtuozzo.com>
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/11] ext4 resize: lost brelse() in update_backups()
Message-ID: <20181103211408.GH28850@thunk.org>
References: <cover.1540935522.git.vvs@virtuozzo.com>
 <7120b1a5-fcda-8e31-fc8c-7944b4291b14@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7120b1a5-fcda-8e31-fc8c-7944b4291b14@virtuozzo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 31, 2018 at 12:58:03AM +0300, Vasily Averin wrote:
> bh was not released after error in ext4_journal_get_write_access()
> 
> Fixes ac27a0ec112a ("ext4: initial copy of files from ext3") # 2.6.19
> 
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>

Thanks, applied.  I fixed up the commit description and Fixes/Cc
trailers.

						- Ted
