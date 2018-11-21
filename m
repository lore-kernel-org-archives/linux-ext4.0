Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36530 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730375AbeKVC7l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 21 Nov 2018 21:59:41 -0500
Date: Wed, 21 Nov 2018 11:24:32 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext2fs: Fix build of new superblock fields on BE machines
Message-ID: <20181121162432.GF26006@thunk.org>
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
> ---
> 
> I just noticed this today.  I don't see the patch that includes this
> field already pushed to kernel.org, so if you want to squash this one to
> that patch before pushing to make the result more bisectable in BE
> machines, I am ok with that.

Oops, sorry, I just pushed it out before I saw your note.  I'll add it
as a follow-on commit right away.  Fortunately we don't do too much
debugging on BE machines, so it's probably not worth breaking the git
rules and rewinding, even though it's highly unlikely anyone has done
a git pull in the last 10 minutes or so.

While we're at it, I should have noticed this earler before I acceptd
patch 2 in your series.  Could you also send a follow up patch which
adds a quick description of the fname_encoding feature to the ext4.5
man page?

Also, did your v2 patch series to e2fsprogs reflect any of the
comments I made late last night on the rest of the v1 patch series?

Thanks, regards,

						- Ted
