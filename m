Return-Path: <SRS0=ApgQ=N6=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46240 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727816AbeKSN6J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 19 Nov 2018 08:58:09 -0500
Date: Sun, 18 Nov 2018 22:35:52 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH e2fsprogs 1/9] e2fsprogs: Add timestamp extension bits to
 superblock
Message-ID: <20181119033552.GE32299@thunk.org>
References: <20181015211220.27370-1-krisman@collabora.co.uk>
 <20181015211220.27370-2-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181015211220.27370-2-krisman@collabora.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 15, 2018 at 05:12:12PM -0400, Gabriel Krisman Bertazi wrote:
> Re-sync the superblock structure declaration with its kernel counterpart
> to include the fields added by kernel commit 6a0678a79bb3 ("ext4: super:
> extend timestamps to 40 bits")
> 
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

Thanks, applied.

					- Ted
