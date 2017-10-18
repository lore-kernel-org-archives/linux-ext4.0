From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: mention noload when recovering on read-only device
Date: Wed, 18 Oct 2017 13:10:04 -0400
Message-ID: <20171018171004.4x6bbg6qitugnwsn@thunk.org>
References: <977f189abb1ff382dedd6916b7140081d47d3e8d.1505383806.git.simon@ruderich.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Simon Ruderich <simon@ruderich.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34474 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750829AbdJRRKH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 18 Oct 2017 13:10:07 -0400
Content-Disposition: inline
In-Reply-To: <977f189abb1ff382dedd6916b7140081d47d3e8d.1505383806.git.simon@ruderich.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 14, 2017 at 12:23:06PM +0200, Simon Ruderich wrote:
> Help the user to find the appropriate mount option to continue mounting
> the file system on a read-only device if the journal requires recovery.
> 
> Signed-off-by: Simon Ruderich <simon@ruderich.org>

Applied, thanks.

						- Ted
