From: djwong <djwong@us.ibm.com>
Subject: Re: [RFC] jbd2: reduce the number of writes when commiting a
 transacation
Date: Wed, 25 Apr 2012 13:34:34 -0700
Message-ID: <20120425203434.GB6938@tux1.beaverton.ibm.com>
References: <20120420110627.GA30373@gmail.com>
 <E5D2F131-A01C-4CB2-8A7C-88CACBBC450B@dilger.ca>
 <20120423022505.GA7855@gmail.com>
 <67060CC0-9F64-40ED-9467-572996ECF21F@whamcloud.com>
 <20120423221948.GA6938@tux1.beaverton.ibm.com>
 <20120424194108.GI18865@thunk.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@whamcloud.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120424194108.GI18865@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Apr 24, 2012 at 03:41:08PM -0400, Ted Ts'o wrote:
> On Mon, Apr 23, 2012 at 10:19:48PM +0000, djwong wrote:
> > 
> > My huge checksum patchset _does_ include checksums for data blocks; see the
> > t_checksum field in struct journal_block_tag_s.  iirc the corresponding journal
> > replay modifications will skip over corrupt data blocks and keep going.
> 
> I need to check for this in the patches (and you may be doing this
> already), but in the kernel failed checksums should result in an
> ext4_error() call which will set the file system as corrupt and
> needing to be checked.  And in e2fsck it should force a full check of
> the file system.

I'm fairly sure the kernel patch doesn't do that, I think it just skips the
block and moves on.

As for e2fsck... what does one do inside e2fsck to force a full check?  Is that
just the equivalent of passing -f?

--D
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

