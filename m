From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [RFC][PATCH] set_page_buffer_dirty should skip unmapped buffers
Date: Fri, 01 Sep 2006 14:01:35 -0700
Message-ID: <44F89FAF.2050601@us.ibm.com>
References: <1157125829.30578.6.camel@dyn9047017100.beaverton.ibm.com>	<Pine.LNX.4.64.0609011652420.24650@hermes-2.csi.cam.ac.uk>	<1157128342.30578.14.camel@dyn9047017100.beaverton.ibm.com> <20060901101801.7845bca2.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Anton Altaparmakov <aia21@cam.ac.uk>, sct@redhat.com,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
In-Reply-To: <20060901101801.7845bca2.akpm@osdl.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andrew Morton wrote:
> On Fri, 01 Sep 2006 09:32:22 -0700
> Badari Pulavarty <pbadari@us.ibm.com> wrote:
>
>   
>>>> Kernel BUG at fs/buffer.c:2791
>>>> invalid opcode: 0000 [1] SMP
>>>>
>>>> Its complaining about BUG_ON(!buffer_mapped(bh)).
>>>>         
>
> I need to have a little think about this, remember what _should_ be
> happening in this situation.
>
> We (mainly I) used to do a huge amount of fsx-linux testing on 1k blocksize
> filesystems.  We've done something to make this start happening.  Part of
> resolving this bug will be working out what that was.
>   

Here is the progress in tracking this down so far.

I am able to reproduce the problem on following kernel versions.

2.6.18-rc5
2.6.18-rc4
2.6.17.11
2.6.16.28
2.6.15.7
2.6.14.7

I am yet to find a latest kernel version - where this works :(
I am going to try older versions of the kernel.

Thanks,
Badari


-- 
VGER BF report: H 3.60822e-15
