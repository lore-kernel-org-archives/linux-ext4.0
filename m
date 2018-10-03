Return-Path: <SRS0=mHRP=MP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49344 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbeJCIKu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 3 Oct 2018 04:10:50 -0400
Date: Tue, 2 Oct 2018 21:24:37 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-ext4@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] ext4: initialize retries variable in
 ext4_da_write_inline_data_begin()
Message-ID: <20181003012437.GA18521@thunk.org>
References: <20180813133459.24241-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180813133459.24241-1-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 13, 2018 at 03:34:59PM +0200, Lukas Czerner wrote:
> Variable retries is not initialized in ext4_da_write_inline_data_begin()
> which can lead to nondeterministic number of retries in case we hit
> ENOSPC. Initialize retries to zero as we do everywhere else.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Fixes: bc0ca9df3b2a ("ext4: retry allocation when inline->extent conversion failed")
> Cc: stable@kernel.org

Applied, thanks.

					- Ted
