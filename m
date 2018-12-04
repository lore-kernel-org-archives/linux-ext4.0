Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39034 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbeLDFZc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 4 Dec 2018 00:25:32 -0500
Date: Tue, 4 Dec 2018 00:25:27 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Chengguang Xu <cgxu519@gmx.com>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: remove redundant condition check
Message-ID: <20181204052527.GG4981@thunk.org>
References: <20181113232448.11071-1-cgxu519@gmx.com>
 <20181127094358.GE16301@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181127094358.GE16301@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 27, 2018 at 10:43:58AM +0100, Jan Kara wrote:
> On Wed 14-11-18 07:24:48, Chengguang Xu wrote:
> > ext4_xattr_destroy_cache() can handle NULL pointer correctly,
> > so there is no need to check NULL pointer before calling
> > ext4_xattr_destroy_cache().
> > 
> > Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
> 
> The patch looks good. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
