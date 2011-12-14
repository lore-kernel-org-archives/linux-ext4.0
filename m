From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v2.2 00/23] ext4: Add metadata checksumming
Date: Tue, 13 Dec 2011 17:31:58 -0800
Message-ID: <20111214013158.GB8233@tux1.beaverton.ibm.com>
References: <20111214004613.28243.54122.stgit@elm3c44.beaverton.ibm.com> <20111214011028.GA8233@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Martin K Petersen <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111214011028.GA8233@tux1.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 13, 2011 at 05:10:28PM -0800, Darrick J. Wong wrote:
> On Tue, Dec 13, 2011 at 04:46:14PM -0800, Darrick J. Wong wrote:
<snip>
> > This patchset has been tested on 3.2.0-rc5 on x64, i386, ppc64, and ppc32.  The
> > patches seems to work fine on all four platforms.
> 
> OH COME ON!!!!
> 
> stgit helpfully changed the From lines, screwing everything up.  Awesome.  I
> apologize, I wasn't expecting stgit to change the From: lines when I migrated
> the disk format changes to the front of the set.
> 
> I don't really want to respam the list just to fix this one little thing.  If
> people want more code changes I'll gladly make them and re-send.  If not, then
> Ted, I can just send you the whole mess as a big mbox file, or post them on a
> webserver somewhere, with correct attribution.

The e2fsprogs patchset is also found here:
http://djwong.org/docs/ext4_checksum_progs/

The kernel patchset is also found here:
http://djwong.org/docs/ext4_checksum_kernel/

(Honestly, I don't enjoy spamming the list with 91 patches.)

--D
> 
> --D
> > 
> > --D
> > 
> > [1] https://ext4.wiki.kernel.org/index.php/Ext4_Metadata_Checksums
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
