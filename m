From: Ted Ts'o <tytso@mit.edu>
Subject: Bug#615998: linux-image-2.6.32-5-xen-amd64: Repeatable "kernel BUG at fs/jbd2/commit.c:534" from Postfix on ext4
Date: Tue, 28 Jun 2011 10:16:50 -0400
Message-ID: <20110628141650.GH2729@thunk.org>
References: <404FD5CC-8F27-4336-B7D4-10675C53A588@boeing.com>
 <20110624134659.GB26380@quack.suse.cz>
 <2F80BF45-28FA-46D3-9A28-CA9416DC5813@boeing.com>
 <20110624200231.GA32176@quack.suse.cz>
 <alpine.LFD.2.00.1106271312310.3845@dhcp-27-109.brq.redhat.com>
 <20110627140251.GI5597@quack.suse.cz>
 <alpine.LFD.2.00.1106271714350.3845@dhcp-27-109.brq.redhat.com>
 <20110627160140.GC2729@thunk.org>
 <2D8D1A30-C092-4163-B47A-BCEDACE536A3@boeing.com>
 <20110628093652.GA29978@quack.suse.cz>
Reply-To: Ted Ts'o <tytso@mit.edu>, 615998@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>,
	Lukas Czerner <lczerner@redhat.com>, Sean Ryle <seanbo@gmail.com>,
	"615998@bugs.debian.org" <615998@bugs.debian.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Sachin Sant <sachinp@in.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Jan Kara <jack@suse.cz>
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-Message-ID: <handler.615998.B615998.130927062328320@bugs.debian.org>
Content-Disposition: inline
In-Reply-To: <20110628093652.GA29978@quack.suse.cz>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
List-Id: linux-ext4.vger.kernel.org

> > My basic impression is that the use of "data=journalled" can help
> > reduce the risk (slightly) of serious corruption to some kinds of
> > databases when the application does not provide appropriate syncs
> > or journalling on its own (IE: such as text-based Wiki database files).

Yes, although if the application has index files that have to be
updated at the same time, there is no guarantee that the changes that
survive after a system failure (either a crash or a power fail),
unless the application is doing proper application-level journalling
or some other structured.

> To sum up, the only additional guarantee data=journal offers against
> data=ordered is a total ordering of all IO operations. That is, if you do a
> sequence of data and metadata operations, then you are guaranteed that
> after a crash you will see the filesystem in a state corresponding exactly
> to your sequence terminated at some (arbitrary) point. Data writes are
> disassembled into page-sized & page-aligned sequence of writes for purpose
> of this model...

data=journal can also make the fsync() operation faster, since it will
involver fewer seeks (although it will require a greater write
bandwidth).  Depending on the write bandwidth, you really need to
benchmark things to be sure, though.

						- Ted
