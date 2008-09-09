From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ext4: fix #11321: create /proc/ext4/*/stats et al more
 carefully
Date: Tue, 9 Sep 2008 00:12:03 -0700
Message-ID: <20080909001203.7480549e.akpm@linux-foundation.org>
References: <20080905210652.GE11569@x200.localdomain>
	<20080906075713.GM3086@webber.adilger.int>
	<20080907121557.GA3432@x200.localdomain>
	<20080907160414.GB26248@charite.de>
	<20080905210652.GE11569@x200.localdomain>
	<20080906075713.GM3086@webber.adilger.int>
	<20080907121557.GA3432@x200.localdomain>
	<20080907162447.GB32429@mit.edu>
	<20080907164130.GA3376@x200.localdomain>
	<20080908143951.GH8161@mit.edu>
	<20080909070630.GC5786@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@MIT.EDU>,
	Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754830AbYIIHM6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2008 03:12:58 -0400
In-Reply-To: <20080909070630.GC5786@x200.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 9 Sep 2008 11:06:30 +0400 Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Mon, Sep 08, 2008 at 10:39:51AM -0400, Theodore Tso wrote:
> > Here's what I've checked into the ext4 patch queue for submission to
> > mainline at the next merge window.  I've added a bit more error
> > checking in case proc_mkdir() fails and returns NULL.
> 
> Hopefully, Andrew, will pick up original non-broken patch.

What does this mean??
