From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH e2fsprogs] Add ZFS detection to libblkid
Date: Mon, 2 Jun 2008 22:58:09 +0200
Message-ID: <20080602205809.GG3242@nb.net.home>
References: <1212171647.7508.46.camel@localhost> <20080602074102.GA3242@nb.net.home> <1212418863.7337.34.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@Sun.COM>
To: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbYFBU6f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jun 2008 16:58:35 -0400
Content-Disposition: inline
In-Reply-To: <1212418863.7337.34.camel@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 02, 2008 at 04:01:03PM +0100, Ricardo M. Correia wrote:
> Hi Karel,
> 
> On Seg, 2008-06-02 at 09:41 +0200, Karel Zak wrote:
> 
> >  It'd be nice to add ZFS detection to libvolume_id from udev package.
> 
> 
> Interesting, I didn't know libvolume_id existed.
> Is there a reason why there should be 2 different libraries doing what
> appears to be essentially the same thing?

 I'm just merging these two libraries to libfsprobe :-)
 http://git.kernel.org/?p=utils/util-linux-ng/util-linux-ng.git;a=shortlog;h=topic/fsprobe

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
