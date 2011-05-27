From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] Attempt to sync the fsstress writes to a frozen F.S
Date: Fri, 27 May 2011 18:28:03 +0200
Message-ID: <20110527162803.GA21260@quack.suse.cz>
References: <4DCA3583.7010904@canonical.com>
 <1305097841-2308-1-git-send-email-surbhi.palande@canonical.com>
 <20110524214222.GF26055@thunk.org>
 <4DDCEF4D.1070107@canonical.com>
 <185A6552-AC55-475A-AB32-4EB9671612F3@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: surbhi.palande@canonical.com, sandeen@redhat.com, jack@suse.cz,
	marco.stornelli@gmail.com, adilger.kernel@dilger.ca,
	toshi.okajima@jp.fujitsu.com, m.mizuma@jp.fujitsu.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:54754 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210Ab1E0Q2H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 May 2011 12:28:07 -0400
Content-Disposition: inline
In-Reply-To: <185A6552-AC55-475A-AB32-4EB9671612F3@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Ted,

On Wed 25-05-11 08:12:15, Ted Tso wrote:
> Just as a request --- could you start a new thread (this one is getting
> so long it's hard to follow)?
> 
> And could you also include a reliable reproduction case?
  Just a quick note - this patch series was not really meant to fix the
deadlocks. They are meant to make freezing reliable in combination with
mmapped writes. As a side-effect, they make the deadlock Surbhi describes
less probable but I'm aware it's still there.

I plan to have another look at how the deadlock could be fixed (the first
attempt was rejected by Dave Chinner) but currently I'm busy with other
stuff...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
