From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: mkfs.ext2 succeeds despite nbd write errors?
Date: Sat, 7 Nov 2015 21:02:03 +0000
Message-ID: <20151107210203.GW29330@redhat.com>
References: <CALuDM+AtyUUMFcdTOocxCw9BxQ4PBx5aeYVYwmy_UErh1MZjww@mail.gmail.com>
	<20151107110354.GM1908@redhat.com>
	<CALuDM+Aw9JCMVbQcRKaaUu+=+xvDpMgL8sUZpT2snz9Qp5DqpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, libguestfs@redhat.com
To: Jason Pepas <jasonpepas@gmail.com>
Return-path: <libguestfs-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CALuDM+Aw9JCMVbQcRKaaUu+=+xvDpMgL8sUZpT2snz9Qp5DqpA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/libguestfs>,
	<mailto:libguestfs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/libguestfs>
List-Post: <mailto:libguestfs@redhat.com>
List-Help: <mailto:libguestfs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/libguestfs>,
	<mailto:libguestfs-request@redhat.com?subject=subscribe>
Sender: libguestfs-bounces@redhat.com
Errors-To: libguestfs-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

[Adding linux-ext4 mailing list.  The original bug report is here:
https://www.redhat.com/archives/libguestfs/2015-November/msg00078.html ]

On Sat, Nov 07, 2015 at 01:22:45PM -0600, Jason Pepas wrote:
> On Sat, Nov 7, 2015 at 5:03 AM, Richard W.M. Jones <rjones@redhat.com> wrote:
> > How about 'strace mkfs.ext2 ..' and see if any system calls are
> > returning errors.  That would show you whether nbd-client is throwing
> > errors away, or whether mkfs is getting the errors and ignoring them
> > (seems pretty unlikely, but you never know).
> >
> > After that, it'd be down to tracing where the errors end up in the
> > kernel.
> 
> Thanks for the tip!
> 
> The results are interesting.  It looks like all of mkfs's pwrite()
> calls succeed, but its final fsync() calls do actually fail:
> 
> 
> root@debian:~# strace mkfs.ext2 /dev/nbd0 2>&1 | tee strace.out
> 
> root@debian:~# cat strace.out | grep pwrite
> pwrite(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
> 32768, 8187379712) = 32768
> pwrite(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
> 32768, 8187412480) = 32768
> pwrite(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
> 32768, 8187445248) = 32768
> ...
> 
> root@debian:~# cat strace.out | grep fsync
> fsync(3)                                = -1 EIO (Input/output error)
> fsync(3)                                = -1 EIO (Input/output error)
> 
> 
> The fsync() calls happen just before mkfs exists success:
> 
> 
> root@debian:~# cat strace.out | tail
> pwrite(3, "\1\2\0\0\2\2\0\0\3\2\0\0\367{\365\37\2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
> 4096, 6576672768) = 4096
> fsync(3)                                = -1 EIO (Input/output error)
> pwrite(3, "\0\0\10\0\0\0
> \0\231\231\1\0qm\37\0\365\377\7\0\0\0\0\0\2\0\0\0\2\0\0\0"..., 1024,
> 1024) = 1024
> fsync(3)                                = -1 EIO (Input/output error)
> close(3)                                = 0
> write(1, "done\n\n", 6done
> 
> )                 = 6
> exit_group(0)                           = ?
> +++ exited with 0 +++
> root@debian:~#
> 
> 
> I did manage to find two calls to fsync in the e2fsprogs source which
> are not return-value-checked:
> 
> https://github.com/tytso/e2fsprogs/blob/956b0f18a5ddb6815a9dff4f10a1e3125cdca9ba/misc/filefrag.c#L303
> https://github.com/tytso/e2fsprogs/blob/956b0f18a5ddb6815a9dff4f10a1e3125cdca9ba/lib/ext2fs/unix_io.c#L915

That second one looks very suspicious to me.  I don't think that it's
ever right for mke2fs to ignore the return value from an fsync call,
so assuming mke2fs calls that function it's surely a bug.

> I'll see about submitting a patch there.
> 
> I'm not sure where to start with hunting down why mkfs's pwrite()
> calls aren't failing.  I'd look to the kernel source for that?

It looks like it's really an e2fsprogs problem, not a kernel problem.
That's pretty surprising - I wasn't expecting it.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-p2v converts physical machines to virtual machines.  Boot with a
live CD or over the network (PXE) and turn machines into KVM guests.
http://libguestfs.org/virt-v2v
