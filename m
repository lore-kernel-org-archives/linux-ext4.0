From: Daniel Phillips <phillips@phunq.net>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Wed, 21 May 2008 15:30:14 -0700
Message-ID: <200805211530.14831.phillips@phunq.net>
References: <482DDA56.6000301@redhat.com> <20080518211140.b29bee30.akpm@linux-foundation.org> <200805191316.27551.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <200805191316.27551.chris.mason@oracle.com>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Monday 19 May 2008 10:16, Chris Mason wrote:
> root@opti:~# fsck -f /dev/sda2
> fsck 1.40.8 (13-Mar-2008)
> e2fsck 1.40.8 (13-Mar-2008)
> /dev/sda2: recovering journal
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Problem in HTREE directory inode 281377 (/barrier-test): bad block number 
> 13543.
> Clear HTree index<y>?    

Nice, htree as a canary for disk corruption.  This makes sense since
directory data is the only verifiable structure at the logical data
level and htree offers the only large scale, verifiable structure.

Thanks for the lovely test methodology example.  Let me additionally
offer this tool:

   http://code.google.com/p/zumastor/source/browse/trunk/ddsnap/tests/devspam.c?r=1564
   devspam

The idea is to write an efficiently verifiable pattern across a range
of a file, including a mix of position-dependent codes and a user
supplied code.  In read mode, devspam will check that the position
dependent codes are correct and match the user supplied code.  This
can be easily extended to a "check that all the user supplied codes
are the same" mode, which would help detect consistency failure in
regular data files much as htree does with directories.  Hmm, this
probably wants to incorporate a sequence number as well, to detect
corruption under a random block update load as you have triggered
with htree.

I used this tool to exorcise the majority of bugs in ddsnap.  It is
a wonderful canary, not only catching bugs early but showing where
where they occurred.

>From what I have seen, Sun seems to rely mostly on MD5 checksums for
detecting corruption in ZFS.  We should do more of that too.

Regards,

Daniel
