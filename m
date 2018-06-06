From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Subject: Re: iomap preparations for GFS2
Date: Wed, 6 Jun 2018 17:31:25 +0200
Message-ID: <CAHpGcMJC01-RVceZajprnLtFP7JS+SrUJ+N_RESgGJyAkj=KJA@mail.gmail.com>
References: <20180606104033.4947-1-hch@lst.de>
	<CAHc6FU458f9xkr2ru2B2L8_FC+=vm5CLDUixBjCZSq5YZZC8=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: cluster-devel <cluster-devel@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
To: Andreas Gruenbacher <agruenba@redhat.com>
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <CAHc6FU458f9xkr2ru2B2L8_FC+=vm5CLDUixBjCZSq5YZZC8=w@mail.gmail.com>
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

2018-06-06 13:38 GMT+02:00 Andreas Gruenbacher <agruenba@redhat.com>:
> On 6 June 2018 at 12:40, Christoph Hellwig <hch@lst.de> wrote:
>> Hi all,
>>
>> this is a slight rework of the patches from Andreas to prepare for gfs2
>> using the iomap code.  I'd like to start with an immutable branch for
>> iomap patches in either the XFS tree or a tree of mine own with something
>> like this so that we can have a nice common base for both the major
>> iomap changes for XFS and the GFS2 work.

When do you want to push this upstream? We've got the gfs2 patches
that depend on it, and we cannot make progress with those before this
set is pushed.

Thanks,
Andreas
