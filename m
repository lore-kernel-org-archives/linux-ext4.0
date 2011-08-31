From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Subject: Re: Bug#615998: linux-image-2.6.32-5-xen-amd64: Repeatable "kernel
 BUG at fs/jbd2/commit.c:534" from Postfix on ext4
Date: Tue, 30 Aug 2011 19:26:22 -0500
Message-ID: <F33B5C17-2893-44D4-BBE4-C75CDC1375EA@boeing.com>
References: <20110405230538.GH2832@thunk.org>
 <FD93E462-D97B-411B-BF09-9A64670AC5C2@boeing.com>
 <AF621113-8320-4973-A88A-1FC048EA4293@boeing.com>
 <BANLkTi=5BLA07tvbv3PFcZ0cc8FmBtg+UA@mail.gmail.com>
 <404FD5CC-8F27-4336-B7D4-10675C53A588@boeing.com>
 <20110624134659.GB26380@quack.suse.cz>
 <2F80BF45-28FA-46D3-9A28-CA9416DC5813@boeing.com>
 <20110624200231.GA32176@quack.suse.cz>
 <5DE8D448-A77D-46E8-BF40-15AA7F7CDBE9@boeing.com>
 <79E8C04C-B5A8-49E5-901F-444C8B8A53DB@boeing.com>
 <20110830221249.GH16202@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Sean Ryle <seanbo@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
	"615998@bugs.debian.org" <615998@bugs.debian.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Sachin Sant <sachinp@in.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from stl-smtpout-01.boeing.com ([130.76.96.56]:54477 "EHLO
	stl-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375Ab1HaA6G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Aug 2011 20:58:06 -0400
In-Reply-To: <20110830221249.GH16202@quack.suse.cz>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 30, 2011, at 18:12, Jan Kara wrote:
> On Fri 26-08-11 16:03:32, Moffett, Kyle D wrote:
>> Ping?
>> 
>> Any more ideas for debugging this issue?
> 
> Sorry for not getting to you earlier.

That's ok, I have a workaround so it's been on my back burner for a while.

>> I can still trigger it on my VM snapshot very easily, so if you have anything
>> you think I should test I would be very happy to give it a shot.
> 
>  OK, so in the meantime I found a bug in data=journal code which could be
> related to your problem. It is fixed by commit
> 2d859db3e4a82a365572592d57624a5f996ed0ec which is in 3.1-rc1. Have you
> tried that or newer kernel as well?
> 
> If the problem still is not fixed, I can provide some debugging patch to
> you. We spoke with Josef Bacik how errors like yours could happen so I have
> some places to watch...

I have not tried anything more recent; I'm actually a bit reluctant to move
away from the Debian squeeze official kernels since I do need the security
updates.

I took a quick look and I can't find that function in 2.6.32, so I assume it
would be a rather nontrivial back-port.  It looks like the relevant code
used to be in ext4_clear_inode somewhere?

Out of curiosity, what would happen in data=journal mode if you unlinked a
file which still had buffers pending?  That case does not seem to be handled
by that commit you mentioned, was it already handled elsewhere?

Thanks again!

Cheers,
Kyle Moffett
