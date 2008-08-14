From: Christian Hesse <mail@eworm.de>
Subject: Re: Oops with ext4 from 2.6.27-rc3
Date: Thu, 14 Aug 2008 08:59:01 +0200
Message-ID: <200808140859.03171.mail@eworm.de>
References: <47983.10.5.1.205.1218652098.squirrel@webmail.lugor.de> <1218672653.6456.14.camel@mingming-laptop> <20080814015113.GA8078@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kolab.mylinuxtime.de ([212.112.242.22]:55021 "EHLO
	kolab.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbYHNG7F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Aug 2008 02:59:05 -0400
In-Reply-To: <20080814015113.GA8078@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thursday 14 August 2008, Theodore Tso wrote:
> On Wed, Aug 13, 2008 at 05:10:53PM -0700, Mingming Cao wrote:
> > I could reproduce it.
> >
> > This patch works for me on top of Ted's change.  Christian, could you
> > try it?
>
> Thanks, mingming!  Looks good and I've added it to the patch queue.

08:58:16 eworm@io:~$ uptime
 08:58:18 up 37 min,  2 users,  load average: 3.57, 2.36, 1.12

This is *a lot* longer than the system survived without the patches. I hope it 
is fixed now. Ted and Mingming, thanks a lot!

A short side note... I get warnings when compiling the new code:

fs/ext4/inode.c: In function 'ext4_da_release_space':
fs/ext4/inode.c:1581: warning: format '%d' expects type 'int', but argument 2 
has type 'long unsigned int'
fs/ext4/inode.c:1581: warning: format '%lu' expects type 'long unsigned int', 
but argument 3 has type 'int'
-- 
Regards,
Chris
