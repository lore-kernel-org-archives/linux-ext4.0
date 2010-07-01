From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 0/3] Extended file stat functions [ver #2]
Date: Thu, 1 Jul 2010 10:09:32 +0200
Message-ID: <201007011009.33197.arnd@arndb.de>
References: <FB78A152-53D3-4000-ABDB-9D6051ECB887@dilger.ca> <30875.1277939713@redhat.com> <84225B35-7365-4DE2-8920-5741011B347C@dilger.ca>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
	smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org,
	aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, sjayaraman-l3A5Bk7waGM@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <84225B35-7365-4DE2-8920-5741011B347C-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Thursday 01 July 2010 06:57:07 Andreas Dilger wrote:
> If a future kernel gets a new static field at st_extra_results (say
> unsigned long long st_ino_high) with a new flag XSTAT_REQUEST_INO_HIGH
> 0x000040000ULL the kernel will think that the old app is requesting 
> this field, and will fill in the 64-bit field at st_extra_results[1]
> (which the old app didn't allocate space for, nor does it understand)
> and may get a segfault, or stack smashing, or random heap corruption.

That depends on whether the struct contains a 'buflen' field or not
(it may be part of the struct, as a syscall argument, or in a second struct).
I argue that it should not contain a buflen field and that users should
consequently not set bits that they don't know about to prevent the
scenario you describe.

If the buflen stays in, it will prevent the stack smashing part,
but add extra complexity in the interface, which can cause other
problems.

	Arnd
