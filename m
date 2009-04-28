From: "Michael B. Trausch" <mbt@zest.trausch.us>
Subject: ext4 undeletion question
Date: Tue, 28 Apr 2009 10:42:39 -0400 (EDT)
Message-ID: <alpine.DEB.2.00.0904281037240.5262@zest.trausch.us>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: mike-mobile@trausch.us
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-15-213-186-BusName-Atlanta.hfc.comcastbusiness.net ([173.15.213.186]:51170
	"EHLO zest.trausch.us" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1761425AbZD1Oue (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Apr 2009 10:50:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(First things first, please keep my cell phone -- mike-mobile@trausch.us 
-- on the cc list, as I cannot easily read mail on my system since it is, 
more or less, crippled at the moment.)

Alright, so I have found myself in a troublesome situation.  I had a 
directory which I accidentally deleted (instead of an identically-named 
directory in *another* directory) and I need to get it back; it was a 
version control repository directory and contains ~150 revisions of a 
project I have been working on this week.  (Ironically, I was preparing to 
back it up today, heh.)

Anyway, is there _any_ means by which to recover files from an ext4 
filesystem?  The utils for ext2 filesystems don't work (not surprising), 
and I am wondering if there is a way to look for deleted files, knowing 
what their name was, and recover them if they are not yet overwritten.  I 
have my home directory mounted read-only at this point so as to minimize 
the chance of the latter, and discovered my mistake nearly immediately so 
I hope that the data are still intact.

Any help would be greatly appreciated!

   --- Mike
