From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [BUG] ext2/3/4: dio reads stale data when we do some append dio
 writes
Date: Tue, 19 Nov 2013 03:18:26 -0800
Message-ID: <20131119111826.GA20485@infradead.org>
References: <20131119095302.GA4534@gmail.com>
 <20131119102235.GA5010@infradead.org>
 <20131119104508.GA4630@gmail.com>
 <20131119110147.GA3323@infradead.org>
 <20131119111947.GA4782@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131119111947.GA4782@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 19, 2013 at 07:19:47PM +0800, Zheng Liu wrote:
> Yes, I know that XFS has a shared/exclusive lock.  I guess that is why
> it can pass the test.  But another question is why xfs fails when we do
> some append dio writes with doing buffered read.

Can you provide a test case for that issue?

