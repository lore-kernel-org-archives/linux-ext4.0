From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: xfstests generic/130 hang with non-4k block size ext4 on 4.7-rc1
 kernel
Date: Thu, 2 Jun 2016 00:58:00 +0800
Message-ID: <20160601165800.GI10350@eguan.usersys.redhat.com>
References: <20160531140922.GM5140@eguan.usersys.redhat.com>
 <20160531154017.GC5357@thunk.org>
 <20160601063822.GH10350@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eryu Guan <eguan@redhat.com>, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:33303 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbcFAQ6M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Jun 2016 12:58:12 -0400
Received: by mail-pf0-f174.google.com with SMTP id b124so18564916pfb.0
        for <linux-ext4@vger.kernel.org>; Wed, 01 Jun 2016 09:58:12 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160601063822.GH10350@eguan.usersys.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 01, 2016 at 02:38:22PM +0800, Eryu Guan wrote:
> On Tue, May 31, 2016 at 11:40:17AM -0400, Theodore Ts'o wrote:
> > On Tue, May 31, 2016 at 10:09:22PM +0800, Eryu Guan wrote:
> > > 
> > > I noticed that generic/130 hangs starting from 4.7-rc1 kernel, on non-4k
> > > block size ext4 (x86_64 host). And I bisected to commit 06bd3c36a733
> > > ("ext4: fix data exposure after a crash").
> > > 
> > > It's the sub-test "Small Vector Sync" in generic/130 hangs the kernel,
> > > and I can reproduce it on different hosts, both bare metal and kvm
> > > guest.
> > 
> > Hmm, it's not reproducing for me, either using your simplified repro
> > or generic/130.  Is there something specific with your kernel config,
> > which is needed for the reproduction, perhaps?
> 
> That's weird, it's easily reproduced for me on different hosts/guests.
> The kernel config I'm using is based on the config from RHEL7.2 kernel,
> leaving all new config options to their default choices. i.e
> 
> cp /boot/<config-rhel7.2> ./.config && yes "" | make oldconfig && make
> 
> I attached my kernel config file.
> 
> And my test vm has 8G memory & 4 vcpus, with RHEL7.2 installed running
> upstream kernel, host is RHEL6.7. xfsprogs version 3.2.2 (shipped with
> RHEL7.2) and version 4.5.0 (compiled from upstream) made no difference.
> 
> I think I can try configs from other venders such as SuSE, Ubuntu. If
> you can share your config file I'll test it as well.

I've tried kernel config from Ubuntu 16.04, and I can reproduce the hang
as well. If I add "-o data=journal" or "-o data=writeback" mount option,
I don't see the hang. So seems it only happens in data=ordered mode,
which matches the code change in commit 06bd3c36a733, I think.

I had some troubles booting the kernel compiled with your config file,
I'll dig into it more tomorrow.

Thanks,
Eryu
