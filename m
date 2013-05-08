From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC] mess in jbd2_block_tag_csum_verify()
Date: Wed, 8 May 2013 14:55:41 -0700
Message-ID: <20130508215541.GA7730@blackbox.djwong.org>
References: <20130508155130.GT25399@ZenIV.linux.org.uk>
 <41D3CA9A-6284-4E5A-97AD-4D11E2307B01@dilger.ca>
 <20130508164508.GA5625@blackbox.djwong.org>
 <20130508170751.GV25399@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	"Theodore Ts'o" <tytso@mit.edu>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130508170751.GV25399@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

[add ext4 list to cc]

On Wed, May 08, 2013 at 06:07:52PM +0100, Al Viro wrote:
> On Wed, May 08, 2013 at 09:45:08AM -0700, Darrick J. Wong wrote:
> 
> > The journal block tag checksum is 16 bits long.
> > 
> > > Problem solved?
> > 
> > I wish.  Now we know what I'll be patching today...
> > 
> > Anyhow, thank you for catching this.
> 
> make C=2 fs/jbd2/ is a good idea (with recent enough sparse); to get rid of
> false positives re endianness, apply the patch below - that'll reduce the
> warnings to
> fs/jbd2/commit.c:358:25: warning: incorrect type in assignment (different base types)
> fs/jbd2/commit.c:358:25:    expected restricted __be16 [usertype] t_checksum
> fs/jbd2/commit.c:358:25:    got restricted __be32 [usertype] <noident>
> fs/jbd2/recovery.c:411:20: warning: cast to restricted __be32
> fs/jbd2/recovery.c:411:20: warning: cast from restricted __be16
> fs/jbd2/recovery.c:411:20: warning: cast to restricted __be32
> fs/jbd2/recovery.c:411:20: warning: cast from restricted __be16
> fs/jbd2/recovery.c:411:20: warning: cast to restricted __be32
> fs/jbd2/recovery.c:411:20: warning: cast from restricted __be16
> fs/jbd2/recovery.c:411:20: warning: cast to restricted __be32
> fs/jbd2/recovery.c:411:20: warning: cast from restricted __be16
> fs/jbd2/recovery.c:411:20: warning: cast to restricted __be32
> fs/jbd2/recovery.c:411:20: warning: cast from restricted __be16
> fs/jbd2/recovery.c:411:20: warning: cast to restricted __be32
> fs/jbd2/recovery.c:411:20: warning: cast from restricted __be16
> fs/jbd2/recovery.c:411:18: warning: incorrect type in assignment (different base types)
> fs/jbd2/recovery.c:411:18:    expected restricted __be32 [usertype] provided
> fs/jbd2/recovery.c:411:18:    got unsigned int

Interesting... I have something that calls itself sparse 0.4.3 and I don't see
any endianness warnings at all.  Is endian checking new for 0.4.4?  Or maybe I
simply don't have it configured correctly?

> which is where that problem lives (writing and checking tag->t_checksum resp.)
> FWIW, I think that the contents of that field in all existing fs images should
> be treated as junk - current kernels will puke if they happen to try and
> check them anyway.  Perhaps the right fix would be to store cpu_to_be16(csum)
> on the write side and do return cpu_to_be16(calculated) == tag->t_checksum
> on the check side - that would be independent from host endianness, as well
> as ignoring the right bits...
> 
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 0f53946..f75fbd7 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -339,7 +339,7 @@ static void jbd2_descr_block_csum_set(journal_t *j,
>  }
>  
>  static void jbd2_block_tag_csum_set(journal_t *j, journal_block_tag_t *tag,
> -				    struct buffer_head *bh, __u32 sequence)
> +				    struct buffer_head *bh, __be32 sequence)

Hmm, I thought "__u" implied native endian.  Any reason why we need to force
the parameter to "__be"?  I'd rather leave the call sites alone, but I don't
have any strong opinions either way.

Anyway, patches to fix the kernel and e2fsprogs are on their way.

--D

>  {
>  	struct page *page = bh->b_page;
>  	__u8 *addr;
> @@ -348,7 +348,6 @@ static void jbd2_block_tag_csum_set(journal_t *j, journal_block_tag_t *tag,
>  	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
>  		return;
>  
> -	sequence = cpu_to_be32(sequence);
>  	addr = kmap_atomic(page);
>  	csum = jbd2_chksum(j, j->j_csum_seed, (__u8 *)&sequence,
>  			  sizeof(sequence));
> @@ -695,7 +694,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  		write_tag_block(tag_bytes, tag, jh2bh(jh)->b_blocknr);
>  		tag->t_flags = cpu_to_be16(tag_flag);
>  		jbd2_block_tag_csum_set(journal, tag, jh2bh(new_jh),
> -					commit_transaction->t_tid);
> +					cpu_to_be32(commit_transaction->t_tid));
>  		tagp += tag_bytes;
>  		space_left -= tag_bytes;
>  
> diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
> index 626846b..cbbea8c 100644
> --- a/fs/jbd2/recovery.c
> +++ b/fs/jbd2/recovery.c
> @@ -178,7 +178,8 @@ static int jbd2_descr_block_csum_verify(journal_t *j,
>  					void *buf)
>  {
>  	struct jbd2_journal_block_tail *tail;
> -	__u32 provided, calculated;
> +	__be32 provided;
> +	__u32 calculated;
>  
>  	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
>  		return 1;
> @@ -190,8 +191,7 @@ static int jbd2_descr_block_csum_verify(journal_t *j,
>  	calculated = jbd2_chksum(j, j->j_csum_seed, buf, j->j_blocksize);
>  	tail->t_checksum = provided;
>  
> -	provided = be32_to_cpu(provided);
> -	return provided == calculated;
> +	return provided == cpu_to_be32(calculated);
>  }
>  
>  /*
> @@ -381,7 +381,8 @@ static int calc_chksums(journal_t *journal, struct buffer_head *bh,
>  static int jbd2_commit_block_csum_verify(journal_t *j, void *buf)
>  {
>  	struct commit_header *h;
> -	__u32 provided, calculated;
> +	__be32 provided;
> +	__u32 calculated;
>  
>  	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
>  		return 1;
> @@ -392,19 +393,18 @@ static int jbd2_commit_block_csum_verify(journal_t *j, void *buf)
>  	calculated = jbd2_chksum(j, j->j_csum_seed, buf, j->j_blocksize);
>  	h->h_chksum[0] = provided;
>  
> -	provided = be32_to_cpu(provided);
> -	return provided == calculated;
> +	return provided == cpu_to_be32(calculated);
>  }
>  
>  static int jbd2_block_tag_csum_verify(journal_t *j, journal_block_tag_t *tag,
> -				      void *buf, __u32 sequence)
> +				      void *buf, __be32 sequence)
>  {
> -	__u32 provided, calculated;
> +	__be32 provided;
> +	__u32 calculated;
>  
>  	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
>  		return 1;
>  
> -	sequence = cpu_to_be32(sequence);
>  	calculated = jbd2_chksum(j, j->j_csum_seed, (__u8 *)&sequence,
>  				 sizeof(sequence));
>  	calculated = jbd2_chksum(j, calculated, buf, j->j_blocksize);
> @@ -592,7 +592,7 @@ static int do_one_pass(journal_t *journal,
>  					/* Look for block corruption */
>  					if (!jbd2_block_tag_csum_verify(
>  						journal, tag, obh->b_data,
> -						be32_to_cpu(tmp->h_sequence))) {
> +						tmp->h_sequence)) {
>  						brelse(obh);
>  						success = -EIO;
>  						printk(KERN_ERR "JBD: Invalid "
> @@ -809,7 +809,8 @@ static int jbd2_revoke_block_csum_verify(journal_t *j,
>  					 void *buf)
>  {
>  	struct jbd2_journal_revoke_tail *tail;
> -	__u32 provided, calculated;
> +	__be32 provided;
> +	__u32 calculated;
>  
>  	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
>  		return 1;
> @@ -821,8 +822,7 @@ static int jbd2_revoke_block_csum_verify(journal_t *j,
>  	calculated = jbd2_chksum(j, j->j_csum_seed, buf, j->j_blocksize);
>  	tail->r_checksum = provided;
>  
> -	provided = be32_to_cpu(provided);
> -	return provided == calculated;
> +	return provided == cpu_to_be32(calculated);
>  }
>  
>  /* Scan a revoke record, marking all blocks mentioned as revoked. */
