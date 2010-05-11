From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Rampant ext3/4 corruption on 2.6.34-rc7 with VIVT ARM (Marvell
	88f5182)
Date: Tue, 11 May 2010 20:47:58 +1000
Message-ID: <1273574878.21352.25.camel@pasglop>
References: <1273569821.21352.19.camel@pasglop>
	<20100511101620.GA18654@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Saeed Bishara <saeed@marvell.com>, Nicolas Pitre <nico@marvell.com>,
	linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <jejb@parisc-linux.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Jamie Lokier <jamie@shareable.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20100511101620.GA18654@shareable.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
	<mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
	<mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: linux-arm-kernel-bounces@lists.infradead.org
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2010-05-11 at 11:16 +0100, Jamie Lokier wrote:
> 
> I've seen similar ext3 corruption errors with an IDE on a Sigma
> Designs EM8620 with ARM core.  It's completely unrelated :-) But the
> fault was in the IDE driver doing cache flushes too late after
> starting to set up DMA.  To diagnose it, we luckily found a
> reproducible test case, then sprinkled full cache flushes at various
> places to narrow it down, and eventually found that one full cache
> flush in the driver itself sorted it out, which told us where the
> fault was.  From there it was easy. 

Ok, well, that's -a- possibility... we'll see. I'm doing some more tests
to try to characterize the problem a bit better, then we can play with
the driver. I think it's also worth trying with earlier kernels in case
it's some kind of regression, though that means I'll have to backport my
board support for that little box :-)

Cheers,
Ben.
