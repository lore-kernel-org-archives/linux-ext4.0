From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: Filessystem corruptions while using rsnapshot
Date: Wed, 9 Sep 2009 23:50:55 +0200
Message-ID: <20090909215055.GC2011@phenom2.trippelsdorf.de>
References: <20090909133026.GA1965@phenom2.trippelsdorf.de>
 <4AA7BE69.7070406@redhat.com>
 <20090909172015.GA1980@phenom2.trippelsdorf.de>
 <4AA7E411.7070005@redhat.com>
 <20090909212925.GA2011@phenom2.trippelsdorf.de>
 <4AA81FB1.7000000@redhat.com>
 <20090909214223.GB2011@phenom2.trippelsdorf.de>
 <4AA82224.3010605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-144.synserver.de ([212.40.180.144]:1067 "HELO
	smtp-out-144.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753079AbZIIVux (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Sep 2009 17:50:53 -0400
Content-Disposition: inline
In-Reply-To: <4AA82224.3010605@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 09, 2009 at 04:46:12PM -0500, Eric Sandeen wrote:
> Markus Trippelsdorf wrote:
> > On Wed, Sep 09, 2009 at 04:35:45PM -0500, Eric Sandeen wrote:
> 
> ...
> 
> >> Just for completeness, if there are errors in the system logs, can you 
> >> post them here as well?
> > 
> > There are no errors in the system logs.
> > I only learned about this bug when a regular boot-time fsck was running that
> > printed the problems mentionted above.
> 
> Hm, but there should be no regular boot-time fsck unless you have your 
> forced-fsck interval set pretty low; a normal boot-time fsck will simply 
> replay the log.  Was that it; did you just happen to catch this on the 
> 21st boot or whatever the interval may be?

Yes, sorry I didn't make myself clear, I just happen to catch this on
the 21st boot...
After that I booted from an USB stick and ran fsck by hand from there.
-- 
Markus
