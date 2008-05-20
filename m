From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Tue, 20 May 2008 16:13:06 +0100
Message-ID: <20080520151306.GF16676@shareable.org>
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org> <482DF44B.50204@redhat.com> <20080516220315.GB15334@shareable.org> <20080519002838.GB8335@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vge
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:54865 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbYETPNU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 May 2008 11:13:20 -0400
Content-Disposition: inline
In-Reply-To: <20080519002838.GB8335@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Fri, May 16, 2008 at 11:03:15PM +0100, Jamie Lokier wrote:
> > The MacOS X folks decided that speed is most important for fsync().
> > fsync() does not guarantee commit to platter.  *But* they added an
> > fcntl() for applications to request a commit to platter, which SQLite
> > at least uses.  I don't know if MacOS X uses barriers for filesystem
> > operations.
> 
> Out of curiosity, exactly *what* semantics did MacOS X give fsync(),
> then?  Did it simply start the process of staging writes to disk, but
> not wait for the writes to hit the platter before returning?  That's
> basically the equivalent of ext3's barrier=0.

I haven't read the code and don't use MacOS myself.

>From its fcntl() man page:

    Note that while fsync() will flush all data from the host to the
    drive (i.e. the "permanent storage device"), the drive itself may
    not physically write the data to the platters for quite some time
    and it may be written in an out-of-order sequence.

    Specifically, if the drive loses power or the OS crashes, the
    application may find that only some or none of their data was
    written. The disk drive may also re-order the data so that later
    writes may be present while earlier writes are not.

    This is not a theoretical edge case. This scenario is easily
    reproduced with real world workloads and drive power failures.

    For applications that require tighter guarantess about the
    integrity of their data, MacOS X provides the F_FULLFSYNC
    fcntl. The F_FULLFSYNC fcntl asks the drive to flush all buffered
    data to permanent storage.  Applications such as databases that
    require a strict ordering of writes should use F_FULLFSYNC to
    ensure their data is written in the order they expect. Please see
    fcntl(2) for more detail.

Some notable things:

   1. Para 2 says "if the drive loses power __or the OS crashes__".
      Does this mean some drives will abandon cached writes when reset
      despite retaining power?

   2. Para 3 to be re-read by the skeptical.

   3. Para 4 perpetuates the confused idea that write ordering is what
      it's all about, for things like databases.  In fact, sometimes
      ordering barriers are all that's needed and flush is unnecessary
      performance baggage.  But sometimes an fsync() which only
      guarantees ordering is insufficient.  An "ideal"
      database-friendly block layer would offer both.

I doubt if common unix mail transports use F_FULLSYNC on Darwin
instead of fsync(), before reporting a mail received safely, but they
probably should.  I recall SQLite does use it (unless I'm confusing
it with some other database).

-- Jamie
