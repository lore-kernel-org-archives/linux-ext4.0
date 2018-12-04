Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38872 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbeLDEdY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 3 Dec 2018 23:33:24 -0500
Date: Mon, 3 Dec 2018 23:33:16 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Pan Bian <bianpan2016@163.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix possible use after free in ext4_quota_enable
Message-ID: <20181204043316.GC4981@thunk.org>
References: <1543202466-68277-1-git-send-email-bianpan2016@163.com>
 <20181127091453.GA16301@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181127091453.GA16301@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 27, 2018 at 10:14:53AM +0100, Jan Kara wrote:
> On Mon 26-11-18 11:21:06, Pan Bian wrote:
> > The function frees qf_inode via iput but then pass qf_inode to
> > lockdep_set_quota_inode on the failure path. This may result in a
> > use-after-free bug. The patch frees df_inode only when it is never used.
> > 
> > Signed-off-by: Pan Bian <bianpan2016@163.com>
> > Fixes: daf647d2dd5("ext4: add lockdep annotations for i_data_sem")
> 
> Thanks for the fix! The patch looks good. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
