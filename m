From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: ext4 64bit (disk >16TB) question
Date: Tue, 15 Jul 2008 18:13:18 +0200
Message-ID: <87tzer9lcx.fsf@frosties.localdomain>
References: <87bq10w8gv.fsf@frosties.localdomain>
	<87y743vh3q.fsf@frosties.localdomain> <487CA331.8050403@redhat.com>
	<200807151601.20881.bs@q-leap.de> <487CAF6A.8070403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: rwheeler@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:53992 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659AbYGOQNU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jul 2008 12:13:20 -0400
In-Reply-To: <487CAF6A.8070403@redhat.com> (Ric Wheeler's message of "Tue, 15
	Jul 2008 10:08:42 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ric Wheeler <rwheeler@redhat.com> writes:

> How long would you wait for something like fsck to run to completion
> before you would need to go to back up tapes? 6 hours? 1 day? 1 week
> ;-) ?

Backup? What are backups? :))

A hardware raid6 resync takes about 16h. A Software raid6 (over 6
hardware raid6) resync takes 1-2 days.

With lustre the fsck has to be done on the MDT (meta data target) to
build a database file and on all the OST (object storage target). So
there is some parallelization in the system.

But each OST, if we get ext4 64bit working, would be 28TB. I would
assume days for an fsck run. Weeks would not be good and less than a
day is totaly unrealistic.


But a few days for an fsck of 400-800TB filesystem isn't so
bad. Reading that amount from backup will take ages too, if you even
have one.

MfG
        Goswin
