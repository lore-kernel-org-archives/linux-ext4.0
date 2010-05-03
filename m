From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH] Prevent creation of files larger than RLIMIT_FSIZE
	using fallocate
Date: Mon, 3 May 2010 12:31:11 +0530
Message-ID: <20100503070111.GB13756@amitarora.in.ibm.com>
References: <201004281854.49730.knikanth@suse.de> <4BD85F1F.7030100@suse.de> <201004291014.07194.knikanth@suse.de> <20100430143319.d51d6d77.akpm@linux-foundation.org> <20100501070426.GA9562@amitarora.in.ibm.com> <20100501101846.GA3769@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Nikanth Karthikesan <knikanth@suse.de>, coly.li@suse.de,
	Nick Piggin <npiggin@suse.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Eelis <opensuse.org@contacts.eelis.net>,
	Amit Arora <aarora@in.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100501101846.GA3769@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, May 01, 2010 at 06:18:46AM -0400, Christoph Hellwig wrote:
> On Sat, May 01, 2010 at 12:34:26PM +0530, Amit K. Arora wrote:
> > Agreed. How about doing this check in the filesystem specific fallocate
> > inode routines instead ? For example, in ext4 we could do :
> 
> That looks okay - in fact XFS should already have this check because
> it re-uses the setattr implementation to set the size.

You are right. I have written a test and it passes on XFS, but fails on
ext4. 
 
> Can you submit an xfstests testcase to verify this behaviour on all
> filesystems?

Sure. Its ready and is under test. Will post shortly..

--
Regards,
Amit Arora
