From: Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH] jbd2: Create proc entry with bdevname+i_ino.
Date: Sun, 14 Sep 2008 01:40:03 -0700
Message-ID: <20080914084003.GP4563@wotan.suse.de>
References: <20080908233114.GD20100@mail.oracle.com>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com, sunil.mushran@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:41248 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbYINIkF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Sep 2008 04:40:05 -0400
Content-Disposition: inline
In-Reply-To: <20080908233114.GD20100@mail.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 08, 2008 at 04:31:14PM -0700, Joel Becker wrote:
> jbd2 currently creates statistics files for each loaded journal in
> /proc/fs/jbd2/<bdevname>.  ocfs2 loads multiple journals when recovering
> other nodes, and the multiple journals on a given bdev collide in the
> proc namespace.

Did this patch ever get reviewied? We'd really like it in so that Ocfs2 can
use JBD2...

Thanks,
	--Mark

--
Mark Fasheh
