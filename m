From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: e2fsck ext4 with extents possible?
Date: Wed, 30 Jan 2008 11:31:53 -0600
Message-ID: <47A0B489.1000705@redhat.com>
References: <47A0574B.1000002@yahoo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: supersud501 <supersud501@yahoo.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbYA3Rb4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jan 2008 12:31:56 -0500
In-Reply-To: <47A0574B.1000002@yahoo.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

supersud501 wrote:
> hello,
> 
> i'm testing the ext4-filesystem for months now (no data loss experienced 
> ), but i noticed e2fsck not being able to check a ext4-filesystem with 
> extents ("e2fsck: Filesystem has unsupported feature(s)").
> 
> i just pulled linus' kernel tree (with the newly added patches to ext4) 
> and e2fsprogs git tree (from git.kernel.org), but still e2fsprogs is not 
> able to check my ext4-fs.
> 
> so i wonder whether there's somewhere a patch for e2fsprogs flying 
> around i've missed or whether checking ext4 with extents is simply not 
> supported yet? if so, how's development going on with this?

No released e2fsprogs supports ext4 filesystems with new on-disk
features yet; that's partly what the "dev" on the end of "ext4dev.ko" is
for.  Ted's working on it.

-Eric
