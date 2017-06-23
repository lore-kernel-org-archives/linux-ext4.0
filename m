From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tests: add new test f_del_dup_quota
Date: Fri, 23 Jun 2017 17:29:43 -0400
Message-ID: <20170623212943.oltjd3uysfmzr4p2@thunk.org>
References: <20170601213258.GA3167@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38168 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753306AbdFWV3o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 23 Jun 2017 17:29:44 -0400
Content-Disposition: inline
In-Reply-To: <20170601213258.GA3167@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 01, 2017 at 05:32:58PM -0400, Eric Whitney wrote:
> Add a test to validate the changes in commit b0f5fa880c36: "e2fsck:
> fix multiply-claimed block quota accounting when deleting files".
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.

					- Ted
