From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Subject: Re: A feature??
Date: Sun, 20 May 2007 07:01:32 -0400 (EDT)
Message-ID: <alpine.DEB.0.99.0705200700040.12765@sigma.j-a-k-j.com>
References: <46500C02.3010802@cybericom.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Chris Lee <cslee-list@cybericom.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from seahorse.shentel.net ([204.111.1.244]:32771 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641AbXETL0E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 May 2007 07:26:04 -0400
In-Reply-To: <46500C02.3010802@cybericom.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> I am not a FS guru so please tell me where to get off if I sound stupid.
> After lurking for some time I have come up with something that may be of
> interest as a feature:
> 
> If EXT4 were to pr-allocate a configurable amount of space for a special file
> and then use that file as a new EXT4 partition;
> -Use that file for all new writes to disk
> -Any changed files are changed by writing the change to this file, or the
> whole changed file, whichever is more efficient end to end.
> -A section of the file includes tracking of files that need modification in
> the actual FS.
> -Then when the disk is put back into normal read write mode the FS data in the
> file just needs to be worked into the actual FS.
> 
> This way the FS could be put into suspended operation while a third party
> reads it.
> I know there are other methods like snapshots, but this works at the FS level
> so that the third party, which obviously needs to know ext4, can access the
> hard drive directly.

Sounds like a combination of loopback and union mounting, except more 
automated. Not sure there'd be much benefit to implementing those concepts 
redundantly at the filesystem level.
