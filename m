From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] [RFC] New fsck option to ignore device-mapper crypto
	devices
Date: Wed, 12 Mar 2008 16:14:55 -0400
Message-ID: <20080312201455.GF15804@mit.edu>
References: <n7xejaoynp9.fsf@sor.suse.de> <1204813967.8679.28.camel@norville.austin.ibm.com> <n7xzltbwzq3.fsf@sor.suse.de> <1204824227.7964.4.camel@norville.austin.ibm.com> <n7xiqzywr7u.fsf@sor.suse.de> <1204903187.7975.10.camel@norville.austin.ibm.com> <n7xr6egkk6w.fsf@sor.suse.de> <20080312200236.GE15804@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>, ludwig.nussel@suse.de,
	linux-ext4@vger.kernel.org
To: Matthias Koenig <mkoenig@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:47618 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754357AbYCLUO7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Mar 2008 16:14:59 -0400
Content-Disposition: inline
In-Reply-To: <20080312200236.GE15804@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 12, 2008 at 04:02:36PM -0400, Theodore Tso wrote:
> So here's another way you could do things that doesn't require any
> patches to fsck at all.  Just add "comment=crypto" into the option
> field of /etc/fstab, like this.  
> 
> /dev/mapper/crypto-frobnitz /crypto1           ext3    comment=crypto  1 1
> 
> Then you can skip filesystems that have the comment=crypto in the
> options field via:
> 
>      fsck -AR -t opts=!comment=crypto

Oh by the way, in case you haven't tried this, the best way to test
exactly what fsck will do with a set of arguments is by using the -NV
options, i.e.:

      fsck -ARNV -t opts=!comment=crypto

						- Ted
