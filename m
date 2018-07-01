From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/1] iomap: Direct I/O for inline data
Date: Sun, 1 Jul 2018 08:13:06 +0200
Message-ID: <20180701061306.GA27195@lst.de>
References: <20180627003906.15571-1-agruenba@redhat.com>
	<20180627003906.15571-2-agruenba@redhat.com>
	<20180629085614.GB16042@lst.de>
	<CAHc6FU66vvPsDU2sq9O-_fRcU8CH_b6UsnQCYaSSbh-vVVWj=g@mail.gmail.com>
	<20180629160148.GA9938@lst.de>
	<CAHc6FU4UJEb2u7+XRFzhSkx_BZfB6ONNYDMeraoMMHTcPjtpqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cluster-devel <cluster-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: Andreas Gruenbacher <agruenba@redhat.com>
Return-path: <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAHc6FU4UJEb2u7+XRFzhSkx_BZfB6ONNYDMeraoMMHTcPjtpqQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 29, 2018 at 07:02:07PM +0200, Andreas Gruenbacher wrote:
> On 29 June 2018 at 18:01, Christoph Hellwig <hch@lst.de> wrote:
> > On Fri, Jun 29, 2018 at 04:40:40PM +0200, Andreas Gruenbacher wrote:
> >> On 29 June 2018 at 10:56, Christoph Hellwig <hch@lst.de> wrote:
> >> > This looks generally fine.  But I think it might be worth refactoring
> >> > iomap_dio_actor a bit first, e.g. something like this new patch
> >> > before yours, which would also nicely solve your alignmnet concern
> >> > (entirely untested for now):
> >>
> >> This looks correct. I've rebased my patches on top of it and I ran the
> >> xfstest auto group on gfs2 and xfs on top.
> >>
> >> Can you push this to your gfs2-iomap branch? I'll then repost an
> >> updated version of "iomap: Direct I/O for inline data".
> >
> > Darrick now has a real iomap merge branch which replaced it.
> 
> Where is it? Not in
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git
> it seems.

https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/log/?h=iomap-4.19-merge
