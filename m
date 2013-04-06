From: "Michael D. Setzer II" <msetzerii@gmail.com>
Subject: Re: Error in linux-3.0.72 build.
Date: Sat, 06 Apr 2013 21:32:06 +1000
Message-ID: <516007B6.26486.625F6@msetzerii.gmail.com>
References: <515FF835.28644.1FF1E@msetzerii.gmail.com>, <20130406112657.GA3625@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:48706 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163267Ab3DFLcM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Apr 2013 07:32:12 -0400
In-reply-to: <20130406112657.GA3625@pd.tnic>
Content-description: Mail message body
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6 Apr 2013 at 13:26, Borislav Petkov wrote:

Date sent:      	Sat, 6 Apr 2013 13:26:57 +0200
From:           	Borislav Petkov <bp@alien8.de>
To:             	"Michael D. Setzer II" <msetzerii@gmail.com>
Copies to:      	linux-kernel@vger.kernel.org, 
linux-ext4@vger.kernel.org
Subject:        	Re: Error in linux-3.0.72 build.

> On Sat, Apr 06, 2013 at 08:25:57PM +1000, Michael D. Setzer II wrote:
> > Just downloaded new kernels, and find this error in build.
> > 
> > fs/built-in.o: In function `find_group_flex':
> > /home/msetzerii/data/linux-3.0.72/fs/ext4/ialloc.c:359: undefined 
> > reference to `__udivdi3'
> > /home/msetzerii/data/linux-3.0.72/fs/ext4/ialloc.c:374: undefined 
> > reference to `__udivdi3'
> > make: *** [.tmp_vmlinux1] Error 1
> 
> Looks like your compiler is generating 64-bit division which is a call
> into libgcc. Which gcc version are you using?
> 

gcc (GCC) 4.5.1 20100924 (Red Hat 4.5.1-4)

Other two new kernel built fine, and all the previous 3.0.x kernels 
have build using the same .config on system.

It is a quad core phenom II machine running Fedora 14 with the 
linux32 option to build 32bit kernels for use on my g4l project cd 
image.



> +ext4 folks.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --


+----------------------------------------------------------+
  Michael D. Setzer II -  Computer Science Instructor      
  Guam Community College  Computer Center                  
  mailto:mikes@kuentos.guam.net                            
  mailto:msetzerii@gmail.com
  http://www.guam.net/home/mikes
  Guam - Where America's Day Begins                        
  G4L Disk Imaging Project maintainer 
  http://sourceforge.net/projects/g4l/
+----------------------------------------------------------+

http://setiathome.berkeley.edu (Original)
Number of Seti Units Returned:  19,471
Processing time:  32 years, 290 days, 12 hours, 58 minutes
(Total Hours: 287,489)

BOINC@HOME CREDITS
SETI        14361044.287140   |   EINSTEIN    10723942.979852
ROSETTA      6832434.144171   |   ABC         15903532.519753

