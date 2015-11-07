From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: mkfs.ext2 succeeds despite nbd write errors?
Date: Sat, 7 Nov 2015 23:20:01 +0000
Message-ID: <20151107232001.GX29330@redhat.com>
References: <CALuDM+AtyUUMFcdTOocxCw9BxQ4PBx5aeYVYwmy_UErh1MZjww@mail.gmail.com>
	<20151107110354.GM1908@redhat.com>
	<CALuDM+Aw9JCMVbQcRKaaUu+=+xvDpMgL8sUZpT2snz9Qp5DqpA@mail.gmail.com>
	<20151107210203.GW29330@redhat.com>
	<CALuDM+CAE1g8-9g9_72hU3xcQnA5k8QTkSQj4rjHh2tHc8mgLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, libguestfs@redhat.com
To: Jason Pepas <jasonpepas@gmail.com>
Return-path: <libguestfs-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CALuDM+CAE1g8-9g9_72hU3xcQnA5k8QTkSQj4rjHh2tHc8mgLw@mail.gmail.com>
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

On Sat, Nov 07, 2015 at 05:09:52PM -0600, Jason Pepas wrote:
> On Sat, Nov 7, 2015 at 3:02 PM, Richard W.M. Jones <rjones@redhat.com> wrote:
> >> I'm not sure where to start with hunting down why mkfs's pwrite()
> >> calls aren't failing.  I'd look to the kernel source for that?
> >
> > It looks like it's really an e2fsprogs problem, not a kernel problem.
> > That's pretty surprising - I wasn't expecting it.
> 
> I agree the fsync() issue is an e2fsprogs problem, but as for
> specifically the pwrite() calls not getting a -1 return value, that's
> the kernel's fault, right?

I'm definitely not an expert here, but I do recall being told that
writes and reads are allowed to return an "OK" indication, but a later
close(2) or fsync(2) might fail.  That is particularly a problem with NFS.

I'll leave the rest to the true experts on the ext4 mailing list.

> I've been rolling this around in my mind and I think I can see why the
> kernel would correctly make fsync() fail but not pwrite() fail.  Let
> me run this by you:
> 
> When a pwrite() happens, that doesn't immediately cause nbd to send a
> network packet out, and doesn't wait on a network reply before
> returning, right?  It just ends up in some dirty block device queue,
> I'm guessing?  And then something triggers a bunch of dirty blocks to
> get flushed out to "disk"?  If that's the case, then its impossible
> for the kernel to give an accurate return code to pwrite(), because it
> doesn't know those blocks will eventually fail to be written to "disk"
> (nbd).
> 
> But as for fsync(), the kernel is probably waiting until every last
> dirty sector gets written before it decides what the return code is,
> which is why we see that pwrite() isn't failing, but fsync() is
> failing.
> 
> Does that make sense?
> 
> I wonder if the block device were opened with O_DIRECT by e2fsprogs if
> that would cause the pwrite() calls to fail correctly?

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
libguestfs lets you edit virtual machines.  Supports shell scripting,
bindings from many languages.  http://libguestfs.org
