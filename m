Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38978 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbeLDFSC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 4 Dec 2018 00:18:02 -0500
Date: Tue, 4 Dec 2018 00:17:57 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Colin King <colin.king@canonical.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: clean up indentation issues, remove extraneous tabs
Message-ID: <20181204051757.GE4981@thunk.org>
References: <20181123163043.14178-1-colin.king@canonical.com>
 <20181127092836.GD16301@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181127092836.GD16301@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 27, 2018 at 10:28:36AM +0100, Jan Kara wrote:
> On Fri 23-11-18 16:30:43, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > There are several lines that are indented too far, clean these
> > up by removing the tabs.
> > 
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> The patch looks good. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
