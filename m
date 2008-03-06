From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] [RFC] New fsck option to ignore device-mapper crypto
	devices
Date: Thu, 6 Mar 2008 12:42:20 -0500
Message-ID: <20080306174220.GH18188@mit.edu>
References: <n7xejaoynp9.fsf@sor.suse.de> <1204813967.8679.28.camel@norville.austin.ibm.com> <n7xzltbwzq3.fsf@sor.suse.de> <1204824227.7964.4.camel@norville.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthias Koenig <mkoenig@suse.de>, ludwig.nussel@suse.de,
	linux-ext4@vger.kernel.org
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:42852 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932339AbYCFRmf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Mar 2008 12:42:35 -0500
Content-Disposition: inline
In-Reply-To: <1204824227.7964.4.camel@norville.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 06, 2008 at 11:23:47AM -0600, Dave Kleikamp wrote:
> Zero tells fsck not to check the filesystem during reboot.  It's what
> tells fsck -A which filesystems to check.  If we don't expect the
> filesystem to be check-able during that phase, a non-zero value won't
> have any real meaning.

I'm now beginning to understand why SuSE wanted fsck -M/-m (ignore
mounted filesystems).  Looks like SuSE has a very strange and
non-standard usage scenario with fsck -A which is *not* just at
boot-time.

So before we try to figure out whether Yet Another FSCK option makes
sense, maybe it would be good to get an explanation exactly *how* SuSE
is using fsck -A, besides just at boot-time?

						- Ted
