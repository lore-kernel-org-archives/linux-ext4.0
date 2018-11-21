Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38738 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731891AbeKVJ43 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Nov 2018 04:56:29 -0500
Date: Wed, 21 Nov 2018 18:19:57 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext2fs: Fix build of new superblock fields on BE machines
Message-ID: <20181121231957.GB10588@thunk.org>
References: <20181121001127.1868-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121001127.1868-1-krisman@collabora.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 20, 2018 at 07:11:27PM -0500, Gabriel Krisman Bertazi wrote:
> New superblock fields must be byte swapped before being accessed in Big
> Endian machines.
> 
> Not tested on an actual BE machine.
> 
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>

Thanks, applied.

					- Ted
