From: <Martin_Zielinski@McAfee.com>
Subject: RE: 2.6.32 ext3 assertion j_running_transaction != NULL fails in
 commit.c
Date: Tue, 26 Apr 2011 07:45:33 -0500
Message-ID: <BCB84D936723884B91E4CC5CA0A7C54AA4F6D085B8@EMEADALEXMB1.corp.nai.org>
References: <BCB84D936723884B91E4CC5CA0A7C54AA4F6D082BE@EMEADALEXMB1.corp.nai.org>
 <20110425231454.GB9486@thunk.org>
 <BCB84D936723884B91E4CC5CA0A7C54AA4F6D08501@EMEADALEXMB1.corp.nai.org>
 <20110426122338.GE9486@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dalsmrelay2.nai.com ([205.227.136.216]:56904 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab1DZMuM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Apr 2011 08:50:12 -0400
In-Reply-To: <20110426122338.GE9486@thunk.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I will port the jbd2 debugging code to jbd an will try to get the new kernel into production.
After a reboot we will have to wait several weeks. (Strange: all machines failed within 72 hours).

With sqlite I can currently produce ~10.000.000 commits in one hour with a program that does nothing else.
I doubt that it is possible to have an overflow in such a short time that we are observing.
Maybe the __log_start_commit commit call comes with a corrupt target id from elsewhere. But your patch will catch that, too.

Cheers,
Martin

-----Original Message-----
From: Ted Ts'o [mailto:tytso@mit.edu] 
Sent: Dienstag, 26. April 2011 14:24
To: Zielinski, Martin
Cc: linux-ext4@vger.kernel.org
Subject: Re: 2.6.32 ext3 assertion j_running_transaction != NULL fails in commit.c

On Tue, Apr 26, 2011 at 04:07:11AM -0500, Martin_Zielinski@mcafee.com wrote:
> Ted!
> Thank you a lot!
> We observed this bug on ~10 out of 40 machines after an uptime from about 3 weeks. All run under comparable conditions.
> I will have a closer look on the debugfs output to verify if the situation can  happen within this short time range. Additionally we installed a crash kernel and I changed the BUG into a panic(). 
> So I will be able to look at the journal structure if this happens again.

If you would be willing to install the debugging code that is in the
jbd2 patch into the jbd patch, and this put this on your production
machines, that would be really great.  I can send you a revised jbd
patch if that would help (the debugging in code in jbd2 should move
over to the jbd patch really simply).

							- Ted
