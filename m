From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: tests: report if a test is taking a long time
Date: Wed, 30 Aug 2017 02:07:37 -0400
Message-ID: <20170830060737.yx5tyty5dr55pens@thunk.org>
References: <1503724788-84776-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39764 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750756AbdH3GHj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 30 Aug 2017 02:07:39 -0400
Content-Disposition: inline
In-Reply-To: <1503724788-84776-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 25, 2017 at 11:19:48PM -0600, Andreas Dilger wrote:
> Print out a message if a test takes longer than 60s, with a
> reminder to potentially add is_slow_test to that test, so
> that it is easier to find which tests are taking a long time,
> especially if running with "make -j check" or similar.
> 
> Add an exclusion for r_expand_full on MacOS since HFS+ does
> not support sparse devices and doesn't like large test images.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

					- Ted
