From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/5][TAKE2] fallocate() implementation on i86, x86_64 and powerpc
Date: Tue, 15 May 2007 18:53:53 +0530
Message-ID: <20070515132353.GB12964@amitarora.in.ibm.com>
References: <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070514132926.GA30768@amitarora.in.ibm.com> <20070514142820.GA31468@amitarora.in.ibm.com> <20070514144524.GA31748@amitarora.in.ibm.com> <20070515094436.d441098f.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: torvalds@osdl.org, akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com,
	cmm@us.ibm.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070515094436.d441098f.sfr@canb.auug.org.au>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 15, 2007 at 09:44:36AM +1000, Stephen Rothwell wrote:
> On Mon, 14 May 2007 20:15:24 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
> >
> > This patch implements sys_fallocate() and adds support on i386, x86_64
> > and powerpc platforms.
> 
> This patch no longer applies to Linus' tree - for a start there is no file
> arch/x86_64/kernel/functionlist any more.
> 
> Can you rebase it, please?

I will rebase it to 2.6.22-rc1 and repost the patches soon.
Thanks!

--
Regards,
Amit Arora
