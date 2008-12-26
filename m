From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: jbd2 inside a device mapper module
Date: Thu, 25 Dec 2008 22:37:36 -0500
Message-ID: <20081226033736.GK9871@mit.edu>
References: <20081224211038.GT4127@blitiri.com.ar>
	<20081224234915.GA23723@mit.edu>
	<20081225143535.GA4127@blitiri.com.ar>
	<20081225155248.GJ9871@mit.edu>
	<20081226000005.GB4127@blitiri.com.ar>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dm-devel@redhat.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Alberto Bertogli <albertito@blitiri.com.ar>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20081226000005.GB4127@blitiri.com.ar>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 25, 2008 at 10:00:05PM -0200, Alberto Bertogli wrote:
> 
> I think I'm not explaining myself correctly. My code has _nothing_ to do
> with ext2/3/4 (or any other filesystem) whatsoever. I'm not using the
> journal as an external one for a filesystem. I want to use it to be able
> to do atomic writes in my own, filesystem independant, device-mapper
> code.

How many block writes are you batching into a single transaction?  If
you're not careful you may find that performance overhead will be
quite expensive.

> After what you told me (both this and the deprecation of
> jbd2_journal_create()), I took a look at e2fsprogs' source. From what I
> could see, "mke2fs -O journal_dev" creates the external journal inside
> some ext2/3/4 structures, which caused my journal-loading code to fail
> (because it doesn't know about ext stuff).

Yes, this is necessary because in a production system you need to be
able to identify the external journal by UUID, and the ext2/3/4
superblock makes it easy to add a label, UUID, et. al.  It also
significantly lowers the chance that an external journal will get
misidentified as some other filesystem based on the data stored in the
journal.

					- Ted
