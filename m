From: Ron Johnson <ron.l.johnson@cox.net>
Subject: Re: ext5
Date: Thu, 11 Feb 2010 10:49:33 -0600
Message-ID: <4B74351D.5010308@cox.net>
References: <20100211064433.GF739@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from eastrmpop107.cox.net ([68.230.240.49]:35750 "EHLO
	eastrmpop107.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab0BKQ5k (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Feb 2010 11:57:40 -0500
Received: from eastrmimpo03.cox.net ([68.1.16.126])
          by eastrmmtao105.cox.net
          (InterMail vM.8.00.01.00 201-2244-105-20090324) with ESMTP
          id <20100211164935.OJEI29464.eastrmmtao105.cox.net@eastrmimpo03.cox.net>
          for <linux-ext4@vger.kernel.org>; Thu, 11 Feb 2010 11:49:35 -0500
In-Reply-To: <20100211064433.GF739@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-02-11 00:44, tytso@mit.edu wrote:
> On Wed, Feb 10, 2010 at 11:18:21PM -0600, Ron Johnson wrote:
>>> We currently don't have any plans for an "ext5".  There might be some
>>> new features that might gradually trickle into ext4; for example
>>> there's someone who I may be mentoring who is interested in working on
>>> an idea I've had to add read-only compression to ext4.  (Actually, the
>>> design I've sketched out makes 90% of the work be file system
>>> independent, so it's something that could be retrofitted into other
>>> filesystems: xfs, btrfs, etc.)
>> I guess that means every file on the fs?
> 
> No, I mean per-file compression, but a compressed file is immutable.
> This is basically what Mac OS X has recently added, and while I
> haven't looked at their implementation, Apple being one of those
> closed source companies and all, I wouldn't be surprised if they did
> things the same way.
> 
>> Windows-like per-file compression would be darned useful in certain
>> circumstances.  Big mbox files, for example.
> 
> The problem with mbox files is that some mail readers try to smart
> about how they modify them to avoid needing to rewrite the whole mbox
> file; mutt will seak to the middle of the file, write to the end of
> the file, and then trim off any excess space by using the truncate
> system call.  This is *hard* to support if the mbox file is
> compressed; you can do it using a stacker-style compression technique,
> but it's not as efficient, and it has a lot of complexity in the
> kernel.

I guess that's how Windows does it?

> The idea with read-only compressed files is that they are useful for
> large executables or large static files, where compressing them means
> that it takes less time to read them off of an HDD.

Sure.  Anything is better than nothing!

-- 
"Hell hath no fury like the vast robot armies of a woman scorned."
Walt
