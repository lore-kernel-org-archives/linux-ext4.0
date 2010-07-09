From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: Ext3: batched discard support
Date: Fri, 9 Jul 2010 10:53:27 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1007091050190.2867@localhost>
References: <1278508727-29135-1-git-send-email-lczerner@redhat.com> <AANLkTil_Y6rjgbAjQcOqTeFUt1WO46MNKFp5Qe4iSK3z@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	jmoyer@redhat.com, rwheeler@redhat.com, eshishki@redhat.com,
	sandeen@redhat.com
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291Ab0GIIxc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Jul 2010 04:53:32 -0400
In-Reply-To: <AANLkTil_Y6rjgbAjQcOqTeFUt1WO46MNKFp5Qe4iSK3z@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 7 Jul 2010, Greg Freemyer wrote:

> On Wed, Jul 7, 2010 at 9:18 AM, Lukas Czerner <lczerner@redhat.com> wrote:
> >
> > Hello again,
> >
> > I have composed a set of patches to add batched discard support for Ext3 file
> > system. Functionality is basically the same as in "batched discard support
> > for Ext4" (see http://www.spinics.net/lists/linux-ext4/msg19827.html ).
> >
> > There are two patches:
> 
> I'm inclined to review these, but before I do, I thought ext3 was
> closed to patches like this.
> 
> Or is it still accepting more new functionality than I thought?
> 
> Greg
> 

Hi, Greg

thanks for your interest ! Unfortunately it seems like you are right,
I was suspecting something like that. Anyway I am not the one who make
those decisions...so anyone ?

Thanks

-Lukas
