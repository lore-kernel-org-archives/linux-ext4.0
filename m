From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Filessystem corruptions while using rsnapshot
Date: Wed, 09 Sep 2009 16:46:12 -0500
Message-ID: <4AA82224.3010605@redhat.com>
References: <20090909133026.GA1965@phenom2.trippelsdorf.de> <4AA7BE69.7070406@redhat.com> <20090909172015.GA1980@phenom2.trippelsdorf.de> <4AA7E411.7070005@redhat.com> <20090909212925.GA2011@phenom2.trippelsdorf.de> <4AA81FB1.7000000@redhat.com> <20090909214223.GB2011@phenom2.trippelsdorf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbZIIVqe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Sep 2009 17:46:34 -0400
In-Reply-To: <20090909214223.GB2011@phenom2.trippelsdorf.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Markus Trippelsdorf wrote:
> On Wed, Sep 09, 2009 at 04:35:45PM -0500, Eric Sandeen wrote:

...

>> Just for completeness, if there are errors in the system logs, can you 
>> post them here as well?
> 
> There are no errors in the system logs.
> I only learned about this bug when a regular boot-time fsck was running that
> printed the problems mentionted above.

Hm, but there should be no regular boot-time fsck unless you have your 
forced-fsck interval set pretty low; a normal boot-time fsck will simply 
replay the log.  Was that it; did you just happen to catch this on the 
21st boot or whatever the interval may be?

Otherwise, the fs was flagged with errors, and -that- forced the full 
fsck at boot time, and hopefully something previous was logged somewhere ...

-Eric
