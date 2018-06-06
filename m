From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: iomap preparations for GFS2
Date: Wed, 6 Jun 2018 13:38:50 +0200
Message-ID: <CAHc6FU458f9xkr2ru2B2L8_FC+=vm5CLDUixBjCZSq5YZZC8=w@mail.gmail.com>
References: <20180606104033.4947-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	cluster-devel <cluster-devel@redhat.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20180606104033.4947-1-hch@lst.de>
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

On 6 June 2018 at 12:40, Christoph Hellwig <hch@lst.de> wrote:
> Hi all,
>
> this is a slight rework of the patches from Andreas to prepare for gfs2
> using the iomap code.  I'd like to start with an immutable branch for
> iomap patches in either the XFS tree or a tree of mine own with something
> like this so that we can have a nice common base for both the major
> iomap changes for XFS and the GFS2 work.

Okay.

Thanks,
Andreas
