From: Hubert Bahr <hab@hbahr.org>
Subject: extremely long delays are they possible?
Date: Sat, 16 Oct 2010 01:02:12 -0500
Message-ID: <4CB93FE4.6030005@hbahr.org>
Reply-To: hab@hbahr.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61760 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab0JPGCN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Oct 2010 02:02:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In reality I would prefer writes only occur to an ssd if the FS write 
cache is overflowing.  The application is package rebuilding.  The 
package is brought in from nfs expanded built (compiled etc)  then the 
results written back to an nfs mount and the log written to Cluster Head 
then everything erased.  However, if there are build problems the 
expanded file system and results are left intact.  My Memory Size is 
large enough (16GB) to buffer the whole process except when a build 
problem occur's.  Since this can be hours into a build I would prefer to 
capture.  This is part of a cluster batch process that is only examined 
at the expected end of the total batch process.  Capturing the problems 
precludes using only a ramfs, but I would like to avoid needless writes 
to the ssd.  I am afraid that embedded fsyncs may blow this anyway.  
Maybe I could use some on error mv but I prefer the dynamic memory 
sharing rather than a fixed ramfs.  The longest single package build I 
have observed is 11.5 hours and it also took the most space.
would fstab options like    ext4     
commit=50000,noatime,delalloc,data=writeback    give me the desired action?
Thanks
Hubert
