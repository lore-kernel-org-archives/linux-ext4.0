Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38996 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726056AbeLDFVd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 4 Dec 2018 00:21:33 -0500
Date: Tue, 4 Dec 2018 00:21:27 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Colin King <colin.king@canonical.com>, Jan Kara <jack@suse.com>,
        linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jbd2: clean up indentation issue, replace spaces with tab
Message-ID: <20181204052127.GF4981@thunk.org>
References: <20181123164053.19193-1-colin.king@canonical.com>
 <20181126135632.GA25835@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181126135632.GA25835@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 26, 2018 at 02:56:32PM +0100, Jan Kara wrote:
> On Fri 23-11-18 16:40:53, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > There is a statement that is indented with spaces, replace it with
> > a tab.
> > 
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> Looks good. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
