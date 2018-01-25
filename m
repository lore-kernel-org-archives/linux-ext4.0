From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH RFC v2 00/13] NLS/UTF-8 Case-Insensitive lookups for ext4
 and VFS proposal
Date: Thu, 25 Jan 2018 03:16:50 +0000
Message-ID: <20180125031650.GU13338@ZenIV.linux.org.uk>
References: <20180125025349.31494-1-krisman@collabora.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, david@fromorbit.com, olaf@sgi.com,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        alvaro.soliverez@collabora.co.uk, kernel@lists.collabora.co.uk
To: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:55816 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751762AbeAYDQ4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Jan 2018 22:16:56 -0500
Content-Disposition: inline
In-Reply-To: <20180125025349.31494-1-krisman@collabora.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 25, 2018 at 12:53:36AM -0200, Gabriel Krisman Bertazi wrote:

> The second proposal is related to the VFS layer:
> 
> (2) Enable Insensitive lookup support on a per-mountpoint basis,
> via a MS_CASEFOLD flag, with the ultimate goal of supporting a
> case-insensitive bind mount of a subtree, side-by-side with a
> sensitive version of the filesystem.

First reaction: No.  With the side of HELL NO.

Your ultimate goal sounds utterly insane - dcache tree must be shared
for all mounts.  Moreover, "would these two names refer to the same
object" can not be mount-dependent.  Not going to happen.

Please, post the description of what you are planning to do.
Detailed.  I'm not saying that it's 100% impossible to do correctly,
but I'm _very_ sceptical about the feasibility.

I'm certainly not going to ACK any VFS changes until you convince
me that this thing can be done with sane semantics.
