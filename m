From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Wed, 20 Apr 2011 11:29:56 -0400
Message-ID: <20110420152956.GA24641@infradead.org>
References: <E7438588-5C5A-42B9-9B6C-FADF7CAC6D3A@dilger.ca>
 <4EEEA16E-1FDB-4430-A372-8F8701196E4C@mit.edu>
 <20110418004040.GS21395@dastard>
 <6C89E159-A5F6-4A06-A3D2-273BE4CFB9B5@dilger.ca>
 <BANLkTin=WEpSf6ddiOMNMOpCPP-wiEttSw@mail.gmail.com>
 <20110419034455.GB23985@dastard>
 <BANLkTinjh968ECqAobQ677hnV5yzke1ncw@mail.gmail.com>
 <20110419074538.GG23985@dastard>
 <20110419140909.GD3030@thunk.org>
 <20110419210825.GJ23985@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>,
	"coreutils@gnu.org" <coreutils@gnu.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	P?draig Brady <P@draigbrady.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49895 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab1DTP37 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Apr 2011 11:29:59 -0400
Content-Disposition: inline
In-Reply-To: <20110419210825.GJ23985@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 20, 2011 at 07:08:25AM +1000, Dave Chinner wrote:
> So, it logically follws that you need to use the SYNC flag for both
> unwritten extents and delalloc extents to find out where there data
> realy lies by converting them to real, written extents. i.e. the
> only extents you can trust contain data from FIEMAP are the real
> extents on disk....

Even more funny is that the bug report that started this thread involved
software that didn't actually care about the location on disk, at all.

cp from coreutils really just wanted an efficient way to skip holes
in sparse files, and we got into a chain reaction of various flaws
and oversights :

 (1) Linux lacks the SEEK_HOLE/SEEK_DATA interface that would make
     skipping holes trivial and thus coreutils has to use FIEMAP.
 (2) ext4 and btrfs in some cases mishandled reporting delalloc
     extents, which means coreutils had to add the sync flag,
     despite not caring where data is on disk
 (3) coreutils tried to treat unwrittent extents as holes.  Which
     makes some sense given their high-level description, although
     probably not too much in practice given that we explicitly
     allocated blocks to these "holes" to optimize performance.
     But the main issue here is that there is no documentation
     that clearly states that unwrittent extents reported by
     FIEMAP may actually contain useful data.  In fact there's
     no useful documentation for FIEMAP outside the kernel tree.
     And interface that complex really needs a manpage.

