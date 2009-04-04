From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Sat, 4 Apr 2009 12:00:56 -0600
Message-ID: <9b1675090904041100s4620e604nfa8281e9ab869841@mail.gmail.com>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu>
	 <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain>
	 <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain>
	 <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain>
	 <20090404135719.GA9812@mit.edu> <20090404151649.GE5178@kernel.dk>
	 <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain>
	 <20090404173412.GF5178@kernel.dk>
	 <alpine.LFD.2.00.0904041039230.3915@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jens Axboe <jens.axboe@oracle.com>, Theodore Tso <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:32417 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbZDDSA6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 4 Apr 2009 14:00:58 -0400
In-Reply-To: <alpine.LFD.2.00.0904041039230.3915@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Guys,

Sorry for this "quick" interruption.  Jens doesn't like the sqllite
problem.  Ted and Linus don't like the latency problem.  Why not make
that SYNC_ALL option a 1/0 option in /proc/sys/vm/sync_all or
something of the like?  That sort of change is pretty small, and quick
to make, right?  This would help, at least until the real problem is
found.

Sorry if I'm stepping out of bounds. :P
