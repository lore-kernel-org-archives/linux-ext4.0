From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Tue, 19 Apr 2011 01:27:32 -0400
Message-ID: <20110419052732.GA19952@infradead.org>
References: <4DA7836A.5040604@draigBrady.com>
 <20110415000940.GL21395@dastard>
 <76FFF648-CA02-494B-A862-566C66A8CB82@dilger.ca>
 <20110416005040.GP21395@dastard>
 <E7438588-5C5A-42B9-9B6C-FADF7CAC6D3A@dilger.ca>
 <4EEEA16E-1FDB-4430-A372-8F8701196E4C@mit.edu>
 <20110418004040.GS21395@dastard>
 <6C89E159-A5F6-4A06-A3D2-273BE4CFB9B5@dilger.ca>
 <BANLkTin=WEpSf6ddiOMNMOpCPP-wiEttSw@mail.gmail.com>
 <20110419025949.GA3030@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>,
	"coreutils@gnu.org" <coreutils@gnu.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	P?draig Brady <P@draigbrady.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58745 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab1DSF1p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Apr 2011 01:27:45 -0400
Content-Disposition: inline
In-Reply-To: <20110419025949.GA3030@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 18, 2011 at 10:59:49PM -0400, Ted Ts'o wrote:
> Maybe coreutils will need to use FIEMAP_FLAG_SYNC initially, since
> it's the only way to guarantee correct behaviour for XFS.  But I woul=
d
> really rather that be the long-term way we leave things!

As Eric pointed out both ext4 and XFS have the same behaviour when
writing into unwritten extent.  I think you are a bit confused because
ext4 also got basic handling of delalloc extents wrong before commit
6d9c85eb700bd3ac59e63bb9de463dea1aca084c, which never was a problem wit=
h
XFS.  It would be nice if ext4 developers had sent the included
regression test for xfs so that everyone could verify this behaviour,
btw.

To report written to but not synced unwritten extents properly we'd
need to move fiemap away from the on=F0disk state reporting done so far
and do something that is purely in-memory.  It would be doable by
walking the pagecache and checking for the buffer unwritten flag
in a loop over the pages, but I'm honestly not sure it's going to
help much.  In fact given that unwritten extent were specifically
allocated before it doesn't seem like an overly smart idea to skip
them in a copy - yes it will save space but it also undoes the
previous explicit preallocation.  If people want it they should rather
add a new option to cp to turn zeroes into holes.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
