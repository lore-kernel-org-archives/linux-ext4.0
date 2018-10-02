Return-Path: <SRS0=f65u=MO=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41258 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbeJCAUf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 2 Oct 2018 20:20:35 -0400
Date: Tue, 2 Oct 2018 13:36:01 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH RESEND] ext4: Fix build error when DX_DEBUG is defined
Message-ID: <20181002173601.GA4684@thunk.org>
References: <20180924181524.4921-1-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180924181524.4921-1-krisman@collabora.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 24, 2018 at 02:15:24PM -0400, Gabriel Krisman Bertazi wrote:
> Enabling DX_DEBUG triggers the build error below.  info is an attribute
> of  the dxroot structure.
> 
> linux/fs/ext4/namei.c:2264:12: error: ‘info’
> undeclared (first use in this function); did you mean ‘insl’?
> 	   	  info->indirect_levels));
> 
> Fixes: e08ac99fa2a2 ("ext4: add largedir feature")
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Applied, thanks.

					- Ted
