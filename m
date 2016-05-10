From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC v3] [PATCH 0/18] DAX page fault locking
Date: Tue, 10 May 2016 13:52:10 +0200
Message-ID: <20160510115210.GJ11897@quack2.suse.cz>
References: <1461015341-20153-1-git-send-email-jack@suse.cz>
 <1462829283.3149.7.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "jack@suse.cz" <jack@suse.cz>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, Ted Tso <tytso@mit.edu>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1462829283.3149.7.camel@intel.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Hi!

On Mon 09-05-16 21:28:06, Verma, Vishal L wrote:
> On Mon, 2016-04-18 at 23:35 +0200, Jan Kara wrote:
> I've noticed that patches 1 through 12 of your series are relatively
> independent, and are probably more stable than the remaining part of
> the series that actually changes locking.

Yes.

> My dax error handling series also depends on the patches that change
> zeroing in DAX (patches 5, 6, 9).
> 
> To allow the error handling stuff to move faster, can we split these
> into two patchsets?
>
> I was hoping to send the dax error handling series through the nvdimm
> tree, and if you'd like, I can also prepend your patches 1-12 with my
> series.

So I'm thinking how to best merge this. There are some ext4 patches which
are not trivial (mainly "ext4: Refactor direct IO code"). These can go in
as far as I'm concerned but there is a potential for conflicts in ext4
tree and I'd definitely want to give them full test run in the ext4 tree.
The best what I can think of is to pull ext4 related changes into a stable
branch in ext4 tree and then pull that branch into nvdimm tree. Ted, what
do you think? If you agree, I can separate the patches into three parts -
one for ext4 tree, stable patches for nvdimm tree, and then remaining
patches.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
