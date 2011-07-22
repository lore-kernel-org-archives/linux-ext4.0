From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH XFSPROGS 1/3] configure.in: Declare a requirement for at
 least autoconf 2.50
Date: Fri, 22 Jul 2011 10:28:50 -0400
Message-ID: <20110722142850.GB19681@infradead.org>
References: <1311292237-4155-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40894
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751418Ab1GVO2w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jul 2011 10:28:52 -0400
Content-Disposition: inline
In-Reply-To: <1311292237-4155-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 21, 2011 at 07:50:35PM -0400, Theodore Ts'o wrote:
> On Debian/Ubuntu systems, if autoconf version 2.13 is installed,
> autoconf will try to automatically figure out whether autoconf 2.13 or
> something more modern is required (since the autoconf maintainers,
> curses be upon them, didn't bother to maintain compatibility between
> autoconf 2.13 and 2.50).  Unfortunately, the hueristics aren't
> perfect, and although the configure.in file looks superficially like
> it will be compatible with autoconf 2.13, it isn't.  You will end up
> with a number of very subtle compilation failures if you use autoconf
> 2.13.
> 
> So declare a requirement for autoconf 2.50 using AC_PREREQ(2.50).

Thanks a lot, I've applied our xfsprogs and xfstests patches, and also
ported the change to the xfsdump and dmapi repositories.
