From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] jbd2: gate checksum calculations on crc driver presence, not sb flags
Date: Thu, 1 Oct 2015 00:35:12 -0600
Message-ID: <9E6A0BA2-8E7E-4DFA-A2D4-D07E9CC186CF@dilger.ca>
References: <20150930174708.GJ10391@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>,
	Nikolay Borisov <kernel@kyup.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	SiteGround Operations <operations@siteground.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150930174708.GJ10391@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 30, 2015, at 11:47 AM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 
> Change the journal's checksum functions to gate on whether or not the
> crc32c driver is loaded, and gate the loading on the superblock bits.
> This prevents a journal crash if someone loads a journal in no-csum
> mode and then randomizes the superblock, thus flipping on the feature
> bits.
> 
> Reported-by: Nikolay Borisov <kernel@kyup.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> fs/jbd2/journal.c    |   12 +++++++++---
> include/linux/jbd2.h |   10 ++++++----
> 2 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 8270fe9..16e3a46 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -122,9 +122,15 @@ EXPORT_SYMBOL(__jbd2_debug);
> #endif
> 
> /* Checksumming functions */
> +static bool journal_has_csum_v2or3_feature(journal_t *j)
> +{
> +	return JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2) ||
> +	       JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V3);
> +}
> +
> static int jbd2_verify_csum_type(journal_t *j, journal_superblock_t *sb)
> {
> -	if (!jbd2_journal_has_csum_v2or3(j))
> +	if (!journal_has_csum_v2or3_feature(j))
> 		return 1;
> 
> 	return sb->s_checksum_type == JBD2_CRC32C_CHKSUM;
> @@ -1531,7 +1537,7 @@ static int journal_get_superblock(journal_t *journal)
> 		goto out;
> 	}
> 
> -	if (jbd2_journal_has_csum_v2or3(journal) &&
> +	if (journal_has_csum_v2or3_feature(journal) &&
> 	    JBD2_HAS_COMPAT_FEATURE(journal, JBD2_FEATURE_COMPAT_CHECKSUM)) {
> 		/* Can't have checksum v1 and v2 on at the same time! */
> 		printk(KERN_ERR "JBD2: Can't enable checksumming v1 and v2/3 "
> @@ -1545,7 +1551,7 @@ static int journal_get_superblock(journal_t *journal)
> 	}
> 
> 	/* Load the checksum driver */
> -	if (jbd2_journal_has_csum_v2or3(journal)) {
> +	if (journal_has_csum_v2or3_feature(journal)) {
> 		journal->j_chksum_driver = crypto_alloc_shash("crc32c", 0, 0);
> 		if (IS_ERR(journal->j_chksum_driver)) {
> 			printk(KERN_ERR "JBD2: Cannot load crc32c driver.\n");
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index df07e78..c74c786 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -1340,11 +1340,13 @@ extern size_t journal_tag_bytes(journal_t *journal);
> 
> static inline int jbd2_journal_has_csum_v2or3(journal_t *journal)
> {
> -	if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_CSUM_V2) ||
> -	    JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_CSUM_V3))
> -		return 1;
> +	WARN_ON_ONCE((JBD2_HAS_INCOMPAT_FEATURE(journal,
> +				JBD2_FEATURE_INCOMPAT_CSUM_V2) ||
> +		 JBD2_HAS_INCOMPAT_FEATURE(journal,
> +				JBD2_FEATURE_INCOMPAT_CSUM_V3)) &&
> +		     journal->j_chksum_driver == NULL);
> 
> -	return 0;
> +	return journal->j_chksum_driver != NULL;
> }

Why not use:

	WARN_ON_ONCE(journal_has_csum_v2orv3_feature() &&
		     journal->j_chksum_driver == NULL);

rather than open-coding it?  Yes, you would have to move that function
to the header and give it a better name.

As a side note, I've long thought about changing the macros to be shorter:

#define JBD2_HAS_INCOMPAT_FEATURE(j, name)				\
	((j)->j_format_version >= 2 &&					\
	 ((j)->j_superblock->s_feature_incompat &			\
	  cpu_to_be32((JBD2_HAS_INCOMPAT_FEATURE_ ## name))))

so they can be used like:

static bool jbd2_journal_has_csum_v2or3_feature(journal_t *journal)
{
	return JBD2_HAS_INCOMPAT_FEATURE(journal, CSUM_V2) ||
	       JBD2_HAS_INCOMPAT_FEATURE(journal, CSUM_V3);
}

This not only makes the code much shorter and more readable, it also
avoids potentially hard-to-spot bugs like the following:

	JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_COMPAT_CHECKSUM)

The same would be useful for the equivalent ext4 macros as well.

Cheers, Andreas





