From: Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended
 file stats available [ver #6]
Date: Thu, 22 Jul 2010 19:36:22 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1007221935190.32551@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1007221228260.6115@obet.zrqbmnf.qr>  <20100715021709.5544.64506.stgit@warthog.procyon.org.uk>  <20100715021712.5544.44845.stgit@warthog.procyon.org.uk>  <30448.1279800887@redhat.com> <E1Obuiy-00C9jr-Al@intern.SerNet.DE>
 <AANLkTikBCXK6uEwWq4f0LvpdoKCPs3jvyFa4Zw4e2J_7@mail.gmail.com>  <E1Obxpd-00CRIo-SF@intern.SerNet.DE>  <AANLkTimwIq0pBhCeOjOVjB0yeM3JHOvzVoj9M4ui6al9@mail.gmail.com>  <20100722162712.GB10352@jeremy-laptop>  <AANLkTimdFCGSKLn7aGMpBMIauHTsHY7hpAAmpo6uTcnD@mail.gmail.com>
  <alpine.LSU.2.01.1007221859180.27496@obet.zrqbmnf.qr> <1279818967.3621.23.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Trond Myklebust <trond.myklebust-41N18TsMXrtuMpJDpNschA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1279818967.3621.23.camel-rJ7iovZKK19ZJLDQqaL3InhyD016LWXt@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org


On Thursday 2010-07-22 19:16, Trond Myklebust wrote:
>> >But the fact is, th Unix ctime semantics are insane and largely
>> >useless. There's a damn good reason almost nobody uses ctime under
>> >unix.
>> 
>> I beg to differ. ctime is not completely useless. It reflects changes on 
>> the inode for when you don't you change the content. It's like an mtime 
>> for the metadata. It comes useful when you go around in your filesystem 
>> trying to figure out who of your co-admins screwed up the permissions on 
>> /etc/passwd... and if the mtime is the same as that of the last backup, 
>> I can at least have a reasonable assurance that it was /only/ the 
>> metadata that was tampered with. (SHA1 check, yeah yeah, costly on large 
>> files.)
>
>Errr... Only if you eliminate utimes() from your syscall table.
>Otherwise it is trivial to reset the mtime after changing the file
>contents.

Well yes; I had implicitly implied that evil people with malicious intent
are absent.
