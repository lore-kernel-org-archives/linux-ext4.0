From: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH v1 00/16] ext4: Add metadata checksumming
Date: Sun, 4 Sep 2011 19:44:55 +0200
Message-ID: <88f8907569619968aa7b4a8c669d5aba.squirrel@www.firstfloor.org>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
    <CAGpXXZ+Cq9_aS4BPC5BKNj6aWHzzL7+e8ZQKO3=C7UV+xcnqWA@mail.gmail.com>
    <20110902182214.GC12086@tux1.beaverton.ibm.com>
    <yq1d3fgwn5c.fsf@sermon.lab.mkp.net>
    <6fdb58aed1dae8020900e65cbfb34b28.squirrel@www.firstfloor.org>
    <yq14o0scjmg.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Andi Kleen" <andi@firstfloor.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	djwong@us.ibm.com, "Greg Freemyer" <greg.freemyer@gmail.com>,
	"Andreas Dilger" <adilger.kernel@dilger.ca>,
	"Theodore Tso" <tytso@mit.edu>,
	"Sunil Mushran" <sunil.mushran@oracle.com>,
	"Amir Goldstein" <amir73il@gmail.com>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"Mingming Cao" <cmm@us.ibm.com>,
	"Joel Becker" <jlbec@evilplan.org>,
	"linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, "Coly Li" <colyli@gmail.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq14o0scjmg.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>>> "Andi" == Andi Kleen <andi@firstfloor.org> writes:
>
>>> On Westmere and beyond it is possible to accelerate generic CRC
>>> calculation using the PCLMULQDQ operation. There are many of our CRC
>
> Andi> Faster than the lookup table? That's hard to believe.
>
> Using PCLMULQDQ you can parallelize the calculation. You can even boost
> hw CRC32C performance that way.
>
>   http://download.intel.com/design/intarch/papers/323405.pdf
>
>   http://download.intel.com/design/intarch/papers/323102.pdf

Doesn't have any performance numbers.

You need to keep in mind that PCLMULQDQ uses FPU state, so any
speedup for the kernel must be large enough to amortize the cost of
saving the FPU state.

Typically that only works out for quite large buffers, but
kernel buffers are relatively small.

For the ext4 metadata a better approach is probably some sort of
incremental CRC, or possibly separate CRCs for very commonly
changed fields. When I looked at this most changes were only for
small fields.

-Andi
