From: Jan Kara <jack@suse.cz>
Subject: Re: Ext3: batched discard support
Date: Mon, 12 Jul 2010 17:09:26 +0200
Message-ID: <20100712150926.GE3356@quack.suse.cz>
References: <1278508727-29135-1-git-send-email-lczerner@redhat.com>
 <AANLkTil_Y6rjgbAjQcOqTeFUt1WO46MNKFp5Qe4iSK3z@mail.gmail.com>
 <alpine.LFD.2.00.1007091050190.2867@localhost>
 <4C36F767.3060103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	linux-ext4@vger.kernel.org, jmoyer@redhat.com, eshishki@redhat.com,
	sandeen@redhat.com, Jan Kara <jack@suse.cz>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40699 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab0GLPJv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Jul 2010 11:09:51 -0400
Content-Disposition: inline
In-Reply-To: <4C36F767.3060103@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 09-07-10 06:18:15, Ric Wheeler wrote:
> On 07/09/2010 04:53 AM, Lukas Czerner wrote:
> >On Wed, 7 Jul 2010, Greg Freemyer wrote:
> >
> >>On Wed, Jul 7, 2010 at 9:18 AM, Lukas Czerner<lczerner@redhat.com>  wrote:
> >>>
> >>>Hello again,
> >>>
> >>>I have composed a set of patches to add batched discard support for Ext3 file
> >>>system. Functionality is basically the same as in "batched discard support
> >>>for Ext4" (see http://www.spinics.net/lists/linux-ext4/msg19827.html ).
> >>>
> >>>There are two patches:
> >>
> >>I'm inclined to review these, but before I do, I thought ext3 was
> >>closed to patches like this.
> >>
> >>Or is it still accepting more new functionality than I thought?
> >>
> >>Greg
> >>
> >
> >Hi, Greg
> >
> >thanks for your interest ! Unfortunately it seems like you are right,
> >I was suspecting something like that. Anyway I am not the one who make
> >those decisions...so anyone ?
> >
> >Thanks
> >
> >-Lukas
> 
> Not sure how much we want to move into ext3, but I think that Jan is
> the person to make that call.
> 
> Discard support got stuck into several other file systems and would
> be useful for ext3.
> 
> Jan, Ted, what do you both think about these patches?
  I'm fine with taking a feature like this one into ext3 because it's
separated from the rest of the code. So if people want this and Ted is
OK with taking it for ext4, I'll merge the ext3 patches (I would like to
avoid having ext3 feature not supported by ext4...).

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
