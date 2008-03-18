From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 10276] New: directory ctime not updated by
 rename
Date: Tue, 18 Mar 2008 10:00:23 -0700
Message-ID: <20080318100023.1e047627.akpm@linux-foundation.org>
References: <bug-10276-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: bugme-daemon@bugzilla.kernel.org,
	lasse-kernelbug-2008@mail.plastictree.net
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753386AbYCSTZk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Mar 2008 15:25:40 -0400
In-Reply-To: <bug-10276-10286@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 18 Mar 2008 09:11:54 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=10276
> 
>            Summary: directory ctime not updated by rename
>            Product: File System
>            Version: 2.5
>      KernelVersion: 2.6.24.3
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: ext3
>         AssignedTo: akpm@osdl.org
>         ReportedBy: lasse-kernelbug-2008@mail.plastictree.net
> 
> 
> Latest working kernel version:
> Earliest failing kernel version:
> Distribution: LFS
> Hardware Environment: 32bit x86
> Software Environment:
> Problem Description: Renaming a file into a directory so that an already
> existing file is overwritten, will not update the ctime on the directory. This
> seems to be the reason for certain failures with incremental backups (e.g.,
> with star).
> 
> Steps to reproduce:
> 
> Run the following commands and watch the output from stat. Upon the second run
> of rename, the ctime is not updated on the directory sub.
> 
> rm -fr sub new &&
> mkdir sub &&
> stat sub &&
> sleep 2 &&
> echo running rename &&
> ./rename a &&
> stat sub &&
> sleep 2 &&
> echo running rename again &&
> ./rename b &&
> stat sub
> 
> 
> Here is rename.c:
> 
> #include <unistd.h>
> #include <fcntl.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <sys/stat.h>
> 
> int main(int argc, char** argv) {
>         int fd;
> 
>         fd = open("new", O_WRONLY | O_NDELAY | O_TRUNC | O_CREAT, 0644);        
>         write(fd, argv[1], 1);
>         close(fd);
>         rename("new", "sub/x");
> 
>         return 0;
> }
> 

Do we agree that this is a bug?  If so, is it a VFS thing or a per-fs
thing?

Thanks.

