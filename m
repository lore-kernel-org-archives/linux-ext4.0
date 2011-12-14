From: Hugh Dickins <hughd@google.com>
Subject: Re: Bug with "fix partial page writes" [3.2-rc regression]
Date: Wed, 14 Dec 2011 10:07:22 -0800 (PST)
Message-ID: <alpine.LSU.2.00.1112140957160.1271@eggly>
References: <20111121165626.GD14568@thunk.org> <alpine.LSU.2.00.1111211331120.1879@sister.anvils> <alpine.LSU.2.00.1112051456580.3938@sister.anvils> <4EDD729E.2060402@linux.vnet.ibm.com> <alpine.LSU.2.00.1112060030220.1615@sister.anvils>
 <4EDE85F4.4020503@linux.vnet.ibm.com> <CAGBYx2YmYRw_p5KHJCYaQNsCpe5OVV7X2TpaK=OE7znCiE7oZA@mail.gmail.com> <4EDF9CAB.3050502@linux.vnet.ibm.com> <4EE046C7.9030902@linux.vnet.ibm.com> <alpine.LSU.2.00.1112080909300.22300@sister.anvils>
 <20111214041251.GG6276@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Curt Wohlgemuth <curtw@google.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Rafael Wysocki <rjw@sisk.pl>,
	Andy Whitcroft <apw@canonical.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60558 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498Ab1LNSHm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Dec 2011 13:07:42 -0500
Received: by wgbdr13 with SMTP id dr13so2217245wgb.1
        for <linux-ext4@vger.kernel.org>; Wed, 14 Dec 2011 10:07:41 -0800 (PST)
In-Reply-To: <20111214041251.GG6276@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 13 Dec 2011, Ted Ts'o wrote:
> Hey Hugh,
> 
> If you could do me a favor and run your "kernel compile torture test"
> on the tree found on the "dev" branch of the git tree at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
> 
> ... I'd really appreciate it.  This should have all of the patches
> needed to address the problems you had been having, and it would be
> great to get some additional testing before I push it to Linus.
> 
> I'm currently running a full xfstests run on this tree as we speak....

Builds from that tree have now been running it without incident for
9 hours overnight on five machines.  Before setting that off, I gave
them each an hour of fsx under memory pressure, some ext2, some ext4:
again, nothing to report.  Plus I have confidence in Yongqiang's four
patches from running the test with them on rc4 for 3 days on two
machines.  Looks good to me - thanks to you all!

Hugh
