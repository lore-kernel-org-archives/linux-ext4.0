From: Jan Kara <jack@suse.cz>
Subject: Re: GRUB and the risk of block list corruption in extX
Date: Thu, 7 Feb 2013 14:27:13 +0100
Message-ID: <20130207132713.GD20564@quack.suse.cz>
References: <51137F76.8070705@ts.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Martin Wilck <martin.wilck@ts.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58657 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758587Ab3BGN10 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Feb 2013 08:27:26 -0500
Content-Disposition: inline
In-Reply-To: <51137F76.8070705@ts.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Thu 07-02-13 11:18:30, Martin Wilck wrote:
> you may have seen the following warning that is displayed when
> someone tries to install GRUB2 on in a extX partition:
> 
>   "/sbin/grub-setup: warn: Embedding is not possible. GRUB can only be
>   installed in this setup by using blocklists. However, blocklists are
>   UNRELIABLE and their use is discouraged."
> 
> Recently I have been involved in discussions about this on
> https://bugzilla.redhat.com/show_bug.cgi?id=872826.
> 
> The Grub manual says "installing to a filesystem means that GRUB is
> vulnerable to its blocks being moved around by filesystem features such
> as tail packing, or even by aggressive fsck implementations".
> 
> My question to the extX experts: Under what circumstances (except
> modifying, overwriting, deleting the bootloader image "core.img" itself)
> can a block list referencing "core.img" be corrupted? In particular:
> 
>  1) could it happen during ordinary operation, filesystem code silently
>    moving blocks around?
  No.

>  2) could it happen in an e2fsck run?
  Yes, if there is some corruption found. But then all bets are off anyway.
I.e. if fsck in -p (preen) mode fails, you have to rerun grub after fixing
the fs.

>  3) could it be caused by e4defrag?
  If you defrag the image file then yes. But that's obvious I guess.

>  4) could it happen with resize2fs even if the blocks occupied by the
> file fit in the size that the FS is resized to (otherwise obviously "yes")?
  If you do offline resize and we need to grow number of group descriptor
blocks it may happen we move around blocks. For online resize we only allow
to resize upto the amount of reserved descriptor blocks so there it cannot
happen. Shrinking should be safe unless the file is in the part of
filesystem that is being removed.

>  5) Anything else?
  No, I don't think so.

>  6) if the file was protected with the IMMUTABLE flag, would any of 1-5
> still be able to corrupt the file?
  IMMUTABLE flag has no impact on these.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
