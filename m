From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH e2fsprogs] Add ZFS detection to libblkid
Date: Mon, 02 Jun 2008 17:11:02 -0600
Message-ID: <20080602231102.GR2961@webber.adilger.int>
References: <1212171647.7508.46.camel@localhost>
 <20080602074102.GA3242@nb.net.home> <1212418863.7337.34.camel@localhost>
 <20080602205809.GG3242@nb.net.home> <20080602213848.GO2961@webber.adilger.int>
 <20080602223113.GH3242@nb.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "Ricardo M. Correia" <Ricardo.M.Correia@sun.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:45252 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbYFBXLP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 19:11:15 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m52NBEk6026554
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 16:11:15 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K1U00101YQY3600@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 02 Jun 2008 16:11:14 -0700 (PDT)
In-reply-to: <20080602223113.GH3242@nb.net.home>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 03, 2008  00:31 +0200, Karel Zak wrote:
> On Mon, Jun 02, 2008 at 03:38:48PM -0600, Andreas Dilger wrote:
> > On Jun 02, 2008  22:58 +0200, Karel Zak wrote:
> > > On Mon, Jun 02, 2008 at 04:01:03PM +0100, Ricardo M. Correia wrote:
> > > > Hi Karel,
> > > > 
> > > > On Seg, 2008-06-02 at 09:41 +0200, Karel Zak wrote:
> > > > 
> > > > >  It'd be nice to add ZFS detection to libvolume_id from udev package.
> > > > 
> > > > 
> > > > Interesting, I didn't know libvolume_id existed.
> > > > Is there a reason why there should be 2 different libraries doing what
> > > > appears to be essentially the same thing?
> > > 
> > >  I'm just merging these two libraries to libfsprobe :-)
> > >  http://git.kernel.org/?p=utils/util-linux-ng/util-linux-ng.git;a=shortlog;h=topic/fsprobe
> > 
> > Hrm, having "fs" in the name is a bit unfortunate, since several of the
> > things that libblkid detects are not filesystems (e.g. MD, swap).
> > Similarly, libvolume_id also does not contain "fs" in the name...
> 
>  Any suggestion? (Frankly, I don't care about names...)

To be honest, I'd prefer if you just kept the existing name(s) and merged
the functionality of the two libraries into one.  That avoids the need to
re-code either set of applications, and also avoids the risk of a yet
_another_ library in addition to libblkid and libvolume_id that is used
in a few places each.

Failing that, how about "libdevprobe"?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

