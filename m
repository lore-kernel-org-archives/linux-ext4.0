From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Performance of ext4
Date: Fri, 20 Jun 2008 08:32:52 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0806200812340.3383@diagnostix.dwd.de>
References: <20080612131928.GB18229@mit.edu> <Pine.LNX.4.64.0806121333480.27806@diagnostix.dwd.de>
 <20080612180605.GD22481@skywalker> <Pine.LNX.4.64.0806121940020.2974@diagnostix.dwd.de>
 <Pine.LNX.4.64.0806130753100.7097@diagnostix.dwd.de>
 <20080616175408.GF3279@atrey.karlin.mff.cuni.cz> <20080616181353.GA20686@skywalker>
 <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de> <20080619155645.GA8582@mit.edu>
 <485A8C2D.1090806@redhat.com> <20080619174211.GB9119@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Eric Sandeen <sandeen@redhat.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Jan Kara <jack@suse.cz>, Solofo.Ramangalahy@bull.net,
	Nick Dokos <nicholas.dokos@hp.com>, linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753306AbYFTIdL@vger.kernel.org>
In-Reply-To: <20080619174211.GB9119@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 19 Jun 2008, Theodore Tso wrote:

> On Thu, Jun 19, 2008 at 11:41:17AM -0500, Eric Sandeen wrote:
>>
>> It might be worth runninga "simple" fsx under your kernel too; last time
>> I tested fsx it was still happy and it exercises fs ops (including
>> truncate) at random...
>>
>
> From what Holger described, it's doubtful that the bug is in the
> truncate operation.
>
Correct, the benchmark just copies, moves, hardlinks and deletes a lot
of small files. It also overwrites existing files but not at the same
scale it does the other operations.

> It sounds like i_size is actually dropping in
> size at some pointer long after the file was written.  If I had to
> guess the value in the inode cache is correct; and perhaps so is the
> value on the journal.  But somehow, the wrong value is getting written
> to disk (remember the jbd layer can keep up to three different
> versions of filesystem metadata in memory, because most of the time we
> don't block modifications to the filesystem while we are in the middle
> of writing a previous commit to disk).  So depending on whether the
> inode gets redirtied or not, the inconsistency could self-heal, and if
> the inode never gets pushed out of memory due to memory pressure, the
> problem might not be noticed until the system reboots or the
> filesystem is unmounted.
>
I always had the feeling that waiting a day or unmounting caused a lot
more truncation. On my system at home for example I mounted the test
filesystem again and saw that files where truncated and I am pretty sure
that when I looked at those files during and shortly after the test they
where still complete. But I will recheck and do test as you suggested.

What I find strange is that the missing parts of the file are not for
example exactly 512 or 1024 or 4096 bytes it is mostly some odd number
of bytes.

Holger
