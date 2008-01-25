From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: [RFC] Parallelize IO for e2fsck
Date: Fri, 25 Jan 2008 10:03:34 -0800
Message-ID: <OF1E5FD388.EC04F1B3-ON882573DB.00620670-882573DB.0063346F@us.ibm.com>
References: <20080124234037.GJ15858@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Cc: Bodo Eggert <7eggert@gmx.de>,
	Andreas Dilger <adilger@clusterfs.com>,
	Andreas Dilger <adilger@sun.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Adrian Bunk <bunk@kernel.org>, David Chinner <dgc@sgi.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-linux-kernel@vger.kernel.org, Ric Wheeler <ric@emc.com>,
	Valerie Henson <val@vahconsulting.com>, Valdis.Kletnieks@vt.edu
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20080124234037.GJ15858@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> AIX basically did this with SIGDANGER (the signal is ignored by
> default), except there wasn't the ability for the process to tell the
> kernel at what level of memory pressure before it should start getting
> notified, and there was no way for the kernel to tell how bad the
> memory pressure actually was.  On the other hand, it was a relatively
> simple design.

AIX does provide a system call to find out how much paging backing store 
space is available and the thresholds set by the system administrator. 
Running out of paging space is the only memory pressure AIX is concerned 
about.  While I think having processes make memory usage decisions based 
on that is a shoddy way to manage system resources, that's what it is 
intended for.

Incidentally, some context for the AIX approach to the OOM problem: a 
process may exclude itself from OOM vulnerability altogether.  It places 
itself in "early allocation" mode, which means at the time it creates 
virtual memory, it reserves enough backing store for the worst case.  The 
memory manager does not send such a process the SIGDANGER signal or 
terminate it when it runs out of paging space.  Before c. 2000, this was 
the only mode.  Now the default is late allocation mode, which is similar 
to Linux.

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Filesystems

