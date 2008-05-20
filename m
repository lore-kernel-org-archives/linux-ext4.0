From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Tue, 20 May 2008 15:42:34 +0100
Message-ID: <20080520144233.GA16676@shareable.org>
References: <482DDA56.6000301@redhat.com> <20080517002030.GA7374@mit.edu> <20080516173552.e88183d9.akpm@linux-foundation.org> <200805172048.34455.chris.mason@oracle.com> <20080518013641.GH16496@mit.edu> <4830420D.4080608@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Ric Wheeler <ricwheeler@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4830420D.4080608@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ric Wheeler wrote:
> I will have to figure out to get this kind of test going without all
> of my big EMC toys ;-)

Fwiw, you can test correctness by running a nested VM-in-VM guest
which simulates disk write cache and flush operations (which flush to
the host kernel).  I believe recent QEMU/KVM has this as an option.
Data written by the innermost guest will reside in the middle kernel's
write cache.

Disk cache flush commands from the innermost kernel will cause the
middle kernel to write dirty sectors to the outer kernel.  Killing the
outermost host process is roughly equivalent to pulling the plug on a
real machine, but faster and without hurting real hardware.

This might not tell you much about performance, but you should be able
to run a lot of repeatable filesystem barrier tests this way.

-- Jamie
