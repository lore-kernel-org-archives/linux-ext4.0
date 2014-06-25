From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [RFC][PATCH 0/1] ext4: Fix ext4_mb_normalize_request
Date: Wed, 25 Jun 2014 15:43:43 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1406251501020.2171@localhost.localdomain>
References: <1402667736-7843-1-git-send-email-lczerner@redhat.com> <alpine.LFD.2.00.1406241435320.4772@localhost.localdomain> <A4318EB6-BE6B-4D69-877C-5CC7F3518C66@dilger.ca>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1959177122-1403703826=:2171"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Alex Zhuravlev <alexey.zhuravlev@intel.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206AbaFYNns (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Jun 2014 09:43:48 -0400
In-Reply-To: <A4318EB6-BE6B-4D69-877C-5CC7F3518C66@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1959177122-1403703826=:2171
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: 8BIT

On Tue, 24 Jun 2014, Andreas Dilger wrote:

> Date: Tue, 24 Jun 2014 10:25:56 -0600
> From: Andreas Dilger <adilger@dilger.ca>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
>     Alex Zhuravlev <alexey.zhuravlev@intel.com>
> Subject: Re: [RFC][PATCH 0/1] ext4: Fix ext4_mb_normalize_request
> 
> On Jun 24, 2014, at 6:36 AM, Lukáš Czerner <lczerner@redhat.com> wrote:
> > On Fri, 13 Jun 2014, Lukas Czerner wrote:
> > 
> >> Date: Fri, 13 Jun 2014 15:55:35 +0200
> >> From: Lukas Czerner <lczerner@redhat.com>
> >> To: linux-ext4@vger.kernel.org
> >> Subject: [RFC][PATCH 0/1] ext4: Fix ext4_mb_normalize_request
> >> 
> >> This is my first attempt to fix the ext4_mb_normalize_request()
> >> function in in ext4 which deals with file preallocations.
> >> 
> >> This is not yet a final version as it needs more testing, however
> >> I'd like to see some suggestions.
> > 
> > Does anyone have any comments on this and the related patch ?
> 
> Comments inline.
> 
> >> Currently there are couple of problems with ext4_mb_normalize_request().
> >> 
> >> - We're trying to normalize unwritten extents allocation which is
> >>  entirely unnecessary, because user exactly knows what how much space
> >>  he is going to need - no need for file system to do preallocations.
> >> 
> >> - ext4_mb_normalize_request() unnecessarily divides bigger allocation
> >>  requests to small ones (8MB). I believe that this is a bug rather
> >>  than design.
> 
> The reason that the large requests were broken into smaller ones is
> because it becomes increasingly difficult to find large contiguous
> extents as the filesystem becomes more full.  If there was a single
> buddy bitmap for the whole filesystem then it would be possible to
> scan for e.g. 64MB extents of free blocks, but with the current code
> this may require loading up a new block bitmap for each allocation.
> 
> It may be that with the optimizations that have been landed since the
> mballoc code was originally written (to cache the largest free extent
> in memory for each group) that this group descriptor walk may be fast
> enough to handle large allocations.  In that case, the limit on the
> number of groups to scan for an allocation may need to be increased.

I think that it definitelly got better, moreover with features like
flex_bg we pack it more closely together making it easier for
readahead to be actually usefull.

This was mostly a experiment on how can we change it and what the
results will be. However I am a bit puzzled about your answer. While
I do understand that making the allocation unnecessarily large is
harder for the allocator, there is no question about that. We might
want to add automatic tweak to make it smaller as the file system
fills up, or as the free space becomes more fragmented. However this
applies to the rounding up the allocation request for speculative
preallocation.

What I described was not the case, it was always capped at 8MB and I
do not think it was a design decision


But I do not think this was a design decision but rather a bug. See
the code...

	} else if (NRL_CHECK_SIZE(ac->ac_o_ex.fe_len,
					(8<<20)>>bsbits, max, 8 * 1024)) {
		start_off = ((loff_t)ac->ac_o_ex.fe_logical >>
							(23 - bsbits)) << 23;
		size = 8 * 1024 * 1024;
	} else {
		start_off = (loff_t)ac->ac_o_ex.fe_logical << bsbits;
		size	  = ac->ac_o_ex.fe_len << bsbits;
	}

the last "else" is there exactly for the big allocation, however as
it stands the last else condition will never be false when we get to
it simply because:

max = 2 << bsbits;

#define NRL_CHECK_SIZE(req, size, max, chunk_size)	\
		(req <= (size) || max <= (chunk_size))

which means that (max <= 8 * 1024) will always be true not matter
what is the block size (well, for the maximum of 4k block size).

Or do you think that having several smaller allocations is faster
than one bigger allocation ? I do not think so, if nothing the file
might get more fragmented as shown by the tests.


> 
> >> - For smaller allocations (or smaller files) we do not even respect the
> >>  fe_logical. Although we do respect it for bigger files.
> 
> This is done so it is possible to pack many small allocations into a
> single large RAID stripe to avoid read-modify-write overhead.

I do not think that ext4_mb_normalize_request() is supposed to care
about raid. Also ac_g_ex.fe_logical does not seem to play any role
in raid alignment, or am I mistaken ?

In the case of small file it will be set to 0.

> 
> >> - Overall the logic within ext4_mb_normalize_request() is weird and
> >>  no-one really understand why it is the way it is.
> >> 
> >> Fix all of this by:
> >> 
> >> - Disabling preallocation for unwritten extent allocation. However
> >>  because the maximum size of the unwritten extent is one block smaller
> >>  than written, in order to avoid unnecessary fragmentation we limit the
> >>  request to EXT_INIT_MAX_LEN / 2
> 
> That should work out well.  Once the extents are converted to initialized
> extents they can be merged, and this will also leave some room to split
> uninitialized extents if they are not completely overwritten.
> 
> >> - Get rid of the "if table" in ext4_mb_normalize_request() and replace
> >>  it with simply aligning the assumed end of the file up to power of
> >>  two. But we still limit the allocation size to EXT4_BLOCKS_PER_GROUP.
> >>  Also do this on file system block units to take into account different
> >>  block sized file systems.
> 
> We have a patch to make this table tunable, but in the end we never used
> anything other than the default power-of-two values, so I don't think it
> is a loss to remove this code.  That said, it would actually be better to
> align with the s_stripe_width instead of the next power-of-two value.

Good point, we can align it to s_stripe_width after rouding up to
nearest power of two, though for smaller allocation this might not
be so helpful.

> 
> It is important to note that having more extents is not a significant
> performance impact if they are at least 4-8MB in size, but if the allocator
> causes read-modify-write on a RAID array can cut performance in half.

I agree, however ext4_mb_normalize_request() is mostly about
preallocation, it does not do any allocation decisions based on the
raid. However I agree that we can align the size to s_stripe_width.

> 
> >> It passes xfstests cleanly in default configuration, I've not tried any
> >> non-default options yet.
> >> 
> >> I've tried to test how much it changes allocation. The test and some results
> >> can be found at
> >> 
> >> http://people.redhat.com/lczerner/mballoc/
> >> 
> >> normalize.sh is the simple script I run and output.normalize_orig[34]
> >> contains result from the vanila  3.15.0 while output.normalize_patch[56]
> >> contains results with this patch.
> >> 
> >> From the performance stand point I do not see any major differences except
> >> that untar seems to always generate better results (which might be because
> >> of bigger continuous extents).
> 
> Actually, looking at the results, while the extent allocations look more
> "regular" with the patched code, the actual performance is significantly
> worse for some tests, both in terms of speed and in terms of free space
> fragmentation:

The test is far from being perfect and most of the times varies
widely, but it does not look like it's worse with the patch:


		Orig3		Patch5		Orig4		Patch6
-------------------------------------------------------------------------
Fallocate	0m0.276s	0m0.324s	0m0.258s	0m0.197s
Copy		4m58.145s	5m37.090s	4m43.531s	4m5.406s
Tar		6m10.526s	6m5.518s	5m42.999s	5m32.376s
Untar		7m23.806s	7m6.787s	7m27.812s	7m11.225s
Single_dd	0m15.979s	0m16.504s	0m18.130s	0m16.358s
Multiple_dd	3m13.562s	3m15.353s	3m11.031s	3m14.018s
Fsstress	0m6.401s	0m7.994s	0m6.555s	0m6.375s
-------------------------- TEST ON IMAGE FILE ---------------------------
Fallocate	0m0.216s	0m0.290s	0m0.272s	0m0.206s
Copy		4m17.888s	5m24.326s	4m14.834s	4m19.867s
Tar		4m31.356s	4m39.639s	4m33.940s	4m37.231s
Untar		3m34.945s	3m43.807s	4m4.969s	3m28.390s
Single_dd	0m14.875s	0m16.735s	0m19.060s	0m16.500s
Multiple_dd	3m14.358s	3m24.676s	3m21.938s	3m41.215s
Fsstress	0m11.472s	0m9.079s	0m9.705s	0m11.167s

Nice table, I should have done that before ;) So you can see that it
really differs too much. But there are some patterns to be seen.

Here patched ext4 was faster although the difference is too small to
be taken seriously. I need to do more runs and proper statistics.
Tar		6m10.526s	6m5.518s	5m42.999s	5m32.376s

Here patched ext4 is slower, but the difference is again
insignificant.
Multiple_dd	3m13.562s	3m15.353s	3m11.031s	3m14.018s

So I'd say as fat as running times are concerned the appear to be
the no significant difference, but more testing and better
statistics should be done.

You're right that Avg. free extent seems to be slightly smaller,
however looking at the free extents histogram I think that Weighted
Average would show results more favourable for the patches ext4. The
reason is that currently we're packing allocations closely together
which will give us a bit more bigger free extents, however we also
have much more smaller ones. Whole with my patch there seems to be
less really small extents and more medium sized extents (4M-128M).

But that needs to be confirmed.


> 
> orig3:					patch5:
> [+] Fallocate test			[+] Fallocate test
> 
> real	0m0.216s			real	0m0.290s
> user	0m0.000s			user	0m0.001s
> sys	0m0.061s			sys	0m0.037s
> Device: /dev/loop0			Device: /dev/loop0
> Blocksize: 4096 bytes			Blocksize: 4096 bytes
> Total blocks: 22282240			Total blocks: 22282240
> Free blocks: 3535514 (15.9%)		Free blocks: 3535512 (15.9%)
> 
> Min. free extent: 32 KB 		Min. free extent: 32 KB 
> Max. free extent: 2064256 KB		Max. free extent: 2064256 KB
> Avg. free extent: 235700 KB		Avg. free extent: 228096 KB
> 
> orig3:					patch5:
> [+] Copy linux source			[+] Copy linux source
> 
> real	4m17.888s			real	5m24.326s
> user	0m2.265s			user	0m2.486s
> sys	2m4.205s			sys	2m34.918s
> Device: /dev/loop0			Device: /dev/loop0
> Blocksize: 4096 bytes			Blocksize: 4096 bytes
> Total blocks: 22282240			Total blocks: 22282240
> Free blocks: 17536027 (78.7%)		Free blocks: 17536042 (78.7%)
> 
> Min. free extent: 4 KB 			Min. free extent: 4 KB 
> Max. free extent: 2064256 KB		Max. free extent: 2064256 KB
> Avg. free extent: 267724 KB		Avg. free extent: 209384 KB
> 
> orig3:					patch5:
> [+] Untar linux source			[+] Untar linux source
> 
> real	3m34.945s			real	3m43.807s
> user	0m3.459s			user	0m3.687s
> sys	1m35.126s			sys	1m42.839s
> Device: /dev/loop0			Device: /dev/loop0
> Blocksize: 4096 bytes			Blocksize: 4096 bytes
> Total blocks: 22282240			Total blocks: 22282240
> Free blocks: 8852805 (39.7%)		Free blocks: 8852831 (39.7%)
> 
> Min. free extent: 4 KB 			Min. free extent: 4 KB 
> Max. free extent: 2064256 KB		Max. free extent: 2064256 KB
> Avg. free extent: 102936 KB		Avg. free extent: 72120 KB
> 
> The same is true for the "single dd" and "multiple dd" tests.  The only one
> that shows somewhat better performance and fragmentation results is fsstress,
> but I wouldn't exactly call that representative of normal user workloads.
> 
> 
> >> Free space fragmentation seems to be about the same, however with the patch
> >> there seems to be less smaller free space extents and more bigger ones which
> >> is expected due to bigger preallocations (and I think it's a good thing).
> 
> Hmm, this is exactly the opposite of what I see in the output files?

Seem my explanation above, I need to do a better job at presenting
the numbers in more understandable way.

> 
> >> The biggest difference which is obvious from the results is that extent tree
> >> is much smaller (sometimes five times smaller) with the patch. Except of the
> >> fallocate case because we now limit the requests to (EXT_INIT_MAX_LEN / 2)
> >> so we can not merge them - it might be worth experimenting with something
> >> smaller which is a factor of unwritten extent size.
> >> 
> >> But as I said the extent tree is much smaller which means that the extents
> >> overall are bigger which again is a good thing. This becomes very obvious
> >> when we look at the extent tree of the image file (the last steps in the
> >> test).
> >> 
> >> What do you think ?
> 
> I definitely agree that there is work to be done to improve this code, but
> since the results are quite mixed I think it makes sense to separate out
> some of the changes into different patches and test them independently.  That
> will simplify the isolation of which changes are affecting the performance.

I agree, more experimentation is needed.

Thanks for taking your time to look at this!
-Lukas

> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 
> 
--8323328-1959177122-1403703826=:2171--
