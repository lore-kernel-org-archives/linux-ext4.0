From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: enable project quota reporting in debugfs
Date: Mon, 30 Jan 2017 15:34:54 -0500
Message-ID: <20170130203454.xcuuu2hptgfdg2t3@thunk.org>
References: <20170110215401.GA1232@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41298 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751062AbdA3Ue5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 30 Jan 2017 15:34:57 -0500
Content-Disposition: inline
In-Reply-To: <20170110215401.GA1232@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 10, 2017 at 04:54:01PM -0500, Eric Whitney wrote:
> Make the minor changes required so the list_quota and get_quota commands
> can report project quota information.  This also fixes a debugfs
> segfault that currently occurs when either list_quota or get_quota is
> invoked with an unknown quota_type argument.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Applied, thanks.

					- Ted
