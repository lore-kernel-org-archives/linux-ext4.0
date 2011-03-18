From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: mkdir performance.
Date: Fri, 18 Mar 2011 11:49:11 -0500
Message-ID: <4D838D07.2070607@redhat.com>
References: <20110318085742.GA20480@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757036Ab1CRQtQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Mar 2011 12:49:16 -0400
In-Reply-To: <20110318085742.GA20480@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/18/11 3:57 AM, Rogier Wolff wrote:
> 
> Hi Guys, 
> 
> I'm seeing more and more mkdir performance problems.
> 
> On the big partition where I most often NEED the performance an
> strace -tttT mkdir asdlkfj results in: 
> 
> 1300437461.968657 mkdir("asdklfj", 0777) = 0 <0.065133>
> 
> On my homedir (older machine) the same mkdir is a lot faster:
> 
> 1300437428.294018 mkdir("asdklfj", 0777) = 0 <0.003813>
> 
> Only 3 milliseconds. Ten times faster! That would be great!

Did you have a chance to play with that patch I flung onto
the list?  :)

-Eric

> On my local workstation I get: 
> 
> 1300437803.200227 mkdir("askldjf", 0777) = 0 <0.000092>
> 
> 92 microseconds. even 30 times faster than that!
> 
> That 65 milliseconds. For just one it's not that bad. Not even
> noticable. In my current (data-recovery) project I have (/ my client
> has) about 30000 directories. This means that to do the recovery I
> wait an additional 32 minutes just for all the mkdirs.
> 
> But I'm not waiting just once for "all the mkdirs". During the course
> of a datarecovery I reconstruct the tree many times over, making
> backups of the current state over and over again. In this project I've
> been waiting that half hour over ten times, so it's cost me over 5
> hours in productivity.
> 
> IIRC, a fix was available, right?
> 
> To "fix" this, all I need to do is to switch to the most recent
> kernel, right? Or was the fix not yet integrated with Linus?
> 
> 	Roger. 
> 

