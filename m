From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: Interface for the new fallocate() system call
Date: Fri, 30 Mar 2007 09:00:16 +0200
Message-ID: <20070330070016.GB8365@osiris.boeblingen.de.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com> <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com> <Pine.LNX.4.61.0703291854000.31834@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@osdl.org,
	akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0703291854000.31834@yvahk01.tjqt.qr>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Mar 29, 2007 at 07:01:54PM +0200, Jan Engelhardt wrote:
> Hi,
> 
> On Mar 29 2007 17:21, Amit K. Arora wrote:
> >
> >We need to come up with the best possible layout of arguments for the
> >fallocate() system call. Various architectures have different
> >requirements for how the arguments should look like. Since the mail
> >chain has become huge, here is the summary of various inputs received
> >so far.
> 
> >s390 prefers following layout:
> >   int fallocate(int fd, loff_t offset, loff_t len, int mode)
> >For details on why and how "int, int, loff_t, loff_t" is a problem on
> >s390, please see Heiko's mail on 16th March. Here is the link:
> >http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg133595.html
> 
> Quoting that...
> 	|len -> r6 + second halve on stack
> 
> Then, is not this a gcc glitch? (IMO, it should put all of "len" on the 
> stack)

It _does_ put all of "len" on the stack. That is what I tried to explain
in the section that follows what you quoted.
