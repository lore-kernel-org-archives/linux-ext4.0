From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP
 related?)
Date: Tue, 19 Apr 2011 12:01:14 -0400
Message-ID: <20110419160114.GE3030@thunk.org>
References: <E7438588-5C5A-42B9-9B6C-FADF7CAC6D3A@dilger.ca>
 <4EEEA16E-1FDB-4430-A372-8F8701196E4C@mit.edu>
 <20110418004040.GS21395@dastard>
 <6C89E159-A5F6-4A06-A3D2-273BE4CFB9B5@dilger.ca>
 <BANLkTin=WEpSf6ddiOMNMOpCPP-wiEttSw@mail.gmail.com>
 <20110419034455.GB23985@dastard>
 <BANLkTinjh968ECqAobQ677hnV5yzke1ncw@mail.gmail.com>
 <20110419074538.GG23985@dastard>
 <20110419140909.GD3030@thunk.org>
 <4DAD987F.5000506@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>, xfs-oss <xfs@oss.sgi.com>,
	"coreutils@gnu.org" <coreutils@gnu.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	=?iso-8859-1?Q?P=E1draig?= Brady <P@draigbrady.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50900 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862Ab1DSQBY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Apr 2011 12:01:24 -0400
Content-Disposition: inline
In-Reply-To: <4DAD987F.5000506@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 19, 2011 at 09:13:19AM -0500, Eric Sandeen wrote:
> 
> But I too am confused about Dave's assertion that it only reflects ondisk state when we have that pesky delalloc flag.
> 
> Whose idea was that, anyway? ;)
> 
> I'd certainly buy the argument that it -should- only reflect ondisk state, and we should nuke the delalloc flag from orbit, if we could, though.

I see three options of how we can clarify FIEMAP's semantics:

1) We define it as only reflecting ondisk state, and nuke the delalloc
flag from orbit.

2) We state that if the file is currently has unflushed pages in the
page cache, and FIEMAP_FLAG_SYNC is not passed, whether or not extents
return the DELALLOC flag or how they handle the UNWRITTEN flag is
undefined.

3) We state that FIEMAP is supposed to return information which
reflects the union of the on-disk and page cache state, with all that
this implies.

All of these are internally consistent definitions --- we need to
chose one, document, and then tell the shellutils folks what they
should do.

In the case of #1 and #2, we really need to implement support for
SEEK_HOLE/SEEK_DATA for userspace programs like cp who want to know
this information.

Do we all agree on the problem statement, at least?  If so, then we
can try to come consensus on what is the appropriate solution. 

    	   		     	     - Ted
