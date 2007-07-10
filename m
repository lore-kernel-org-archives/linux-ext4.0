From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [EXT4 set 2][PATCH 3/5] cleanups: set_jbd2_64bit_feature for
 >16TB ext4 fs
Date: Tue, 10 Jul 2007 16:30:22 -0700
Message-ID: <20070710163022.333ece67.akpm@linux-foundation.org>
References: <1183275392.4010.122.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1183275392.4010.122.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 01 Jul 2007 03:36:32 -0400
Mingming Cao <cmm@us.ibm.com> wrote:

> Set the journals JBD2_FEATURE_INCOMPAT_64BIT on devices with more
> than 32bit block sizes during mount time.  This ensure proper record
> lenth when writing to the journal.

This patch isn't in Ted's kernel.org directory and hasn't been in -mm. 
Where did it come from?  Is something amiss with ext4 patch management?

> Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
> Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
> ---
>  fs/ext4/super.c |   11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> Index: linux-2.6.22-rc4/fs/ext4/super.c
> ===================================================================
> --- linux-2.6.22-rc4.orig/fs/ext4/super.c	2007-06-11 16:15:54.000000000 -0700
> +++ linux-2.6.22-rc4/fs/ext4/super.c	2007-06-11 16:16:10.000000000 -0700
> @@ -1804,6 +1804,13 @@

Please prepare patches using `diff -p'

>  		goto failed_mount3;
>  	}
>  
> +	if (ext4_blocks_count(es) > 0xffffffffULL &&
> +	    !jbd2_journal_set_features(EXT4_SB(sb)->s_journal, 0, 0,
> +				       JBD2_FEATURE_INCOMPAT_64BIT)) {
> +		printk(KERN_ERR "ext4: Failed to set 64-bit journal feature\n");
> +		goto failed_mount4;
> +	}

It is not appropriate for the text "ext4" to appear in a JBD2 message.

>  	/* We have now updated the journal if required, so we can
>  	 * validate the data journaling mode. */
>  	switch (test_opt(sb, DATA_FLAGS)) {


