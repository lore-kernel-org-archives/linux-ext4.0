From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13930] non-contiguous files (64.9%) on a ext4 fs
Date: Fri, 7 Aug 2009 22:20:53 GMT
Message-ID: <200908072220.n77MKrYv025705@demeter.kernel.org>
References: <bug-13930-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33945 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbZHGWUy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Aug 2009 18:20:54 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n77MKrA4025706
	for <linux-ext4@vger.kernel.org>; Fri, 7 Aug 2009 22:20:53 GMT
In-Reply-To: <bug-13930-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13930


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #2 from Theodore Tso <tytso@mit.edu>  2009-08-07 22:20:51 ---
I'm pretty sure what's going on here is the problem I've reported before where
if you have a large number of large files being written at the same time, the
Linux page cleaner round-robins between the different dirty inodes to avoid
starving some inode from ever getting its dirty pages written out.  This then
combines with ext4's multi-block allocator limiting its search for 8MB of free
extent chunks, so we only expand a dirty page writeback request into 2048
blocks.   See the discussion here:

    http://thread.gmane.org/gmane.comp.file-systems.ext4/13107

The reason why you're seeing this so much is that this filesystem has
relatively few inodes (just under 16,000) and a very large average inode size
(about 54 megabytes), and so a very large number of the files are
"non-contiguous".    But, if you look at this statistic from e2fsck:

         Histogramme des profondeurs d'extents : 14555/1388

14,555, or 91% of the files, have fewer than 4 extents, so that all of the
extents fit in the inode.  (Note that an extent addresses at most 128 meg, so
by definition a 512meg file will have at least 4 extents.)   That means it's
highly likely that if you look at a particularly large file using "filefrag
-v", you will see something like this:

 ext logical physical expected length flags
   0       0  2165248             512 
   1     512  2214400  2165759   1536 
   2    2048  2244608  2215935   2048 
   3    4096  2250752  2246655   2048 
   4    6144  2254848  2252799  32768 
   5   38912  2287616            8192 
   6   47104  2299904  2295807   2048 
   7   49152  2306048  2301951   2048 eof

Note that extent #5 is really located contiguously after extent #4; the reason
why a new extent was created is because the maximum length that can be encoded
in the on-disk extent data structure is 32,768 blocks.  (Which if you are using
4k blocks, means a maximum extent size of 128 megs.)

So this kind of "non-contiguous" file is non-optimal, and we really should fix
the block allocator to better.  On the other hand, it's not as disastrously
fragmented as say, the following file from an ext3 filesystem:

 ext logical physical length
   0       0  5228587    12 
   1      12  5228600   110 
   2     122  5228768   145
   3     267  5228915     1
   4     268  5228918     9
   5     277  5228936    69
   6     346  5229392   165
   7     511  5230282   124
   8     635  5230496    42
   9     677  5231614    10
  10     687  5231856    20
  11     707  5231877    46
  12     753  5231975     1
  13     754  5232033    14
  14     768  5232205     2
  15     770  5233913     4
  16     774  5233992   262
  17    1036  5234256   191

Part of the problem is that "non-contiguous" or "fragmented" doesn't really
describe whether the file is like the first ext4 file (which is indeed
non-contiguous, and while it could be better allocated on disk, the time to
read the file sequentially won't be _that_ much worse than a file that 100%
contiguous), than say, a file like this second ext3 file, where the performance
degradation are much worse.

I suppose we could do something where we define "fragmented" as a file where
has no extents which are smaller than N blocks, or where the average extent
size is greater than M blocks.   My original way of dealing with this number
was to simply use the phrase "non-contiguous" instead of "fragmented", which is
technically accurate, but it causes people to get overly concerned when they
see something like "64.9% non-contiguous files".   Unfortunately, at moment
what this means is something like "approximately 65% of your files are greater
than 8 megabytes".

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
