From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Fix punch hole on files with indirect mapping
Date: Fri, 27 Jun 2014 12:58:02 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1406271257250.2349@localhost.localdomain>
References: <1403192228-25771-1-git-send-email-lczerner@redhat.com> <20140626162450.GD6826@thunk.org> <alpine.LFD.2.00.1406261827080.2172@localhost.localdomain> <20140627013329.GE6826@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-658542762-1403866686=:2349"
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, stable@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbaF0K6L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Jun 2014 06:58:11 -0400
In-Reply-To: <20140627013329.GE6826@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-658542762-1403866686=:2349
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 26 Jun 2014, Theodore Ts'o wrote:

> Date: Thu, 26 Jun 2014 21:33:29 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, jack@suse.cz, stable@vger.kernel.org
> Subject: Re: [PATCH] ext4: Fix punch hole on files with indirect mapping
> 
> On Thu, Jun 26, 2014 at 06:28:57PM +0200, Lukáš Czerner wrote:
> > 
> > It does. But this is not exactly a critical bug and it has been
> > there since the introduction of punch hole for indirect file. But I
> > guess it's better to fix it sooner rather than later, so I am fine
> > with this.
> 
> One of the reasons why I want to get this fixed sooner rather than
> later is that even when testing a stock ext4 file system, fsstress can
> potentially create indirect mapped files that could then get punched.
> So I wonder if bug might be responsible for some of the very random
> failures that I've been seeing in my testing...
> 
> 					- Ted

Fair enough, we can wait with my patch for the next merge window.

Thanks!
-Lukas
--8323328-658542762-1403866686=:2349--
