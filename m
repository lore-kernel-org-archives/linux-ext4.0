From: Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: iomap preparations for GFS2 v2
Date: Fri, 15 Jun 2018 09:31:26 +0100
Message-ID: <5a1e303b-e96e-7faf-1bcd-36d63a237514@redhat.com>
References: <20180614120457.28285-1-hch@lst.de>
	<CAHc6FU4nQ562SxepV1=dqcuuuPBWOTXr4sAiY_5H-Z7uOaTNng@mail.gmail.com>
	<20180615080326.GB19525@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: cluster-devel <cluster-devel@redhat.com>, linux-xfs@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>, Andreas Gruenbacher <agruenba@redhat.com>
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20180615080326.GB19525@lst.de>
Content-Language: en-US
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

Hi,


On 15/06/18 09:03, Christoph Hellwig wrote:
> On Thu, Jun 14, 2018 at 03:04:38PM +0200, Andreas Gruenbacher wrote:
>> I saw that you've pushed this onto the gfs2-iomap branch in your xfs
>> repository. I've rebased the gfs2 iomap-write branch onto that;
>> there's a trivial patch for adding a private pointer to struct iomap
>> at the head of that branch that would sense to move to the shared
>> branch as well now.
> Please send that patch out ASAP.
>
>> The next step would probably be to start using iomap_readpage /
>> iomap_readpages in gfs2 for block size == page size. This requires
>> adding inline data support to iomap_readpage which is trivial, but
>> because of gfs2's reliance on buffer heads, that alone isn't enough.
> Is it?  At least for block size == page size we will only call
> readpage on a pristine, newly allocated page.  So buffer heads won't
> be in the game at that point, and the iomap buffered write code will
> just allocate them for you once we start a write operation, or take
> a page fault that makes the page writable.
>

Yes, for block size == page size, it should not be an issue to drop the 
use of buffer heads on reads in GFS2. I was fairly sure that we already 
did that in ->readpages() anyway, but it is a while since I looked at 
the code and my memory may be playing tricks on me,

Steve.
