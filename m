From: Theodore Tso <tytso@mit.edu>
Subject: Re: Bug in delayed allocation: really bad block layouts!
Date: Sun, 10 Aug 2008 21:46:47 -0400
Message-ID: <20080811014646.GE15353@mit.edu>
References: <E1KSEkA-00009o-CV@closure.thunk.org> <489F2B38.3060104@redhat.com> <20080810182231.GB15353@mit.edu> <489F397A.1040709@redhat.com> <489F49B0.6020105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:48913 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753788AbYHKCtH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Aug 2008 22:49:07 -0400
Content-Disposition: inline
In-Reply-To: <489F49B0.6020105@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

1;1613;0cOn Sun, Aug 10, 2008 at 03:04:00PM -0500, Eric Sandeen wrote:
> 
> # find . -name \*.h | xargs filefrag | grep -v extents | awk -F :
> '{print $2}' | sort | uniq -c
>    2460  1 extent found
> 
> so *really* everything.
> 

Um, no, because you filtered out "extents", and filefrag will print "2
extents found", so that it gets the singular/plural correct.  One of
the things I've been meaning to do is to clean up the output of
filefrag so that it's a bit easier to parse.  It's really stupid for
it to print "file is in extents format" over and over again...

I've done some research on my laptop's filesystem, and I've found
examples of files with the characteristic horrendous layout going back
as far back to at least July 7th.  (See below)

This takes us back to about the time when we were stablizing the
patches that went into 2.6.26, and before the most recent set of
patches to fix the journal credits and delayed allocation patches.

Interestingly, I'm not seeing the bad layouts for files created June
30th, which is when I switched my laptop's root filesystem to ext4.
So that gives us a pretty good time bound on the patches that might be
involved.  (This is a great demonstration of what it's a real win to
manage the ext4 patch queue using git, since we can see which patches
were added during that week or so.)

In other news, I've added an enhancement to e2fsck which makes it much
easier to spot these sorts of problems.  On the latest e2fsprogs git
branch, you'll be able to do "e2fsck -E fragcheck /dev/thunk/root" and
get a report which makes it really ease to see the problem.

						- Ted

debugfs:  stat <4545760>
Inode: 4545760   Type: regular    Mode:  0755   Flags: 0x80000
Generation: 278636620    Version: 0x00000000:00000001
User:     0   Group:     0   Size: 6669
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 16
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x487282ce:50c55b54 -- Mon Jul  7 16:55:42 2008
 atime: 0x487282cd:00000000 -- Mon Jul  7 16:55:41 2008
 mtime: 0x485d754f:00000000 -- Sat Jun 21 17:40:31 2008
crtime: 0x487282ce:50c55b54 -- Mon Jul  7 16:55:42 2008
Size of extra inode fields: 28
BLOCKS:
(0):19472457, (1):19816447
TOTAL: 2

debugfs:  stat <4545768>
Inode: 4545768   Type: regular    Mode:  0755   Flags: 0x80000
Generation: 278636628    Version: 0x00000000:00000001
User:     0   Group:     0   Size: 7655
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 16
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x487282ce:5a3cff0c -- Mon Jul  7 16:55:42 2008
 atime: 0x487282cd:00000000 -- Mon Jul  7 16:55:41 2008
 mtime: 0x485d754f:00000000 -- Sat Jun 21 17:40:31 2008
crtime: 0x487282ce:5a3cff0c -- Mon Jul  7 16:55:42 2008
Size of extra inode fields: 28
BLOCKS:
(0):19472458, (1):20849215
TOTAL: 2

debugfs:  stat <4545769>
Inode: 4545769   Type: regular    Mode:  0755   Flags: 0x80000
Generation: 278636629    Version: 0x00000000:00000001
User:     0   Group:     0   Size: 17452
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 40
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x487282ce:5a3cff0c -- Mon Jul  7 16:55:42 2008
 atime: 0x487282cd:00000000 -- Mon Jul  7 16:55:41 2008
 mtime: 0x485d754f:00000000 -- Sat Jun 21 17:40:31 2008
crtime: 0x487282ce:5a3cff0c -- Mon Jul  7 16:55:42 2008
Size of extra inode fields: 28
BLOCKS:
(0):19472459, (1-4):20849216-20849219
TOTAL: 5

debugfs:  ncheck 4545760 4545768 4545769
Inode	  Pathname
4545760	  /usr/projects/sid-root/usr/bin/piconv
4545768	  /usr/projects/sid-root/usr/bin/shasum
4545769	  /usr/projects/sid-root/usr/bin/splain


----------------------Example of files created June 30th


debugfs:  stat <18246>
Inode: 18246   Type: regular    Mode:  0755   Flags: 0x80000
Generation: 1457985356    Version: 0x00000000:00000001
User:     0   Group:     0   Size: 24448
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 48
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x4868cc68:d7f10208 -- Mon Jun 30 08:07:04 2008
 atime: 0x4868cbfa:8ac0ef60 -- Mon Jun 30 08:05:14 2008
 mtime: 0x47f5cddd:00000000 -- Fri Apr  4 02:42:37 2008
crtime: 0x4868cc68:d724eee4 -- Mon Jun 30 08:07:04 2008
Size of extra inode fields: 28
BLOCKS:
(0-5):351687-351692
TOTAL: 6

debugfs:  stat <18247>
Inode: 18247   Type: regular    Mode:  0755   Flags: 0x80000
Generation: 1457985357    Version: 0x00000000:00000001
User:     0   Group:     0   Size: 1297
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 8
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x4868cc68:d7f10208 -- Mon Jun 30 08:07:04 2008
 atime: 0x4868cbfa:8ac0ef60 -- Mon Jun 30 08:05:14 2008
 mtime: 0x47e38ec1:00000000 -- Fri Mar 21 06:32:33 2008
crtime: 0x4868cc68:d7f10208 -- Mon Jun 30 08:07:04 2008
Size of extra inode fields: 28
BLOCKS:
(0):351693
TOTAL: 1

debugfs:  stat <18248>
Inode: 18248   Type: regular    Mode:  0755   Flags: 0x80000
Generation: 1457985358    Version: 0x00000000:00000001
User:     0   Group:     0   Size: 28492
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 56
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x4868cc68:d7f10208 -- Mon Jun 30 08:07:04 2008
 atime: 0x4868cbfa:8ac0ef60 -- Mon Jun 30 08:05:14 2008
 mtime: 0x47398252:00000000 -- Tue Nov 13 05:54:10 2007
crtime: 0x4868cc68:d7f10208 -- Mon Jun 30 08:07:04 2008
Size of extra inode fields: 28
BLOCKS:
(0-6):351694-351700
TOTAL: 7

debugfs:  ncheck 18246 18247 18248
Inode	  Pathname
18246	  /bin/uname
18247	  /bin/bzmore
18248	  /bin/mt-gnu
