From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Ext4 slow on links
Date: Wed, 20 Jun 2012 23:18:53 -0600
Message-ID: <F2D9C6D0-92EC-46E1-B040-6E35F077E2E6@dilger.ca>
References: <20120620002014.GA25471@gamma.logic.tuwien.ac.at> <4FE14034.6070800@redhat.com> <20120620002014.GA25471@gamma.logic.tuwien.ac.at> <20120620021912.GA26323@thunk.org> <20120620033831.GA2395@gamma.logic.tuwien.ac.at> <BA050E9A-2385-4FF9-B41A-3A25F3FF066A@redhat.com> <20120620051844.GA7829@gamma.logic.tuwien.ac.at> <4FE1D91B.8020707@redhat.com> <20120621022818.GD9669@gamma.logic.tuwien.ac.at> <4FE29DA7.40405@redhat.com> <20120621045004.GD18182@gamma.logic.tuwien.ac.at>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, Ted Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Norbert Preining <preining@logic.at>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:59067 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab2FUFSz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2012 01:18:55 -0400
In-Reply-To: <20120621045004.GD18182@gamma.logic.tuwien.ac.at>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-06-20, at 10:50 PM, Norbert Preining wrote:
> On Mi, 20 Jun 2012, Eric Sandeen wrote:
>> Hm.  Upstream coreutils fixed this for rm and some other ops:
> 
> Ok, I see.
> 
>> sorted took 2.6s, unsorted took 52s.
> 
> Got the idea, and tried it now myself not with ls etc, but
> with the program that generates the caos, and yes, stracing it
> gives the same result, getdents and the followed stats are all
> *not* in inode order.
> 
> So that means, it should be fixed in glibc? Right? Ouuchhh...
> 
> That means that this behaviour is for *each* program using getdent
> etc ...
> 
> Do you have any suggestions? Is there a way to force readdir (I guess
> most people use readdir instead of getdents directly) to iterate
> in inode order?

That's what the LD_PRELOAD library that Eric referenced does - you can
load it for any application, and it will sort the dirents in inode order.

It would definitely be better to do this in glibc, though we've also
been discussing on occasion doing this inside ext4 for small directories.

Cheers, Andreas





