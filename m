Return-Path: <SRS0=XuXQ=NS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49320 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728092AbeKHB2Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 7 Nov 2018 20:28:25 -0500
Date: Wed, 7 Nov 2018 10:57:25 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Vasily Averin <vvs@virtuozzo.com>
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org, Daeho Jeong <daeho.jeong@samsung.com>
Subject: Re: [PATCH 3/7] ext4: lost release of s_journal_flag_rwsem on
 rollback in ext4_fill_super
Message-ID: <20181107155725.GD9919@thunk.org>
References: <cover.1541011937.git.vvs@virtuozzo.com>
 <2a41b591-ce2e-e4e1-d86a-e0fd18e77ccd@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a41b591-ce2e-e4e1-d86a-e0fd18e77ccd@virtuozzo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 31, 2018 at 10:12:35PM +0300, Vasily Averin wrote:
> Fixes c8585c6fcaf2 ("ext4: fix races between changing inode journal ...") # 4.7
> 
> cc: Daeho Jeong <daeho.jeong@samsung.com>
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>

Thanks, applied.

					- Ted
