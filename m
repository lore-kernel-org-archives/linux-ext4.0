Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39066 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbeLDFgF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 4 Dec 2018 00:36:05 -0500
Date: Tue, 4 Dec 2018 00:35:57 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
Cc: Jan Kara <jack@suse.cz>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        linux-ext4@vger.kernel.org
Subject: Re: Updated locking documentation for transaction_t
Message-ID: <20181204053557.GA24942@thunk.org>
References: <003451d5-42f7-2084-05b2-3f913f10ce3d@tu-dortmund.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003451d5-42f7-2084-05b2-3f913f10ce3d@tu-dortmund.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 27, 2018 at 03:54:06PM +0100, Alexander Lochmann wrote:
> The following members of struct transaction_s aka transaction_t
> were turned into lock-free variables in the past:
> - t_updates
> - t_outstanding_credits
> - t_handle_count
> However, the documentation has not been updated yet.
> This commit replaced the annotated lock by [none].
> 
> Found by LockDoc (Alexander Lochmann, Horst Schirmeier and Olaf Spinczyk)
> 
> Signed-off-by: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
> Signed-off-by: Horst Schirmeier <horst.schirmeier@tu-dortmund.de>
> ---

Thanks, applied.

					- Ted
