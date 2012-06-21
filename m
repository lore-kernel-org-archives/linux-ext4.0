From: Norbert Preining <preining@logic.at>
Subject: Re: Ext4 slow on links
Date: Thu, 21 Jun 2012 13:50:04 +0900
Message-ID: <20120621045004.GD18182@gamma.logic.tuwien.ac.at>
References: <20120620002014.GA25471@gamma.logic.tuwien.ac.at> <4FE14034.6070800@redhat.com> <20120620002014.GA25471@gamma.logic.tuwien.ac.at> <20120620021912.GA26323@thunk.org> <20120620033831.GA2395@gamma.logic.tuwien.ac.at> <BA050E9A-2385-4FF9-B41A-3A25F3FF066A@redhat.com> <20120620051844.GA7829@gamma.logic.tuwien.ac.at> <4FE1D91B.8020707@redhat.com> <20120621022818.GD9669@gamma.logic.tuwien.ac.at> <4FE29DA7.40405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:56366 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab2FUEuJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2012 00:50:09 -0400
Content-Disposition: inline
In-Reply-To: <4FE29DA7.40405@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric,

wow, thanks again.

On Mi, 20 Jun 2012, Eric Sandeen wrote:
> Hm.  Upstream coreutils fixed this for rm and some other ops:

Ok, I see.

> sorted took 2.6s, unsorted took 52s.

Got the idea, and tried it now myself not with ls etc, but
with the program that generates the caos, and yes, stracing it
gives the same result, getdents and the followed stats are all
*not* in inode order.

So that means, it should be fixed in glibc? Right? Ouuchhh...

That means that this behaviour is for *each* program using getdent
etc ...

Do you have any suggestions? Is there a way to force readdir (I guess
most people use readdir instead of getdents directly) to iterate
in inode order?



Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
PABBY (n.,vb.)
(Fencing term.) The play, or manoeuvre, where one swordsman leaps on
to the table and pulls the battleaxe off the wall.
			--- Douglas Adams, The Meaning of Liff
