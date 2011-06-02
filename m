From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v2] xfstests: add support for ext4dev FSTYP
Date: Thu, 2 Jun 2011 16:44:07 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106021639230.3931@dhcp-27-109.brq.redhat.com>
References: <1306933012-8666-1-git-send-email-amir73il@users.sourceforge.net> <20110601232804.GL32466@dastard> <BANLkTi=sV5=PyZvNSd=DGNW-V84=27d7Yw@mail.gmail.com> <BANLkTimbPWfOJKq6er4mnSYNPcx6VHLcrw@mail.gmail.com> <20110602030802.GR561@dastard>
 <BANLkTi=sPM_AYB4w=N5pWHfws9R3WnfJVw@mail.gmail.com> <20110602064040.GS561@dastard> <BANLkTinJcvvv2pfXBt7EZ9TXONb9jRe0uQ@mail.gmail.com> <alpine.LFD.2.00.1106021352330.3931@dhcp-27-109.brq.redhat.com> <BANLkTinBL5GbhUg5NLCqmLEfz0nNFrjf-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>,
	Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
	sandeen@redhat.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sergey57@gmail.com,
	Theodore Tso <tytso@mit.edu>
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <BANLkTinBL5GbhUg5NLCqmLEfz0nNFrjf-w@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2 Jun 2011, Amir G. wrote:

--snip--
> 
> Ted actually brought this up in our ext4 developers meeting on LSF.
> He said we could register an ext4 module with the ext4dev external symbols
> and it would be useful for testing, since we already have all those tools that
> are aware of ext4dev.

I know, but my point is still valid. why to introduce non-existing FSTYP
into other tools, this is not proper course of action. If the goal is
really resurrect ext4dev we should do this first.

> 
> I  am still using a more low-tech method of cloning ext4 (sed) to build
> a standalone ext4dev module for testing, but it's the same principle.
> 
> >>
> >>
--snip--
> >>
> >> So, yes, it's true. There are other ways to accomplish what I am doing,
> >> but I am going out of my way to try to make the life of developers and testers
> >> easier and you are doing the exact opposite by raising objections to a rather
> >> trivial and harmless patch.
> >
> > What is easier for testers and developers ? I fail to see the reason for
> > including non-existing FSTYP into xfstests while it should be forgotten
> > by now. Just provide sources with whatever fs name you choose (or just
> > patches for ext4 preferably), provide patches to e2fsprogs and patches to
> > xfstests if you want people to test with it. And it should be easy for every
> > tester, or developer to use it, shouldn't it ? Is that a problem ?
> 
> Yes, it is a problem. You are thinking in terms of a developer who builds
> new kernels on a daily basis.
> Back in the time, when I developed next3, I asked some friend and
> people in the community
> if they could test it.
> It turned out that they don't even know how to build a kernel and they
> don't want
> to invest the time in doing that.
> This is when I realized that to get to a wider audience of testers, I
> need to make the testing
> process E A S Y !
> 
> And by E A S Y, I mean:
> 1. Take a Fedora 15 system
> 2. download http://next3.sourceforge.net/files/1.0.13/ext4dev_snapshots-1.0.13-x86_64.tar.gz
> 3. tar xfz ext4dev_snapshots-1.0.13-x86_64.tar.gz && cd ext4dev_snapshots-1.0.13
> 4. make && sudo make install && sudo make test

So you're saying that you can not patch xfstests (and other) sources in the
make time ??

Thanks!
-Lukas
