From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: jbd2 inside a device mapper module
Date: Fri, 26 Dec 2008 13:06:42 -0500
Message-ID: <20081226180642.GO9871@mit.edu>
References: <20081224211038.GT4127@blitiri.com.ar>
	<20081224234915.GA23723@mit.edu>
	<20081225143535.GA4127@blitiri.com.ar>
	<20081225155248.GJ9871@mit.edu>
	<20081226000005.GB4127@blitiri.com.ar>
	<20081226033736.GK9871@mit.edu>
	<20081226161708.GC4127@blitiri.com.ar>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dm-devel@redhat.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Alberto Bertogli <albertito@blitiri.com.ar>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20081226161708.GC4127@blitiri.com.ar>
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

On Fri, Dec 26, 2008 at 02:17:08PM -0200, Alberto Bertogli wrote:
> 
> At this moment I'm trying to keep it simple, so I plan to batch two for
> each sector written to the device: one for the metadata and one for the
> data.
> 

I think I can pretty much guarantee that your performance will be so
horrible that it won't be worth using.

> > Yes, this is necessary because in a production system you need to be
> > able to identify the external journal by UUID, and the ext2/3/4
> > superblock makes it easy to add a label, UUID, et. al.  It also
> > significantly lowers the chance that an external journal will get
> > misidentified as some other filesystem based on the data stored in the
> > journal.
> 
> Yes, it makes sense. I've reserved the first sector for that purpose.

Why not just use the ext3/4 external journal format?

						- Ted
