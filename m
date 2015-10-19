From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC,3/5] ext4: Fix abs() usage in ext4_mb_check_group_pa
Date: Mon, 19 Oct 2015 00:03:30 -0400
Message-ID: <20151019040330.GA9381@thunk.org>
References: <1442279124-7309-4-git-send-email-john.stultz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: John Stultz <john.stultz@linaro.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58197 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbbJSEDd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Oct 2015 00:03:33 -0400
Content-Disposition: inline
In-Reply-To: <1442279124-7309-4-git-send-email-john.stultz@linaro.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 14, 2015 at 06:05:22PM -0700, John Stultz wrote:
> The ext4_fsblk_t type is a long long, which should not be used
> with abs(), as is done in ext4_mb_check_group_pa().
> 
> This patch modifies ext4_mb_check_group_pa() to use abs64()
> instead.
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: linux-ext4@vger.kernel.org
> Signed-off-by: John Stultz <john.stultz@linaro.org>

Applied, thanks.

						- Ted
