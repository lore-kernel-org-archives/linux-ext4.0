From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Interface for the new fallocate() system call
Date: Thu, 29 Mar 2007 20:05:24 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0703292002210.31834@yvahk01.tjqt.qr>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
 <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com>
 <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com>
 <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com>
 <20070329115126.GB7374@amitarora.in.ibm.com> <Pine.LNX.4.61.0703291854000.31834@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0703291314330.4366@chaos.analogic.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@osdl.org,
	akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0703291314330.4366@chaos.analogic.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

 
On Mar 29 2007 13:18, linux-os (Dick Johnson) wrote:
>
>I think it's always better to put only a pointer on the stack as
>above.

I have to disagree, since wrapping it into a struct and copying the struct
in kernelspace from userspace requires more code. Pointers only become
useful at 3 (rarely) or 4 (yeah, more likely) and 5+ (definitely)
arguments, (3) see above about copying, (4) middle thing and (5) tons of
arguments like mmap() should be wrapped up... for simplicity of dealing
with it later.


Jan
-- 
