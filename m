From: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [BUG] 2.6.27-rc1 - Filesystem warning on ext4 with e2fsck
Date: Mon, 11 Aug 2008 09:27:12 -0500
Message-ID: <48A04C40.1040206@redhat.com>
References: <48A0127E.6000505@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Kernel Testers List <kernel-testers-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Andy Whitcroft <apw-26w3C0LaAnFg9hUCZPvPmw@public.gmane.org>
To: Kamalesh Babulal <kamalesh-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Return-path: <kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <48A0127E.6000505-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Kamalesh Babulal wrote:
> Hi,
> 
> After running the fsx linux test on the ext4 partition mounted with 
> -o errors=panic,journal_async_commit, filesystem check is reporting
> warning
> 
> # /usr/local/e2fsprogs/sbin/e2fsck -fnv /dev/sda6 
> e2fsck 1.41.0 (10-Jul-2008)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> /lost+found not found.  Create? no
> 
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> 
> /dev/sda6: ********** WARNING: Filesystem still has errors **********

Was lost+found manually removed between mkfs & fsck?  (did you do an rm
-rf * or similar ?)  That'd produce exactly the above warning, since you
told e2fsck "-n" ...

-Eric
