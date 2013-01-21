From: Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: jbd2: don't wake kjournald unnecessarily
Date: Mon, 21 Jan 2013 18:39:39 +0100
Message-ID: <1358789979.8755.0.camel@tucsk.piliscsaba.szeredi.hu>
References: <CA+icZUWOvk5i+XY22xdZYuxu=Vy3fG2QxJStEgNFQVS4u55y-w@mail.gmail.com>
	 <CA+icZUUzNYE9QAh_p7=ZNuvZbxRPCb9zd4k7+aW-hv34mQWz=A@mail.gmail.com>
	 <20130121104733.GE5588@quack.suse.cz>
	 <CA+icZUVy-=jJkRsEKmX+ZGRjiGr4wwp3pqdxuLCRHeqW_H0x9Q@mail.gmail.com>
	 <CA+icZUVAP4ArN+j34GTUwMxte5DtLPJSrLmK9T6Na8Qy+aM0Rg@mail.gmail.com>
	 <20130121140738.GI5588@quack.suse.cz>
	 <CA+icZUVya4cYGcmX=YeOKZNhXpgEBioDFp8o1Q=TKWmKEvFm6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-next <linux-next@vger.kernel.org>
To: sedat.dilek@gmail.com
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <CA+icZUVya4cYGcmX=YeOKZNhXpgEBioDFp8o1Q=TKWmKEvFm6Q@mail.gmail.com>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2013-01-21 at 15:28 +0100, Sedat Dilek wrote:
> On Mon, Jan 21, 2013 at 3:07 PM, Jan Kara <jack@suse.cz> wrote:

> >   Well, I think the outputs make it pretty clear. /dev/loop0 is a mounted
> > image from fuse filesystem. Fuse daemon making filesystem accessible gets
> > frozen before /dev/loop0 gets fully written out and so jbd2 journal thread
> > hangs. Maybe Miklos (added to CC) could fill in some details / ideas but I
> > think the setup like you have never really worked...
> >
> 
> Thank you for the explanations.
> Before doing some patches for Linux Test Project and replying to
> LLVMLinux I was reflecting about FUSE when saw the 'df -h -T' line.
> You might be right, that pm_test/freezer could never be OK here.
> I wantend to test against Linux v3.8-rc4 to be sure.
> Anyway, thanks for sharing your thoughts with me!

There are several problems with this setup.  Loop over fuse has always
been problematic because of interaction with the memory management.
E.g. the kernel is trying to allocate memory and is writing out dirty
pages to the loop device then that write ends up in the userspace
filesystem process which may want to allocate additional memory to
complete the write.  This may end up deadlocking the writeout, which is
not good.  So loop over fuse (for write) is not a good idea in any case.

One way to get around this limitation is to use mountlo, which does a
loop mount in userspace using UML and fuse.   That will probably be
better. 

Unfortunately fuse has a bad interaction with the freezer as well.  The
reason for that is the freezer wants all syscalls to finish but with a
frozen userspace a fuse daemon will not be able to complete the work
necessary to finish those syscalls.  We thought about this long and hard
and there are no easy solutions.   We can allow the freezer to proceed
for cases when the syscall is directly waiting for a fuse filesystem
daemon reply.  But the syscall may be waiting for the filesystem daemon
indirectly, e.g. sleeping on i_mutex, and that's rather more difficult
to fix.  It's not impossible but it's a big project.

To conclude:  writable loop over fuse is broken and was always broken,
it should not be used.  Other solutions should work better but fuse is
currently not 

Thanks,
Miklos
