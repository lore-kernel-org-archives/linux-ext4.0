Return-Path: <SRS0=ApgQ=N6=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46400 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727281AbeKSOhc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 19 Nov 2018 09:37:32 -0500
Date: Sun, 18 Nov 2018 23:15:09 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH e2fsprogs 2/9] e2fsprogs: Reserve feature bit and SB
 field bit for filename encoding
Message-ID: <20181119041509.GG32299@thunk.org>
References: <20181015211220.27370-1-krisman@collabora.co.uk>
 <20181015211220.27370-3-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181015211220.27370-3-krisman@collabora.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 15, 2018 at 05:12:13PM -0400, Gabriel Krisman Bertazi wrote:
> The s_encoding field in the superblock stores a magic number indicating
> the encoding format and version used globally by file and directory
> names in the filesystem.
> 
> The s_encoding_flags defines policies for using the charset encoding,
> like how to handle invalid sequences and what kind of normalization to
> use.
> 
> A feature flag is also allocated to indicate whether this filesystem has
> encoding awareness enabled.
> 
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

Thanks, applied.

						- Ted
