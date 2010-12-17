From: Stephan Boettcher <boettcher@physik.uni-kiel.de>
Subject: Re: [PATCH] resize2fs: handle exactly-16T filesystems in resize2fs
Date: Fri, 17 Dec 2010 09:06:21 +0100
Message-ID: <s6nei9gygaq.fsf@falbala.ieap.uni-kiel.de>
References: <4D09978E.5050302@redhat.com>
	<alpine.LFD.2.00.1012160957320.2781@dhcp-lab-213.englab.brq.redhat.com>
	<20101217001557.GE4455@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from l3ms.rz.uni-kiel.de ([134.245.11.96]:35746 "EHLO
	l3ms.rz.uni-kiel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab0LQIGZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Dec 2010 03:06:25 -0500
Received: from localhost ([127.0.0.1])
	by l3ms.rz.uni-kiel.de with esmtp (Exim 4.72)
	(envelope-from <boettcher@physik.uni-kiel.de>)
	id 1PTVKc-0005K9-JD
	for linux-ext4@vger.kernel.org; Fri, 17 Dec 2010 09:06:26 +0100
In-Reply-To: <20101217001557.GE4455@thunk.org> (Ted Ts'o's message of "Thu, 16
	Dec 2010 19:15:57 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Ted Ts'o" <tytso@mit.edu> writes:

> The 1.42 version is on the main "master" and "next" branch, where
> "next" is where I'll check in things initially, and then "master"
> catches up with "next".  I took this from git, with the basic idea
> being that if there are people who are testing next, and people who
> are using the "master", hopefully problems get noticed and fixed
> before people are using "master" grab a commit.  To be honest there
> probably aren't enough people tracking next and master for this to
> make a huge amount of difference, but I'm following this scheme
> anyway.

So, I am doing the right thing, when I use the master branch for my 20TB
filesystem? Or shall I try next, at least until I decide to actually use
the filesystem for something real?

-- 
Stephan

