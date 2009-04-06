From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH e2fsprogs] Add ZFS detection to libblkid
Date: Mon, 6 Apr 2009 22:35:28 +0200
Message-ID: <20090406203527.GB6800@nb.net.home>
References: <1212171647.7508.46.camel@localhost> <49D6C844.5070604@redhat.com> <49D75AD1.7060101@redhat.com> <20090404212507.GC3199@webber.adilger.int> <1239045758.7486.80.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@Sun.COM>,
	Eric Sandeen <sandeen@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:50101 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756AbZDFUfe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Apr 2009 16:35:34 -0400
Content-Disposition: inline
In-Reply-To: <1239045758.7486.80.camel@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 06, 2009 at 08:22:38PM +0100, Ricardo M. Correia wrote:
> So I think you're (mostly) right - in theory, a correct implementation
> would have to search all the uberblock slots in all the 4 labels (2 at
> the beginning of the partition and 2 at the end), for a total of 512
> magic offsets, but this is not easy to do with libblkid because it only
> looks for the magic values at hard-coded offsets (as opposed to being
> able to implement a routine to look for a filesystem, which could use a
> simple "for" statement).

 Note that the new libblkid version (in util-linux-ng) could use a
 simple "for" statement (see ufs.c or *_raid.c), but the "magic value
 at hard-coded offset" is a better (cheaper) method.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
