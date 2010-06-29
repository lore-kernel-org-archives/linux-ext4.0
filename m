From: Joel Becker <Joel.Becker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file
 stats available
Date: Tue, 29 Jun 2010 15:48:44 -0700
Message-ID: <20100629224844.GF4150@mail.oracle.com>
References: <AANLkTimSU_pCXW5zR8__Q3-fzgxwEUX8rPqLeZtPD_hX@mail.gmail.com>
 <20100629200259.23196.81509.stgit@warthog.procyon.org.uk>
 <20100629200315.23196.68742.stgit@warthog.procyon.org.uk>
 <26026.1277851016@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ulrich Drepper <drepper-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
	smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org,
	aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, sjayaraman-l3A5Bk7waGM@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <26026.1277851016-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 29, 2010 at 11:36:56PM +0100, David Howells wrote:
> Ulrich Drepper <drepper-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > And while you're at it, maybe some spare fields at the end are nice.
> 
> I made it so that the syscall can return variable length data: the main xstat
> struct, plus extra records yet to be defined.  They could even be variable
> length and assembled/disassembled with something like the control message
> macros for recvmsg().

	The less variable length stuff the better, I think.  At least,
for the stuff stat(2) already returns, you should have a fixed-size
structure.  Even if I only pass the GIVE_ME_UIDS flag, I don't want to
have to deal with the variable size stuff until I've actually asked for
esoteric things.  I'll know that the non-UIDS fields are garbage by the
fact that I didn't ask for them.

Joel

-- 

"Time is an illusion, lunchtime doubly so."
        -Douglas Adams

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Phone: (650) 506-8127
