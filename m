From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC][Patch 2/2] Persistent preallocation in ext4
Date: Fri, 22 Dec 2006 20:46:15 +0530
Message-ID: <20061222151615.GA5851@amitarora.in.ibm.com>
References: <20061205134338.GA1894@amitarora.in.ibm.com> <20061215123920.GB24572@amitarora.in.ibm.com> <20061219114251.GA25086@amitarora.in.ibm.com> <20061219211409.GP5937@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	suzuki@in.ibm.com, alex@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46101 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945900AbWLVPRx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Dec 2006 10:17:53 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kBMFHq0B021979
	for <linux-ext4@vger.kernel.org>; Fri, 22 Dec 2006 10:17:52 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kBMFGaZp091698
	for <linux-ext4@vger.kernel.org>; Fri, 22 Dec 2006 10:16:36 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kBMFGU4P007314
	for <linux-ext4@vger.kernel.org>; Fri, 22 Dec 2006 10:16:35 -0500
To: Andreas Dilger <adilger@clusterfs.com>
Content-Disposition: inline
In-Reply-To: <20061219211409.GP5937@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 19, 2006 at 02:14:09PM -0700, Andreas Dilger wrote:
> On Dec 19, 2006  17:12 +0530, Amit K. Arora wrote:
> > I wrote a simple tool to test these patches. The tool takes four
> > arguments:
> >
> > * command: It may have either of the two values - "prealloc" or "write"
> > * filename: This is the filename with relative path
> > * offset: The offset within the file from where the preallocation, or
> > 		the write should start.
> > * length: Total number of bytes to be allocated/written from offset.
> >
> > Following cases were tested :
> > 1. * preallocation from 0 to 32MB
> >    * write to various parts of the preallocated space in sets
> >    * observed that the extents get split and also get merged
> >
> > 2. * preallocate with holes at various places in the file
> >    * write to blocks starting from a hole and ending into preallocated
> >       blocks and vice-versa
> >    * try to write to entire set of blocks (i.e. from 0 to the last
> >       preallocated block) which has holes in between.

Hi Andreas,

> An ideal test would be to modify fsx to (randomly) do preallocations
> instead of truncates that increase the size.
Thanks for the suggestion. The modified fsx (used "fsx-linux" in LTP as
the base) did uncover couple of bugs. One has a straight forward fix of
using ext4_ext_get_actual_len() in ext4_ext_put_gap_in_cache(). Without
this change, it is resulting in a panic when a ftruncate() of size zero
is done on an extent enabled file with preallocated blocks.

The other problem is slightly more complicated and occurs in some
specific conditions (filesize >= 512KB and number of operations >=
100000). When it happens, it results in duplicate entries for a few
logical block numbers in the tree. It looks as if some kind of "leak" is
happening while splitting/merging extents. Following is a typical
example (this is an output from debugfs in e2fsprogs-1.39 utils, which
has the patch supporting preallocation applied to it):

debugfs 1.39 (29-May-2006)
debugfs:  stat testfile
header: magic=f30a entries=1 max=4 depth=1 generation=0
index: block=0 leaf=1201 leaf_hi=0 unused=0
header: magic=f30a entries=16 max=84 depth=0 generation=0
extent[u]: block=0-25 len=26 start=645 start_hi=0
extent[i]: block=26-67 len=42 start=671 start_hi=0
extent[u]: block=68-502 len=435 start=713 start_hi=0
extent[i]: block=76-107 len=32 start=589 start_hi=0
extent[i]: block=116-131 len=16 start=629 start_hi=0
extent[i]: block=132-134 len=3 start=1257 start_hi=0
extent[i]: block=135-177 len=43 start=2154 start_hi=0
extent[i]: block=178-194 len=17 start=4206 start_hi=0
extent[i]: block=195-247 len=53 start=1148 start_hi=0
extent[i]: block=248-248 len=1 start=1202 start_hi=0
extent[i]: block=249-249 len=1 start=1249 start_hi=0
extent[i]: block=250-289 len=40 start=1203 start_hi=0
extent[i]: block=290-361 len=72 start=3161 start_hi=0
extent[i]: block=362-366 len=5 start=5222 start_hi=0
extent[i]: block=367-397 len=31 start=3238 start_hi=0
extent[i]: block=398-511 len=114 start=1351 start_hi=0
Inode: 11   Type: regular    Mode:  0644   Flags: 0x80000   Generation:
3161384699
User:     0   Group:     0   Size: 524288
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 1864
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x458bc897 -- Fri Dec 22 06:59:19 2006
atime: 0x458bc897 -- Fri Dec 22 06:59:19 2006
mtime: 0x458bc897 -- Fri Dec 22 06:59:19 2006
BLOCKS:
(IND):1201, (0-502):645-1147, (76-107):589-620, (116-131):629-644,
(132-134):1257-1259, (135-177):2154-2196, (178-194):4206-4222,
(195-247):1148-1200, (248):1202, (249):1249, (250-289):1203-1242,
(290-361):3161-3232, (362-366):5222-5226, (367-397):3238-3268,
(398-511):1351-1464
TOTAL: 932


Above we can see that block numbers from 68 to 502 are each covered by
more than one extent (besides couple of holes, which also might be part
of the same problem).

Note: A "u" in extent[u] donates that this extent is
uninitialized, and thus was created as part of preallocation and noone
has written to it. An "i" signifies that the extent is initialized.

I am trying to solve this issue currently. Any suggestions are more than
welcome.. :)

Regards,
Amit Arora

> 
> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
