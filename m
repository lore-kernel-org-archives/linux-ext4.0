From: Theodore Tso <tytso@mit.edu>
Subject: Problems with accessing the ext4 patch queue
Date: Sat, 14 Jun 2008 20:48:10 -0400
Message-ID: <20080615004810.GD12260@mit.edu>
References: <3.0.6.32.20080614145505.01b28a18@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Gary Hawco <ghawco@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:45530 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754102AbYFOAsS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 14 Jun 2008 20:48:18 -0400
Content-Disposition: inline
In-Reply-To: <3.0.6.32.20080614145505.01b28a18@pop.west.cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jun 14, 2008 at 02:55:05PM +0000, Gary Hawco wrote:
> I guess I should have checked to see if repo.or.cz site was down. It is!
> 
> I am reasonably sure re: my last post that the problems accessing the site
> with git clone are due to this.

>From the GIT mailing list:

    Date:  Sat, 14 Jun 2008 16:48:45 +0200
    From: Petr Baudis <pasky@suse.cz>
    Subject: git.or.cz, repo.or.cz down
    To: git@vger.kernel.org

      Hi,

      FYI, the server running git.or.cz and repo.or.cz crashed and will
    probably stay down until Monday - please bear with us; repo.or.cz
    users may enjoy trying out some alternative development models than
    central-server based ones. ;-)

      The oops happenned once before already, but this time I figured out
    more details thanks to the good ol' netconsole. For the more technically
    inclined, the crash is due to an IPv6 kernel bug:

            http://www.spinics.net/lists/netdev/msg65854.html

						- Ted
