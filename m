From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] : Remove incompatible pointer assignment warning in
	ext4 quota operations
Date: Thu, 12 Feb 2009 15:22:09 +0100
Message-ID: <20090212142209.GA3923@duck.suse.cz>
References: <ea11fea30901272117j760a34e8w5df0ec1916632f3f@mail.gmail.com> <ea11fea30901272121x319aa2b3m2a5a5799b6df4d8a@mail.gmail.com> <20090202161005.GG19165@atrey.karlin.mff.cuni.cz> <ea11fea30902120054g5192f269y5cdf34795d9f8e1e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:55236 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbZBLOWM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Feb 2009 09:22:12 -0500
Content-Disposition: inline
In-Reply-To: <ea11fea30902120054g5192f269y5cdf34795d9f8e1e@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 12-02-09 14:24:17, Manish Katiyar wrote:
> On Mon, Feb 2, 2009 at 9:40 PM, Jan Kara <jack@suse.cz> wrote:
> >> On Wed, Jan 28, 2009 at 10:47 AM, Manish Katiyar <mkatiyar@gmail.com> wrote:
> >> > Below patch removes the following warning during compilation :
> >> >
> >> >  CC [M]  fs/ext4/super.o
> >> > fs/ext4/super.c:949: warning: initialization from incompatible pointer type
> >> >  LD [M]  fs/ext4/ext4.o
> >>
> >> Sorry,
> >>
> >> Tha correct patch is here.
> >>
> >> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> >  Looks fine to me.
> > Acked-by: Jan Kara <jack@suse.cz>
> 
> Hi Jan,
> 
> A simple doubt. Patches acked by you will be automatically picked up
> or will I have to resend it with your ack added ??
  Ah, I realized that probably I should merge this patch since I carry the
ext4 quota reservation patch... Thanks for the reminder. But when I tried
to merge your patch I've found that the warning is already fixed in my tree
by some other patch. I'm sorry. Thanks for your work.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
