From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Tue, 19 Apr 2011 09:13:19 -0500
Message-ID: <4DAD987F.5000506@sandeen.net>
References: <76FFF648-CA02-494B-A862-566C66A8CB82@dilger.ca> <20110416005040.GP21395@dastard> <E7438588-5C5A-42B9-9B6C-FADF7CAC6D3A@dilger.ca> <4EEEA16E-1FDB-4430-A372-8F8701196E4C@mit.edu> <20110418004040.GS21395@dastard> <6C89E159-A5F6-4A06-A3D2-273BE4CFB9B5@dilger.ca> <BANLkTin=WEpSf6ddiOMNMOpCPP-wiEttSw@mail.gmail.com> <20110419034455.GB23985@dastard> <BANLkTinjh968ECqAobQ677hnV5yzke1ncw@mail.gmail.com> <20110419074538.GG23985@dastard> <20110419140909.GD3030@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>, xfs-oss <xfs@oss.sgi.com>,
	"coreutils@gnu.org" <coreutils@gnu.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	=?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigbrady.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42624 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab1DSONG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Apr 2011 10:13:06 -0400
In-Reply-To: <20110419140909.GD3030@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/19/11 9:09 AM, Ted Ts'o wrote:
> On Tue, Apr 19, 2011 at 05:45:38PM +1000, Dave Chinner wrote:
>> You are *not listening*. There is no #2. FIEMAP returns the extent
>> state _on disk_ at the time of the call.
> 
> Dave, you're being rather strident about your insistence about what
> FIEMAP's semantics are.  Part of the problem here is that it's *not*
> clear or settled.
> 
> If it really is the state _on_ _disk_, does XFS really have a DELALLOC
> bit _on_ _disk_?
> 
> 					- Ted
> 

no of course it doesn't....

But I too am confused about Dave's assertion that it only reflects ondisk state when we have that pesky delalloc flag.

Whose idea was that, anyway? ;)

I'd certainly buy the argument that it -should- only reflect ondisk state, and we should nuke the delalloc flag from orbit, if we could, though.

-Eric
