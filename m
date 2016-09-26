From: Jan Kara <jack@suse.cz>
Subject: SECRM, UNRM, COMPR flags
Date: Mon, 26 Sep 2016 11:11:49 +0200
Message-ID: <20160926091149.GA7733@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43815 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965343AbcIZJLw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 26 Sep 2016 05:11:52 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F01B6AC9E
        for <linux-ext4@vger.kernel.org>; Mon, 26 Sep 2016 09:11:50 +0000 (UTC)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

in ext4 we have these SECRM, UNRM, COMPR flags which users can set, they
can read them, but which actually don't do anything. This is actually
somewhat confusing - e.g. I've just got report about one tool which
apparently sets SECRM flag on a file in a hope that it is somehow safer.
Also this is a waste of flags.

I've checked other filesystems (xfs, btrfs) and they report EOPNOTSUPP if
these flags are not really supported. Should not we do the same in ext4? I
know there is a concern about breaking userspace but since other major
filesystems already behave this way I think there is a good chance tools
handle this reasonably... What do people thing?

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
