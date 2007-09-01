From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 1/2] JBD: slab management support for large block(>8k)
Date: Sat, 1 Sep 2007 19:39:22 +0100
Message-ID: <20070901183922.GA12907@infradead.org>
References: <20070828190551.415127746@sgi.com> <20070828190735.292638294@sgi.com> <1188432669.3799.35.camel@localhost.localdomain> <1188434857.3799.76.camel@localhost.localdomain> <1188605538.3837.51.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, adilger@clusterfs.com,
	sho@tnes.nec.co.jp, ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org, clameter@sgi.com
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1188605538.3837.51.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Aug 31, 2007 at 05:12:18PM -0700, Mingming Cao wrote:
> >From clameter:
> Teach jbd/jbd2 slab management to support >8k block size. Without this, it refused to mount on >8k ext3.


But the real fix is to kill this code.  We can't send down slab pages
down the block layer without breaking iscsi or aoe.  And this code is
only used in so rare cases that all the normal testing won't hit it.
Very bad combination.
