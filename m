From: Jimmy Rentz <jedynamic@bellsouth.net>
Subject: Re: ext4 - error with root drive mount
Date: Wed, 4 Feb 2009 19:29:11 -0500
Message-ID: <20090204192911.78564f27@amd64linuxmsi.rentzhouse.lan>
References: <20090203191531.0dfe27a1@amd64linuxmsi.rentzhouse.lan>
	<20090204062400.GZ14762@mit.edu>
	<20090204093420.44cac139@amd64linuxmsi.rentzhouse.lan>
	<4989BFEC.8020803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jimmy Rentz <jedynamic@bellsouth.net>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmailhost05.isp.att.net ([204.127.217.105]:34692 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbZBEA3R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Feb 2009 19:29:17 -0500
In-Reply-To: <4989BFEC.8020803@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 04 Feb 2009 10:18:52 -0600
Eric Sandeen <sandeen@redhat.com> wrote:

> Jimmy Rentz wrote:
> 
> > I am not sure how to reproduce this problem.  It seems random
> > enough.  The system is a mythtv box so it happens to
> > poweron/poweroff on a regular basis to record.    
> 
> Just to be clear, it does this in a controlled manner, right.
> 
> -Eric
You mean whether the poweron/poweroff part is done cleanly? 
The system sets a wakeup time to poweron (to
record) then calls poweroff (via a script).  
