From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH] blkid: optimize dm_device_is_leaf() usage
Date: Wed, 27 Aug 2008 10:10:01 +0200
Message-ID: <20080827081000.GO6029@nb.net.home>
References: <1219697316-5632-1-git-send-email-kzak@redhat.com> <20080826122405.GA8720@mit.edu> <20080826135102.GK6029@nb.net.home> <20080826144721.GD8720@mit.edu> <20080826204737.GM6029@nb.net.home> <20080826233224.GB29936@mit.edu> <20080827001942.GN6029@nb.net.home> <20080827072643.GT3392@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Eric Sandeen <sandeen@redhat.com>, mbroz@redhat.com,
	agk@redhat.com
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238AbYH0IKf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Aug 2008 04:10:35 -0400
Content-Disposition: inline
In-Reply-To: <20080827072643.GT3392@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 27, 2008 at 01:26:43AM -0600, Andreas Dilger wrote:
> On Aug 27, 2008  02:19 +0200, Karel Zak wrote:
> > On Tue, Aug 26, 2008 at 07:32:25PM -0400, Theodore Tso wrote:
> > > you'll just be re-inventing blkid.  If you don't cache, you'll either
> > 
> >  Hehe.. I will directly copy code from blkid and vol_id. It's open
> >  source. I needn't re-inventing ;-)
> 
> Couldn't you just change libblkid to export the probe functions?  It
> always makes me cringe when code like this is copied, because I just
> _know_ one or the other will become out of date, and it will take
> twice as much effort to keep them in sync.  I'd rather see people
> doing "high value" work instead of watching for and copying patches
> around.

 Yes, good point. Frankly, I think about it in last weeks. I have done
 work on the low-lever part of libfsprobe -- it shouldn't be a problem
 port this code to libblkid. The advantage will be a library that is
 usable for udev and backwardly compatible for the current blkid
 applications. I will try it...

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
