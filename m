From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/5] ext4: Fix endian problem in MMP initialization
Date: Tue, 25 Oct 2011 09:35:05 -0400
Message-ID: <20111025133505.GL31921@thunk.org>
References: <20111021211759.10784.17257.stgit@elm3c44.beaverton.ibm.com>
 <20111021211825.10784.97113.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111021211825.10784.97113.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 21, 2011 at 02:18:25PM -0700, Darrick J. Wong wrote:
> As part of startup, the MMP initialization code does this:
> 
> mmp->mmp_seq = seq = cpu_to_le32(mmp_new_seq());
> 
> Next, mmp->mmp_seq is written out to disk, a delay happens, and then the MMP
> block is read back in and the sequence value is tested:
> 
> if (seq != le32_to_cpu(mmp->mmp_seq)) {
> 	/* fail the mount */
> 
> On a LE system such as x86, the *le32* functions do nothing and this works.
> Unfortunately, on a BE system such as ppc64, this comparison becomes:
> 
> if (cpu_to_le32(new_seq) != le32_to_cpu(cpu_to_le32(new_seq)) {
> 	/* fail the mount */
> 
> Except for a few palindromic sequence numbers, this test always
> causes the mount to fail, which makes MMP filesystems generally
> unmountable on ppc64.  The attached patch fixes this situation.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

Thanks, this is already in the ext4 tree, although not yet in the
master branch (just the dev branch).

					- Ted
