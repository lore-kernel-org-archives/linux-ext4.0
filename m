From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH v2] ext4: fix initialization of UNINIT bitmap blocks
Date: Thu, 25 Sep 2008 17:04:46 -0600
Message-ID: <20080925230446.GO10950@webber.adilger.int>
References: <20080915133604.GA6548@skywalker>
 <1221489026.6733.36.camel@frecb007923.frec.bull.fr>
 <1221745514.3550.83.camel@frecb007923.frec.bull.fr>
 <20080921004451.GA15402@mit.edu>
 <1222070998.3581.25.camel@frecb007923.frec.bull.fr>
 <20080922084721.GA6691@skywalker>
 <1222075960.3581.33.camel@frecb007923.frec.bull.fr>
 <20080923231346.GT10950@webber.adilger.int>
 <1222261048.3511.23.camel@frecb007923.frec.bull.fr>
 <20080924162339.GH9929@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: =?utf-8?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:53480 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbYIYXFc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Sep 2008 19:05:32 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m8PN5QWP019830
	for <linux-ext4@vger.kernel.org>; Thu, 25 Sep 2008 16:05:27 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K7R00701XAZSX00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 25 Sep 2008 16:05:26 -0700 (PDT)
In-reply-to: <20080924162339.GH9929@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 24, 2008  12:23 -0400, Theodore Ts'o wrote:
> > Do you mean that making ext4_group_info generic for both mballoc and
> > oldalloc will reduce the code complexity ?
> 
> Long-term, we want to do this, yes.  There's a lot of stuff in mballoc
> that we probably need to move out into generic code.  I'll sending
> patches shortly that move the /proc handling code into the generic
> code, and also saving 2k of compiled object code in the process.
> 
> Here, I think main argument is since mballoc is on by default, and the
> benefits of this are huge, is that we would save memory by using an
> unused bit in ext4_group_info.

Exactly.

> A related question is at what point should we remove the oldalloc code
> altogehter?

I'd vote for sooner rather than later.  We're pretty clear on the mballoc
benefits, and there is a lot of old/duplicate cruft that is confusing
(e.g. old block reservation code) that could be removed at the same time.

> > Anyway, I don't understand why we should write bitmaps to disk after
> > that, and why we should zeroing the inode table.  Don't we end up with a
> > fast mkfs and a slow mount doing all the stuff older mkfs was doing ?
> > The UNINIT feature would become less interesting.
> 
> It would be an absolute disaster to do this at mount time, especially
> if it included zeroing the inode table.  Zeroing the inode table must
> be done in a background kernel thread,

Yes, definitely I meant "in a background thread that can be interrupted
if there is other fs activity or unmount", not synchronously with the
mount.  The risk of fatal itable/GDT corruption in the first minute of
using a newly formatted filesystem is small, and the corresponding value
of any data in that filesystem would be equally small.

> with appropriate locks to avoid races with the block allocation code

Definitely...

> I don't think we should worry about initializing the bitmaps in
> advance.  There's just no advantage in doing that for the bitmaps.

Well, just some small safety that there isn't complete garbage on
disk, which helps e2fsck make a better decision in case of old data
still on the disk.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

