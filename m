From: Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH V3 3/8] Cleancache: core ops functions and configuration
Date: Tue, 22 Jun 2010 20:43:00 +0530
Message-ID: <4C20D2FC.7010307@vflare.org>
References: <20100621231939.GA19505@ca-server1.us.oracle.com> <20100622144320.GA13324@infradead.org>
Reply-To: ngupta@vflare.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
	chris.mason@oracle.com, viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org, adilger@Sun.COM, tytso@mit.edu,
	mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, jeremy@goop.org,
	JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@suse.de,
	dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com,
	konrad.wilk@oracle.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100622144320.GA13324@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 06/22/2010 08:13 PM, Christoph Hellwig wrote:
> On Mon, Jun 21, 2010 at 04:19:39PM -0700, Dan Magenheimer wrote:
>> [PATCH V3 3/8] Cleancache: core ops functions and configuration
>>
>> Cleancache core ops functions and configuration
> 
> NACK for code that just adds random hooks all over VFS and even
> individual FS code, does an EXPORT_SYMBOL but doesn't actually introduce
> any users.
> 
> And even if it had users these would have to be damn good ones given how
> invasive it is.  So what exactly is this going to help us?  Given your
> affiliation probably something Xen related, so some real use case would
> be interesting as well instead of just making Xen suck slightly less.
> 
> 

One use case of cleancache is to provide transparent page cache compression
support. Currently, I'm working 'zcache' which provides hooks for cleancache
callbacks to implement the same.

Page cache compression is expected is benefit use cases where memory is the
bottleneck. In particular, I'm interested in KVM virtualization case where
this can allow running more VMs per host for given amount of RAM.

The zcache code is under active development and a working snapshot can be
found here:
http://code.google.com/p/compcache/source/browse/#hg/sub-projects/zcache
(sorry for lack of code comments in its current state)

Thanks,
Nitin
