From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4 unlink performance
Date: Sat, 15 Nov 2008 19:56:10 -0500
Message-ID: <20081116005610.GI22948@mit.edu>
References: <20081113185712.GB11204@untroubled.org> <20081113191000.GA11516@untroubled.org> <20081113204240.GF21652@mit.edu> <20081114041121.GB11746@untroubled.org> <20081114145914.GE25117@mit.edu> <20081115204423.GA4671@untroubled.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="tKW2IUtsqtDRztdT"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:46755 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751346AbYKPA4P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Nov 2008 19:56:15 -0500
Content-Disposition: inline
In-Reply-To: <20081115204423.GA4671@untroubled.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 15, 2008 at 02:44:23PM -0600, Bruce Guenter wrote:
> On Fri, Nov 14, 2008 at 09:59:14AM -0500, Theodore Tso wrote:
> > This is beginning to perhaps sound like a layout problem of some kind.
> 
> To test this theory, I ran one test where I populated the filesystem
> with ext3 and then mounted as ext4 to do the unlinking.  This produced
> unlink times comparable with ext3.  That is, the degredation is occuring
> when the filesystem is populated, not when it is cleaned.

The problem is definitely in how we choose the directory and file
inode numbers for ext4.  A quick look of the free block and free inode
counts from the dumpe2fs of your ext3 and ext4 256-byte inode e2images
tells the tail.  Ext4 is using blocks and inodes packed up against the
beginning of the filesystem, and ext3 has the blocks and inodes spread
out for better locality.

We didn't change the ext4's inode allocation algorithms, so I'm
guessing that it's interacting very poorly with ext4's block delayed
allocation algorithms.  Bruce, how much memory did you have in your
system?  Do you have a large amount of memory, say 6-8 gigs, by any
chance?  When the filesystem creates a new directory, if the block
group is especially full, it will choose a new block group for the
directory, to spread things out.  However, if the blocks haven't been
allocated yet, then the directories won't be spread out appropriately,
and then the inodes will be allocated close to the directories, and
then things go downhill from there.  This is much more likely to
happen if you have a large number of small files, and a large amount
of memory, and when you are unpacking a tar file and so are write out
a large number of these small files spaced very closely in time,
before they have a chance to get forced out to disk and thus allocated
so the filesystem can take block group fullness into account when
deciding how to allocate inode numbers.

When I have a chance I'll write a program which analyzes how close the
blocks are to inodes, and how close inodes are to their containing
directory, but I'm pretty sure what we'll find will just confirm
what's going on in greater detail.

One thing is clear --- we need to rethink our block and inode
allocation algorithms in light of delayed allocation.  Maybe XFS has
some tricks up its sleeve that we can learn from?

     	       	   	       	      	    - Ted


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=ext3-256-inode-usage

  29566 free blocks, 15551 free inodes, 95 directories
  30568 free blocks, 16285 free inodes, 0 directories
  31581 free blocks, 16312 free inodes, 0 directories
  30484 free blocks, 16266 free inodes, 0 directories
  31187 free blocks, 15954 free inodes, 0 directories
  30693 free blocks, 16359 free inodes, 0 directories
  31282 free blocks, 16276 free inodes, 0 directories
  30689 free blocks, 16355 free inodes, 0 directories
  31589 free blocks, 16258 free inodes, 0 directories
  28653 free blocks, 15401 free inodes, 0 directories
  31126 free blocks, 16207 free inodes, 0 directories
  25170 free blocks, 16197 free inodes, 0 directories
  31535 free blocks, 16320 free inodes, 0 directories
  31489 free blocks, 16330 free inodes, 0 directories
  30900 free blocks, 16310 free inodes, 0 directories
  31617 free blocks, 16296 free inodes, 0 directories
  31459 free blocks, 16308 free inodes, 0 directories
  31402 free blocks, 16210 free inodes, 0 directories
  31501 free blocks, 16203 free inodes, 0 directories
  31429 free blocks, 16259 free inodes, 0 directories
  30675 free blocks, 15607 free inodes, 0 directories
  31690 free blocks, 16332 free inodes, 0 directories
  31662 free blocks, 16303 free inodes, 0 directories
  31554 free blocks, 16325 free inodes, 0 directories
  31487 free blocks, 16173 free inodes, 0 directories
  29451 free blocks, 15815 free inodes, 0 directories
  31536 free blocks, 16189 free inodes, 0 directories
  19668 free blocks, 16335 free inodes, 0 directories
  30513 free blocks, 16001 free inodes, 0 directories
  31586 free blocks, 16341 free inodes, 0 directories
  30155 free blocks, 16167 free inodes, 0 directories
  31178 free blocks, 16222 free inodes, 0 directories
  31197 free blocks, 16048 free inodes, 0 directories
  31364 free blocks, 16185 free inodes, 0 directories
  31559 free blocks, 16203 free inodes, 0 directories
  31380 free blocks, 16152 free inodes, 0 directories
  30137 free blocks, 16053 free inodes, 0 directories
  31044 free blocks, 16189 free inodes, 0 directories
  31515 free blocks, 16274 free inodes, 0 directories
  31676 free blocks, 16332 free inodes, 0 directories
  31517 free blocks, 16324 free inodes, 0 directories
  31623 free blocks, 16349 free inodes, 0 directories
  31285 free blocks, 16178 free inodes, 0 directories
  31272 free blocks, 16251 free inodes, 0 directories
  31440 free blocks, 16331 free inodes, 0 directories
  13310 free blocks, 16176 free inodes, 0 directories
  0 free blocks, 16044 free inodes, 0 directories
  30405 free blocks, 16202 free inodes, 0 directories
  31474 free blocks, 16288 free inodes, 0 directories
  30343 free blocks, 16301 free inodes, 0 directories
  31159 free blocks, 16008 free inodes, 0 directories
  31660 free blocks, 16321 free inodes, 0 directories
  17290 free blocks, 16222 free inodes, 0 directories
  23962 free blocks, 16335 free inodes, 0 directories
  31233 free blocks, 16290 free inodes, 0 directories
  30149 free blocks, 16258 free inodes, 0 directories
  30357 free blocks, 16161 free inodes, 0 directories
  30995 free blocks, 15863 free inodes, 0 directories
  23693 free blocks, 16269 free inodes, 0 directories
  27104 free blocks, 15766 free inodes, 0 directories
  31648 free blocks, 16290 free inodes, 0 directories
  31596 free blocks, 16269 free inodes, 0 directories
  31403 free blocks, 16208 free inodes, 0 directories
  31640 free blocks, 16327 free inodes, 0 directories
  31575 free blocks, 16303 free inodes, 0 directories
  31071 free blocks, 16103 free inodes, 0 directories
  13310 free blocks, 16176 free inodes, 0 directories
  31065 free blocks, 16333 free inodes, 0 directories
  31588 free blocks, 16329 free inodes, 0 directories
  13310 free blocks, 0 free inodes, 0 directories
  28372 free blocks, 16023 free inodes, 0 directories
  13310 free blocks, 0 free inodes, 0 directories
  29706 free blocks, 16289 free inodes, 0 directories
  13310 free blocks, 0 free inodes, 0 directories
  29130 free blocks, 16317 free inodes, 0 directories
  13310 free blocks, 0 free inodes, 0 directories
  30203 free blocks, 16301 free inodes, 0 directories
  13310 free blocks, 0 free inodes, 0 directories
  29788 free blocks, 16259 free inodes, 0 directories
  13310 free blocks, 0 free inodes, 0 directories
  25710 free blocks, 15173 free inodes, 0 directories
  12285 free blocks, 0 free inodes, 0 directories
  26642 free blocks, 16275 free inodes, 0 directories
  13310 free blocks, 0 free inodes, 0 directories
  28614 free blocks, 16214 free inodes, 0 directories
  13310 free blocks, 0 free inodes, 0 directories
  29711 free blocks, 16228 free inodes, 0 directories
  13310 free blocks, 0 free inodes, 0 directories
  27163 free blocks, 16240 free inodes, 0 directories
  13310 free blocks, 0 free inodes, 0 directories
  28846 free blocks, 15929 free inodes, 0 directories
  13310 free blocks, 0 free inodes, 0 directories
  26446 free blocks, 16342 free inodes, 0 directories
  13310 free blocks, 0 free inodes, 0 directories
  24677 free blocks, 16304 free inodes, 0 directories
  13310 free blocks, 0 free inodes, 0 directories
  28747 free blocks, 15548 free inodes, 0 directories
  30087 free blocks, 16166 free inodes, 0 directories
  13310 free blocks, 0 free inodes, 0 directories
  11233 free blocks, 0 free inodes, 0 directories
  11154 free blocks, 0 free inodes, 0 directories
  12057 free blocks, 0 free inodes, 0 directories
  9413 free blocks, 0 free inodes, 0 directories
  11859 free blocks, 0 free inodes, 0 directories
  7909 free blocks, 0 free inodes, 0 directories
  11103 free blocks, 0 free inodes, 0 directories
  13169 free blocks, 8284 free inodes, 0 directories
  24380 free blocks, 15681 free inodes, 0 directories
  13310 free blocks, 0 free inodes, 0 directories
  16131 free blocks, 7469 free inodes, 0 directories
  13310 free blocks, 0 free inodes, 0 directories
  0 free blocks, 16384 free inodes, 0 directories
  9358 free blocks, 0 free inodes, 0 directories
  27525 free blocks, 15333 free inodes, 0 directories
  13310 free blocks, 0 free inodes, 0 directories
  11112 free blocks, 0 free inodes, 0 directories
  29474 free blocks, 16254 free inodes, 0 directories
  27974 free blocks, 16149 free inodes, 0 directories
  25894 free blocks, 15618 free inodes, 0 directories
  13310 free blocks, 0 free inodes, 0 directories
  11755 free blocks, 0 free inodes, 0 directories
  30976 free blocks, 16297 free inodes, 0 directories
  13310 free blocks, 0 free inodes, 0 directories
  31148 free blocks, 16349 free inodes, 0 directories
  30863 free blocks, 16191 free inodes, 0 directories
  30674 free blocks, 16368 free inodes, 0 directories
  13310 free blocks, 0 free inodes, 0 directories
  27776 free blocks, 16240 free inodes, 0 directories
  14180 free blocks, 3409 free inodes, 0 directories
  31712 free blocks, 16354 free inodes, 0 directories
  30933 free blocks, 16069 free inodes, 0 directories
  13310 free blocks, 0 free inodes, 0 directories
  28038 free blocks, 15849 free inodes, 0 directories
  13310 free blocks, 0 free inodes, 0 directories
  11535 free blocks, 0 free inodes, 0 directories
  12145 free blocks, 642 free inodes, 0 directories
  26785 free blocks, 16306 free inodes, 0 directories
  13310 free blocks, 146 free inodes, 0 directories
  12397 free blocks, 269 free inodes, 0 directories
  10192 free blocks, 16104 free inodes, 0 directories
  20992 free blocks, 16346 free inodes, 0 directories
  31697 free blocks, 16348 free inodes, 0 directories
  31085 free blocks, 16335 free inodes, 0 directories
  30950 free blocks, 16321 free inodes, 0 directories
  24539 free blocks, 16322 free inodes, 0 directories
  30995 free blocks, 15785 free inodes, 0 directories
  31644 free blocks, 16338 free inodes, 0 directories
  22704 free blocks, 9156 free inodes, 0 directories
  31638 free blocks, 16325 free inodes, 0 directories
  31718 free blocks, 16369 free inodes, 0 directories
  30880 free blocks, 15661 free inodes, 0 directories
  27625 free blocks, 13296 free inodes, 0 directories
  31625 free blocks, 16306 free inodes, 0 directories
  31591 free blocks, 16293 free inodes, 0 directories
  31572 free blocks, 16252 free inodes, 0 directories
  31544 free blocks, 16339 free inodes, 0 directories
  31455 free blocks, 16315 free inodes, 0 directories
  31569 free blocks, 16296 free inodes, 0 directories
  31694 free blocks, 16341 free inodes, 0 directories
  31603 free blocks, 16282 free inodes, 0 directories
  31059 free blocks, 16126 free inodes, 0 directories
  31543 free blocks, 16295 free inodes, 0 directories
  31616 free blocks, 16346 free inodes, 0 directories
  30928 free blocks, 16242 free inodes, 0 directories
  31574 free blocks, 16337 free inodes, 0 directories
  31464 free blocks, 16335 free inodes, 0 directories
  31455 free blocks, 16236 free inodes, 0 directories
  31240 free blocks, 16076 free inodes, 0 directories
  28782 free blocks, 16307 free inodes, 0 directories
  31616 free blocks, 16282 free inodes, 0 directories
  31495 free blocks, 16265 free inodes, 0 directories
  30114 free blocks, 15817 free inodes, 0 directories
  30788 free blocks, 16044 free inodes, 0 directories
  30826 free blocks, 16033 free inodes, 0 directories
  30691 free blocks, 16347 free inodes, 0 directories
  30268 free blocks, 16201 free inodes, 0 directories
  31237 free blocks, 16098 free inodes, 0 directories
  31632 free blocks, 16310 free inodes, 0 directories
  31392 free blocks, 16067 free inodes, 0 directories
  31587 free blocks, 16305 free inodes, 0 directories
  18075 free blocks, 15746 free inodes, 0 directories
  30974 free blocks, 15772 free inodes, 0 directories
  31451 free blocks, 16316 free inodes, 0 directories
  31633 free blocks, 16331 free inodes, 0 directories
  31618 free blocks, 16328 free inodes, 0 directories
  30546 free blocks, 16237 free inodes, 0 directories
  31537 free blocks, 16318 free inodes, 0 directories
  31469 free blocks, 16225 free inodes, 0 directories
  31695 free blocks, 16355 free inodes, 0 directories
  30358 free blocks, 15864 free inodes, 0 directories
  31461 free blocks, 16203 free inodes, 0 directories
  30353 free blocks, 16193 free inodes, 0 directories
  31151 free blocks, 16131 free inodes, 0 directories
  30619 free blocks, 16337 free inodes, 0 directories
  31633 free blocks, 16277 free inodes, 0 directories
  27108 free blocks, 12675 free inodes, 0 directories
  31107 free blocks, 15946 free inodes, 0 directories
  15105 free blocks, 2938 free inodes, 0 directories
  31434 free blocks, 16243 free inodes, 0 directories
  31696 free blocks, 16345 free inodes, 0 directories
  28579 free blocks, 15890 free inodes, 0 directories
  28891 free blocks, 16116 free inodes, 0 directories
  27859 free blocks, 16075 free inodes, 0 directories
  31483 free blocks, 16328 free inodes, 0 directories
  28222 free blocks, 16300 free inodes, 0 directories
  31588 free blocks, 16261 free inodes, 0 directories
  31729 free blocks, 16373 free inodes, 0 directories
  31546 free blocks, 16305 free inodes, 0 directories
  31672 free blocks, 16292 free inodes, 0 directories
  31490 free blocks, 16246 free inodes, 0 directories
  13310 free blocks, 15882 free inodes, 0 directories
  13464 free blocks, 16340 free inodes, 0 directories
  31455 free blocks, 16295 free inodes, 0 directories
  31431 free blocks, 16221 free inodes, 0 directories
  31548 free blocks, 16305 free inodes, 0 directories
  13310 free blocks, 14144 free inodes, 0 directories
  13556 free blocks, 16218 free inodes, 0 directories
  31510 free blocks, 16256 free inodes, 0 directories
  13310 free blocks, 0 free inodes, 400 directories
  0 free blocks, 9462 free inodes, 671 directories
  3870 free blocks, 9683 free inodes, 401 directories
  0 free blocks, 10254 free inodes, 1036 directories
  0 free blocks, 12830 free inodes, 1040 directories
  0 free blocks, 13954 free inodes, 886 directories
  5497 free blocks, 15126 free inodes, 536 directories

--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=ext4-256-inode-usage

  685 free blocks, 0 free inodes, 1199 directories
  4096 free blocks, 0 free inodes, 547 directories
  3823 free blocks, 0 free inodes, 362 directories
  4604 free blocks, 0 free inodes, 268 directories
  2168 free blocks, 0 free inodes, 232 directories
  2163 free blocks, 0 free inodes, 180 directories
  3577 free blocks, 0 free inodes, 141 directories
  3168 free blocks, 0 free inodes, 133 directories
  2144 free blocks, 0 free inodes, 113 directories
  4122 free blocks, 0 free inodes, 109 directories
  3575 free blocks, 0 free inodes, 94 directories
  2177 free blocks, 0 free inodes, 90 directories
  2746 free blocks, 0 free inodes, 99 directories
  2867 free blocks, 0 free inodes, 88 directories
  4774 free blocks, 0 free inodes, 76 directories
  2300 free blocks, 5408 free inodes, 49 directories, 5408 unused inodes
  1196 free blocks, 0 free inodes, 72 directories
  3745 free blocks, 0 free inodes, 63 directories
  2419 free blocks, 0 free inodes, 61 directories
  4606 free blocks, 0 free inodes, 65 directories
  1501 free blocks, 0 free inodes, 56 directories
  1136 free blocks, 0 free inodes, 61 directories
  8875 free blocks, 0 free inodes, 56 directories
  7227 free blocks, 0 free inodes, 61 directories
  6326 free blocks, 0 free inodes, 47 directories
  179 free blocks, 0 free inodes, 39 directories
  1295 free blocks, 0 free inodes, 49 directories
  6778 free blocks, 0 free inodes, 56 directories
  4675 free blocks, 0 free inodes, 31 directories
  2203 free blocks, 0 free inodes, 37 directories
  1653 free blocks, 0 free inodes, 47 directories
  2920 free blocks, 0 free inodes, 45 directories
  1911 free blocks, 0 free inodes, 40 directories
  2969 free blocks, 0 free inodes, 30 directories
  1628 free blocks, 0 free inodes, 41 directories
  5938 free blocks, 0 free inodes, 34 directories
  2766 free blocks, 0 free inodes, 36 directories
  4067 free blocks, 0 free inodes, 34 directories
  3141 free blocks, 0 free inodes, 24 directories
  3582 free blocks, 0 free inodes, 30 directories
  1864 free blocks, 0 free inodes, 35 directories
  4266 free blocks, 0 free inodes, 27 directories
  2911 free blocks, 0 free inodes, 38 directories
  4633 free blocks, 0 free inodes, 36 directories
  2899 free blocks, 0 free inodes, 19 directories
  6290 free blocks, 5438 free inodes, 15 directories, 5438 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  720 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  863 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  1541 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  717 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  5467 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  12388 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  16352 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  0 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  31743 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  16352 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  16352 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  16352 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  16352 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  16352 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  16352 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
  30768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes

--tKW2IUtsqtDRztdT--
