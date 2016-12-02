From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] ext4: fix reading new encrypted symlinks on no-journal
 file systems
Date: Fri, 2 Dec 2016 10:05:31 -0800
Message-ID: <20161202180531.GA3508@google.com>
References: <20161201195731.GA131121@google.com>
 <20161202171422.20724-1-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:35332 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753780AbcLBSFe (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Dec 2016 13:05:34 -0500
Received: by mail-pf0-f172.google.com with SMTP id i88so53603126pfk.2
        for <linux-ext4@vger.kernel.org>; Fri, 02 Dec 2016 10:05:34 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20161202171422.20724-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 02, 2016 at 12:14:22PM -0500, Theodore Ts'o wrote:
> On a filesystem with no journal, a symlink longer than about 32
> characters (exact length depending on padding for encryption) could not
> be followed or read immediately after being created in an encrypted
> directory.  This happened because when the symlink data went through the
> delayed allocation path instead of the journaling path, the symlink was
> incorrectly detected as a "fast" symlink rather than a "slow" symlink
> until its data was written out.
> 
> To fix this, disable delayed allocation for symlinks, since there is
> no benefit for delayed allocation anyway.
> 

Looks good to me.

Eric
