From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: resize2fs problem with stride calc
Date: Sun, 21 Sep 2014 11:13:06 -0500
Message-ID: <541EF912.7000801@redhat.com>
References: <BAY179-W85AF983234DB78F07A12EFDB50@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: TR Reardon <thomas_reardon@hotmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbaIUQNJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Sep 2014 12:13:09 -0400
In-Reply-To: <BAY179-W85AF983234DB78F07A12EFDB50@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/20/14 3:46 PM, TR Reardon wrote:
> resize2fs seems to come up with some crazy default stride numbers.
> This occurs with and without bigalloc.
> 
> 
> I was testing enabling/disabling 64bit using latest patches from DJW,
> and noticed that s_raid_stride was being written with nonsensical
> values, in particular determine_fs_stride() is coming up with overly
> large values.  The code is old (2006) and lacks comment so I'm not
> sure what the intended operation is.  Does this just need to be
> updated for flex_bg?  Should s_raid_stride ever be auto-changed on
> resize?  If it should change, should stripe also change?

That old commit says:

+               In addition, add code so that resize2fs can automatically
+               determine the RAID stride parameter that had been
+               previously used on the filesystem.

but a year later, in 2007, this:

commit 96c6a3acd377698cb99ffd9925bec9b20ca4f6f9
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri May 18 22:06:53 2007 -0400

    Store the RAID stride value in the superblock and take advantage of it

stored it properly in the superblock (this hit e2fsprogs-1.40).

So maybe the whole heuristic could just be removed now, but from a simple
test, it's working here.

What was the geometry (dumpe2fs -h) of your filesystem before the resize?

-Eric
