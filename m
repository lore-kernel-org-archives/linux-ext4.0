From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: ext4 kernel patches against linux-2.6.18-rc7-mm1
Date: Wed, 20 Sep 2006 11:32:28 -0500
Message-ID: <45116D1C.20807@redhat.com>
References: <1158767799.9276.23.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:1162 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1751810AbWITQca (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Sep 2006 12:32:30 -0400
To: Dave Kleikamp <shaggy@austin.ibm.com>
In-Reply-To: <1158767799.9276.23.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Dave Kleikamp wrote:

> # From Mingming Cao
> sector_t-jbd2.patch

I think this one needs to address the first, last variables in
journal_fail_superblock():

 static int journal_reset(journal_t *journal)
 {
        journal_superblock_t *sb = journal->j_superblock;
-       unsigned int first, last;
+       sector_t first, last;

        first = be32_to_cpu(sb->s_first);
        last = be32_to_cpu(sb->s_maxlen);

(and then later change that back to unsigned long long, in the spirit of
the patch series)

-Eric
