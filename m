From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tests: log tests that are taking a long time
Date: Sun, 15 Oct 2017 22:31:49 -0400
Message-ID: <20171016023149.flqk7pu4mgxsvvof@thunk.org>
References: <1507675204-70036-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49716 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751541AbdJPCbv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 15 Oct 2017 22:31:51 -0400
Content-Disposition: inline
In-Reply-To: <1507675204-70036-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 10, 2017 at 04:40:04PM -0600, Andreas Dilger wrote:
> Create a .slow file for tests that take too long to run, so it is
> possible to find them easily after all of the tests have run.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

						- Ted
