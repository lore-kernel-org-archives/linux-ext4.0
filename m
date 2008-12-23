From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: (resend) extent header problems following shrink with resize2fs
Date: Tue, 23 Dec 2008 01:18:33 -0500
Message-ID: <20081223061833.GQ23723@mit.edu>
References: <87abanbfvo.fsf@burly.wgtn.ondioline.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Paul Collins <paul@burly.ondioline.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:39181 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751896AbYLWGSj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Dec 2008 01:18:39 -0500
Content-Disposition: inline
In-Reply-To: <87abanbfvo.fsf@burly.wgtn.ondioline.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 23, 2008 at 06:49:15PM +1300, Paul Collins wrote:
> (resending without gipped attachment)
> 
> Yesterday I created a ~464GB ext4 volume and copied about 107GB of music
> files onto it.  Then I decided that I wanted to use half of the disk for
> something else, so last night I resized the ext4 filesystem to ~232GB
> and recreated the partitions to suit.  This morning I wrote some new
> files to the ext4 filesystem, which went fine.  Then I installed a new
> music player, which wanted to scan all of the files on the disk.  It
> reported being unable to read some files, and there's rather a lot of
> this sort of thing in dmesg (see also http://ondioline.org/~paul/e4dmesg.gz):

Yeah, resize2fs needs to be fixed to handle extents correctly.  At the
moment it can screw them up pretty badly.  I'll log this as a bug to
resize2fs; thanks for reporting it, and I hope you didn't suffer any
permanent data loss.

Regards,

							- Ted
