From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [RFC] ext4 metadata checksumming design
Date: Wed, 17 Aug 2011 10:09:16 -0700
Message-ID: <20110817170916.GQ20655@tux1.beaverton.ibm.com>
References: <20110817032519.GN20655@tux1.beaverton.ibm.com> <20110817135719.GA25996@one.firstfloor.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Joel Becker <jlbec@evilplan.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Amir Goldstein <amir73il@gmail.com>, Coly Li <colyli@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110817135719.GA25996@one.firstfloor.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 17, 2011 at 03:57:19PM +0200, Andi Kleen wrote:
> On Tue, Aug 16, 2011 at 08:25:19PM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > I've created a page on the ext4 wiki outlining the patchset that I'm working on
> > to add metadata checksumming to ext4.  The page can be found at this address:
> > https://ext4.wiki.kernel.org/index.php/Ext4_Metadata_Checksums
> 
> Can you summarize the differences to my earlier patchkit?

My new patchset intends to expand on your earlier inode/superblock patches by
adding checksums to nearly all metadata objects (directory blocks, htree,
extent tree, block/inode bitmaps, extended attributes).  It also adds code to
e2fsprogs to verify the checksums, and make the necessary adjustments to the
on-disk format to add space for checksums.

--D
> 
> -Andi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
