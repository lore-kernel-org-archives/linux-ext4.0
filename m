From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH e2fsprogs] Add ZFS detection to libblkid
Date: Tue, 3 Jun 2008 00:31:13 +0200
Message-ID: <20080602223113.GH3242@nb.net.home>
References: <1212171647.7508.46.camel@localhost> <20080602074102.GA3242@nb.net.home> <1212418863.7337.34.camel@localhost> <20080602205809.GG3242@nb.net.home> <20080602213848.GO2961@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Ricardo M. Correia" <Ricardo.M.Correia@sun.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708AbYFBWbQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jun 2008 18:31:16 -0400
Content-Disposition: inline
In-Reply-To: <20080602213848.GO2961@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 02, 2008 at 03:38:48PM -0600, Andreas Dilger wrote:
> On Jun 02, 2008  22:58 +0200, Karel Zak wrote:
> > On Mon, Jun 02, 2008 at 04:01:03PM +0100, Ricardo M. Correia wrote:
> > > Hi Karel,
> > > 
> > > On Seg, 2008-06-02 at 09:41 +0200, Karel Zak wrote:
> > > 
> > > >  It'd be nice to add ZFS detection to libvolume_id from udev package.
> > > 
> > > 
> > > Interesting, I didn't know libvolume_id existed.
> > > Is there a reason why there should be 2 different libraries doing what
> > > appears to be essentially the same thing?
> > 
> >  I'm just merging these two libraries to libfsprobe :-)
> >  http://git.kernel.org/?p=utils/util-linux-ng/util-linux-ng.git;a=shortlog;h=topic/fsprobe
> 
> Hrm, having "fs" in the name is a bit unfortunate, since several of the
> things that libblkid detects are not filesystems (e.g. MD, swap).
> Similarly, libvolume_id also does not contain "fs" in the name...

 Any suggestion? (Frankly, I don't care about names...)

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
