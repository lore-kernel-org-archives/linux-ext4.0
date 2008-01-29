From: david@lang.hm
Subject: Re: [RFC] Parallelize IO for e2fsck
Date: Tue, 29 Jan 2008 00:29:28 -0800 (PST)
Message-ID: <alpine.DEB.1.00.0801290028460.16707@asgard.lang.hm>
References: <70b6f0bf0801161322k2740a8dch6a0d6e6e112cd2d0@mail.gmail.com> <70b6f0bf0801161330y46ec555m5d4994a1eea7d045@mail.gmail.com> <20080121230041.GL3180@webber.adilger.int> <20080122033830.GR155259@sgi.com> <3673.1200975438@turing-police.cc.vt.edu>
 <20080122070050.GM3180@webber.adilger.int> <20080122144052.GC17804@mit.edu> <20080128193005.GC4032@ucw.cz> <20080128195633.GB20528@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Pavel Machek <pavel@ucw.cz>, Valdis.Kletnieks@vt.edu,
	David Chinner <dgc@sgi.com>,
	Valerie Henson <val@vahconsulting.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger@clusterfs.com>,
	Ric Wheeler <ric@emc.com>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:51819
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYA2HSM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jan 2008 02:18:12 -0500
In-Reply-To: <20080128195633.GB20528@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 28 Jan 2008, Theodore Tso wrote:

> On Mon, Jan 28, 2008 at 07:30:05PM +0000, Pavel Machek wrote:
>>
>> As user pages are always in highmem, this should be easy to decide:
>> only send SIGDANGER when highmem is full. (Yes, there are
>> inodes/dentries/file descriptors in lowmem, but I doubt apps will
>> respond to SIGDANGER by closing files).
>
> Good point; for a system with at least (say) 2GB of memory, that
> definitely makes sense.  For a system with less than 768 megs of
> memory (how quaint, but it wasn't that long ago this was a lot of
> memory :-), there wouldn't *be* any memory in highmem at all....

not to mention machines with 1G of ram (900M lowmem, 128M highmem)

David Lang
