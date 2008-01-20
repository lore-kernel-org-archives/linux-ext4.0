From: Daniel Phillips <phillips@phunq.net>
Subject: Re: [CALL FOR TESTING] Make Ext3 fsck way faster [2.6.24-rc6 -mm patch]
Date: Sat, 19 Jan 2008 20:10:20 -0800
Message-ID: <200801192010.20699.phillips@phunq.net>
References: <200801140839.01986.abhishekrai@google.com> <20080115152801.GA7292@mit.edu> <d9885f0f0801170447r1c2bfeb9l6c911bfa0113366f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Theodore Tso" <tytso@mit.edu>,
	"Christoph Hellwig" <hch@infradead.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, rohitseth@google.com,
	linux-ext4@vger.kernel.org
To: "Abhishek Rai" <abhishekrai@google.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756880AbYATEKq@vger.kernel.org>
In-Reply-To: <d9885f0f0801170447r1c2bfeb9l6c911bfa0113366f@mail.gmail.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thursday 17 January 2008 04:47, Abhishek Rai wrote:
> > if Abhishek wants to pursue it, would be to pull in all of the
> > indirect blocks when the file is opened, and create an in-memory
> > extent tree that would speed up access to the file.  It's rarely
> > worth doing this without metaclustering, since it doesn't help for
> > sequential I/O, only random I/O, but with metaclustering it would
> > also be a win for sequential I/O.  (This would also remove the
> > minor performance degradation for sequential I/O imposed by
> > metaclustering, and in fact improve it slightly for really big
> > files.)
>
> Also, since the in memory extent tree will now occupy much less
> space, we can keep them cached for a much longer time which will
> improve performance of random reads. The new metaclustering patch is
> more amenable to this trick since it reduces fragmentation thereby
> reducing the number of extents.

I can see value in preemptively loading indirect blocks into the buffer 
cache, but is building a second-order extent tree really worth the 
effort?  Probing the buffer cache is very fast.

Regards,

Daniel
