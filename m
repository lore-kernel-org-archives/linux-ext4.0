From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Mentor for a GSoC application wanted (Online ext2/3 filesystem checker)
Date: Mon, 21 Apr 2008 12:58:50 -0600
Message-ID: <20080421185849.GD20637@parisc-linux.org>
References: <f19298770804190244y5d6a8502p39f98d1c420135a@mail.gmail.com> <20080419185603.GA30449@mit.edu> <480A42F6.2030005@redhat.com> <20080419220432.GB30449@mit.edu> <87iqyc85q7.fsf@basil.nowhere.org> <20080420234241.GB23292@shareable.org> <20080421080111.GD14446@one.firstfloor.org> <480CD9CD.70607@emc.com> <480CDBFD.30009@redhat.com> <480CE09D.4020402@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, Theodore Tso <tytso@mit.edu>,
	Alexey Zaytsev <alexey.zaytsev@gmail.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Rik van Riel <riel@surriel.com>
To: Ric Wheeler <ric@emc.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:43589 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbYDUS7H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Apr 2008 14:59:07 -0400
Content-Disposition: inline
In-Reply-To: <480CE09D.4020402@emc.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 21, 2008 at 02:44:45PM -0400, Ric Wheeler wrote:
> Turning the drive write cache off is the default case for most RAID 
> products (including our mid and high end arrays).
> 
> I have not seen an issue with drives wearing out with either setting (cache 
> disabled or enabled with barriers).
> 
> The theory does make some sense, but does not map into my experience ;-)

To be fair though, the gigabytes of NVRAM on the array perform the job
that the drive's cache would do on a lower-end system.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
