From: Jan Kara <jack@suse.cz>
Subject: Re: ext2 quota corruption in xfstest 235
Date: Mon, 31 May 2010 19:12:27 +0200
Message-ID: <20100531171227.GA5334@quack.suse.cz>
References: <20100531094704.GB10283@lst.de>
 <20100531095131.GA10496@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47628 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760Ab0EaRN2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 May 2010 13:13:28 -0400
Content-Disposition: inline
In-Reply-To: <20100531095131.GA10496@lst.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 31-05-10 11:51:31, Christoph Hellwig wrote:
> Hmm, ext2 doesn't seem to be too happy these days:
  This is a bug in quota-tools (they don't tell the kernel to write all
internal state to quota file before they read it). I've fixed that up in
CVS of quota-tools last week...

> 235 2s ...[ 3091.091422] EXT2-fs (vdb6): warning: mounting unchecked fs,
> running e2fsck is recommended
> @@ -1,20 +1,11 @@
>  QA output created by 235
> +repquota: Illegal reference (6 >= 6) in user quota file on /dev/vdb6. Quota file is probably corrupted.
> +Please run quotacheck(8) and try again.
>  *** Report for user quotas on device [SCR_DEV]
>  Block grace time: 7days; Inode grace time: 7days
> 
> ...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
