From: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: ext2/3: document conditions when reliable operation is possible
Date: Fri, 28 Aug 2009 19:33:02 -0600
Message-ID: <4A98854E.9020302@gmail.com>
References: <20090312092114.GC6949@elf.ucw.cz> <200903121413.04434.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pavel Machek <pavel@ucw.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	tytso@mit.edu, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rob Landley <rob@landley.net>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751475AbZH2BdG@vger.kernel.org>
In-Reply-To: <200903121413.04434.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 03/12/2009 01:13 PM, Rob Landley wrote:
>> +* write caching is disabled. ext2 does not know how to issue barriers
>> +  as of 2.6.28. hdparm -W0 disables it on SATA disks.
>
> And here we're talking about ext2.  Does neither one know about write
> barriers, or does this just apply to ext2?  (What about ext4?)
>
> Also I remember a historical problem that not all disks honor write barriers,
> because actual data integrity makes for horrible benchmark numbers.  Dunno how
> current that is with SATA, Alan Cox would probably know.

I've heard rumors of disks that claim to support cache flushes but 
really just ignore them, but have never heard any specifics of model 
numbers, etc. which are known to do this, so it may just be legend. If 
we do have such knowledge then we should really be blacklisting those 
drives and warning the user that we can't ensure data integrity. (Even 
powering down the system would be unsafe in this case.)
