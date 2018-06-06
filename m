From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/6] iomap: move bdev and dax_dev in a
	union
Date: Wed, 6 Jun 2018 14:05:10 +0200
Message-ID: <20180606120510.GA13047@lst.de>
References: <20180606104033.4947-1-hch@lst.de>
	<20180606104033.4947-3-hch@lst.de>
	<CAHc6FU5xFMmN1EPGrZOhx9S5Focwq0Ky9HZeQ9VRGFC-o-cZZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cluster-devel <cluster-devel@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
To: Andreas Gruenbacher <agruenba@redhat.com>
Return-path: <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAHc6FU5xFMmN1EPGrZOhx9S5Focwq0Ky9HZeQ9VRGFC-o-cZZw@mail.gmail.com>
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

On Wed, Jun 06, 2018 at 01:37:02PM +0200, Andreas Gruenbacher wrote:
> This seems backwards.

It is.  So much for last minute polarity fixups..
