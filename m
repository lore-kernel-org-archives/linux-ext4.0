From: Ted Ts'o <tytso@mit.edu>
Subject: Re: tune2fs can't be used on a mounted ext4, or...?
Date: Mon, 11 Apr 2011 09:10:08 -0400
Message-ID: <20110411131008.GB5802@thunk.org>
References: <20110410003954.4108b9c9@natsu>
 <14B9D41F-4D38-4F01-97E9-17E86DA578FC@dilger.ca>
 <20110410035005.64f565e3@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	linux-raid@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110410035005.64f565e3@natsu>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Roman,

Your symptoms don't sound familiar to me, other than the standard
concerns about hardware induced file system inconsistency problems.
Have you checked your logs carefully to make sure there weren't any
hardware errors reported?  If this is a hardware RAID system, is it
regularly doing disk scrubbing?  Has the hardware RAID reported
anything unusual?  How long have you been running in a degraded RAID 6
state?

And have you tried shutting down the system and running fsck to make
sure there weren't any file system corruption problems?  When's the
last time you've run fsck on the system?

If this is an LVM system, I'd strongly suggest that you set aside
space you can take a snapshot, and then regularly take a snapshot, and
then run fsck on the snapshot.  If any problems are noted, you can
then schedule downtime and fsck the entire system.

Regards,

						- Ted
