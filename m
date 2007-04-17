From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: Interface for the new fallocate() system call
Date: Tue, 17 Apr 2007 18:25:14 +0530
Message-ID: <20070417125514.GA7574@amitarora.in.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com> <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com,
	suparna@in.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>,
	Jakub Jelinek <jakub@redhat.com>, torvalds@linux-foundation.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070330071417.GI355@devserv.devel.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Mar 30, 2007 at 02:14:17AM -0500, Jakub Jelinek wrote:
> Wouldn't
> int fallocate(loff_t offset, loff_t len, int fd, int mode)
> work on both s390 and ppc/arm?  glibc will certainly wrap it and
> reorder the arguments as needed, so there is no need to keep fd first.
>

I think more people are comfirtable with this approach. Since glibc
will wrap the system call and export the "conventional" interface
(with fd first) to applications, we may not worry about keeping fd first
in kernel code. I am personally fine with this approach.

Still, if people have major concerns, we can think of getting rid of the
"mode" argument itself. Anyhow we may, in future, need to have a policy
based system call (say, for providing the goal block by applications for
performance reasons). "mode" can then be made part of it.

Comments ?
--
Regards,
Amit Arora
