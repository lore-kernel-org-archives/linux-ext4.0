From: Christoph Lameter <clameter@sgi.com>
Subject: Re: [RFC 1/2] JBD: slab management support for large block(>8k)
Date: Sun, 2 Sep 2007 04:40:21 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0709020438490.28046@schroedinger.engr.sgi.com>
References: <20070828190551.415127746@sgi.com> <20070828190735.292638294@sgi.com>
 <1188432669.3799.35.camel@localhost.localdomain> <1188434857.3799.76.camel@localhost.localdomain>
 <1188605538.3837.51.camel@localhost.localdomain> <20070901183922.GA12907@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mingming Cao <cmm@us.ibm.com>, linux-fsdevel@vger.kernel.org,
	adilger@clusterfs.com, sho@tnes.nec.co.jp,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070901183922.GA12907@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 1 Sep 2007, Christoph Hellwig wrote:

> On Fri, Aug 31, 2007 at 05:12:18PM -0700, Mingming Cao wrote:
> > >From clameter:
> > Teach jbd/jbd2 slab management to support >8k block size. Without this, it refused to mount on >8k ext3.
> 
> 
> But the real fix is to kill this code.  We can't send down slab pages
> down the block layer without breaking iscsi or aoe.  And this code is
> only used in so rare cases that all the normal testing won't hit it.
> Very bad combination.

We are doing what you describe right now. So the current code is broken?


