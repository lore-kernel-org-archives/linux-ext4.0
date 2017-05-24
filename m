From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove redundant check for encrypted file on dio
 write path
Date: Wed, 24 May 2017 18:21:34 -0400
Message-ID: <20170524222134.3sy44uybdhqn3nnr@thunk.org>
References: <20170523005316.18996-1-ebiggers3@gmail.com>
 <20170523082410.GD1230@quack2.suse.cz>
 <20170523161354.GB106748@gmail.com>
 <20170524081041.GB10604@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-ext4@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35024 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033770AbdEXWVh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 24 May 2017 18:21:37 -0400
Content-Disposition: inline
In-Reply-To: <20170524081041.GB10604@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, applied.

					- Ted
