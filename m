Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38948 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbeLDFMN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 4 Dec 2018 00:12:13 -0500
Date: Tue, 4 Dec 2018 00:12:08 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com
Subject: Re: [PATCH] ext4: missing unlock/put_page() in
 ext4_try_to_write_inline_data()
Message-ID: <20181204051208.GD4981@thunk.org>
References: <1543310705-11051-1-git-send-email-mlombard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1543310705-11051-1-git-send-email-mlombard@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 27, 2018 at 10:25:05AM +0100, Maurizio Lombardi wrote:
> In case of error, ext4_try_to_write_inline_data() should unlock
> and release the page it holds.
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>

Thanks, applied.

						- Ted
