From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: ext4 kernel patches against linux-2.6.18-rc7-mm1
Date: Wed, 20 Sep 2006 12:38:48 -0500
Message-ID: <45117CA8.2010501@redhat.com>
References: <1158767799.9276.23.camel@kleikamp.austin.ibm.com> <45116D1C.20807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:4042 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S932152AbWITRiu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Sep 2006 13:38:50 -0400
To: Dave Kleikamp <shaggy@austin.ibm.com>
In-Reply-To: <45116D1C.20807@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen wrote:
> Dave Kleikamp wrote:
> 
>> # From Mingming Cao
>> sector_t-jbd2.patch
> 
> I think this one needs to address the first, last variables in
> journal_fail_superblock():
> 
>  static int journal_reset(journal_t *journal)
>  {
>         journal_superblock_t *sb = journal->j_superblock;
> -       unsigned int first, last;
> +       sector_t first, last;
> 
>         first = be32_to_cpu(sb->s_first);
>         last = be32_to_cpu(sb->s_maxlen);
> 
> (and then later change that back to unsigned long long, in the spirit of
> the patch series)

Hm, and looking further, I think this change:

 journal_t * jbd2_journal_init_dev(struct block_device *bdev,
                        struct block_device *fs_dev,
-                       int start, int len, int blocksize)
+                       sector_t start, int len, int blocksize)

is unnecessary; this is initializing the journal on an external device,
and start is in the first few blocks of the disk:

        sb_block = EXT3_MIN_BLOCK_SIZE / blocksize;
        start = sb_block + 1;

and len is also constrained by the maximum log size.

-Eric
