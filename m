Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33656 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbeKUPfz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 21 Nov 2018 10:35:55 -0500
Date: Wed, 21 Nov 2018 00:03:01 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH e2fsprogs 9/9] tune2fs: Prevent enabling encryption flag
 on encoding-aware fs
Message-ID: <20181121050301.GD26006@thunk.org>
References: <20181015211220.27370-1-krisman@collabora.co.uk>
 <20181015211220.27370-10-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181015211220.27370-10-krisman@collabora.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 15, 2018 at 05:12:20PM -0400, Gabriel Krisman Bertazi wrote:
> The kernel will refuse to mount filesystems with the encryption and
> encoding features enabled at the same time.  The encoding feature can
> only be set at mount time, so we can just prevent encryption from being
> set at a later time by tune2fs.
> 
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

This check also needs to be in mke2fs, right?  I don't think I saw it
in your mke2fs patch.

					- Ted
