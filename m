From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: xt4 - True Readonly mount [WAS - Re: [Bug 14354] Bad corruption
	with 2.6.32-rc1 and upwards]
Date: Mon, 2 Nov 2009 16:59:18 -0500
Message-ID: <87f94c370911021359x19f57427o19e6f7bfcfadae21@mail.gmail.com>
References: <87f94c370910300720s5ea3d780o45fcf32303820a3c@mail.gmail.com>
	 <20091101054542.GP18464@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ted Augustine <taugustine@techpathways.com>,
	Alexey Fisher <bug-track@fisher-privat.net>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:63979 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756846AbZKBV7O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Nov 2009 16:59:14 -0500
Received: by iwn10 with SMTP id 10so3669945iwn.4
        for <linux-ext4@vger.kernel.org>; Mon, 02 Nov 2009 13:59:18 -0800 (PST)
In-Reply-To: <20091101054542.GP18464@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 1, 2009 at 12:45 AM, Theodore Tso <tytso@mit.edu> wrote:
> On Fri, Oct 30, 2009 at 10:20:35AM -0400, Greg Freemyer wrote:
>> Ignoring computer forensics, with LVM snapshots, hardware raid array
>> snapshots, etc. even in the presence of a dirty log, we need to be
>> able to mount a drive in true read-only fashion fro many backup
>> operations to function correctly.
>
> Can you go into more detail about "many backup operations"?

One example is a hardware raid array that creates readonly snapshots
or clones.  (Lots of those exist in the real world).

So the typical backup procedure is:

====
Queisce application (databases, etc. have utils to do this.)

Queisce filesystem (xfs_freeze -f can be done from userspace. is there
a ext4 util?)

issue raid array command to create snapshot.

release filesystem (xfs_freeze -u)

release the app (util provided by app).

Mount the snapshot readonly (true readonly with zero writes to the
block device).

Backup the readonly snapshot (to tape, etc.).
===

I believe XFS had 2 issues related to this process when first
implemented in linux.

1) It required the UUID to be unique.  Obviously in the above scenario
it is not, so "mount -o nouuid" was added for xfs.

2) Journal replay was originally aways attempted in the above process,
so the "mount -o norecovery" option was added to force a true readonly
mount.

ext4 may already support mounting of readonly clones, but if not it
needs to before it will qualify as a data center ready filesystem.

Greg
-- 
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
Preservation and Forensic processing of Exchange Repositories White Paper -
<http://www.norcrossgroup.com/forms/whitepapers/tng_whitepaper_fpe.html>

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
