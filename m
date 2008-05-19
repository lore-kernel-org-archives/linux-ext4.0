From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Sun, 18 May 2008 20:28:38 -0400
Message-ID: <20080519002838.GB8335@mit.edu>
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org> <482DF44B.50204@redhat.com> <20080516220315.GB15334@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Eric Sandeen <sandeen@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080516220315.GB15334@shareable.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, May 16, 2008 at 11:03:15PM +0100, Jamie Lokier wrote:
> The MacOS X folks decided that speed is most important for fsync().
> fsync() does not guarantee commit to platter.  *But* they added an
> fcntl() for applications to request a commit to platter, which SQLite
> at least uses.  I don't know if MacOS X uses barriers for filesystem
> operations.

Out of curiosity, exactly *what* semantics did MacOS X give fsync(),
then?  Did it simply start the process of staging writes to disk, but
not wait for the writes to hit the platter before returning?  That's
basically the equivalent of ext3's barrier=0.

							- Ted
