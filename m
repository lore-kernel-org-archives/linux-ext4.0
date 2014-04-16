From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] check: add support for an external test expunging file
Date: Wed, 16 Apr 2014 10:15:30 +1000
Message-ID: <20140416001530.GU15995@dastard>
References: <1397530320-20579-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:16127 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750893AbaDPAPq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Apr 2014 20:15:46 -0400
Content-Disposition: inline
In-Reply-To: <1397530320-20579-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 14, 2014 at 10:52:00PM -0400, Theodore Ts'o wrote:
> Currently the -X option is intended to specify a set of expunging
> files which are stored in each test/* subdirectory.  As described in
> the commit description for 0b1e8abd4, in order to exclude the test
> generic/280, the -X option is used as follows:
> 
>     $ cat tests/generic/3.0-stable-avoid
>     280
>     $ sudo ./check -X 3.0-stable-avoid generic/280
> 
> However, it is sometimes useful to store the set of expunged tests in
> a single file, outside of tests/* subdirectories.  This commit allows
> the following:
> 
>     $ cat /root/conf/data_journal.exclude
>     generic/068
>     ext4/301
>     $ sudo ./check -X /root/conf/data_journal.exclude -g auto
> 
> If the argument to the -X option is a pathname (that is, includes a
> '/' character), treat it as the latter case.  If it the argument to
> the -X option is just a bare filename (that is, does not include '/'
> character), treat it as the former.

Can you add a new option rather than overloading the existing one
with new meanings and semantics?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
