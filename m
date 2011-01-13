From: Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [PATCH] Update atime from future.
Date: Thu, 13 Jan 2011 14:18:57 +0000
Message-ID: <1294928337.2401.28.camel@dolmen>
References: <1293631121-12667-1-git-send-email-sickamd@gmail.com>
	 <1294050468.2429.2.camel@dolmen>
	 <20110111133314.GA10705@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: yangsheng <sickamd@gmail.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755832Ab1AMORs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Jan 2011 09:17:48 -0500
In-Reply-To: <20110111133314.GA10705@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Tue, 2011-01-11 at 14:33 +0100, Pavel Machek wrote:
> 	return 1;
> > > +	/*
> > > +	 * Is the previous atime value old than a day? If yes,
> > >  	 * update atime:
> > >  	 */
> > >  	if ((long)(now.tv_sec - inode->i_atime.tv_sec) >= 24*60*60)
> > 
> > I don't think this is a good plan for cluster filesystems, since if the
> > times on the nodes are not exactly synchronised (we do highly recommend
> > people run ntp or similar) then this might lead to excessive atime
> > updating. The current behaviour is to ignore atimes which are in the
> > future for exactly this reason,
> 
> Well, would these "update storms" really be a problem?
> 
> AFAICT they should be fairly non-frequent, and worst thing that can
> happen is that you'll do as many updates as different time settings,
> settling for the lowest value...?
> 									Pavel

Sorry for the delay in replying. It has been a problem in the past,
certainly. I think it is best to be cautious in this case, since that
way we can be sure it won't be a problem. The chosen solution looks ok
to me,

Steve.


