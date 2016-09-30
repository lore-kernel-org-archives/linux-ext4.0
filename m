From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: create function to read journal inode
Date: Fri, 30 Sep 2016 02:11:37 -0400
Message-ID: <20160930061136.sfw65ainhhgjkpht@thunk.org>
References: <20160922011450.GB27216@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47680 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935955AbcI3GLv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Sep 2016 02:11:51 -0400
Content-Disposition: inline
In-Reply-To: <20160922011450.GB27216@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 21, 2016 at 09:14:50PM -0400, Eric Whitney wrote:
> Factor out the code used in ext4_get_journal() to read a valid journal
> inode from storage, enabling its reuse in other functions.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.

					- Ted
