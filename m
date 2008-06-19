From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: kerneloops.org: 2.6.26-rc possible regression in ext3
Date: Wed, 18 Jun 2008 23:40:34 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0806182325540.2907@woody.linux-foundation.org>
References: <4859EFE2.2090202@linux.intel.com> <alpine.LFD.1.10.0806182242390.2907@woody.linux-foundation.org> <alpine.LFD.1.10.0806182302340.2907@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>
To: Arjan van de Ven <arjan@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754147AbYFSGlG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jun 2008 02:41:06 -0400
In-Reply-To: <alpine.LFD.1.10.0806182302340.2907@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Wed, 18 Jun 2008, Linus Torvalds wrote:
> 
> and that "lea" is doing an address computation of "eax+2*ebx-2". Which 
> does *not* look like an address to a 32-bit entity, but to a 16-bit one. 
> Yeah, it's not conclusive, but it is suggestive.

I'm wrong, that's just "eax+ebx-2". The *2 was just a brainfart on my 
part.

But I think I have pinpointed where it comes from: it's the 

	struct dx_map_entry *map;

which is a structure like this:

	struct dx_map_entry
	{
	        u32 hash;
	        u16 offs;
	        u16 size;
	};

and it does look like it's the

	if (size + map[i].size/2 > blocksize/2)

calculation, where "i" counts backwards from "count-1" to 0.

In particular, the code

  27:	8d 4c 18 fe          	lea    0xfffffffe(%eax,%ebx,1),%ecx
  2b:*	8b 19                	mov    (%ecx),%ebx     <-- trapping instruction
  2d:	83 e9 08             	sub    $0x8,%ecx
  30:	89 d8                	mov    %ebx,%eax
  32:	66 d1 e8             	shr    %ax
  38:	8d 04 02             	lea    (%edx,%eax,1),%eax

seems to be that "size + map[i].size/2" calculation, but I have a hard 
time trying to line it up with wat _my_ compiler gives me. But the nearest 
match I have is:

        movw    6(%ecx), %bx    # <variable>.size, D.21305
        subl    $8, %ecx        #, ivtmp.921
        movl    -104(%ebp), %edx        # blocksize, tmp179
        movl    %ebx, %eax      # D.21305, tmp176
        shrw    %ax     # tmp176
        movzwl  %ax, %eax       # tmp176, tmp177
        leal    (%esi,%eax), %eax       #, tmp178

which seems to be largely the same thing (except I have a "movw" to load 
the size, and %ecx is offset by one 'map' entry - so the offset is 6 (in 
the memop) instead of that "-2" (from the lea).

I think I'll give up, but that's the closest match I can find. No 
guarantees, but it seems to support the notion of "wrong 32-bit load where 
it should have used a 16-bit one".

		Linus
