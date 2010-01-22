From: tytso@mit.edu
Subject: Re: [PATCH] default max mount count to unused
Date: Thu, 21 Jan 2010 20:37:35 -0500
Message-ID: <20100122013735.GB21263@thunk.org>
References: <4B5785A5.2010505@redhat.com>
 <F348497E-C9B1-49D3-920B-5AF98CBDDD98@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Bill Nottingham <notting@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>,
	LVM Mailing List <linux-lvm@redhat.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55373 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659Ab0AVBiD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jan 2010 20:38:03 -0500
Content-Disposition: inline
In-Reply-To: <F348497E-C9B1-49D3-920B-5AF98CBDDD98@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 21, 2010 at 05:22:55PM -0700, Andreas Dilger wrote:
> 
> Alasdair, any chance you can include this script into the LVM package?
> 
> Ted, this should really be added to e2fsprogs, and the e2croncheck
> script removed.  The existing e2croncheck script is broken in a
> number of ways (e.g. the force check timestamp 19000101 is invalid,
> the email reporting doesn't work because "$RPT-EMAIL" is never set)
> and is less functional in other ways (it doesn't remove stale
> snapshots in case of an interrupted script, it doesn't check
> multiple LVs, etc).

Sure, I'd be happy to include this to e2fsprogs.  I'm not sure which
distro package should be installing it, but we can leave that up to
the distro maintainers.

					- Ted
