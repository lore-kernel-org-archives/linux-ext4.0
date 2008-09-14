From: Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH] jbd2: Create proc entry with bdevname+i_ino.
Date: Sun, 14 Sep 2008 07:51:11 -0700
Message-ID: <20080914145111.GQ4563@wotan.suse.de>
References: <20080908233114.GD20100@mail.oracle.com> <20080914084003.GP4563@wotan.suse.de> <20080914090306.GF30537@mit.edu>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com, sunil.mushran@oracle.com
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:38035 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbYINOvN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Sep 2008 10:51:13 -0400
Content-Disposition: inline
In-Reply-To: <20080914090306.GF30537@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 14, 2008 at 05:03:06AM -0400, Theodore Tso wrote:
> > Did this patch ever get reviewied? We'd really like it in so that Ocfs2 can
> > use JBD2...
> 
> Thanks for pinging me; it fell through the cracks.  I'll make sure it
> gets put into the queue for merging at the next merge window....

Great, thanks Ted! We'll be pushing Ocfs2/JBD2 support upstream next merge
window too, so this lines things up well for us.

Btw, if anyone is interested in checking out the patches,

Pull:
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git jbd2

or via gitweb:
http://git.kernel.org/?p=linux/kernel/git/mfasheh/ocfs2.git;a=shortlog;h=jbd2

Of course, they'll also hit lkml along with the rest of our Ocfs2 features.
	--Mark

--
Mark Fasheh
