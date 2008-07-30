From: Asheesh Laroia <kernel.bugzilla@asheesh.org>
Subject: Re: [Bug 11175] New: ext3 BUG in add_dirent_to_buf+0x6c/0x269
Date: Tue, 29 Jul 2008 18:08:31 -0700 (PDT)
Message-ID: <alpine.DEB.1.10.0807291748070.20406@alchemy.localdomain>
References: <bug-11175-27@http.bugzilla.kernel.org/> <20080729171207.d88728cf.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wide-rose.makesad.us ([203.178.130.147]:40686 "EHLO
	rose.makesad.us" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753717AbYG3BhX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jul 2008 21:37:23 -0400
In-Reply-To: <20080729171207.d88728cf.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 29 Jul 2008, Andrew Morton wrote:

> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).

Great, will do.  I've rpepared an e2image -s now that follows this chain 
of events:

* ext3 BUG()
* reboot
* filesystem is mounted once
* e2image snapshots taken: both with and without -s

I have not run fsck between the BUG() and the snapshots I took, so it will 
hopefully still be useful.  I will publish the one with "-s"; I will stash 
away the one without "-s" in case it is helpful.

I then ran fsck on the filesystem so I could proceed with using the disk.

The full image is uploading now; I'll let you all know when it's done in 
2-3 days (it's ca. 1.5 gibibytes).

-- Asheesh.

-- 
A Fortran compiler is the hobgoblin of little minis.
