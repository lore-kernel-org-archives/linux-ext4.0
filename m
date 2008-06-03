From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] Add ZFS detection to libblkid
Date: Mon, 2 Jun 2008 20:05:50 -0400
Message-ID: <20080603000550.GG23119@mit.edu>
References: <1212171647.7508.46.camel@localhost> <20080602074102.GA3242@nb.net.home> <1212418863.7337.34.camel@localhost> <20080602205809.GG3242@nb.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>,
	linux-ext4@vger.kernel.org, Andreas Dilger <adilger@Sun.COM>
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33958 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753399AbYFCAGC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 20:06:02 -0400
Content-Disposition: inline
In-Reply-To: <20080602205809.GG3242@nb.net.home>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 02, 2008 at 10:58:09PM +0200, Karel Zak wrote:
> 
>  I'm just merging these two libraries to libfsprobe :-)
>  http://git.kernel.org/?p=utils/util-linux-ng/util-linux-ng.git;a=shortlog;h=topic/fsprobe
> 

Note that libfsprobe does not currently have proper support for ext4
and ext4dev filesystem types.

						- Ted
