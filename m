From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [BUG] ext2/3/4: dio reads stale data when we do some append dio
 writes
Date: Tue, 19 Nov 2013 02:22:35 -0800
Message-ID: <20131119102235.GA5010@infradead.org>
References: <20131119095302.GA4534@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131119095302.GA4534@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 19, 2013 at 05:53:03PM +0800, Zheng Liu wrote:
> code snippet:

Can you please wire this up as a regression test for xfstests?

