From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Mon, 11 Jun 2012 08:27:36 -0400
Message-ID: <20120611122736.GA14051@thunk.org>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com>
 <1339411562-17100-2-git-send-email-saugata.das@stericsson.com>
 <1339414891.2401.12.camel@sauron.fi.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mmc@vger.kernel.org, patches@linaro.org, venkat@linaro.org,
	Saugata Das <saugata.das@linaro.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-mmc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1339414891.2401.12.camel@sauron.fi.intel.com>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 11, 2012 at 02:41:31PM +0300, Artem Bityutskiy wrote:
> 
> Word "context" is very generic and it is widely used various things, and
> I believe we should try to avoid overloading this term and obfuscating
> the I/O stack with various functions and other identifiers like
> "get_context()". This would hurt readability. It is fine to use it
> withing the UFS-specific code, but not globally withing the kernel code.
> 
> I do not really have good name candidates, but even "ufscontext" is
> already better than just "context". Or "iocontext" ? Or just "ufsdata" ?

Before we try naming it, can we get some more details about exactly
how context in the eMMC context works?

It appears to be a way of grouping related writes together (yes?) but
at what granularity?  What are the restrictions at the device level?

The proof-of-concept patches seem to use the inode number as a way of
trying to group related writes, but what about at a larger level than
that?  For example, if we install a RPM or deb package where all of
the files will likely be replaced together, should that be given the
same context?

How likely does it have to be that related blocks written under the
same context must be deleted at the same time for this concept to be
helpful?  If we have a context where it is the context assumption does
not hold (example: a database where you have a random access
read/write pattern with blocks updated in place) how harm will it be
to the device format if those blocks are written under the same
context?

The next set of questions we need to ask is how generalizable is this
concept to devices that might be more sophisticated than simple eMMC
devices.  If we're going to expose something all the way out to the
file system layer, it would be nice if it worked on more than just
low-end flash devices, but also on more sophisticated devices as well.

Regards,

					- Ted
