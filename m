From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 quota tests?
Date: Tue, 26 Jan 2010 19:51:13 +0100
Message-ID: <20100126185113.GK3187@quack.suse.cz>
References: <6601abe91001260931i39328e77kfe984834275c1282@mail.gmail.com>
 <4B5F32FE.5050800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Curt Wohlgemuth <curtw@google.com>, Jan Kara <jack@suse.cz>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59712 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226Ab0AZSvF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jan 2010 13:51:05 -0500
Content-Disposition: inline
In-Reply-To: <4B5F32FE.5050800@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 26-01-10 12:22:54, Eric Sandeen wrote:
> Curt Wohlgemuth wrote:
> > Hi Jan:
> > 
> > I heard from the ext4 conference call yesterday that you might have
> > some quota tests that would be useful.  Can you give me a pointer to
> > where I might find them?
> > 
> > Thanks,
> > Curt
> 
> I'm the one who suggested that Jan -might- have some quota test
> infrastructure, but I don't know for sure.  :)
> 
> Jan, we'd love to pull anything you might have into xfstests if
> we can, I think.
  Yes, that would be a good idea. As I wrote to Curt, I don't have anything
generally usable. But for example extending fsstress and fsx tests with
quota checking should be pretty straightforward. And the tar test I have
described could be added as well.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
