From: Pavel Machek <pavel@ucw.cz>
Subject: Re: Add a norecovery option to ext3/4?
Date: Wed, 11 Apr 2007 20:06:39 +0000
Message-ID: <20070411200639.GC5881@ucw.cz>
References: <20070409000556.GA13980@implementation> <4619B202.3050601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2958 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992511AbXDLLSw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Apr 2007 07:18:52 -0400
Content-Disposition: inline
In-Reply-To: <4619B202.3050601@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!

> >Distribution installers usually try to probe OSes for 
> >building a suited
> >grub menu.  Unfortunately, mounting an ext3 partition, 
> >even in read-only
> >mode, does perform some operations on the filesystem 
> >(log recovery).
> >This is not a good idea since it may silently garbage 
> >data.  
> 
> Can you elaborate?  Under what circumstances is log 
> replay going to harm data?  Do you mean that the 

Suspend machine, boot from CD trying to read from HDD, resume. People
lost data because of this trap.

Imagine _broken_ disk, with hw dying. Would you rather replay log,
possibly corrupting it even more, or read few files you do care about?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
