From: Jan Kara <jack@suse.cz>
Subject: Re: dead/wrong code in ext3/4_releasepage()
Date: Mon, 2 Jul 2012 19:33:26 +0200
Message-ID: <20120702173326.GL6679@quack.suse.cz>
References: <4FEDDD63.4000800@ya.ru>
 <20120702170959.GJ6679@quack.suse.cz>
 <4FF1D712.3060402@ya.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Andrew Perepechko <anserper@ya.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53025 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab2GBRd2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jul 2012 13:33:28 -0400
Content-Disposition: inline
In-Reply-To: <4FF1D712.3060402@ya.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Mon 02-07-12 21:14:58, Andrew Perepechko wrote:
> So you think the correct fix would be to remove the check completely
> since every try_to_release_page() caller is obliged to perform the
> page_has_private() check?
  Yes, I think that would be reasonable. XFS already relies on this so
it should be safe.

								Honza

> On 07/02/2012 09:09 PM, Jan Kara wrote:
> >On Fri 29-06-12 20:52:51, Andrew Perepechko wrote:
> >>This does not lead to oom or any similar issue since calls to
> >>try_to_release_page()
> >>are accompanied by page_has_private() checks.
> >>
> >>
> >   The check is a dead code because ->release_page() is called only if
> >PagePrivate bit is set.
> >
> >								Honza
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
