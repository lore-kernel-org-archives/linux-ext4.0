From: Ron Johnson <ron.l.johnson@cox.net>
Subject: Re: ext5
Date: Wed, 10 Feb 2010 23:18:21 -0600
Message-ID: <4B73931D.5000302@cox.net>
References: <20100210215028.GD739@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from eastrmmtao103.cox.net ([68.230.240.9]:55394 "EHLO
	eastrmmtao103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab0BKFSW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Feb 2010 00:18:22 -0500
Received: from eastrmimpo01.cox.net ([68.1.16.119])
          by eastrmmtao103.cox.net
          (InterMail vM.8.00.01.00 201-2244-105-20090324) with ESMTP
          id <20100211051822.OQHR3222.eastrmmtao103.cox.net@eastrmimpo01.cox.net>
          for <linux-ext4@vger.kernel.org>; Thu, 11 Feb 2010 00:18:22 -0500
In-Reply-To: <20100210215028.GD739@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-02-10 15:50, tytso@mit.edu wrote:
> On Wed, Feb 10, 2010 at 12:40:05AM +0100, Anonymous Remailer (austria) wrote:
>> will there be ext5? ext4 works just fine so far. but it could be
>> even more faster. otherwise i have to jump to btrfs (when it's
>> done).
> 
> We currently don't have any plans for an "ext5".  There might be some
> new features that might gradually trickle into ext4; for example
> there's someone who I may be mentoring who is interested in working on
> an idea I've had to add read-only compression to ext4.  (Actually, the
> design I've sketched out makes 90% of the work be file system
> independent, so it's something that could be retrofitted into other
> filesystems: xfs, btrfs, etc.)

I guess that means every file on the fs?

Windows-like per-file compression would be darned useful in certain 
circumstances.  Big mbox files, for example.

-- 
"Hell hath no fury like the vast robot armies of a woman scorned."
Walt
