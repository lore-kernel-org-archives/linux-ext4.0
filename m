From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 1/2] ext4: Calculate and verify inode checksums
Date: Fri, 8 Apr 2011 12:30:31 -0700
Message-ID: <20110408193031.GF24354@tux1.beaverton.ibm.com>
References: <20110406224410.GB24354@tux1.beaverton.ibm.com> <20110406224547.GT32706@tux1.beaverton.ibm.com> <4D9D0ADB.9010005@oracle.com> <20110407164006.GC24354@tux1.beaverton.ibm.com> <4D9DF01C.6050506@oracle.com> <20110408185013.GB17677@noexit>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Sunil Mushran <sunil.mushran@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-ker
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110408185013.GB17677@noexit>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Apr 08, 2011 at 11:50:13AM -0700, Joel Becker wrote:
> On Thu, Apr 07, 2011 at 10:10:52AM -0700, Sunil Mushran wrote:
> > On 04/07/2011 09:40 AM, Darrick J. Wong wrote:
> > >That said, I haven't really quantified the performance impact of this naive
> > >approach yet, so I wonder -- did you see a similar scenario with ocfs2, and
> > >what kind of performance increase did you get by adapting the code to use the
> > >jbd2 trigger?  If there's potentially a large increase, it would be interesting
> > >to apply the same conversion to the group descriptor checksumming code too.
> > 
> > Joel Becker may remember the overhead. He wrote the patch. That said we have few
> > differences. ocfs2 has larger (blocksized) inodes. Also, it computes ECC. The code
> > is in fs/ocfs2/blockcheck.c.

Heh, yes, ext4 uses a fairly simple crc16 and the inodes are (most likely) not
block sized.

> 	ocfs2 does the journal access/journal dirty cycle a lot more
> than extN.  I think you'd want to generate your own numbers.

Ok, I ran both the mailserver ffsb profile and a quick-and-dumb test that tried
to dirty inodes as fast as it could.  On both a regular disk, an SSD, and a
loopmounted ext4 on a tmpfs I couldn't really see much of a performance
difference at all.  I'll see about giving this a try once I get the field
location and e2fsck behavior more firmly resolved, though I suspect I won't see
much gain.

--D
